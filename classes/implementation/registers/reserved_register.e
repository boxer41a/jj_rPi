note
	description: "[
		Represents a "reserved" register in a {PI_CONTROLLER}.
		See BCM2711 Peripherals.pdf, page 83 for an example.
		
		Current's `value' cannot/should not be read; this is just a place-
		holder to mark reserved registers.
		
		All features are inapplicable except for `address', `name', 
		`description', and `show'.
		
		This class may be an over-specification and not very useful.
		]"
	author: "Jimmy J Johnson"
	date: "5/26/26"


frozen class
	RESERVED_REGISTER

inherit

	REGISTER
		export
			{NONE}
				all
			{ANY}
				name,
				description
		redefine
			make,
			name,
			description,
			value,
			bit_value,
			as_hex_string,
			as_binary_string,
			set_default_value,
			reset,
			set_value,
			show,
			set_bit,
			clear_bit,
			set_reserved_mask,
			set_read_only_mask,
			set_write_only_mask,
			set_write_once_mask,
			is_valid_value,
			is_bit_set,
			is_reset,
			is_readable,
			is_writable,
			is_read_writable,
			is_bit_reserved,
			is_bit_read_only,
			is_bit_write_only,
			is_bit_write_once,
			is_bit_read_writable,
			is_bit_readable,
			is_bit_writable,
			require_password,
			remove_password,
			set_read_write,
			set_read_only,
			set_write_only,
			set_bit_read_write,
			set_bit_read_only,
			set_bit_write_only,
			set_bit_write_once,
			filtered,
			filtered_on_write,
			pin_mask,
			c_register_value,
			c_set_register_value
		end

create
	make

feature {NONE} -- Initialization

	make (a_address: POINTER; a_name: like name; a_description: like description)
			-- Set up the register
		do
			address := a_address
				-- Use copy to avoid an accidental name change
			name := "-"
			description := "Reserved"
		end

feature -- Access

	name: STRING_8
			-- A printable name for Current (e.g. GPFSEL0, GPLEV0, etc)
			-- In this case simple a dash

	description: STRING_8
			-- A short description of this register's function

	value: NATURAL_32
			-- The 32-bit value referenced by Current
			-- This feature ensures the password and write-only bits
			-- are zero.  Any reserved bits are also read as zeros even
			-- though the manual says we don't care.  Otherwise, there
			-- is not an easy way to check values in assertions.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	bit_value (a_index: INTEGER_32): NATURAL_32
			-- The 32-bit value referenced by Current
			-- This feature ensures the password and write-only bits
			-- are zero.  Any reserved bits are also read as zeros even
			-- though the manual says we don't care.  Otherwise, there
			-- is not an easy way to check values in assertions.
		require else
			called_in_error: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	as_hex_string: STRING
			-- The `value' displayed as a hex string
			-- (e.g. "0xFF000071")
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	as_binary_string: STRING
			-- The `value' displayed as a hex string
			-- (e.g. "0b11000000000000000000000001110001")
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature -- Element change

	set_default_value (a_value: NATURAL_32)
			-- Set the `default_value', the value to which Current is
			-- set upon creation or when `reset'.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	reset
			-- Change Current to its `default_value'
			-- Set each bit according to the "reset" value in the ARM Document
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	 set_value (a_value: NATURAL_32)
			-- Change the `value' stored in Current
			-- A post-condition will not work, because some registers
			-- are read-only or will be reset by the Pi after a value
			-- is written to the register.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	show
			-- Display values
		do
			print ("{" + generating_type +"}.show:  " + name + " at " + address.out + "%N")
			print ("     value = " + " Inapplicable" + "%N")
			print ("     password_mask:   " + password_mask.to_hex_string + "%N")
			print ("     reserved mask:   " + reserved_mask.to_hex_string + "%N")
			print ("     write-only mask: " + write_only_mask.to_hex_string + "%N")
			print ("     read-only mask:  " + read_only_mask.to_hex_string + "%N")
			print ("     is_pass_word_required:  " + is_password_required.out + "%N")
		end

	set_bit (a_index: INTEGER_32)
			-- Make the bit at `a_index' one without changing other bits
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	clear_bit (a_index: INTEGER_32)
			-- Make the bit at `a_index' zero without changing other bits
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_reserved_mask (a_mask: NATURAL_32)
			-- Change the `reserved_mask' to prevent certain bits from
			-- being changed ("write as zero, read as don't care)
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_read_only_mask (a_mask: NATURAL_32)
			-- Change the `read_only_mask' to mark bits as read-only.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_write_only_mask (a_mask: NATURAL_32)
			-- Change the `write_only_mask' to mark bits as write-only.
			-- These bits will always read as zero.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_write_once_mask (a_mask: NATURAL_32)
			-- Change the `write_once_mask' to mark bits as write-once.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature -- Query

	is_valid_value (a_value: NATURAL_32): BOOLEAN
			-- Can `a_value' be written to Current?
			-- Always false, because cannot write to a reserved register.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_set (a_index: INTEGER_32): BOOLEAN
			-- Is the `a_index' bit set to one?
			-- Always false, because cannot read from a reserved register.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature -- Status report

	is_reset: BOOLEAN
			-- Is Current set to its `default_value'
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_readable: BOOLEAN = False
			-- Can Current `value' be read (with perhaps
			-- some restrictions on `reserved_bits')?

	is_writable: BOOLEAN = False
			-- Can Current be changed?

	is_read_writable: BOOLEAN = False
			-- Is Current readable and writable?

	is_bit_reserved (a_index: INTEGER_32): BOOLEAN
			-- ISs bit number `a_index' marked as reserved?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_read_only (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' marked as read-only?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_write_only (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' marked as read-only?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_write_once (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' marked as write-once?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_read_writable (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' readable and writable?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_readable (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' readable?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	is_bit_writable (a_index: INTEGER_32): BOOLEAN
			-- Is bit number `a_index' writable?
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature -- Status_setting		

	require_password
			-- Use a `password' (hardcoded) when writing to Current.
			-- The user does not have to enter a password.  When calling
			-- `set_value' with `is_password_required', the passed-in value
			-- must have zeros in the password bits.  (The caller does not
			-- provide a password.)
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	remove_password
			-- Remove the requirement for a password.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_read_write
			-- Make Current readable and writeable
			-- (i.e can call both `value' and `set_value')
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_read_only
			-- Make Current unchangeable
			-- (i.e. can call `value' but not `set_value')
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_write_only
			-- Make Current changable but not readable
			-- (i.e. can call `set_value' but not `value')
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_bit_read_write (a_index: INTEGER_32)
			-- Set the `a_index' bit to read-write
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_bit_read_only (a_index: INTEGER_32)
			-- Set the `a_index' bit to "read-only"
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_bit_write_only (a_index: INTEGER_32)
			-- Set the `a_index' bit to "write-only"
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	set_bit_write_once (a_index: INTEGER_32)
			-- Set the `a_index' bit "write-once"
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature {NONE} -- Implementation

	filtered (a_value: NATURAL_32): NATURAL_32
			-- The result of filtering `a_value' against the `reserved_mask'
			-- to set the "don't-care" bits to zero.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	filtered_on_write (a_value: NATURAL_32): NATURAL_32
			-- The result of filtering `a_value' against any `write-once_mask'
			-- bits to set "write-once-to-clear" or "write-once-to-clear-other"
			-- bits to their default_value.
			-- This feature is called in `set_value' after writing to the
			-- physical register to check writing to a particular bit should
			-- have cleared that bit.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature {NONE} -- Implementation

	pin_mask (a_index: INTEGER_32): NATURAL_32
			-- Bitmask used to isolate the value a single bit in a register
			-- (i.e. 32-bit number with a one in the `a_index' location
			-- which can be bit-anded with a register to return only the
			-- value of that pin)
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

feature {NONE} -- Implementation

	c_register_value (a_address: POINTER): NATURAL_32
			-- The value stored at physical address `a_address'.
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

	c_set_register_value (a_address: POINTER; a_value: NATURAL_32)
			-- Set the value referenced by `a_address' to `a_value'
		require else
			inapplicable: False
		do
			check
				do_not_call: False then
					-- because it is an unused register
			end
		end

end
