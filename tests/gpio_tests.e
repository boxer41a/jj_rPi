note
	description: "[
		Tests the {GPIO} {PERIPHERAL} of the one {PI_CONTROLER},
		the `pi', from {SHARED}.
		]"
	author: "Jimmy J. Johnson"
	date: "7/19/24"

class
	GPIO_TESTS

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

	JJ_TEST_ROUTINES
		undefine
			default_create,
			as_named
		end

	SHARED
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- Called after all initializations in `default_create'.
			-- Redefined to set `test_limit' for auto-testing.
		do
			add_valid_target_type ("REGISTER")
			add_valid_target_type ("GPIO")
		end

feature -- Constants

feature -- Basic operations

	run_all
			-- Demo/test all features
		do
			test_register_functions
		end

	test_register_functions
			-- Pick one of the {GPIO} registers and run tests
			-- We use the first GPAREN register, because it is
			-- read/write capable on all 32 bits.
		local
			r: REGISTER
		do
--			r := gpio.
			-- No, can't do this because none of the registers are
			-- exported.  Not able to check low-level functions here.
			assert ("not testable here", false)
		end

	test_pull_state_features
			-- Test featues dealing with the pull state
		local
			i: INTEGER
		do
			divider ("set_pull_state_on_pin")
			from i := 1
			until i > pi.pin_last.number
			loop
					-- Set odd-numbered pins high
				if i \\ 2 = 0 then
					procedure (agent gpio.set_pull_state_on_pin (i, {GPIO_PIN_CONSTANTS}.Low), "set_pull_state_on_pin")
				else
					procedure (agent gpio.set_pull_state_on_pin (i, {GPIO_PIN_CONSTANTS}.High), "set_pull_state_on_pin")
				end
				i := i + 1
			end
				-- Now check each pins' pull state
			from i := 1
			until i > pi.pin_last.number
			loop
				if i \\ 2 = 0 then
					function (agent gpio.pull_state_on_pin (i), "pull_state_on_pin", {GPIO_PIN_CONSTANTS}.Low)
				else
					function (agent gpio.pull_state_on_pin (i), "pull_state_on_pin", {GPIO_PIN_CONSTANTS}.High)
				end
				i := i + 1
			end
		end

	test_mode_features
			-- Test featues dealing with the mode setting
		local
			i: INTEGER
			d: INTEGER
		do
			divider ("set_mode_on_pin")
			from i := 1
			until i > pi.pin_last.number
			loop
				d := i \\ 8
				inspect d
				when 0 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.Input), "set_mode_on_pin")
				when 1 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.Output), "set_mode_on_pin")
				when 2 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt0), "set_mode_on_pin")
				when 3 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt1), "set_mode_on_pin")
				when 4 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt2), "set_mode_on_pin")
				when 5 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt3), "set_mode_on_pin")
				when 6 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt4), "set_mode_on_pin")
				when 7 then
					procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt5), "set_mode_on_pin")
				else
					check
						should_not_happen: false
							-- because of mod function
					end
				end
				i := i + 1
			end
				-- Now check each pins' mode
			from i := 1
			until i > pi.pin_last.number
			loop
				d := i \\ 8
				inspect d
				when 0 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.Input)
				when 1 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.Output)
				when 2 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.alt0)
				when 3 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.alt1)
				when 4 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.alt2)
				when 5 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.alt3)
				when 6 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.alt4)
				when 7 then
					function (agent gpio.mode_on_pin (i), "set_mode_on_pin", {GPIO_PIN_CONSTANTS}.alt5)
				else
					check
						should_not_happen: false
							-- because of mod function
					end
				end
				i := i + 1
			end
		end

	test_signal_features
			-- Test featues dealing with a pin's signal
		local
			i: INTEGER
		do
			divider ("write_signal_on_pin")
				-- Set all pins to output mode
			from i := 1
			until i > pi.pin_last.number
			loop
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.Output), "set_mode_on_pin")
				i := i + 1
			end
				-- Set output to high or low
			from i := 1
			until i > pi.pin_last.number
			loop
					-- Set odd-numbered pins High
				if i \\ 2 = 0 then
					procedure (agent gpio.write_signal_on_pin (i, {GPIO_PIN_CONSTANTS}.Low), "write_signal_state_on_pin")
				else
					procedure (agent gpio.write_signal_on_pin (i, {GPIO_PIN_CONSTANTS}.High), "write_signal_state_on_pin")
				end
				i := i + 1
			end
				-- Now check each pins' signal
			from i := 1
			until i > pi.pin_last.number
			loop
				if i \\ 2 = 0 then
					function (agent gpio.read_signal_on_pin (i), "read_signal_on_pin", {GPIO_PIN_CONSTANTS}.Low)
				else
					function (agent gpio.read_signal_on_pin (i), "read_signal_on_pin", {GPIO_PIN_CONSTANTS}.High)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	as_named (a_any: detachable ANY): STRING_8
		do
			Result := ""
			if attached {GPIO} a_any as g then
				Result := Result + "GPIO"
			else
				Result := Precursor (a_any)
			end
		end

feature {NONE} -- Implementation

	gpio: GPIO
			-- Obtained from featue `pi' in {SHARED}
		attribute
			Result := pi.gpio
		end


end
