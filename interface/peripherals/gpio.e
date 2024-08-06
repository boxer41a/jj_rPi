note
	description: "[
		The registers used to control each {GPIO_PIN}, and functions
		for controling the GPIO pins.
		All the registers are reached from the first {REGISTER}
		which is set up using `offset'.
		]"
	author: "Jimmy J Johnson"
	date: "10/23/20"

class
	GPIO

inherit

	PERIPHERAL
		redefine
			make
		end

create
	make

feature {NONE}-- Initialization

	make (a_file_descriptor: INTEGER_32; a_length: INTEGER_32; a_address: NATURAL_32)
			-- Initialize Current
		do
				-- Precursor sets the `base_address'
			Precursor {PERIPHERAL} (a_file_descriptor, a_length, a_address)
				-- GPFSELx registers
			create gpfsel_0.make (base_address + 0x00, "GPFSEL0")
			create gpfsel_1.make (base_address + 0x04, "GPFSEL1")
			create gpfsel_2.make (base_address + 0x08, "GPFSEL2")
			create gpfsel_3.make (base_address + 0x0C, "GPFSEL3")
			create gpfsel_4.make (base_address + 0x10, "GPFSEL4")
			create gpfsel_5.make (base_address + 0x14, "GPFSEL5")
				-- reserved  0x18
			create gpset_0.make (base_address + 0x1C, "GPSET0")
			create gpset_1.make (base_address + 0x20, "GPSET1")
				-- reserved  0x24
			create gpclr_0.make (base_address + 0x28, "GPCLR0")
			create gpclr_1.make (base_address + 0x2C, "GPCLR1")
				-- reserved  0x30
			create gplev_0.make (base_address + 0x34, "GP_LEV0")
			create gplev_1.make (base_address + 0x38, "GP_LEV1")
				-- reserved  0x3C
			create gpeds_0.make (base_address + 0x40, "GPEDS0")
			create gpeds_1.make (base_address + 0x44, "GPEDS1")
				-- reserved  0x48
			create gpren_0.make (base_address + 0x4C, "GPREN0")
			create gpren_1.make ( base_address + 0x50, "GPREN1")
				-- reserved  0x54
			create gpfen_0.make (base_address + 0x58, "GPFEN0")
			create gpfen_1.make (base_address + 0x5C, "GPFEN1")
				-- reserved  0x60
			create gphen_0.make (base_address + 0x64, "GPHEN0")
			create gphen_1.make (base_address + 0x68, "GPHEN1")
				-- reserved  0x6C
			create gplen_0.make (base_address + 0x70, "GPLEN0")
			create gplen_1.make (base_address + 0x74, "GPLEN1")
				-- reserved  0x78
			create gparen_0.make (base_address + 0x7C, "GPAREN0")
			create gparen_1.make (base_address + 0x80, "GPAREN1")
				-- reserved  0x84			
			create gpafen_0.make (base_address + 0x88, "GPAFEN0")
			create gpafen_1.make (base_address + 0x8C, "GPAFEN1")
			create gpio_pup_pdn_cntrl_reg0.make (base_address + 0xE4, "GPIO_PUP_PDN_CNTRL_REG0")
			create gpio_pup_pdn_cntrl_reg1.make (base_address + 0xE8, "GPIO_PUP_PDN_CNTRL_REG1")
			create gpio_pup_pdn_cntrl_reg2.make (base_address + 0xEC, "GPIO_PUP_PDN_CNTRL_REG2")
			create gpio_pup_pdn_cntrl_reg3.make (base_address + 0xF0, "GPIO_PUP_PDN_CNTRL_REG3")
				-- GPFSEL0 to GPFSEL5
			gpfsel_0.set_reserved_mask (0xC0000000)
			gpfsel_1.set_reserved_mask (0xC0000000)
			gpfsel_2.set_reserved_mask (0xC0000000)
			gpfsel_3.set_reserved_mask (0xC0000000)
			gpfsel_4.set_reserved_mask (0xC0000000)
			gpfsel_5.set_reserved_mask (0xFF000000)
				-- GPSET0 & GPSET1
--			gpset_0.set_write_only
--			gpset_1.set_write_only
			gpset_1.set_reserved_mask (0xFC000000)
				-- GPCLR0 & GPCLR1
--			gpclr_0.set_write_only
-- 			gpclr_1.set_write_only
			gpclr_1.set_reserved_mask (0xFC000000)
				-- GPLEV0 & GPLEV1
			gplev_0.set_read_only
			gplev_1.set_read_only
			gplev_1.set_reserved_mask (0xFC000000)
				-- GPEDS0 & GPEDS1
			gpeds_0.set_write_once_mask (0xFFFFFFFF)
			gpeds_1.set_reserved_mask (0xFC000000)
			gpeds_1.set_write_once_mask (0x03FFFFFF)
				-- GPREN0 & GPREN1			
			gpren_1.set_reserved_mask (0xFC000000)
				-- GPFEN0 & GPFEN1
			gpfen_1.set_reserved_mask (0xFC000000)
				-- GPHEN0 & GPHEN1
			gphen_1.set_reserved_mask (0xFC000000)
				-- GPLEN0 & GPLEN1
			gplen_1.set_reserved_mask (0xFC000000)
				-- GPAREN0 & GPAREN1
			gparen_1.set_reserved_mask (0xFC000000)
				-- GPAFEN0 & GPAFEN1
			gpafen_1.set_reserved_mask (0xFC000000)
				-- Pull up downs
			gpio_pup_pdn_cntrl_reg3.set_reserved_mask (0xFFF00000)

--			test_register_temp
		end

feature -- Access


feature -- Query

	is_valid_pin_number (a_number: INTEGER_32): BOOLEAN
			-- Is `a_number' within proper range
		do
			Result := a_number >= pi.pin_0.number and a_number <= pi.pin_last.number
		end

	pull_state_on_pin (a_number: INTEGER): NATURAL_32
			-- The pull-up/down state of `a_number'
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: PULL_UP_DOWN_REGISTER
		do
			reg := pull_up_down_register (a_number)
			Result := reg.pull_state (a_number)
		end

	mode_on_pin (a_number: INTEGER_32): NATURAL_32
			-- What function is `a_number' performing?  Pin_input, Pin_output
			-- alt_function_0, 1, 2, 3, 4, or 5?
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: FUNCTION_SELECT_REGISTER
		do
			reg := function_select_register (a_number)
			Result := reg.pin_mode (a_number)
		end

	is_event_detected_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Has an event (e.g. a rising/falling edge or a high/low level change)
			-- as programmed in a rising/falling edge detect enable register or in
			-- a high/low level detect enable register) been detected on `a_number'?
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpeds_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

	is_rising_edge_detection_enabled_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Is rising-edge detection enabled for `a_number'?
			-- See `enable_rising_edge_detect'
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpren_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

	is_falling_edge_detection_enabled_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Is falling-edge detection enabled for `a_number'?
			-- See `enable_falling_edge_detect'
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpfen_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

	is_high_level_detect_enabled_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Is high-level detection enabled for `a_number'?
			-- See `enable_high_level_detect'
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gphen_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

	is_low_level_detect_enabled_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Is low-level detection enabled for `a_number'?
			-- See `enable_low_level_detect'
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gplen_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

	is_asyncronous_rising_edge_detect_enabled_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Is asyncronous rising-edge detection enabled for `a_number'?
			-- See `enable_rising_edge_detect'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gparen_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

	is_asyncronous_falling_edge_detect_enabled_on_pin (a_number: INTEGER_32): BOOLEAN
			-- Is asyncronous falling-edge detection enabled for `a_number'?
			-- See `enable_falling_edge_detect'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpafen_register (a_number)
			Result := reg.bit_value (a_number \\ 32) = {GPIO_PIN_CONSTANTS}.high
		end

feature -- Basic operations

	terminate_mode (a_number: INTEGER_32)
			-- Some functions run for x amount of time,
			-- so can't just set mode until some condition?
		do
			io.put_string ("{PI_CONTROLLER}.terminate_mode:  Fix me! %N")
---			check
--				fix_me:  false
--					-- because
--			end
		end

	set_pull_state_on_pin (a_number: INTEGER_32; a_state: NATURAL_32)
			-- The the pull up/down state for `a_number'
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
			is_valid_pull_state: a_state = {GPIO_PIN_CONSTANTS}.Pull_none or
								a_state = {GPIO_PIN_CONSTANTS}.Pull_up or
								a_state = {GPIO_PIN_CONSTANTS}.Pull_down
		local
			reg: PULL_UP_DOWN_REGISTER
		do
			reg := pull_up_down_register (a_number)
			reg.set_pin_state (a_number, a_state)
		ensure
			state_was_set: pull_state_on_pin (a_number) = a_state
		end

	set_mode_on_pin (a_number: INTEGER_32; a_mode: NATURAL_32)
			-- Set pin number `a_number' to `a_mode' (e.g. `Pin_input',
			-- `Pin_output', `Pin_gpio_clock', etc).
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
--			is_valid_mode_for_pin: false   -- fix me
		local
			m: NATURAL_32
			reg: FUNCTION_SELECT_REGISTER
		do
			reg := function_select_register (a_number)
			m := reg.pin_mode (a_number)
			if m /= a_mode then
				terminate_mode (a_number)
			end
			reg.set_pin_mode (a_number, a_mode)
		ensure
			mode_was_set: mode_on_pin (a_number) = a_mode
		end


	write_signal_on_pin (a_number: INTEGER_32; a_signal: NATURAL_32)
			-- Send `a_signal' (high or low) to `a_number'.
			-- (i.e. send a one or zero to that pin.)
		require
			valid_pin_number: is_valid_pin_number (a_number)
			is_output_mode: mode_on_pin (a_number) = {GPIO_PIN_CONSTANTS}.output
			valid_signal: a_signal = {GPIO_PIN_CONSTANTS}.Low or a_signal = {GPIO_PIN_CONSTANTS}.High
		local
			reg: REGISTER
		do
			if a_signal = {GPIO_PIN_CONSTANTS}.Low then
					-- Get the GPCLRx register associated with `a_number'
				reg := gpclr_register (a_number)
			else
					-- Get the GPSETx register associated with `a_number'
				reg := gpset_register (a_number)
			end
			reg.set_bit (a_number \\ 32)
		end

	read_signal_on_pin (a_number: INTEGER_32): NATURAL_32
			-- Get the value of the signal on `a_number'.
			-- (i.e. get the one or zero for that pin from the GPLEVx register.)
		require
			valid_pin_number: is_valid_pin_number (a_number)
		do
			Result := gplev_register (a_number).bit_value (a_number \\ 32)
		ensure
			valid_result: Result = {GPIO_PIN_CONSTANTS}.Low or Result = {GPIO_PIN_CONSTANTS}.high
		end

	clear_detected_event_on_pin (a_number: INTEGER_32)
			-- Clear an event (e.g. a rising/falling edge or a high/low level)
			-- from the appropriate event detect status register which was set
			-- based on settings in a rising/falling edge detect register or in
			-- a high/low level detect enable register.
			-- If `a_number' is still high when an attempt is made to clear the
			-- event for that pin, the status bit will remain set.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpeds_register (a_number)
			reg.clear_bit (a_number \\ 32)
		ensure
--			no_event_detected_on_pin: not is_event_detected_on_pin (a_number)
		end

	enable_rising_edge_detect_on_pin (a_number: INTEGER_32)
			-- Cause a rising edge tansition to set the corresponding bit in
			-- the appropriate Event Detect Status Register.
			-- When the relevant bits are set in both the GPRENn and GPFENn registers,
			-- any transition (1 to 0 and 0 to 1) will set a bit in the GPEDSn registers.
			-- The GPRENn registers use synchronous edge detection. This means the input
			-- signal is sampled using the system clock and then it is looking for a "011"
			-- pattern on the sampled signal. This has the effect of suppressing glitches.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpren_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_enabled: is_rising_edge_detection_enabled_on_pin (a_number)
		end

	disable_rising_edge_detect_on_pin (a_number: INTEGER_32)
			-- Disable detection of rising edge on `a_number'.
			-- See `enable_rising_edge_detect'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpren_register (a_number)
			reg.clear_bit (a_number \\ 32)
		ensure
			is_disabled: not is_rising_edge_detection_enabled_on_pin (a_number)
		end

	enable_falling_edge_detect_on_pin (a_number: INTEGER_32)
			-- Cause a falling edge tansition to set the corresponding bit in
			-- the appropriate Event Detect Status Register.
			-- When the relevant bits are set in both the GPRENn and GPFENn registers,
			-- any transition (1 to 0 and 0 to 1) will set a bit in the GPEDSn registers.
			-- The GPRENn registers use synchronous edge detection. This means the input
			-- signal is sampled using the system clock and then it is looking for a "100"
			-- pattern on the sampled signal. This has the effect of suppressing glitches.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpfen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_enabled: is_falling_edge_detection_enabled_on_pin (a_number)
		end

	disable_falling_edge_detect_on_pin (a_number: INTEGER_32)
			-- Disable detection of falling edge on `a_number'.
			-- See `enable_falling_edge_detect_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpfen_register (a_number)
			reg.clear_bit (a_number \\ 32)
		ensure
			is_disabled: not is_falling_edge_detection_enabled_on_pin (a_number)
		end

	enable_high_level_detect_on_pin (a_number: INTEGER_32)
			-- Make a high level on `a_number' to cause an event to be detected
			-- on pin.  See `is_event_detected_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gphen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_enabled: is_high_level_detect_enabled_on_pin (a_number)
		end

	disable_high_level_detect_on_pin (a_number: INTEGER_32)
			-- Remove high-level detection from `a_number'.
			-- See `is_event_detected_on_pin' and `enable_high_level_detect_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gphen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_disabled: not is_high_level_detect_enabled_on_pin (a_number)
		end

	enable_low_level_detect_on_pin (a_number: INTEGER_32)
			-- Make a low level on `a_number' to cause an event to be detected
			-- on pin.  See `is_event_detected_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gplen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_enabled: is_low_level_detect_enabled_on_pin (a_number)
		end

	disable_low_level_detect_on_pin (a_number: INTEGER_32)
			-- Remove low-level detection from `a_number'.
			-- See `is_event_detected_on_pin' and `enable_low_level_detect_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gplen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_disabled: not is_low_level_detect_enabled_on_pin (a_number)
		end

	enable_asyncronous_rising_edge_detect_on_pin (a_number: INTEGER_32)
			-- Make an asynchronous rising edge transition detectable on `a_number'
			-- so that `is_event_detected_on_pin' for `a_number' is true.
			-- Asynchronous means the incoming signal is not sampled by the
			-- system clock, so rising edges of very short duration are detectable.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gparen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_enabled: is_asyncronous_rising_edge_detect_enabled_on_pin (a_number)
		end

	disable_asyncronous_rising_edge_detect_on_pin (a_number: INTEGER_32)
			-- Remove asynchronous rising edge detection from `a_number.
			-- See `enable_asyncronous_rising_edge_detect_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gparen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_disabled: not is_asyncronous_rising_edge_detect_enabled_on_pin (a_number)
		end

	enable_asyncronous_falling_edge_detect_on_pin (a_number: INTEGER_32)
			-- Make an asynchronous falling edge transition detectable on `a_number'
			-- so that `is_event_detected_on_pin' for `a_number' is true.
			-- Asynchronous means the incoming signal is not sampled by the
			-- system clock, so rising edges of very short duration are detectable.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpafen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_enabled: is_asyncronous_rising_edge_detect_enabled_on_pin (a_number)
		end

	disable_asyncronous_falling_edge_detect_on_pin (a_number: INTEGER_32)
			-- Remove asynchronous falling edge detection from `a_number.
			-- See `enable_asyncronous_falling_edge_detect_on_pin'.
		require
			valid_pin_number: is_valid_pin_number (a_number)
		local
			reg: REGISTER
		do
			reg := gpafen_register (a_number)
			reg.set_bit (a_number \\ 32)
		ensure
			is_disabled: not is_asyncronous_falling_edge_detect_enabled_on_pin (a_number)
		end

feature -- Output

	show
			-- Display info about this {PERIPHERAL}
		do

		end

feature {NONE} -- Implementation

	function_select_register (a_number: INTEGER_32): FUNCTION_SELECT_REGISTER
			-- The register that controls the function of `a_number'
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		local
			n: INTEGER
		do
			n := a_number // 10
			inspect n
			when 0 then
				Result := gpfsel_0
			when 1 then
				Result := gpfsel_1
			when 2 then
				Result := gpfsel_2
			when 3 then
				Result := gpfsel_3
			when 4 then
				Result := gpfsel_4
			when 5 then
				Result := gpfsel_5
			else
				check
					should_not_happen: false
						-- because there are only 58 gpio pins
				end
				create Result.make (base_address, "Error")
			end
		end

	gpset_register (a_number: INTEGER_32): REGISTER
			-- The register used to set the value of pin `a_number'
			-- The Result is one of "GPSET0" or "GPSET1".
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gpset_0
			else
				Result := gpset_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gpset_0
			upper_pins_implication: a_number > 32 implies Result = gpset_1
		end

	gpclr_register (a_number: INTEGER_32): REGISTER
			-- The register used to clear pin `a_number'
			-- Result is one of "GPCLR0" or "GPCLR1".
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gpclr_0
			else
				Result := gpclr_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gpclr_0
			upper_pins_implication: a_number > 32 implies Result = gpclr_1
		end

	gplev_register (a_number: INTEGER_32): REGISTER
			-- The register used to set the signal level on `a_number' (one of
			-- "GPLEV0" or "GPLEV1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gplev_0
			else
				Result := gplev_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gplev_0
			upper_pins_implication: a_number > 32 implies Result = gplev_1
		end

	gpeds_register (a_number: INTEGER_32): REGISTER
			-- The register used to detect an event on `a_number' (one of
			-- "GPEDS0" or "GPEDS1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gpeds_0
			else
				Result := gpeds_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gpeds_0
			upper_pins_implication: a_number > 32 implies Result = gpeds_1
		end

	gpren_register (a_number: INTEGER_32): REGISTER
			-- The register used to detect a rising edge event on `a_number'
			-- (one of "GPREN0" or "GPREN1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gpren_0
			else
				Result := gpren_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gpren_0
			upper_pins_implication: a_number > 32 implies Result = gpren_1
		end

	gpfen_register (a_number: INTEGER_32): REGISTER
			-- The register used to detect a falling edge event on `a_number'
			-- (one of "GPFEN0" or "GPFEN1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gpfen_0
			else
				Result := gpfen_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gpfen_0
			upper_pins_implication: a_number > 32 implies Result = gpfen_1
		end

	gphen_register (a_number: INTEGER_32): REGISTER
			-- The register used to detect a high level on `a_number'
			-- (one of "GPHEN0" or "GPHEN1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gphen_0
			else
				Result := gphen_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gphen_0
			upper_pins_implication: a_number > 32 implies Result = gphen_1
		end

	gplen_register (a_number: INTEGER_32): REGISTER
			-- The register used to detect a low level on `a_number'
			-- (one of "GPLEN0" or "GPLEN1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gplen_0
			else
				Result := gplen_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gplen_0
			upper_pins_implication: a_number > 32 implies Result = gplen_1
		end

	gparen_register (a_number: INTEGER_32): REGISTER
			-- The register used to asyncronously detect a rising edge on `a_number'
			-- (one of "GPAREN0" or "GPAREN1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gparen_0
			else
				Result := gparen_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gparen_0
			upper_pins_implication: a_number > 32 implies Result = gparen_1
		end

	gpafen_register (a_number: INTEGER_32): REGISTER
			-- The register used to asyncronously detect a falling edge on `a_number'
			-- (one of "GPAFEN0" or "GPAFEN1")
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		do
			if a_number <= 32 then
				Result := gpafen_0
			else
				Result := gpafen_1
			end
		ensure
			lower_pins_implication: a_number <= 32 implies Result = gpafen_0
			upper_pins_implication: a_number > 32 implies Result = gpafen_1
		end

	pull_up_down_register (a_number: INTEGER_32): PULL_UP_DOWN_REGISTER
			-- The register used to set the pull-up/down state of `a_number'
		require
			is_valid_pin_number: is_valid_pin_number (a_number)
		local
			i: INTEGER_32
		do
				-- Appease Void-safety
			Result := gpio_pup_pdn_cntrl_reg0
				-- The pull-up/down registers each control [up to] 15 pins
			i := a_number // 15
			inspect i
			when 0 then
				Result := gpio_pup_pdn_cntrl_reg0
			when 1 then
				Result := gpio_pup_pdn_cntrl_reg1
			when 2 then
				Result := gpio_pup_pdn_cntrl_reg3
			when 3 then
				Result := gpio_pup_pdn_cntrl_reg3
			else
				check
					should_not_happen: false
						-- because of precondition
				end
			end
		ensure
			implication_0: a_number // 15 = 0 implies Result = gpio_pup_pdn_cntrl_reg0
			implication_1: a_number // 15 = 1 implies Result = gpio_pup_pdn_cntrl_reg1
			implication_2: a_number // 15 = 2 implies Result = gpio_pup_pdn_cntrl_reg2
			implication_3: a_number // 15 = 3 implies Result = gpio_pup_pdn_cntrl_reg3
		end

feature {NONE} -- Implementation
feature -- for testing

	gpfsel_0: FUNCTION_SELECT_REGISTER
			-- The "GPFSEL0" register.
			-- See "BCM2711 ARM Peripherals", page 83.

	gpfsel_1: FUNCTION_SELECT_REGISTER
			-- The "GPFSEL1" register.
			-- See "BCM2711 ARM Peripherals", page 83.

	gpfsel_2: FUNCTION_SELECT_REGISTER
			-- The "GPFSEL2" register.
			-- See "BCM2711 ARM Peripherals", page 83.

	gpfsel_3: FUNCTION_SELECT_REGISTER
			-- The "GPFSEL3" register.
			-- See "BCM2711 ARM Peripherals", page 83.

	gpfsel_4: FUNCTION_SELECT_REGISTER
			-- The "GPFSEL4" register.
			-- See "BCM2711 ARM Peripherals", page 83.

	gpfsel_5: FUNCTION_SELECT_REGISTER
			-- The "GPFSEL5" register.
			-- See "BCM2711 ARM Peripherals", page 83.

	gpset_0: REGISTER
			-- Used to set a GPIO pin (0..31)

	gpset_1: REGISTER
			-- Used to set a GPIO pin (32..gpio pin count)

	gpclr_0: REGISTER
			-- Used to clear a GPIO pin (0..31)

	gpclr_1: REGISTER
			-- Used to clear a GPIO pin (32..gpio pin count)

	gplev_0: REGISTER
			-- Used to return the level of a GPIO pin (0..31)
			-- Either low or high

	gplev_1: REGISTER
			-- Used to return the level of a GPIO pin (32..max)
			-- Either low or high

	gpeds_0: REGISTER
			-- GPIO Pin Event Detect Status 0 (for GPIO pins 0..31).
			-- Records level and edge events on the GPIO pins.
			-- The relevant bit is set whenever: 1) an edge is detected that
			-- matches the type of edge programmed in the rising/falling edge
			-- detect enable registers, or 2) a level is detected that matches
			-- the type of level programmed in the high/low level detect enable
			-- registers.

	gpeds_1: REGISTER
			-- GPIO Pin Event Detect Status 1 (for GPIO pins 0..31).
			-- See `gpeds_0'

	gpren_0: REGISTER
			-- GPIO Pin Rising Edge Detect Enable 0 (pins 0..31).
			-- Defines the pins for which a rising edge transition sets a bit in
			-- the Event Detect Status registers (`gpeds_0' or `gpeds_1').  When
			-- the relevant bits are set in both the Rising and Falling edge registers,
			-- any transition (1 to 0 and 0 to 1) will set a bit in the `gpeds_0' or
			-- `gpeds_1' register.	

	gpren_1: REGISTER
			-- GPIO Pin Rising Edge Detect Enable 1 (pins 32..max).
			-- See `gpren_0'.

	gpfen_0: REGISTER
			-- GPIO Pin Falling Edge Detect Enable 0 (pins 0..31).
			-- Defines the pins for which a falling edge transition sets a bit in
			-- the Event Detect Status registers (`gpeds_0' or `gpeds_1').  When
			-- the relevant bits are set in both the Rising and Falling edge registers,
			-- any transition (1 to 0 and 0 to 1) will set a bit in the `gpeds_0' or
			-- `gpeds_1' register.	

	gpfen_1: REGISTER
			-- GPIO Pin Falling Edge Detect Enable 1 (pins 32..max).
			-- See `gpfen_0'.

	gphen_0: REGISTER
			-- GPIO Pin High Detect Enable 0 (pins 0..31).
			-- Defines the pins for which a high level sets a bit in the Event Detect
			-- Status register (`gpeds_0' or `gpeds_1').  If the pin is still high when
			-- an attempt is made to clear the status bit in a status register the status
			-- bit will remain set.

	gphen_1: REGISTER
			-- GPIO Pin High Detect Enable 1 (pins 32..max).
			-- See `gphen_0'.

	gplen_0: REGISTER
			-- GPIO Pin Low Detect Enable 0 (pins 0..31).
			-- Define the pins for which a low level sets a bit in the event Detect
			-- Status register (`gpeds_0' or `gpeds_1').  If the pin is still low when
			-- an attempt is made to clear the status bit in a status register the status
			-- bit will remain set.

	gplen_1: REGISTER
			-- GPIO Pin Low Detect Enable 1 (pins 32..max).
			-- See `gplen_0'.

	gparen_0: REGISTER
			-- GPIO Pin Asyncronous Rising Edge Detect 0 (pins 0..31).
			-- Define the pins for which an asynchronous rising edge transition sets
			-- a bit in the Event Detect Status registers (`gpeds_0' or `gpeds_1').
			-- Asynchronous means the incoming signal is not sampled by the system
			-- clock, so rising edges of very short duration can be detected.

	gparen_1: REGISTER
			-- GPIO Pin Asyncronous Rising Edge Detect 1 (pins 32..max).
			-- See `gparen_0'.

	gpafen_0: REGISTER
			-- GPIO Pin Asyncronous Falling Edge Detect 0 (pins 0..31).
			-- Define the pins for which an asynchronous falling edge transition sets
			-- a bit in the Event Detect Status registers (`gpeds_0' or `gpeds_1').
			-- Asynchronous means the incoming signal is not sampled by the system
			-- clock, so rising edges of very short duration can be detected.

	gpafen_1: REGISTER
			-- GPIO Pin Asyncronous Falling Edge Detect 1 (pins 32..max).

	gpio_pup_pdn_cntrl_reg0: PULL_UP_DOWN_REGISTER
			-- Controls the actuation of the internal pull-up/down resistors for
			-- GPIO pins 0 to 15 (two bits per pin). Reading the register gives
			-- the current pull-state.  See {GPIO_PIN_CONSTANTS}.

	gpio_pup_pdn_cntrl_reg1: PULL_UP_DOWN_REGISTER
			-- Controls the actuation of the internal pull-up/down resistors for
			-- GPIO pins 16 to 31 (two bits per pin). Reading the register gives
			-- the current pull-state.  See {GPIO_PIN_CONSTANTS}.

	gpio_pup_pdn_cntrl_reg2: PULL_UP_DOWN_REGISTER
			-- Controls the actuation of the internal pull-up/down resistors for
			-- GPIO pins 32 to 47 (two bits per pin). Reading the register gives
			-- the current pull-state.  See {GPIO_PIN_CONSTANTS}.

	gpio_pup_pdn_cntrl_reg3: PULL_UP_DOWN_REGISTER
			-- Controls the actuation of the internal pull-up/down resistors for
			-- GPIO pins 48 to 57 (two bits per pin). Reading the register gives
			-- the current pull-state.  See {GPIO_PIN_CONSTANTS}.
			-- Bits 20 to 31 are reserved

invariant

		-- GPFSEL0
	gpfsel_0.is_read_writable
	gpfsel_0.is_bit_reserved (31)
	gpfsel_0.is_bit_reserved (30)
		-- GPFSEL1
	gpfsel_1.is_read_writable
	gpfsel_1.is_bit_reserved (31)
	gpfsel_1.is_bit_reserved (30)
		-- GPFSEL2
	gpfsel_2.is_read_writable
	gpfsel_2.is_bit_reserved (31)
	gpfsel_2.is_bit_reserved (30)
		-- GPFSEL3
	gpfsel_3.is_read_writable
	gpfsel_3.is_bit_reserved (31)
	gpfsel_3.is_bit_reserved (30)
		-- GPFSEL4
	gpfsel_4.is_read_writable
	gpfsel_4.is_bit_reserved (31)
	gpfsel_4.is_bit_reserved (30)
		-- GPFSEL5
	gpfsel_5.is_read_writable
	gpfsel_5.is_bit_reserved (31)
	gpfsel_5.is_bit_reserved (30)
	gpfsel_5.is_bit_reserved (29)
	gpfsel_5.is_bit_reserved (28)
	gpfsel_5.is_bit_reserved (27)
	gpfsel_5.is_bit_reserved (26)
	gpfsel_5.is_bit_reserved (25)
	gpfsel_5.is_bit_reserved (24)
		-- GPSET0
--	gpset_0.is_write_only
		-- GPSET1	
--	gpset_1.is_write_only
	gpset_1.is_bit_reserved (31)
	gpset_1.is_bit_reserved (30)
	gpset_1.is_bit_reserved (29)
	gpset_1.is_bit_reserved (28)
	gpset_1.is_bit_reserved (27)
	gpset_1.is_bit_reserved (26)
		-- GPCLR0
--	gpclr_0.is_write_only
		-- GPCLR1
--	gpclr_1.is_write_only
	gpclr_1.is_bit_reserved (31)
	gpclr_1.is_bit_reserved (30)
	gpclr_1.is_bit_reserved (29)
	gpclr_1.is_bit_reserved (28)
	gpclr_1.is_bit_reserved (27)
	gpclr_1.is_bit_reserved (26)
		-- GPLEV0
	gplev_0.is_read_only
		-- GPLEV1
	gplev_1.is_read_only
	gplev_1.is_bit_reserved (31)
	gplev_1.is_bit_reserved (30)
	gplev_1.is_bit_reserved (29)
	gplev_1.is_bit_reserved (28)
	gplev_1.is_bit_reserved (27)
	gplev_1.is_bit_reserved (26)
		-- GPEDS0
	gpeds_0.is_read_writable
	gpeds_0.is_bit_write_once (31)
	gpeds_0.is_bit_write_once (30)
	gpeds_0.is_bit_write_once (29)
	gpeds_0.is_bit_write_once (28)
	gpeds_0.is_bit_write_once (27)
	gpeds_0.is_bit_write_once (26)
	gpeds_0.is_bit_write_once (25)
	gpeds_0.is_bit_write_once (24)
	gpeds_0.is_bit_write_once (23)
	gpeds_0.is_bit_write_once (22)
	gpeds_0.is_bit_write_once (21)
	gpeds_0.is_bit_write_once (20)
	gpeds_0.is_bit_write_once (19)
	gpeds_0.is_bit_write_once (18)
	gpeds_0.is_bit_write_once (17)
	gpeds_0.is_bit_write_once (16)
	gpeds_0.is_bit_write_once (15)
	gpeds_0.is_bit_write_once (14)
	gpeds_0.is_bit_write_once (13)
	gpeds_0.is_bit_write_once (12)
	gpeds_0.is_bit_write_once (11)
	gpeds_0.is_bit_write_once (10)
	gpeds_0.is_bit_write_once (9)
	gpeds_0.is_bit_write_once (8)
	gpeds_0.is_bit_write_once (7)
	gpeds_0.is_bit_write_once (6)
	gpeds_0.is_bit_write_once (5)
	gpeds_0.is_bit_write_once (4)
	gpeds_0.is_bit_write_once (3)
	gpeds_0.is_bit_write_once (2)
	gpeds_0.is_bit_write_once (1)
	gpeds_0.is_bit_write_once (0)
		-- GPEDS1
	gpeds_1.is_read_writable
	gpeds_1.is_bit_reserved (31)
	gpeds_1.is_bit_reserved (30)
	gpeds_1.is_bit_reserved (29)
	gpeds_1.is_bit_reserved (28)
	gpeds_1.is_bit_reserved (27)
	gpeds_1.is_bit_reserved (26)
	gpeds_1.is_bit_write_once (25)
	gpeds_1.is_bit_write_once (24)
	gpeds_1.is_bit_write_once (23)
	gpeds_1.is_bit_write_once (22)
	gpeds_1.is_bit_write_once (21)
	gpeds_1.is_bit_write_once (20)
	gpeds_1.is_bit_write_once (19)
	gpeds_1.is_bit_write_once (18)
	gpeds_0.is_bit_write_once (17)
	gpeds_1.is_bit_write_once (16)
	gpeds_1.is_bit_write_once (15)
	gpeds_1.is_bit_write_once (14)
	gpeds_1.is_bit_write_once (13)
	gpeds_1.is_bit_write_once (12)
	gpeds_1.is_bit_write_once (11)
	gpeds_1.is_bit_write_once (10)
	gpeds_1.is_bit_write_once (9)
	gpeds_1.is_bit_write_once (8)
	gpeds_1.is_bit_write_once (7)
	gpeds_1.is_bit_write_once (6)
	gpeds_1.is_bit_write_once (5)
	gpeds_1.is_bit_write_once (4)
	gpeds_1.is_bit_write_once (3)
	gpeds_1.is_bit_write_once (2)
	gpeds_1.is_bit_write_once (1)
	gpeds_1.is_bit_write_once (0)
		-- GPREN0
	gpren_0.is_read_writable
		-- GPREN1
	gpren_1.is_read_writable
	gpren_1.is_bit_reserved (31)
	gpren_1.is_bit_reserved (30)
	gpren_1.is_bit_reserved (29)
	gpren_1.is_bit_reserved (28)
	gpren_1.is_bit_reserved (27)
	gpren_1.is_bit_reserved (26)
	gpren_1.is_bit_read_writable (25)
	gpren_1.is_bit_read_writable (24)
	gpren_1.is_bit_read_writable (23)
	gpren_1.is_bit_read_writable (22)
	gpren_1.is_bit_read_writable (21)
	gpren_1.is_bit_read_writable (20)
	gpren_1.is_bit_read_writable (19)
	gpren_1.is_bit_read_writable (18)
	gpren_1.is_bit_read_writable (17)
	gpren_1.is_bit_read_writable (16)
	gpren_1.is_bit_read_writable (15)
	gpren_1.is_bit_read_writable (14)
	gpren_1.is_bit_read_writable (13)
	gpren_1.is_bit_read_writable (12)
	gpren_1.is_bit_read_writable (11)
	gpren_1.is_bit_read_writable (10)
	gpren_1.is_bit_read_writable (9)
	gpren_1.is_bit_read_writable (8)
	gpren_1.is_bit_read_writable (7)
	gpren_1.is_bit_read_writable (6)
	gpren_1.is_bit_read_writable (5)
	gpren_1.is_bit_read_writable (4)
	gpren_1.is_bit_read_writable (3)
	gpren_1.is_bit_read_writable (2)
	gpren_1.is_bit_read_writable (1)
	gpren_1.is_bit_read_writable (0)
		-- GPFEN0
	gpfen_0.is_read_writable
		-- GPFEN1
	gpfen_1.is_read_writable
	gpfen_1.is_bit_reserved (31)
	gpfen_1.is_bit_reserved (30)
	gpfen_1.is_bit_reserved (29)
	gpfen_1.is_bit_reserved (28)
	gpren_1.is_bit_reserved (27)
	gpren_1.is_bit_reserved (26)
	gpfen_1.is_bit_read_writable (25)
	gpfen_1.is_bit_read_writable (24)
	gpfen_1.is_bit_read_writable (23)
	gpfen_1.is_bit_read_writable (22)
	gpfen_1.is_bit_read_writable (21)
	gpfen_1.is_bit_read_writable (20)
	gpfen_1.is_bit_read_writable (19)
	gpfen_1.is_bit_read_writable (18)
	gpfen_1.is_bit_read_writable (17)
	gpfen_1.is_bit_read_writable (16)
	gpfen_1.is_bit_read_writable (15)
	gpfen_1.is_bit_read_writable (14)
	gpfen_1.is_bit_read_writable (13)
	gpfen_1.is_bit_read_writable (12)
	gpfen_1.is_bit_read_writable (11)
	gpfen_1.is_bit_read_writable (10)
	gpfen_1.is_bit_read_writable (9)
	gpfen_1.is_bit_read_writable (8)
	gpfen_1.is_bit_read_writable (7)
	gpfen_1.is_bit_read_writable (6)
	gpfen_1.is_bit_read_writable (5)
	gpfen_1.is_bit_read_writable (4)
	gpfen_1.is_bit_read_writable (3)
	gpfen_1.is_bit_read_writable (2)
	gpfen_1.is_bit_read_writable (1)
	gpfen_1.is_bit_read_writable (0)
		-- GPHEN0
	gphen_0.is_read_writable
		-- GPFEN1
	gphen_1.is_read_writable
	gphen_1.is_bit_reserved (31)
	gpfen_1.is_bit_reserved (30)
	gphen_1.is_bit_reserved (29)
	gphen_1.is_bit_reserved (28)
	gphen_1.is_bit_reserved (27)
	gphen_1.is_bit_reserved (26)
	gphen_1.is_bit_read_writable (25)
	gphen_1.is_bit_read_writable (24)
	gphen_1.is_bit_read_writable (23)
	gphen_1.is_bit_read_writable (22)
	gphen_1.is_bit_read_writable (21)
	gphen_1.is_bit_read_writable (20)
	gphen_1.is_bit_read_writable (19)
	gphen_1.is_bit_read_writable (18)
	gphen_1.is_bit_read_writable (17)
	gphen_1.is_bit_read_writable (16)
	gphen_1.is_bit_read_writable (15)
	gphen_1.is_bit_read_writable (14)
	gphen_1.is_bit_read_writable (13)
	gphen_1.is_bit_read_writable (12)
	gphen_1.is_bit_read_writable (11)
	gphen_1.is_bit_read_writable (10)
	gphen_1.is_bit_read_writable (9)
	gphen_1.is_bit_read_writable (8)
	gphen_1.is_bit_read_writable (7)
	gphen_1.is_bit_read_writable (6)
	gphen_1.is_bit_read_writable (5)
	gphen_1.is_bit_read_writable (4)
	gphen_1.is_bit_read_writable (3)
	gphen_1.is_bit_read_writable (2)
	gphen_1.is_bit_read_writable (1)
	gphen_1.is_bit_read_writable (0)
		-- GPLEN0
	gplen_0.is_read_writable
		-- GPLEN1
	gplen_1.is_read_writable
	gplen_1.is_bit_reserved (31)
	gplen_1.is_bit_reserved (30)
	gplen_1.is_bit_reserved (29)
	gplen_1.is_bit_reserved (28)
	gplen_1.is_bit_reserved (27)
	gplen_1.is_bit_reserved (26)
	gplen_1.is_bit_read_writable (25)
	gplen_1.is_bit_read_writable (24)
	gplen_1.is_bit_read_writable (23)
	gplen_1.is_bit_read_writable (22)
	gplen_1.is_bit_read_writable (21)
	gplen_1.is_bit_read_writable (20)
	gplen_1.is_bit_read_writable (19)
	gplen_1.is_bit_read_writable (18)
	gplen_1.is_bit_read_writable (17)
	gplen_1.is_bit_read_writable (16)
	gplen_1.is_bit_read_writable (15)
	gplen_1.is_bit_read_writable (14)
	gplen_1.is_bit_read_writable (13)
	gplen_1.is_bit_read_writable (12)
	gplen_1.is_bit_read_writable (11)
	gplen_1.is_bit_read_writable (10)
	gplen_1.is_bit_read_writable (9)
	gplen_1.is_bit_read_writable (8)
	gplen_1.is_bit_read_writable (7)
	gplen_1.is_bit_read_writable (6)
	gplen_1.is_bit_read_writable (5)
	gplen_1.is_bit_read_writable (4)
	gplen_1.is_bit_read_writable (3)
	gplen_1.is_bit_read_writable (2)
	gplen_1.is_bit_read_writable (1)
	gplen_1.is_bit_read_writable (0)
		-- GPAREN0
	gparen_0.is_read_writable
		-- GPAREN1
	gparen_1.is_read_writable
	gparen_1.is_bit_reserved (31)
	gparen_1.is_bit_reserved (30)
	gparen_1.is_bit_reserved (29)
	gparen_1.is_bit_reserved (28)
	gparen_1.is_bit_reserved (27)
	gparen_1.is_bit_reserved (26)
	gparen_1.is_bit_read_writable (25)
	gparen_1.is_bit_read_writable (24)
	gparen_1.is_bit_read_writable (23)
	gparen_1.is_bit_read_writable (22)
	gparen_1.is_bit_read_writable (21)
	gparen_1.is_bit_read_writable (20)
	gparen_1.is_bit_read_writable (19)
	gparen_1.is_bit_read_writable (18)
	gparen_1.is_bit_read_writable (17)
	gparen_1.is_bit_read_writable (16)
	gparen_1.is_bit_read_writable (15)
	gparen_1.is_bit_read_writable (14)
	gparen_1.is_bit_read_writable (13)
	gparen_1.is_bit_read_writable (12)
	gparen_1.is_bit_read_writable (11)
	gparen_1.is_bit_read_writable (10)
	gparen_1.is_bit_read_writable (9)
	gparen_1.is_bit_read_writable (8)
	gparen_1.is_bit_read_writable (7)
	gparen_1.is_bit_read_writable (6)
	gparen_1.is_bit_read_writable (5)
	gparen_1.is_bit_read_writable (4)
	gparen_1.is_bit_read_writable (3)
	gparen_1.is_bit_read_writable (2)
	gparen_1.is_bit_read_writable (1)
	gparen_1.is_bit_read_writable (0)
		-- GPAFEN0
	gpafen_0.is_read_writable
		-- GPAFEN1
	gpafen_1.is_read_writable
	gpafen_1.is_read_writable
	gpafen_1.is_bit_reserved (31)
	gpafen_1.is_bit_reserved (30)
	gpafen_1.is_bit_reserved (29)
	gpafen_1.is_bit_reserved (28)
	gpafen_1.is_bit_reserved (27)
	gpafen_1.is_bit_reserved (26)
	gpafen_1.is_bit_read_writable (25)
	gpafen_1.is_bit_read_writable (24)
	gpafen_1.is_bit_read_writable (23)
	gpafen_1.is_bit_read_writable (22)
	gpafen_1.is_bit_read_writable (21)
	gpafen_1.is_bit_read_writable (20)
	gpafen_1.is_bit_read_writable (19)
	gpafen_1.is_bit_read_writable (18)
	gpafen_1.is_bit_read_writable (17)
	gpafen_1.is_bit_read_writable (16)
	gpafen_1.is_bit_read_writable (15)
	gpafen_1.is_bit_read_writable (14)
	gpafen_1.is_bit_read_writable (13)
	gpafen_1.is_bit_read_writable (12)
	gpafen_1.is_bit_read_writable (11)
	gpafen_1.is_bit_read_writable (10)
	gpafen_1.is_bit_read_writable (9)
	gpafen_1.is_bit_read_writable (8)
	gpafen_1.is_bit_read_writable (7)
	gpafen_1.is_bit_read_writable (6)
	gpafen_1.is_bit_read_writable (5)
	gpafen_1.is_bit_read_writable (4)
	gpafen_1.is_bit_read_writable (3)
	gpafen_1.is_bit_read_writable (2)
	gpafen_1.is_bit_read_writable (1)
	gpafen_1.is_bit_read_writable (0)
		-- GPIO_PUP_PDN_CNTRL_REG0
	gpio_pup_pdn_cntrl_reg0.is_read_writable
		-- GPIO_PUP_PDN_CNTRL_REG1
	gpio_pup_pdn_cntrl_reg1.is_read_writable
		-- GPIO_PUP_PDN_CNTRL_REG2
	gpio_pup_pdn_cntrl_reg2.is_read_writable
		-- GPIO_PUP_PDN_CNTRL_REG3
	gpio_pup_pdn_cntrl_reg3.is_read_writable
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (31)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (30)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (29)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (28)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (27)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (26)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (25)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (24)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (23)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (22)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (21)
	gpio_pup_pdn_cntrl_reg3.is_bit_reserved (20)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (19)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (18)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (17)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (16)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (15)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (14)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (13)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (12)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (11)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (10)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (9)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (8)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (7)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (6)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (5)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (4)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (3)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (2)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (1)
	gpio_pup_pdn_cntrl_reg3.is_bit_read_writable (0)


end
