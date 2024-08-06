note
	description: "[
		Represents a register in a {PI_CONTROLLER}.
		Current can be read-write (RW), read-only (RO), or write-only (WO).

		Also, individual bits can be set as read-write (RW), read-only (RO),
		write-only (WO), or write-once-to-clear (W1C) which implies the bit
		is readable and returns a zero after being cleared, or write-
		once-to-clear-other register which always returns a zero, or as
		"Reserved" (see `reserved_mask') which must be written as zero and
		whose return value is "don't care".

		As of now, the "don't care" bits are returned (and checked) as zero,
		but this may be a problem if in the future these bits become become
		useful to a Raspberry Pi.
		]"
	author: "Jimmy J Johnson"
	date: "10/11/20"

class
	REGISTER

--inherit {NONE}

--	SHARED
--		export
--			{NONE}
--				all
--			{ANY}
--				pi
--		undefine
--			is_equal
--		end

create
	make

feature {NONE} -- Initialization

	make (a_pointer: POINTER; a_name: like name)
			-- Set up the register
		do
			pointer := a_pointer
				-- Use copy to avoid an accidental name change
			name := a_name.twin
		end

feature -- Access

	name: STRING_8
			-- A printable name for Current (e.g. GPFSEL0, GPLEV0, etc)

	value: NATURAL_32
			-- The 32-bit value referenced by Current
			-- This feature ensures the password and write-only bits
			-- are zero.  Any reserved bits are also read as zeros even
			-- though the manual says we don't care.  Otherwise, there
			-- is not an easy way to check values in assertions.
		require
			is_readable: is_readable
		do
				-- Get the value out of the register
			Result := c_register_value (pointer)
				-- ...then ensure "don't-care" bits to zero
--			Result := filtered (Result)
			Result := Result.bit_and (reserved_mask.bit_not)
		ensure
			no_password_returned: is_password_required implies Result.bit_and (password_mask) = 0
			no_reserved_bits_returned: Result.bit_and (reserved_mask) = 0
			no_write_only_bits_returned: Result.bit_and (write_only_mask) = 0
		end

	bit_value (a_index: INTEGER_32): NATURAL_32
			-- The value (High or Low) of `a_index'th bit
		require
			is_readable: is_readable
			index_big_enough: a_index >= 0
			index_small_enougth: a_index <= 31
		do
			if value.bit_and (pin_mask (a_index)) = 0 then
					-- All the bits are zero
				Result := 0
			else
					-- The `a_index' bit is set
				Result := 1
			end
		ensure
			valid_result: Result = 0 or Result = 1
			zero_definition: Result = 0 implies value.bit_and (pin_mask (a_index)) = 0
			one_definition: Result = 1 implies value.bit_and (pin_mask (a_index)) > 0
		end

	default_value: NATURAL_32
			-- The value to which to `reset' the `value' of Current

	Default_password: NATURAL_32 = 0x5A000000
			-- Password used when setting some registers

	as_hex_string: STRING
			-- The `value' displayed as a hex string
			-- (e.g. "0xFF000071")
		do
			Result := "0x" + value.to_hex_string
		end

	as_binary_string: STRING
			-- The `value' displayed as a binary string
			-- (e.g. "0b11000000000000000000000001110001")
		local
			i: INTEGER
		do
			Result := "0b"
			from i := 0
			until i > 31
			loop
				Result.append (bit_value (i).out)
				i := i + 1
			end
		end

feature -- Element change

	set_default_value (a_value: NATURAL_32)
			-- Set the `default_value', the value to which Current is
			-- set upon creation or when `reset'.
		do
			default_value := a_value
		end

	reset
			-- Change Current to its `default_value'
			-- Set each bit according to the "reset" value in the ARM Document
		local
			v: NATURAL_32
		do
--			print ("%N")
--			print ("{" + generating_type + "}.reset: %N")
--			print ("     name = " + name.out + "%N")
--			print ("     default_value = " + default_value.to_hex_string + "%N")
--			print ("     value before = " + value.to_hex_string + "%N")
			set_value (Default_value)
--			print ("     value after = " + value.to_hex_string + "%N")
		ensure
			value_was_reset: value = default_value
		end

	 set_value (a_value: NATURAL_32)
			-- Change the `value' stored in Current
		require
			is_writable: is_writable
			is_valid_value: is_valid_value (a_value)
		local
			v: NATURAL_32
		do
				-- Some registers require a `password' in order to
				-- write to the register.  These password bits will
				-- be set to zero by the Pi after the write.
				-- Does not matter if `password' bits are set in `a_value'
				-- because we first clear them here then add the `password'
--	print ("{" + generating_type +"}.set_value (" + a_value.to_hex_string + "):  " + name + "%N")
--	print ("    filtered (a_value) = " + filtered (a_value).to_hex_string + "%N")
			v := a_value
			if is_password_required then
				v := v.bit_and (password_mask.bit_not)
				v := v.bit_or (password)
			end
--	print ("    Calling `c_set_register_value (__, " + v.to_hex_string + ") %N")
			c_set_register_value (pointer, v)
--	show
 --	print ("    filtered (value) = " + filtered (value).to_hex_string + "%N")
		ensure
			value_was_set: filtered (value) = a_value
		end

	show
			-- Display values
		do
			print ("{" + generating_type +"}.show:  " + name + " at " + pointer.out + "%N")
			print ("     value = " + value.to_hex_string + "%N")
			print ("     password_mask:   " + password_mask.to_hex_string + "%N")
			print ("     reserved mask:   " + reserved_mask.to_hex_string + "%N")
			print ("     write-only mask: " + write_only_mask.to_hex_string + "%N")
			print ("     read-only mask:  " + read_only_mask.to_hex_string + "%N")
			print ("     is_pass_word_required:  " + is_password_required.out + "%N")
		end

	set_bit (a_index: INTEGER_32)
			-- Make the bit at `a_index' one without changing other bits
		require
			is_writable: is_writable
			is_bit_writable: is_bit_writable (a_index)
			valid_index: a_index >= 0 and a_index < 32
		local
			v: NATURAL_32
		do
			v := c_register_value (pointer)
--			print ("{REGISTER}.set_bit:  v = " + v.to_hex_string + "%N")
			v := v.bit_or (pin_mask (a_index))
--			print ("    {REGISTER}.set_bit:  v = " + v.to_hex_string + "%N")
			c_set_register_value (pointer, v)
--			print ("    {REGISTER}.set_bit:  value = " + value.to_hex_string + "%N")
		end

	clear_bit (a_index: INTEGER_32)
			-- Make the bit at `a_index' zero without changing other bits
		require
			is_writable: is_writable
			is_bit_writable: is_bit_writable (a_index)
			valid_index: a_index >= 0 and a_index < 32
		local
			v: NATURAL_32
		do
			v := c_register_value (pointer)
			v := v.bit_and (pin_mask (a_index).bit_not)
			c_set_register_value (pointer, v)
		end

	set_reserved_mask (a_mask: NATURAL_32)
			-- Change the `reserved_mask' to prevent certain bits from
			-- being changed ("write as zero, read as don't care)
		do
			reserved_mask:= a_mask
		end

	set_read_only_mask (a_mask: NATURAL_32)
			-- Change the `read_only_mask' to mark bits as read-only.
		require
			is_readable: is_readable
		do
			read_only_mask := a_mask
				-- Ensure the `write_only_mask` and `write_once_mask'
				-- do not also mask out the same bits.
			write_only_mask := write_only_mask.bit_and (read_only_mask.bit_not)
			write_once_mask := write_once_mask.bit_and (read_only_mask.bit_not)
		end

	set_write_only_mask (a_mask: NATURAL_32)
			-- Change the `write_only_mask' to mark bits as write-only.
			-- These bits will always read as zero.
		require
			is_writable: is_writable
		do
			write_only_mask := a_mask
				-- Ensure the `read_only_mask` does not mask same bits
			read_only_mask := read_only_mask.bit_and (write_only_mask.bit_not)
		end

	set_write_once_mask (a_mask: NATURAL_32)
			-- Change the `write_once_mask' to mark bits as write-once.
		require
			is_writable: is_writable
		do
			write_once_mask := a_mask
				-- Ensure the `read_only_mask` does not mask same bits
			read_only_mask := read_only_mask.bit_and (write_once_mask.bit_not)
		end

feature -- Query

	is_valid_value (a_value: NATURAL_32): BOOLEAN
			-- Can `a_value' be written to Current?
			-- This is false if any password, read-only, or reserved bits
			-- are not zero.
		local
			v: NATURAL_32
			m: NATURAL_32
		do
--	print ("--------------------- %N")
--	print ("{" + generating_type +"}.is_valid_value (" + a_value.to_hex_string + "):  " + name + "%N")
				-- Extract the password portion of `a_value'
			v := a_value.bit_and (password_mask)
			Result := is_password_required implies v = 0
--	print ("    password portion of v:  " + v.to_hex_string + "    Result = " + Result.out + "%N")
			if Result then
					-- Can't write to reserved or read-only bits
				m := reserved_mask.bit_or (read_only_mask)
				Result := a_value.bit_and (m) = 0
			end
--	print ("    Result = :  " + Result.out + "%N")
--	print ("--------------------- %N")
--	show
		end

	is_bit_set (a_index: INTEGER_32): BOOLEAN
			-- Is the `a_index' bit set to one?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := value.bit_and (pin_mask (a_index)) > 0
		ensure
			definition: Result implies value.bit_and (pin_mask (a_index)) > 0
		end

feature -- Status

	is_password_required: BOOLEAN
			-- Is a `password' required when writing to Current?
			-- Change with `require_password' or `remove_password'.
			-- The `password' is always 0x5A000000 if required.

	is_reset: BOOLEAN
			-- Is Current set to its `default_value'
		do
			Result := value = Default_value
		ensure
			definition: Result implies value = Default_value
		end

	is_read_only: BOOLEAN
			-- Is Current "read-only"?
			-- If yes, then cannot call `set_value'.

	is_write_only: BOOLEAN
			-- Is Current "write-only"?
			-- If yes then cannot call `value'.

	is_readable: BOOLEAN
			-- Can Current `value' be read (with perhaps
			-- some restrictions on `reserved_bits')?
		do
			Result := not is_write_only
		end

	is_writable: BOOLEAN
			-- Can Current be changed?
		do
			Result := not is_read_only
		end

	is_read_writable: BOOLEAN
			-- Is Current readable and writable?
		do
			Result := is_readable and is_writable
		end

	is_bit_reserved (a_index: INTEGER_32): BOOLEAN
			-- ISs bit number `a_index' marked as reserved?
		do
			Result := reserved_mask.bit_and (pin_mask (a_index)) > 0
		end

	is_bit_read_only (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' marked as read-only?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := read_only_mask.bit_and (pin_mask (a_index)) > 0
		end

	is_bit_write_only (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' marked as read-only?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := write_only_mask.bit_and (pin_mask (a_index)) > 0
		end

	is_bit_write_once (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' marked as write-once?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := write_once_mask.bit_and (pin_mask (a_index)) > 0
		end

	is_bit_read_writable (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' readable and writable?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := is_read_writable and then
					 not (is_bit_read_only (a_index) or
						is_bit_write_only (a_index))
		end

	is_bit_readable (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' readable?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := is_readable and then
					not (is_bit_write_only (a_index) or
						is_bit_write_once (a_index))
		end

	is_bit_writable (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' writable?
		require
			valid_index: a_index >= 0 and a_index < 32
		do
			Result := is_writable and then not is_bit_read_only (a_index)
		end

feature -- Status_setting		

	require_password
			-- Use a `password' (hardcoded) when writing to Current.
			-- The user does not have to enter a password.  When calling
			-- `set_value' with `is_password_required', the passed-in value
			-- must have zeros in the password bits.  (The caller does not
			-- provide a password.)
		do
			is_password_required := true
		ensure
			definition: is_password_required
		end

	remove_password
			-- Remove the requirement for a password.
		do
			is_password_required := false
		ensure
			definition: not is_password_required
		end

	set_read_write
			-- Make Current readable and writeable
			-- (i.e can call both `value' and `set_value')
		do
			is_read_only := false
			is_write_only := false
		ensure
			is_readable: is_readable
			is_writeable: is_writable
		end

	set_read_only
			-- Make Current unchangeable
			-- (i.e. can call `value' but not `set_value')
		do
			is_read_only := true
			is_write_only := false
		ensure
			definition: is_read_only
			not_writable: not is_writable
		end

	set_write_only
			-- Make Current changable but not readable
			-- (i.e. can call `set_value' but not `value')
		do
			is_read_only := false
			is_write_only := true
		ensure
			definition: is_write_only
			not_writable: not is_read_only
		end

	set_bit_read_write (a_index: INTEGER_32)
			-- Set the `a_index' bit to read-write
		require
			valid_index: a_index >= 0 and a_index < 32
		local
			m: like pin_mask
		do
			m := pin_mask (a_index)
				-- Ensure the read-only bit is cleared
			read_only_mask := read_only_mask.bit_and (m.bit_not)
				-- Ensure the write-only bit is cleared
			write_only_mask := write_only_mask.bit_and (m.bit_not)
		ensure
			not_bit_is_read_only: not is_bit_read_only (a_index)
			bit_not_write_only: not is_bit_write_only (a_index)
			bit_not_write_once: not is_bit_write_once (a_index)
		end

	set_bit_read_only (a_index: INTEGER_32)
			-- Set the `a_index' bit to "read-only"
		require
			valid_index: a_index >= 0 and a_index < 32
		local
			m: like pin_mask
		do
			m := pin_mask (a_index)
				-- Ensure the write-only bit is cleared
			write_only_mask := write_only_mask.bit_and (m.bit_not)
				-- Set the read-only bit
			read_only_mask := read_only_mask.bit_or (m)
		ensure
			not_bit_read_write: not is_bit_read_writable (a_index)
			bit_read_only: is_bit_read_only (a_index)
			bit_not_write_only: not is_bit_write_only (a_index)
			bit_not_write_once: not is_bit_write_once (a_index)
		end

	set_bit_write_only (a_index: INTEGER_32)
			-- Set the `a_index' bit to "write-only"
		require
			valid_index: a_index >= 0 and a_index < 32
		local
			m: like pin_mask
		do
			m := pin_mask (a_index)
				-- Ensure the read-only bit is cleared
			read_only_mask := read_only_mask.bit_and (m.bit_not)
				-- Set the read-only bit
			write_only_mask := write_only_mask.bit_or (m)
		ensure
			bit_is_write_only: is_bit_read_only (a_index)
			bit_not_read_only: not is_bit_write_only (a_index)
		end

	set_bit_write_once (a_index: INTEGER_32)
			-- Set the `a_index' bit "write-once"
		require
			valid_index: a_index >= 0 and a_index < 32
		local
			m: like pin_mask
		do
			m := pin_mask (a_index)
				-- Clear bit from other masks
			read_only_mask := read_only_mask.bit_and (m.bit_not)
			write_only_mask := write_only_mask.bit_and (m.bit_not)
				-- Set the read-only bit
			write_once_mask := write_once_mask.bit_or (m)
		ensure
			bit_write_once: is_bit_write_once (a_index)
			bit_is_write_only: not is_bit_read_only (a_index)
			bit_not_read_only: not is_bit_write_only (a_index)
		end

feature {NONE} -- Implementation

	filtered (a_value: NATURAL_32): NATURAL_32
			-- The result of filtering `a_value' against the `reserved_mask'
			-- to set the "don't-care" bits to zero.
		local
			m: NATURAL_32
		do
				-- Set all reserved and password bits to zero,
				-- preserving other bits
			m := reserved_mask.bit_or (read_only_mask)
			if is_password_required then
				m := m.bit_or (password_mask)
			end
			Result := a_value.bit_and (m.bit_not)
		end

	filtered_on_write (a_value: NATURAL_32): NATURAL_32
			-- The result of filtering `a_value' against any `write-once_mask'
			-- bits to set "write-once-to-clear" or "write-once-to-clear-other"
			-- bits to their default_value.
			-- This feature is called in `set_value' after writing to the
			-- physical register to check writing to a particular bit should
			-- have cleared that bit.
		do
		end

feature {NONE} -- Implementation

	pointer: POINTER
			-- The address Current represents

	pin_mask (a_index: INTEGER_32): NATURAL_32
			-- Bitmask used to isolate the value a single bit in a register
			-- (i.e. 32-bit number with a one in the `a_index' location
			-- which can be bit-anded with a regiter to return only the
			-- value of that pin)
		require
			index_big_enough: a_index >= 0
			index_small_enougth: a_index <= 31
		local
			one: NATURAL_32
			shift: INTEGER_32
		do
			one := (1).to_natural_32
			shift := a_index \\ 32
			Result := one.bit_shift_left (shift)
		end

	password: NATURAL_32 = 0x5A000000
			-- The "Clock Manager Password", always the same "5a" shifted
			-- into bits 24..31

	password_mask: NATURAL_32 = 0xFF000000
			-- `bit_and' with `value' to return the "PASSWD" bits (24..31)
			-- 1111 1111 0000 0000 0000 0000 0000 0000
			-- Some registers require a password when writing to the
			-- register, but when quered, return zeros in these bits.
			-- `filtered_value' can use this to ignore these bits when
			-- checking if the register's `value' was set.

	reserved_mask: NATURAL_32
			-- In some registers, particular bits are desinated "write
			-- as 0" bits (i.e. reserved) and read as "don't care".
			-- Set this attribute with `set_reserved_bits' to allow
			-- contract checking for `set_value' with `is_valid_value'.
			-- The default is 0x00000000 (i.e. no reserved bits)

	read_only_mask: NATURAL_32
			-- Marks the bits that are "read_only"

	write_only_mask: NATURAL_32
			-- Marks the bits that are "write_only"

	write_once_mask: NATURAL_32
			-- Marks bits that should read zero after setting a one

feature {NONE} -- Implementation

	c_register_value (a_address: POINTER): NATURAL_32
			-- The value stored at physical address `a_address'.
		external
			"C inline"
		alias
			"[
				unsigned int* v = (void*)($a_address);
				return (EIF_NATURAL_32) (*v);
			]"
		end

	c_set_register_value (a_address: POINTER; a_value: NATURAL_32)
			-- Set the value referenced by `a_address' to `a_value'
		external
			"C inline"
		alias
			"[
				unsigned int* a = ($a_address);
				*a = $a_value;
			]"
		ensure
--			value_was_set: c_register_value (a_address) = a_value
		end

invariant

	read_only_implication: is_read_only implies not is_write_only
	write_only_implication: is_write_only implies not is_read_only
	readable_implication: is_readable implies not is_write_only
	writable_implication: is_writable implies not is_read_only

	not_bits_read_and_write_only: read_only_mask.bit_and (write_only_mask) = 0
	not_bits_read_and_write_once: read_only_mask.bit_and (write_once_mask) = 0

end
