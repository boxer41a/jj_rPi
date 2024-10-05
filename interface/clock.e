note
	description: "[
		A General Purpose GPIO Clock, the PCM Clock or the PWM Clock
		in the {PI_CONTROLLER}.
		See BCM2711 ARM Peripheral, page 102-105
		See BCM2835 Audio & PWM Clocks, Feb 2013.

		A clock is controlled by its `controller' register.  The frequency source
		and MASH settings are selected with this {CLOCK_CONTROL_REGISTER}.
		The resulting output frequency results from a combination of frequency
		source, MASH settings, and settings in `divisor' {CLOCK_DIVISORS_REGISTER}.

		A `divisor' register has an integer part (DIVI) and a real part (DIVF).
		Depending on the MASH setting in the corresponding {CLOCK_CONTROL_REGISTER},
		the resulting frequency will be between a minimum and maximum.
		For {GPIO_CLOCK_CONSTANTS}.stage_1 mash setting:
			minimum frequency = source frequency / (DIVI + 1)
			maximum frequency = source frequency / (DIVI)
			average frequency = source frequency / (DIVI + DIVF // 4096)
				-- 4096, not 1024 based on various blog postings
				-- I'm not convinced that "4096" is correct.

The hardware clock frequency.

PI_HW_CLK_MIN_FREQ 4689
PI_HW_CLK_MAX_FREQ 250000000
PI_HW_CLK_MAX_FREQ_2711 375000000


		]"
	author: "Jimmy J Johnson"
	date: "10/18/20"

class
	CLOCK

inherit

	ANY

	PI_SHARED
		export
			{NONE}
				all
		end

inherit {NONE}

	GPIO_CLOCK_CONSTANTS
		export
			{NONE}
				all
			{ANY}
				is_valid_mash,
				minimum_allowed_frequency,
				maximum_allowed_frequency,
				oscillator_frequency
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING_8; a_address: POINTER)
			-- Set up Current where the `controller' register is at `a_address'
			-- and the `divisor' register is four bytes latter.
		require
			valid_name: a_name ~ "GP0" or a_name ~"GP1" or a_name ~ "GP2" or
						a_name ~ "PCM" or a_name ~ "PWM"
		local
			s: STRING_8
		do
			create controller.make (a_address, "CM_CTL")
			create divisor.make (a_address + 0x04,"CM_DIV")
		end

feature -- Access

	frequency: REAL_64
			-- The theoretical average frequency
			-- BCM2711 ARM Peripherals, page 103
		local
			sf: NATURAL_32
		do
			sf := source_frequency_table.definite_item (source)
			inspect mash
			when {GPIO_CLOCK_CONSTANTS}.integer_division then
				Result := sf / integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.stage_1 then
				Result := sf / (integer_divisor + real_divisor / 4096)
			when {GPIO_CLOCK_CONSTANTS}.stage_2 then
				Result := sf / (integer_divisor + real_divisor / 4096)
			when {GPIO_CLOCK_CONSTANTS}.stage_3 then
				Result := sf / (integer_divisor + real_divisor / 4096)
			else
				check
					should_not_happen: False
						-- because those are all the MASH settings
				end
			end
		end

	minimum_frequency: REAL_64
			-- The theoretical minimum frequency
			-- BCM2711 ARM Peripherals, page 103
		local
			sf: NATURAL_32
		do
			sf := source_frequency_table.definite_item (source)
			inspect mash
			when {GPIO_CLOCK_CONSTANTS}.integer_division then
				Result := sf / integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.stage_1 then
				Result := sf / (integer_divisor + 1)
			when {GPIO_CLOCK_CONSTANTS}.stage_2 then
				Result := sf / (integer_divisor + 2)
			when {GPIO_CLOCK_CONSTANTS}.stage_3 then
				Result := sf / (integer_divisor + 4)
			else
				check
					should_not_happen: False
						-- because those are all the MASH settings
				end
			end
		end

	maximum_frequency: REAL_64
			-- The theoretical maximum frequency
			-- BCM2711 ARM Peripherals, page 103
		local
			sf: NATURAL_32
		do
			sf := source_frequency_table.definite_item (source)
			inspect mash
			when {GPIO_CLOCK_CONSTANTS}.integer_division then
				Result := sf / integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.stage_1 then
				Result := sf / integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.stage_2 then
				Result := sf / (integer_divisor - 1)
			when {GPIO_CLOCK_CONSTANTS}.stage_3 then
				Result := sf / (integer_divisor - 3)
			else
				check
					should_not_happen: False
						-- because those are all the MASH settings
				end
			end
		end

	source: NATURAL_32
			-- The source from which Current gets its timing signal
		do
--			Result := controller.value.bit_and (source_mask)
			Result := controller.source
		ensure
			result_big_enough: Result >= {GPIO_CLOCK_CONSTANTS}.ground_0
			result_small_enough: Result <= {GPIO_CLOCK_CONSTANTS}.ground_15
		end

	mash: NATURAL_32
			-- The current MASH filter set in this register
		do
--			Result := controller.value.bit_and (mash_mask).bit_shift_right (9)
			Result := controller.mash
		ensure
			valid_result: Result = {GPIO_CLOCK_CONSTANTS}.integer_division or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_1 or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_2 or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_3
		end

feature -- Access

	integer_divisor: NATURAL_32
			-- The integer part of divisor
		do
--			Result := divisor.value.bit_and (divi_mask).bit_shift_right (12)
			Result := divisor.integer_divisor
		end

	real_divisor: NATURAL_32
			-- The floating point part of the devisor
		do
--			Result := divisor.value.bit_and (divf_mask)
			Result := divisor.real_divisor
		end


feature -- Status report

	is_enabled: BOOLEAN
			-- Is this clock enabled?
		do
--			Result := not (controller.value.bit_and (enable_mask) = 0)
			Result := controller.is_enabled
		end

	is_busy: BOOLEAN
			-- Is the clock busy?  Is it running?
		do
--			Result := not (controller.value.bit_and (busy_mask) = 0)
			Result := controller.is_busy
		end

	is_flipped: BOOLEAN
			-- Is the clock generator output inverted?
		do
--			Result := not (controller.value.bit_and (flip_mask) = 0)
			Result := controller.is_flipped
		end

feature -- Status setting

	enable
			-- Enable the clock generator (i.e. turn it on?)
			-- Request the clock to start without glitches (i.e. lets the
			-- cycle complete.  Once complete, the `is_busy' flags goes low.
--		local
--			v: NATURAL_32
		do
--				-- Need to set bit 7 without chaning other settings.
--				-- I think we need password in order change this register.
--			v := controller.value
--			print ("{CLOCK}.enable:  value read, v = " + v.out + "%N")
--			v := v.bit_or (password)			-- set password
--			v := v.bit_or (enable_mask)		-- set bit 4
--			print ("{CLOCK}.enable:  v = " + v.out + "%N")
--			controller.set_value (v)
--			if pi.is_test_mode then
--					-- Set the busy bit to emulate clock
--				controller.set_bit_read_write (7)
--				controller.set_bit (7)
--				controller.set_bit_read_only (7)
--			else
--					-- Wait for the busy bit to actually become set
--				wait (100, agent is_busy)
--			end
			controller.enable
		ensure
			is_enabled: is_enabled
			is_running: is_busy
		end

	disable
			-- Disable the clock generator (i.e. turn it off?)
			-- Request the clock to stop without glitches (i.e. lets the
			-- cycle complete.  Once complete, the `is_busy' flags goes low.
--		local
--			v: NATURAL_32
		do
--				-- Need to clear bit 7, without changing other settings.
--				-- I think we need password in order change this register.
--			v := controller.value
--			v := v.bit_or (password)
--			v := v.bit_and (enable_mask.bit_not)				-- clears bit 4
--			controller.set_value (v)
--				-- Wait for the busy bit to actually clear
--			wait (100, agent is_busy)
			controller.disable
		ensure
			is_enabled: not is_enabled
			is_running: not is_busy
		end

	flip
			-- Invert the clock generator output
			-- Intended for use in test/debug only.
		require
			not_busy: not is_busy
--		local
--			v: NATURAL_32
		do
--			v := controller.value
--			v := v.bit_or (password)
--				-- Clears the bit
--			v := v.bit_and (flip_mask.bit_not)
--			if not is_flipped then
--				v := v.bit_or (flip_mask)
--			end
--			controller.set_value (v)
			controller.flip
		ensure
			was_flipped: is_flipped = not old is_flipped
		end

feature -- Element change

	set_frequency (a_frequency: NATURAL_32; a_mash: NATURAL_32)
			-- Set the average output `frequency' (within some tolerance)
			-- and use `a_mash' for the MASH noise-shaping divider.
		require
			is_valid_mash: is_valid_mash (a_mash)
			frequency_not_too_high: a_frequency <= maximum_allowed_frequency
			frequency_attainable: a_frequency <= oscillator_frequency
			frequency_big_enough: a_frequency >= minimum_allowed_frequency
		local
			cs: like oscillator
			b: BOOLEAN
		do
			cs := choose_source (a_frequency, a_mash)
			if is_busy then
				b := is_busy
				disable
			end
			set_clock_source (cs)
			set_mash (a_mash)
				-- Reminder: `divisors' was set by `choose_source' above
			set_integer_divisor (divisors.divi)
			set_real_divisor (divisors.divf)
			if b then
					-- Restart the clock
				enable
			end
		ensure
			frequency_close_enough:  -- fix me
		end

	set_integer_divisor (a_value: NATURAL_32)
			-- Set the `integer_divisor' (DIVI)
		require
			value_big_enough: a_value >= 1
			value_big_enough_for_mash_2: mash = {GPIO_CLOCK_CONSTANTS}.stage_2 implies
										a_value > 1
			value_big_enough_for_mash_3: mash = {GPIO_CLOCK_CONSTANTS}.stage_3 implies
										a_value > 3
			value_small_enough: a_value < 4096
			not_busy: not is_busy
--		local
--			v: NATURAL_32
		do
--			v := divisor.value
--			v := v.bit_or (password)
--			v := v.bit_and (divi_mask.bit_not)		-- clear bits
--			v := v.bit_or (a_value.bit_shift_left (12))
--			divisor.set_value (v)
			divisor.set_integer_divisor (a_value)
		ensure
			integer_divisor_was_set: integer_divisor = a_value
			real_divisor_unchanged: real_divisor = old real_divisor
		end

	set_real_divisor (a_value: NATURAL_32)
			-- Set the floating point value of the divisor (DIVF)
		require
			value_big_enough: a_value >= 0
			value_small_enough: a_value < 4096
			not_busy: not is_busy
--		local
--			v: NATURAL_32
		do
--			v := divisor.value
--			v := v.bit_or (password)
--			v := v.bit_and (divf_mask.bit_not)		-- clear bits
--			v := v.bit_or (a_value)
--			divisor.set_value (v)
			divisor.set_real_divisor (a_value)
		ensure
			real_divisor_was_set: real_divisor = a_value
			integer_divisor_unchanged: integer_divisor = old integer_divisor
		end

feature -- Query

--	is_valid_value (a_value: NATURAL_32): BOOLEAN
--			-- Can `a_value' be written to Current?
--			-- Cannot `set_value' some values, because some bits in
--			-- certain registers are "write as 0" (i.e. reserved bits)
--			-- Redefined to verify `password' bits
--		do
--			Result := controller.is_valid_value (a_value) and
--						a_value.bit_and (password_mask) = password
--		end

feature {NONE} -- Implementation

	choose_source (a_frequency: NATURAL_32; a_mash: like {GPIO_CLOCK_CONSTANTS}.stage_1): like {GPIO_CLOCK_CONSTANTS}.oscillator
			-- Try to choose a clock source that can produce `a_frequency' when
			-- using `a_mash'.
				-- Find the best clock;  want the fastest and most stable
				-- Based on various blogs, etc.  the oscillator is fastest
				-- at 19.2MHz, PLLC at 1000MHz but can change if overclocked,
				-- PLLD at 500 MHz, and HDMI at 216MHz but can vary if HDMI
				-- display connected.
		local
			cs: NATURAL_32				-- clock source
			divs_ok: BOOLEAN
		do
			from cs := {GPIO_CLOCK_CONSTANTS}.ground_0
			until divs_ok or else cs > {GPIO_CLOCK_CONSTANTS}.ground_15
			loop
				cs := cs + 1
				find_frequency_divisors (cs, a_frequency, a_mash)
				divs_ok := divisors.divi >= mash_minimum_divisor_table.definite_item (a_mash)
			end
			check
				divs_ok: divs_ok
					-- If not then no source available to attain `a_frequency'
			end
			if divs_ok then
					-- Check resulting frequencies are in range
				find_frequency_spread (cs, divisors.divi, divisors.divf, a_mash)
					-- Failing checks below are likely because `a_frequency' is too low for `a_mash'
				check
					min_freq_not_too_small: frequency_spread.min_freq >= {GPIO_CLOCK_CONSTANTS}.minimum_allowed_frequency
						-- because the required chosen clock is too slow?
				end
				check
					max_freq_not_too_big: frequency_spread.max_freq <= {GPIO_CLOCK_CONSTANTS}.maximum_allowed_frequency
						-- Because chosen clock too slow?
				end
			end
			Result := cs
			ensure
				clock_speed_not_zero: source_frequency_table.definite_item (Result) > 0
			end

	find_frequency_spread (a_source: NATURAL_32; a_divi, a_divf: NATURAL_32; a_mash: NATURAL_32)
			-- The min, avg, and max frequency actually output from `a_source' given
			-- the divisors, saved in `frequency_spread'
			-- The resulting values could be out of range, so check the results by
			-- calling `is_valid_frequency_mash'.
		require
			is_valid_mash: is_valid_mash (a_mash)
			is_valid_source: is_valid_clock_source (a_source)
		local
			f: NATURAL_32
			min_freq: NATURAL_32
			avg_freq: NATURAL_32
			max_freq: NATURAL_32
		do
			f := source_frequency_table.definite_item (a_source)
				-- Find the resulting frequency spread
			inspect mash_minimum_divisor_table.definite_item (a_mash)
			when 1 then
				min_freq := f // a_divi
				avg_freq := f // a_divi
				max_freq := f // a_divi
			when 2 then
				min_freq := f // (a_divi + 1)
				avg_freq := f // (a_divi + a_divf // 4096)
				max_freq := f // a_divi
			when 3 then
				min_freq := f // (a_divi + 2)
				avg_freq := f // (a_divi + a_divf // 4096)
				max_freq := f // (a_divi - 1)
			when 5 then
				min_freq := f // (a_divi + 4)
				avg_freq := f // (a_divi + a_divf // 4096)
				max_freq := f // (a_divi - 3)
			else
				check
					should_not_happen: false
						-- because that is all posible `mash_minimum_divisor' values
				end
			end
			frequency_spread := [min_freq, avg_freq, max_freq]
		end

	find_frequency_divisors (a_source: like {GPIO_CLOCK_CONSTANTS}.oscillator; a_frequency: NATURAL_32; a_mash: like {GPIO_CLOCK_CONSTANTS}.stage_1)
			-- Find "DIVI" and "DIVF" for these values, placing result in `divisors'
			-- The frequencies resulting from these returned values may not be in range.
		require
			is_valid_mash: is_valid_mash (a_mash)
			frequency_not_too_high: a_frequency <= maximum_allowed_frequency
		local
			sf: NATURAL_32
			divi: NATURAL_32
			divf: NATURAL_32
			div: NATURAL_32
			rem: NATURAL_32
		do
			sf := source_frequency_table.definite_item (a_source)
				-- Compute DIVF and DIVI
			divi := sf // a_frequency
				-- Shift the remainder by 10 bits (i.e. multiply by 2^10)
			div := (sf \\ a_frequency).bit_shift_left (10)
			divf := div // a_frequency
				-- Need to "round" divf, so shift remainder and compair to (.5)(a_frequency)
			rem := (div \\ a_frequency).bit_shift_left (10)
			if rem >= (a_frequency // 2) then
				divf := divf + 1
			end
			divisors := [divi, divf]
		end

	frequency_spread:TUPLE [min_freq, avg_freq, max_freq: NATURAL_32]
			-- Stores result of `find_frequency_spread'
		attribute
			Result := [(0).as_natural_32, (0).as_natural_32, (0).as_natural_32]
		end

	divisors: TUPLE [divi: NATURAL_32; divf: NATURAL_32]
			-- Stores result of `find_frequency_divisors'
		attribute
			Result := [(0).as_natural_32, (0).as_natural_32]
		end

	set_clock_source (a_source: NATURAL_32)
			-- Set the clock source
		require
			is_valid_source: is_valid_clock_source (a_source)
			not_busy: not is_busy
			not_enabled: not is_enabled
--		local
--			v: NATURAL_32
		do
--				-- Set source without changing other bits
--				-- Might need password
--			v := controller.value
--			v := v.bit_or (password)
--			v := v.bit_and (source_mask.bit_not)	-- clear source bits
--				-- No shifting required
--			v := v.bit_or (a_source)
--			controller.set_value (v)
			controller.set_clock_source (a_source)
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
--		local
--			v: NATURAL_32
		do
--			v := controller.value
--			v := v.bit_or (password)
--			v := v.bit_and (mash_mask.bit_not)	-- clear MASH bits
--			v := v.bit_or (a_mash.bit_shift_left (9))
--			controller.set_value (v)
			controller.set_mash (a_mash)
		ensure
			mash_was_set: mash = a_mash
		end

feature {NONE} -- Implementation

--	wait (a_microseconds: NATURAL_32; a_condition: FUNCTION [TUPLE, BOOLEAN])
--			-- Repeatedly pause execution for `a_microseconds', waiting for
--			-- `a_condition'; but only pause for `max_wait_cycles' even if
--			-- `a_condition' is not yet true.
--		local
--			i: INTEGER
--		do
--			from i := 1
--			until a_condition.item or else i > max_wait_cycles
--			loop
--					-- Convert to nanoseconds
--				{EXECUTION_ENVIRONMENT}.sleep (a_microseconds * 1000)
--				i := i + 1
--			end
--		end

--	max_wait_cycles: INTEGER_32 = 100
--			-- Seems like enough tries

feature {NONE} -- Implementaton

	controller: CLOCK_CONTROL_REGISTER
			-- The General Purpose Clock Control register

	divisor: CLOCK_DIVISORS_REGISTER
			-- The General Purpose GPIO Clock Divisors register

--	password: NATURAL_32 = 0x5A000000
--			-- The "Clock Manager Password", always the same "5a" shifted
--			-- into bits 24..31

--	password_mask: NATURAL_32 = 0xFF000000
--			-- `bit_and' with `value' to return the "PASSWD" bits (24..31)
--			-- 1111 1111 0000 0000 0000 0000 0000 0000

feature {NONE} -- Implementation

--	mash_mask: NATURAL_32 = 0x00000600
--			-- `bit_and' with `value' to return the "MASH" bits (9..10)
--			-- 0000 0000 0000 0000 0000 0110 0000 0000

--	flip_mask: NATURAL_32 = 0x00000100
--			-- `bit_and' with `value' to return the "FLIP" bit (8)
--			-- 0000 0000 0000 0000 0000 0001 0000 0000

--	busy_mask: NATURAL_32 = 0x00000080
--			-- `bit_and' with `value' to return the "BUSY" bit (7)
--			-- 0000 0000 0000 0000 0000 0000 1000 0000

--	kill_mask: NATURAL_32 = 0x00000020
--			-- `bit_and' with `value' to return the "KILL" bit (5)
--			-- 0000 0000 0000 0000 0000 0000 0010 0000

--	enable_mask: NATURAL_32 = 0x00000010
--			-- `bit_and' with `value' to return the "ENAB" bit (4)
--			-- 0000 0000 0000 0000 0000 0000 0001 0000

--	source_mask: NATURAL_32 = 0x000000F
--			-- `bit_and' with `value' to return the "SRC" bits (0..3)
--			-- 0000 0000 0000 0000 0000 0000 0000 1111

feature {NONE} -- Implementation

--	divi_mask: NATURAL_32 = 0x00FFF000
--			-- `bit_and' with `value' to return the "DIVI" bits (12..23)
--			-- 0000 0000 1111 1111 1111 0000 0000 0000

--	divf_mask: NATURAL_32 = 0x00000FFF
--			-- `bit_and' with `value' to return the "DIVF" bits (0..11)
--			-- 0000 0000 0000 0000 0000 1111 1111 1111

invariant

	integer_divisor_big_enough: integer_divisor >= 1
	integer_divisor_small_enough: integer_divisor < 4096
	real_divisor_big_enough: integer_divisor >= 0
	real_divisor_small_enough: integer_divisor < 4096
	mash_valid: mash = {GPIO_CLOCK_CONSTANTS}.integer_division or
				mash = {GPIO_CLOCK_CONSTANTS}.stage_1 or
				mash = {GPIO_CLOCK_CONSTANTS}.stage_2 or
				mash = {GPIO_CLOCK_CONSTANTS}.stage_3
	mash_implication: (mash = {GPIO_CLOCK_CONSTANTS}.stage_2 implies integer_divisor > 1) and
					 (mash = {GPIO_CLOCK_CONSTANTS}.stage_3 implies integer_divisor > 3)

--		-- CM_GPOCTL, CM_GP1CTL, & CMGP2CTL
--	controller.is_read_writable
--		-- Password bits
--	controller.is_bit_write_only (31)
--	controller.is_bit_write_only (30)
--	controller.is_bit_write_only (29)
--	controller.is_bit_write_only (28)
--	controller.is_bit_write_only (27)
--	controller.is_bit_write_only (26)
--	controller.is_bit_write_only (25)
--	controller.is_bit_write_only (24)
--		-- reserved bits
--	controller.is_bit_reserved (23)
--	controller.is_bit_reserved (22)
--	controller.is_bit_reserved (21)
--	controller.is_bit_reserved (20)
--	controller.is_bit_reserved (19)
--	controller.is_bit_reserved (18)
--	controller.is_bit_reserved (17)
--	controller.is_bit_reserved (16)
--	controller.is_bit_reserved (15)
--	controller.is_bit_reserved (14)
--	controller.is_bit_reserved (13)
--	controller.is_bit_reserved (12)
--	controller.is_bit_reserved (11)
--		-- MASH, FLIP, BUSY bits
--	controller.is_bit_read_writable (10)
--	controller.is_bit_read_writable (9)
--	controller.is_bit_read_writable (8)
--	controller.is_bit_read_only (7)
--		-- reserved
--	controller.is_bit_reserved (6)
--		-- KILL, ENAB, SRC bits
--	controller.is_bit_read_writable (5)
--	controller.is_bit_read_writable (4)
--	controller.is_bit_read_writable (3)
--	controller.is_bit_read_writable (2)
--	controller.is_bit_read_writable (1)
--	controller.is_bit_read_writable (0)

--		-- CM_GP0DIV, CM_GP1DIV, & CM_GP2DIV
--	divisor.is_read_writable
--		-- Password bits
--	divisor.is_bit_write_only (31)
--	divisor.is_bit_write_only (30)
--	divisor.is_bit_write_only (29)
--	divisor.is_bit_write_only (28)
--	divisor.is_bit_write_only (27)
--	divisor.is_bit_write_only (26)
--	divisor.is_bit_write_only (25)
--	divisor.is_bit_write_only (24)
--	divisor.is_bit_read_writable (23)
--	divisor.is_bit_read_writable (22)
--	divisor.is_bit_read_writable (21)
--	divisor.is_bit_read_writable (20)
--	divisor.is_bit_read_writable (19)
--	divisor.is_bit_read_writable (18)
--	divisor.is_bit_read_writable (17)
--	divisor.is_bit_read_writable (16)
--	divisor.is_bit_read_writable (15)
--	divisor.is_bit_read_writable (14)
--	divisor.is_bit_read_writable (13)
--	divisor.is_bit_read_writable (12)
--	divisor.is_bit_read_writable (11)
--	divisor.is_bit_read_writable (10)
--	divisor.is_bit_read_writable (9)
--	divisor.is_bit_read_writable (8)
--	divisor.is_bit_read_writable (7)
--	divisor.is_bit_read_writable (6)
--	divisor.is_bit_read_writable (5)
--	divisor.is_bit_read_writable (4)
--	divisor.is_bit_read_writable (3)
--	divisor.is_bit_read_writable (2)
--	divisor.is_bit_read_writable (1)
--	divisor.is_bit_read_writable (0)

end
