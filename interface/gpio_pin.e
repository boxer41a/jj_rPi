note
	description: "[
		Represents one of the GPIO pins on a {PI_CONTROLLER}.
		]"
	author: "Jimmy J Johnson"
	date: "10/23/18"

class
	GPIO_PIN

inherit

	ANY

	SHARED
		export
			{NONE}
				all
		end

create
	make

feature {NONE} -- Initialization

	make (a_pin: INTEGER_32)
			-- Create an instance representing `a_pin' number.
		require
--			is_valid_pin_number: is_valid_pin_number (a_pin)
		do
			create function_table.make (10)
			number := a_pin
		end

feature -- Initialization

	extend_function (a_function: like function; a_mode: like mode)
			-- Add `a_function' to the functions available for this pin
			-- indexed by `a_mode'.
		require
			valid_function: a_function >= {GPIO_PIN_CONSTANTS}.function_first and
							a_function <= {GPIO_PIN_CONSTANTS}.function_last
			valid_mode: a_mode = {GPIO_PIN_CONSTANTS}.input or
						a_mode = {GPIO_PIN_CONSTANTS}.output or
						a_mode = {GPIO_PIN_CONSTANTS}.alt0 or
						a_mode = {GPIO_PIN_CONSTANTS}.alt1 or
						a_mode = {GPIO_PIN_CONSTANTS}.alt2 or
						a_mode = {GPIO_PIN_CONSTANTS}.alt3 or
						a_mode = {GPIO_PIN_CONSTANTS}.alt4 or
						a_mode = {GPIO_PIN_CONSTANTS}.alt5
		do
			function_table.extend (a_function, a_mode)
		ensure
			has_function: has_function (a_function)
			correct_index: alternate_function (a_mode) = a_function
		end

feature -- Access

	name: STRING_8
			-- The name of the pin (e.g. "GPIO 1")
		do
			Result := "GPIO Pin " + number.out
		end

	number: INTEGER_32
			-- The pin's number (e.g. gpio number 17)

	state: NATURAL_32
			-- The value on Current (High or Low)
		do
			Result := pi.gpio.read_signal_on_pin (number)
		ensure
			valid_result: Result = {GPIO_PIN_CONSTANTS}.Low or Result = {GPIO_PIN_CONSTANTS}.High
		end

	mode: NATURAL_32
			-- The mode to which Current is set
		do
			Result := pi.gpio.mode_on_pin (number)
		ensure
			valid_mode: Result = {GPIO_PIN_CONSTANTS}.input or
						Result = {GPIO_PIN_CONSTANTS}.output or
						Result = {GPIO_PIN_CONSTANTS}.alt0 or
						Result = {GPIO_PIN_CONSTANTS}.alt1 or
						Result = {GPIO_PIN_CONSTANTS}.alt2 or
						Result = {GPIO_PIN_CONSTANTS}.alt3 or
						Result = {GPIO_PIN_CONSTANTS}.alt4 or
						Result = {GPIO_PIN_CONSTANTS}.alt5
		end

	function: INTEGER_32
			-- The function to which this pin is set (e.g. GPIO clock,
			-- PWM_0_1, etc.)  See {GPIO_PIN_CONSTANTS}.
			-- The default is {GPIO_PIN_CONSTANTS}.Pin_input
		do
			Result := function_table.definite_item (mode)
		end

	alternate_function (a_mode: like mode): like function
			-- The alternate function available for Current if `mode'
			-- was to be set to `a_mode'.
		do
			Result := function_table.definite_item (a_mode)
		end

	pull_state: NATURAL_32
			-- The pull state (High or Low) for Current
		do
			Result := pi.gpio.pull_state_on_pin (number)
		ensure
			valid_pull_state: Result = {GPIO_PIN_CONSTANTS}.pull_none or
							Result = {GPIO_PIN_CONSTANTS}.pull_up or
							Result = {GPIO_PIN_CONSTANTS}.pull_down
		end

feature -- Element change

	set_pull_state (a_state: NATURAL_32)
			-- Change the `pull_state' of Current
		require
			is_valid_pull_state: a_state = {GPIO_PIN_CONSTANTS}.Pull_none or
								a_state = {GPIO_PIN_CONSTANTS}.Pull_up or
								a_state = {GPIO_PIN_CONSTANTS}.Pull_down
		do
			pi.gpio.set_pull_state_on_pin (number, a_state)
		ensure
			state_was_set: pull_state = a_state
		end

	set_mode (a_mode: NATURAL_32)
			-- Set `mode' to `a_mode' (e.g. `Pin_input',
			-- 'Pin_output', `Pin_gpio_clock', etc).
		do
			pi.gpio.set_mode_on_pin (number, a_mode)
		ensure
			mode_was_set: mode = a_mode
		end

	set_state (a_signal: NATURAL_32)
			-- Set `state' to `a_signal' (high or low).
			-- (i.e. send a one or zero.)
		require
			is_output_mode: mode = {GPIO_PIN_CONSTANTS}.output
			valid_signal: a_signal = {GPIO_PIN_CONSTANTS}.Low or a_signal = {GPIO_PIN_CONSTANTS}.High
		do
			pi.gpio.write_signal_on_pin (number, a_signal)
		ensure
			state_was_set: state = a_signal
		end

feature -- Query

	has_function (a_function: like function): BOOLEAN
			-- Does Current support `a_function'?
		do
			Result := function_table.has_item (a_function)
		end

	has_pwm_function: BOOLEAN
			-- Can Current support PWM?
		do
			Result := has_function ({GPIO_PIN_CONSTANTS}.pwm0_0) or else
						has_function ({GPIO_PIN_CONSTANTS}.pwm0_1) or else
						has_function ({GPIO_PIN_CONSTANTS}.pwm1_0) or else
						has_function ({GPIO_PIN_CONSTANTS}.pwm1_1)
		end

	is_set_for_pwm: BOOLEAN
			-- Is `function' set to one of the PWM channels?
		local
			f: like {GPIO_PIN_CONSTANTS}.pwm0_0
		do
			f := function
			Result := f = {GPIO_PIN_CONSTANTS}.pwm0_0 or else
						f = {GPIO_PIN_CONSTANTS}.pwm0_1 or else
						f = {GPIO_PIN_CONSTANTS}.pwm1_0 or else
						f = {GPIO_PIN_CONSTANTS}.pwm1_1
		end

	pwm_channel: INTEGER
			-- The PWM channel this pin, if `is_set_for_pwm', is using
		require
			is_pwm: is_set_for_pwm
		do
			if function = {GPIO_PIN_CONSTANTS}.pwm0_0 or
					function = {GPIO_PIN_CONSTANTS}.pwm0_1 then
				Result := 0
			else
				check
					is_channel_one: function = {GPIO_PIN_CONSTANTS}.pwm1_0 or
									 function = {GPIO_PIN_CONSTANTS}.pwm1_1
						-- because of precondition		
				end
				Result := 1
			end
		ensure
			valid_result: Result = 0 or else Result = 1
			definition_zero: Result = 0 implies function = {GPIO_PIN_CONSTANTS}.pwm0_0 or
											function = {GPIO_PIN_CONSTANTS}.pwm0_1
			definition_zero: Result = 1 implies function = {GPIO_PIN_CONSTANTS}.pwm1_0 or
											function = {GPIO_PIN_CONSTANTS}.pwm1_1
		end

	pwm_index: INTEGER
			-- The PWM index of the `pwm_channel' in use by Current,
			-- if `is_set_for_pwm'
		require
			is_pwm: is_set_for_pwm
		do
			if function = {GPIO_PIN_CONSTANTS}.pwm0_0 or
					function = {GPIO_PIN_CONSTANTS}.pwm1_0 then
				Result := 0
			else
				check
					is_index_one: function = {GPIO_PIN_CONSTANTS}.pwm0_1 or
									 function = {GPIO_PIN_CONSTANTS}.pwm1_1
						-- because of precondition		
				end
				Result := 1
			end
		ensure
			valid_result: Result = 0 or else Result = 1
			definition_zero: Result = 0 implies function = {GPIO_PIN_CONSTANTS}.pwm0_0 or
											function = {GPIO_PIN_CONSTANTS}.pwm1_0
			definition_zero: Result = 1 implies function = {GPIO_PIN_CONSTANTS}.pwm0_1 or
											function = {GPIO_PIN_CONSTANTS}.pwm1_1
		end

feature -- Basic operations

feature -- Status report

	is_event_detected: BOOLEAN
			-- Has an event (e.g. a rising/falling edge or a high/low level change)
			-- been detected on Current?  Event detection must be enabled with
			-- `enable_xxx' features.
		do
			Result := pi.gpio.is_event_detected_on_pin (number)
		end

	is_rising_edge_detection_enabled: BOOLEAN
			-- Is rising-edge detection enabled for `a_pin'?
			-- See `enable_rising_edge_detect'
		do
			Result := pi.gpio.is_rising_edge_detection_enabled_on_pin (number)
		end

	is_falling_edge_detection_enabled: BOOLEAN
		do
			Result := pi.gpio.is_falling_edge_detection_enabled_on_pin (number)
		end

	is_high_level_detect_enabled: BOOLEAN
			-- Is high-level detection enabled for Current?
			-- See `enable_high_level_detect'
		do
			Result := pi.gpio.is_high_level_detect_enabled_on_pin (number)
		end

	is_low_level_detect_enabled: BOOLEAN
			-- Is low-level detection enabled for Current?
			-- See `enable_low_level_detect'
		do
			Result := pi.gpio.is_low_level_detect_enabled_on_pin (number)
		end

	is_asyncronous_rising_edge_detect_enabled: BOOLEAN
			-- Is asyncronous rising-edge detection enabled for Current?
			-- See `enable_rising_edge_detect'.
		do
			Result := pi.gpio.is_asyncronous_rising_edge_detect_enabled_on_pin (number)
		end

	is_asyncronous_falling_edge_detect_enabled: BOOLEAN
			-- Is asyncronous falling-edge detection enabled for Current?
			-- See `enable_falling_edge_detect'.
		do
			Result := pi.gpio.is_asyncronous_falling_edge_detect_enabled_on_pin (number)
		end

feature -- Status setting

	clear_detected_event
			-- Attempt to clear an event (e.g. a rising/falling edge or a high/low level)
			-- If `pull_state' is still high when an attempt is made to clear the
			-- event for that pin, the status bit will remain set.
		do
			pi.gpio.clear_detected_event_on_pin (number)
		ensure
--			no_event_detected_on_pin: not is_event_detected_on_pin (a_pin)
		end

	enable_rising_edge_detect
			-- Cause a rising edge tansition to set the corresponding bit in
			-- the appropriate Event Detect Status Register.
			-- When the relevant bits are set in both the GPRENn and GPFENn registers,
			-- any transition (1 to 0 and 0 to 1) will set a bit in the GPEDSn registers.
			-- The GPRENn registers use synchronous edge detection. This means the input
			-- signal is sampled using the system clock and then it is looking for a "011"
			-- pattern on the sampled signal. This has the effect of suppressing glitches.
		do
			pi.gpio.enable_rising_edge_detect_on_pin (number)
		ensure
			is_enabled: is_rising_edge_detection_enabled
		end

	disable_rising_edge_detect
			-- Disable detection of rising edge.
			-- See `enable_rising_edge_detect'.
		do
			pi.gpio.disable_rising_edge_detect_on_pin (number)
		ensure
			is_disabled: not is_rising_edge_detection_enabled
		end

	enable_falling_edge_detect
			-- Cause a falling edge tansition to set the corresponding bit in
			-- the appropriate Event Detect Status Register.
			-- When the relevant bits are set in both the GPRENn and GPFENn registers,
			-- any transition (1 to 0 and 0 to 1) will set a bit in the GPEDSn registers.
			-- The GPRENn registers use synchronous edge detection. This means the input
			-- signal is sampled using the system clock and then it is looking for a "100"
			-- pattern on the sampled signal. This has the effect of suppressing glitches.
		do
			pi.gpio.enable_falling_edge_detect_on_pin (number)
		ensure
			is_enabled: is_falling_edge_detection_enabled
		end

	disable_falling_edge_detect
			-- Disable detection of falling edge
			-- See `enable_falling_edge_detect.
		do
			pi.gpio.disable_falling_edge_detect_on_pin (number)
		ensure
			is_disabled: not is_falling_edge_detection_enabled
		end

	enable_high_level_detect
			-- Make a high level to cause an event to be detected
			-- See `is_event_detected'.
		do
			pi.gpio.enable_high_level_detect_on_pin (number)
		ensure
			is_enabled: is_high_level_detect_enabled
		end

	disable_high_level_detect
			-- Remove high-level detection
			-- See `is_event_detected' and `enable_high_level_detect'.
		do
			pi.gpio.disable_high_level_detect_on_pin (number)
		ensure
			is_disabled: not is_high_level_detect_enabled
		end

	enable_low_level_detect
			-- Make a low level cause an event to be detected.
			--  See `is_event_detected'.
		do
			pi.gpio.enable_low_level_detect_on_pin (number)
		ensure
			is_enabled: is_low_level_detect_enabled
		end

	disable_low_level_detect
			-- Remove low-level detection.
			-- See `is_event_detected' and `enable_low_level_detect'.
		do
			pi.gpio.disable_low_level_detect_on_pin (number)
		ensure
			is_disabled: not is_low_level_detect_enabled
		end

	enable_asyncronous_rising_edge_detect
			-- Make an asynchronous rising edge transition detectable
			-- so that `is_event_detected'.
			-- Asynchronous means the incoming signal is not sampled by the
			-- system clock, so rising edges of very short duration are detectable.
		do
			pi.gpio.enable_asyncronous_rising_edge_detect_on_pin (number)
		ensure
			is_enabled: is_asyncronous_rising_edge_detect_enabled
		end

	disable_asyncronous_rising_edge_detect
			-- Remove asynchronous rising edge detection.
			-- See `enable_asyncronous_rising_edge_detect'.
		do
			pi.gpio.disable_asyncronous_rising_edge_detect_on_pin (number)
		ensure
			is_disabled: not is_asyncronous_rising_edge_detect_enabled
		end

	enable_asyncronous_falling_edge_detect
			-- Make an asynchronous falling edge transition detectable
			-- so that `is_event_detected'.
			-- Asynchronous means the incoming signal is not sampled by the
			-- system clock, so rising edges of very short duration are detectable.
		do
			pi.gpio.enable_asyncronous_falling_edge_detect_on_pin (number)
		ensure
			is_enabled: is_asyncronous_rising_edge_detect_enabled
		end

	disable_asyncronous_falling_edge_detect
			-- Remove asynchronous falling edge detection.
			-- See `enable_asyncronous_falling_edge_detect'.
		do
			pi.gpio.disable_asyncronous_falling_edge_detect_on_pin (number)
		ensure
			is_disabled: not is_asyncronous_falling_edge_detect_enabled
		end

feature {NONE} -- Implemention

	function_table: HASH_TABLE [like function, like mode]
			-- Functions available on this pin, indexed by a mode
			-- (e.g. the GPIO clock on pin_4 is [GPCLK0, Alt_0].)

invariant

--	valid_mode: mode = {GPIO_PIN_CONSTANTS}.input or
--				mode = {GPIO_PIN_CONSTANTS}.output or
--				mode = {GPIO_PIN_CONSTANTS}.alt0 or
--				mode = {GPIO_PIN_CONSTANTS}.alt1 or
--				mode = {GPIO_PIN_CONSTANTS}.alt2 or
--				mode = {GPIO_PIN_CONSTANTS}.alt3 or
--				mode = {GPIO_PIN_CONSTANTS}.alt4 or
--				mode = {GPIO_PIN_CONSTANTS}.alt5

end
