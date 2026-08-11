note
	description: "[
		A Clock Manager General Purpose Clock Control register for the
		Raspberry Pi with the BCM2711 processor.
		See BCM2711 ARM Peripherals.pdf, page 104.
		]"
	author: "Jimmy J Johnson"
	date: "4/3/22"

class
	CLOCK_CONTROL_REGISTER

inherit

	REGISTER
		redefine
			make
		end

inherit {NONE}

	GPIO_CLOCK_CONSTANTS
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_address: POINTER; a_name: like name; a_description: like description)
			-- Create an instance
		do
			Precursor {REGISTER} (a_address, a_name, a_description)
			require_password
			set_reserved_mask (0x00FFF840)	-- (11..23 & 6)
			set_write_only_mask (password_mask)
			set_bit_read_only (7)
				-- Set default source to Oscillator
			set_default_value (0x00000001)
--			reset
		end

feature -- Access

	source: NATURAL_32
			-- The source from which Current is running
		do
				-- No shifting required
			Result := value.bit_and (source_mask)
		ensure
			result_big_enough: Result >= {GPIO_CLOCK_CONSTANTS}.ground_0
			result_small_enough: Result <= {GPIO_CLOCK_CONSTANTS}.ground_15
		end

	mash: NATURAL_32
			-- The current MASH filter set in this register
		do
			Result := value.bit_and (mash_mask).bit_shift_right (9)
		ensure
			valid_result: Result = {GPIO_CLOCK_CONSTANTS}.integer_division or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_1 or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_2 or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_3
		end

feature -- Status report

	is_enabled: BOOLEAN
			-- Is this clock register enabled?
		do
			Result := not (value.bit_and (enable_mask) = 0)
		end

	is_busy: BOOLEAN
			-- Is the clock busy?  Is it running?
		do
			Result := not (value.bit_and (busy_mask) = 0)
		end

	is_flipped: BOOLEAN
			-- Is the clock generator output inverted?
		do
			Result := not (value.bit_and (flip_mask) = 0)
		end

feature -- Status setting

	 enable
			-- Enable the clock generator (i.e. turn it on)
			-- Request the clock to start after the clock cycle completes.
			-- Waiting for cycle completion avoids glitches, but requires this feature
			-- to `wait' for a short time to allow the "busy" bit to become set.
		local
			v: NATURAL_32
			m: NATURAL_32
		do
				-- Can't we just set bit 4?
				--      NO!  There's reserved bitt, password, etc.
--			set_bit (4)
				-- Need to set bit 4 without chaning other settings,
				-- but can not write the bit 7 (it's read only).
			v := value
				-- Make `m' to ignore reserve and password bits.
			m := password_mask.bit_or (read_only_mask.bit_or (reserved_mask))
			m := m.bit_or (busy_mask)
			v := v.bit_and (m.bit_not)
			v := v.bit_or (enable_mask)		-- set bit 4
			print ("{CLOCK_CONTROL_REGISTER}.enable:  v = " + v.to_binary_string + "%N")
			set_value (v)		-- this will set the value using a password
			print ("{CLOCK_CONTROL_REGISTER}.enable:  value = " + value.to_binary_string + "%N")
				-- Wait for the busy bit to actually become set
			wait (Default_wait, agent is_busy)
			print ("{CLOCK_CONTROL_REGISTER}.enable:  value = " + value.to_binary_string + "%N")
		ensure
			is_enabled: is_enabled
			is_running: is_busy
		end

	disable
			-- Disable the clock generator (i.e. turn it off)
			-- Request the clock to stop after the clock cycle completes.
			-- Waiting for cycle completion avoids glitches, but requires this feature
			-- to `wait' for a short time to allow the "busy" bit to clear.
		local
			v: NATURAL_32
			m: NATURAL_32
		do
				-- Just clear bit 4...  NO!
--			clear_bit (4)
				-- Need to clear bit 4, without changing other settings.
			v := value
				-- clear reseved bits and bit 7
			m := password_mask.bit_or (read_only_mask.bit_or (reserved_mask))
			m := m.bit_or (busy_mask)
			v := v.bit_and (m.bit_not)
			v := v.bit_and (enable_mask.bit_not)		-- clears bit 4
			set_value (v)		-- Changes the `value' using the password
				-- Wait for the busy bit to actually clear
			wait (Default_wait, agent is_busy)
		ensure
			not_enabled: not is_enabled
			not_running: not is_busy
		end

	kill
			-- Stop and reset the clock generator without completing the
			-- current clock cycle.
			-- "This is intended for test/debut only.  Using this control [feature]
			-- may cause a glitch on the clock generator output."
		do
			check
				not_yet_implemented: False then
			end
		end

	flip
			-- Invert the clock generator output
			-- Intended for use in test/debug only.
		require
			not_busy: not is_busy
		local
			v: NATURAL_32
		do
			v := value
				-- Clears the bit
			v := v.bit_and (flip_mask.bit_not)
			if not is_flipped then
				v := v.bit_or (flip_mask)
			end
			set_value (v)
		ensure
			was_flipped: is_flipped = not old is_flipped
		end

feature -- Element change

	set_clock_source (a_source: NATURAL_32)
			-- Set the clock source
		require
			is_valid_source: is_valid_clock_source (a_source)
			not_busy: not is_busy
			not_enabled: not is_enabled
		local
			v: NATURAL_32
		do
				-- Set source without changing other bits
			v := value
			v := v.bit_and (source_mask.bit_not)	-- clear source bits
				-- No shifting required
			v := v.bit_or (a_source)
			set_value (v)
		ensure
			source_was_set: source = a_source
		end

	set_mash (a_mash: NATURAL_32)
			-- Set the MASH (Multi-stAge noise SHaping) noise-shaping divider to
			-- `a_mash' in order to "push fractional divider jitter out of the
			-- audio band.
			-- Set up the MASH filter before enabling Current.
			-- See http://www.aholme.co.uk/Frac2/Mash.htm, for example.
		require
			is_valid_mash: is_valid_mash (a_mash)
			not_busy: not is_busy
			not_enabled: not is_enabled
		local
			v: NATURAL_32
		do
			v := value
			v := v.bit_and (mash_mask.bit_not)	-- clear MASH bits
			v := v.bit_or (a_mash.bit_shift_left (9))
			set_value (v)
		ensure
			mash_was_set: mash = a_mash
		end

feature -- Query

feature {NONE} -- Implementation

	wait (a_microseconds: NATURAL_32; a_condition: FUNCTION [TUPLE, BOOLEAN])
			-- Repeatedly pause execution for `a_microseconds', waiting for
			-- `a_condition'; but only pause for `max_wait_cycles' even if
			-- `a_condition' is not yet true.
		local
			i: INTEGER
		do
			from i := 1
			until a_condition.item or else i > max_wait_cycles
			loop
					-- Convert to nanoseconds
				{EXECUTION_ENVIRONMENT}.sleep (a_microseconds * 1000)
				i := i + 1
			end
		end

	max_wait_cycles: INTEGER_32 = 100
			-- Seems like enough tries

	is_idle: BOOLEAN
			-- Is the clock not busy?  Is it stopped?
			-- Negation of `is_busy' to be used as arguemnt to `wait'
		do
			Result := not is_busy
		ensure
			definition: Result implies not is_busy or not Result implies is_busy
		end

feature {NONE} -- Implementation

	Default_wait: NATURAL_32 = 100
			-- Default time passed to `wait' in microseconds

	mash_mask: NATURAL_32 = 0x00000600
			-- `bit_and' with `value' to return the "MASH" bits (9..10)
			-- 0000 0000 0000 0000 0000 0110 0000 0000

	flip_mask: NATURAL_32 = 0x00000100
			-- `bit_and' with `value' to return the "FLIP" bit (8)
			-- 0000 0000 0000 0000 0000 0001 0000 0000

	busy_mask: NATURAL_32 = 0x00000080
			-- `bit_and' with `value' to return the "BUSY" bit (7)
			-- 0000 0000 0000 0000 0000 0000 1000 0000

	kill_mask: NATURAL_32 = 0x00000020
			-- `bit_and' with `value' to return the "KILL" bit (5)
			-- 0000 0000 0000 0000 0000 0000 0010 0000

	enable_mask: NATURAL_32 = 0x00000010
			-- `bit_and' with `value' to return the "ENAB" bit (4)
			-- 0000 0000 0000 0000 0000 0000 0001 0000

	source_mask: NATURAL_32 = 0x000000F
			-- `bit_and' with `value' to return the "SRC" bits (0..3)
			-- 0000 0000 0000 0000 0000 0000 0000 1111

invariant

	is_read_writable: is_read_writable
		-- Password bits
	is_bit_31_write_only: is_bit_write_only (31)
	is_bit_30_write_only: is_bit_write_only (30)
	is_bit_29_write_only: is_bit_write_only (29)
	is_bit_28_write_only: is_bit_write_only (28)
	is_bit_27_write_only: is_bit_write_only (27)
	is_bit_26_write_only: is_bit_write_only (26)
	is_bit_25_write_only: is_bit_write_only (25)
	is_bit_24_write_only: is_bit_write_only (24)
		-- reserved bits
	is_bit_23_reserved: is_bit_reserved (23)
	is_bit_22_reserved: is_bit_reserved (22)
	is_bit_21_reserved: is_bit_reserved (21)
	is_bit_20_reserved: is_bit_reserved (20)
	is_bit_19_reserved: is_bit_reserved (19)
	is_bit_18_reserved: is_bit_reserved (18)
	is_bit_17_reserved: is_bit_reserved (17)
	is_bit_16_reserved: is_bit_reserved (16)
	is_bit_15_reserved: is_bit_reserved (15)
	is_bit_14_reserved: is_bit_reserved (14)
	is_bit_13_reserved: is_bit_reserved (13)
	is_bit_12_reserved: is_bit_reserved (12)
	is_bit_11_reserved: is_bit_reserved (11)
		-- MASH, FLIP, BUSY bits
	is_bit_10_writeable: is_bit_read_writable (10)
	is_bit_9_writeable: is_bit_read_writable (9)
	is_bit_8_writeable: is_bit_read_writable (8)
	is_bit_7_writeable: is_bit_read_only (7)
		-- reserved
	is_bit_6_reserved: is_bit_reserved (6)
		-- KILL, ENAB, SRC bits
	is_bit_5_read_writable: is_bit_read_writable (5)
	is_bit_4_read_writable: is_bit_read_writable (4)
	is_bit_3_read_writable: is_bit_read_writable (3)
	is_bit_2_read_writable: is_bit_read_writable (2)
	is_bit_1_read_writable: is_bit_read_writable (1)
	is_bit_0_read_writable: is_bit_read_writable (0)

end
