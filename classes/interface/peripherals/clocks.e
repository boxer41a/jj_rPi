note
	description: "[
		Contains the clocks in the {PI_CONTROLLER}.

		This class encapsulates ALL three GPIO clocks [for the 2711] and the
		PCM and PWM clocks, because they all are defined from the same base
		address.
		]"
	author: "Jimmy J Johnson"
	date: "10/17/20"

class
	CLOCKS

inherit

	PERIPHERAL
		redefine
			make
		end

inherit {NONE}

	GPIO_CLOCK_CONSTANTS
		undefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_descriptor: INTEGER_32; a_length: INTEGER_32; a_address: NATURAL_32)
			-- Set up Current, creating the registers
			-- See BCM2711 Arm Peripherals, page 102 and
			-- BCM2835 Audio & PWM clocks
		do
			Precursor (a_file_descriptor, a_length, a_address)
			create clock_0.make ("GP0", base_address + 0x70)
			create clock_1.make ("GP1", base_address + 0x78)
			create clock_2.make ("GP2", base_address + 0x80)
				-- CM_PCMCTL base    0x7E10 1098 = 2,114,982,040
				-- GPIO clocks base  0x7E10 1000 = 2,114,981,888
				--                                       -----------
				--                                         152 ==> 0x98
			create pcm_clock.make ("PCM", base_address + 0x98)
				-- CM_PCMDIV base    0x7E10 109C = 2,114,982,044
				-- GPIO clocks base  0x7E10 1000 = 2,114,981,888
				--                                       -----------
				--                                         156 ==> 0x9C
			create pwm_clock.make ("PWM", base_address + 0xA0)
				-- Set defaults

		end

feature -- Access

	frequency (a_index: INTEGER_32): REAL_64
			-- The theoretical frequency producable on the clock that
			-- is indexed by `a_index' if that clock `is_enabled'
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.frequency
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	minimum_frquency (a_index: INTEGER_32): REAL_64
			-- The theoretical minimum frequency producable on the clock that
			-- is indexed by `a_index' if that clock `is_enabled'
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.minimum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.minimum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.minimum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.minimum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.minimum_frequency
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	maximum_frquency (a_index: INTEGER_32): REAL_64
			-- The theoretical maximum frequency producable on the clock that
			-- is indexed by `a_index' if that clock `is_enabled'
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.maximum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.maximum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.maximum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.maximum_frequency
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.maximum_frequency
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	source (a_index: INTEGER_32): NATURAL_32
			-- The source from which the clock indexed by `a_index' s
			-- gets its timing signal
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.source
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.source
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.source
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.source
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.source
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			result_big_enough: Result >= {GPIO_CLOCK_CONSTANTS}.ground_0
			result_small_enough: Result <= {GPIO_CLOCK_CONSTANTS}.ground_15
		end

	mash (a_index: INTEGER_32): NATURAL_32
			-- The MASH filter in use by the clock indexed by `a_index'
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.mash
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.mash
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.mash
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.mash
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.mash
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			valid_result: Result = {GPIO_CLOCK_CONSTANTS}.integer_division or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_1 or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_2 or
							Result = {GPIO_CLOCK_CONSTANTS}.stage_3
		end

feature -- Status report

	is_enabled (a_index: INTEGER_32): BOOLEAN
			-- Is the clock indexed by `a_index' enabled?
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.is_enabled
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.is_enabled
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.is_enabled
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.is_enabled
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.is_enabled
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	is_busy (a_index: INTEGER_32): BOOLEAN
			-- Is the clock indexed by `a_index' busy?
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.is_busy
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.is_busy
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.is_busy
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.is_busy
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.is_busy
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	is_flipped (a_index: INTEGER_32): BOOLEAN
			-- Is the generated output for the clock indexed
			-- by `a_index' inverted?
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.is_flipped
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.is_flipped
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.is_flipped
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.is_flipped
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.is_flipped
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

feature -- Element change

	set_frequency (a_index: INTEGER_32; a_frequency: NATURAL_32; a_mash: NATURAL_32)
			-- For clock number `a_index', set the average output `frequency'
			-- and use `a_mash' for the MASH noise-shaping divider.
		require
			valid_clock_index: is_valid_clock_index (a_index)
			valid_mash: is_valid_mash (a_mash)
			frequency_not_too_high: a_frequency <= maximum_allowed_frequency
			frequency_attainable: a_frequency <= oscillator_frequency
			frequency_big_enough: a_frequency >= minimum_allowed_frequency
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				clock_0.set_frequency (a_frequency, a_mash)
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				clock_1.set_frequency (a_frequency, a_mash)
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				clock_2.set_frequency (a_frequency, a_mash)
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				pcm_clock.set_frequency (a_frequency, a_mash)
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				pwm_clock.set_frequency (a_frequency, a_mash)
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

feature -- Basic operations

	enable (a_index: INTEGER_32)
			-- Enable the clock generator for clock number `a_index'
			-- (i.e. turn it on)
			-- Request the clock to start without glitches (i.e. lets the
			-- cycle complete).  Once complete, the `is_busy' flags goes low.
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				clock_0.enable
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				clock_1.enable
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				clock_2.enable
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				pcm_clock.enable
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				pwm_clock.enable
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			is_enabled: is_enabled (a_index)
			is_running: is_busy (a_index)
		end

	disable (a_index: INTEGER_32)
			-- Disable the clock generator for clock number `a_index'
			-- (i.e. turn it off?)
			-- Request the clock to stop without glitches (i.e. lets the
			-- cycle complete.  Once complete, the `is_busy' flags goes low.
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				clock_0.disable
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				clock_1.disable
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				clock_2.disable
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				pcm_clock.disable
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				pwm_clock.disable
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			not_enabled: not is_enabled (a_index)
			not_running: not is_busy (a_index)
		end

	flip (a_index: INTEGER_32)
			-- Invert the clock generator output for clock number `a_index'
			-- Intended for use in test/debug only.
		require
			valid_clock_index: is_valid_clock_index (a_index)
			not_busy: not is_busy (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				clock_0.flip
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				clock_1.flip
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				clock_2.flip
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				pcm_clock.flip
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				pwm_clock.flip
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			was_flipped: is_flipped (a_index) = not old is_flipped (a_index)
		end

	show (a_index: INTEGER_32)
			-- Display status information about the clock referenced
			-- by `a_index'.  See {GPIO_CLOCK_CONSTANTS}.
		require
			valid_clock_index: is_valid_clock_index (a_index)
		local
			c: CLOCK
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				c := clock_0
				print ("{CLOCKS}.show:   GPIO Clock 0 %N")
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				c := clock_1
				print ("{CLOCKS}.show:   GPIO Clock 1 %N")
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				c := clock_2
				print ("{CLOCKS}.show:   GPIO Clock 2 %N")
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				c := pcm_clock
				print ("{CLOCKS}.show:   PCM Clock %N")
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				c := pwm_clock
				print ("{CLOCKS}.show:   PWM Clock %N")
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
					-- Appease Void safety
				c := clock_0
				print ("{CLOCKS}.show:   invalid index  %N")
			end
			print ("{CLOCKS}.show:  frequency = " + c.frequency.out + "%N")
			print ("{CLOCKS}.show:  minimum_frequency = " + c.minimum_frequency.out + "%N")
				-- `source'
			inspect c.source
			when {GPIO_CLOCK_CONSTANTS}.oscillator then
				print ("{CLOCKS}.show:  source = " + c.source.out + ", oscillator %N")
			when {GPIO_CLOCK_CONSTANTS}.plla then
				print ("{CLOCKS}.show:  source = " + c.source.out + ", plla %N")
			when {GPIO_CLOCK_CONSTANTS}.pllc then
				print ("{CLOCKS}.show:  source = " + c.source.out + ", pllc %N")
			when {GPIO_CLOCK_CONSTANTS}.plld then
				print ("{CLOCKS}.show:  source = " + c.source.out + ", plld %N")
			when {GPIO_CLOCK_CONSTANTS}.hdmi then
				print ("{CLOCKS}.show:  source = " + c.source.out + ", hdmi %N")
			else
				print ("{CLOCKS}.show:  source = " + c.mash.out + ",  source unknown %N")
			end
				-- `mash'
			inspect c.mash
			when {GPIO_CLOCK_CONSTANTS}.integer_division then
				print ("{CLOCKS}.show:  mash = " + c.mash.out + ", integer division %N")
			when {GPIO_CLOCK_CONSTANTS}.stage_1 then
				print ("{CLOCKS}.show:  mash = " + c.mash.out + ", stage 1 %N")
			when {GPIO_CLOCK_CONSTANTS}.stage_2 then
				print ("{CLOCKS}.show:  mash = " + c.mash.out + ", stage 2 %N")
			when {GPIO_CLOCK_CONSTANTS}.stage_3 then
				print ("{CLOCKS}.show:  mash = " + c.mash.out + ", stage 3 %N")
			else
				print ("{CLOCKS}.show:  mash = " + c.mash.out + ",  mash unknown %N")
			end
			print ("{CLOCKS}.show:  integer_divisor = " + c.integer_divisor.out + "%N")
			print ("{CLOCKS}.show:  real_divisor = " + c.real_divisor.out + "%N")
			print ("{CLOCKS}.show:  is_enabled = " + c.is_enabled.out + "%N")
			print ("{CLOCKS}.show:  is_busy = " + c.is_busy.out + "%N")
			print ("{CLOCKS}.show:  is_flipped = " + c.is_flipped.out + "%N")
		end

feature {NONE} -- Implementation

	integer_divisor (a_index: INTEGER_32): NATURAL_32
			-- The integer part of divisor the clock number `a_index'
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.integer_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.integer_divisor
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	real_divisor (a_index: INTEGER_32): NATURAL_32
			-- The real part of divisor the clock number `a_index'
		require
			valid_clock_index: is_valid_clock_index (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				Result := clock_0.real_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				Result := clock_1.real_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				Result := clock_2.real_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				Result := pcm_clock.real_divisor
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				Result := pwm_clock.real_divisor
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		end

	set_integer_divisor (a_index: INTEGER_32; a_value: NATURAL_32)
			-- Set the `integer_divisor' (DIVI) for clock number `a_index'
			-- to `a_value'
		require
			valid_clock_index: is_valid_clock_index (a_index)
			value_big_enough: a_value >= 2
			value_small_enough: a_value < 4096
			not_busy: not is_busy (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				clock_0.set_integer_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				clock_1.set_integer_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				clock_2.set_integer_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				pcm_clock.set_integer_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				pwm_clock.set_integer_divisor (a_value)
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			divisor_was_set: integer_divisor (a_index) = a_value
		end

	set_real_divisor (a_index: INTEGER_32; a_value: NATURAL_32)
			-- Set the floating point value of the divisor (DIVF) for clock
			-- numer `a_index' to `a_value
		require
			valid_clock_index: is_valid_clock_index (a_index)
			value_big_enough: a_value >= 0
			value_small_enough: a_value < 4096
			not_busy: not is_busy (a_index)
		do
			inspect a_index
			when {GPIO_CLOCK_CONSTANTS}.clock_0_index then
				clock_0.set_real_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_1_index then
				clock_1.set_real_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_2_index then
				clock_2.set_real_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_pcm_index then
				pcm_clock.set_real_divisor (a_value)
			when {GPIO_CLOCK_CONSTANTS}.clock_pwm_index then
				pwm_clock.set_real_divisor (a_value)
			else
				check
					should_not_happen: false
						-- Because that is all the clocks
				end
			end
		ensure
			divisor_was_set: real_divisor (a_index) = a_value
		end

feature {NONE} -- Implementation

	 clock_0: CLOCK
			-- One of three GPIO clocks

	clock_1: CLOCK
			-- One of three GPIO clocks

	clock_2: CLOCK
			-- One of three GPIO clocks

	pcm_clock: CLOCK
			-- The Pulse Code Modulator clock

	pwm_clock: CLOCK
			-- The Pulse Width Modulator clock

--	clock_0_controller: CLOCK_CONTROL_REGISTER
--			-- Clock 0, General Purpose GPIO Clock Control register
--			-- "CM_GP0CTL"

--	clock_0_divisor: CLOCK_DIVISORS_REGISTER
--			-- Clock 0, General Purpose GPIO Clock Divisors register

--	clock_1_controller: CLOCK_CONTROL_REGISTER
--			-- Clock 0, General Purpose GPIO Clock Control register
--			-- "CM_GP1CTL"

--	clock_1_divisor: CLOCK_DIVISORS_REGISTER
--			-- Clock 0, General Purpose GPIO Clock Divisors register

--	clock_2_controller: CLOCK_CONTROL_REGISTER
--			-- Clock 0, General Purpose GPIO Clock Control register
--			-- "CM_GP2CTL"

--	clock_2_divisor: CLOCK_DIVISORS_REGISTER
--			-- Clock 0, General Purpose GPIO Clock Divisors register

--	pcm_clock_control: CLOCK_CONTROL_REGISTER
--			-- PCM Clock Control register
--			-- "CM_PCMCTL"

--	pcm_clock_divisor: CLOCK_DIVISORS_REGISTER
--			-- PCM Clock Control register
--			-- "CM_PCMDIV"

--	pwm_clock_control: CLOCK_CONTROL_REGISTER
--			-- PWM Clock Control register
--			-- "CM_PWMCTL"

--	pwm_clock_divisor: CLOCK_DIVISORS_REGISTER
--			-- PWM Clock Control register
--			-- "CM_PWMDIV"

end
