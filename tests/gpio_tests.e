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

	PI_SHARED
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
			from i := 0
			until i > pi.pin_last.number
			loop
				procedure (agent gpio.set_pull_state_on_pin (i, {GPIO_PIN_CONSTANTS}.Pull_none), "set_pull_state_on_pin (Pull_none)")
				function (agent gpio.pull_state_on_pin (i), "pull_state_on_pin", {GPIO_PIN_CONSTANTS}.Pull_none)
				procedure (agent gpio.set_pull_state_on_pin (i, {GPIO_PIN_CONSTANTS}.Pull_up), "set_pull_state_on_pin (Pull_up)")
				function (agent gpio.pull_state_on_pin (i), "pull_state_on_pin", {GPIO_PIN_CONSTANTS}.Pull_up)
				procedure (agent gpio.set_pull_state_on_pin (i, {GPIO_PIN_CONSTANTS}.Pull_down), "set_pull_state_on_pin (Pull_down)")
				function (agent gpio.pull_state_on_pin (i), "pull_state_on_pin", {GPIO_PIN_CONSTANTS}.Pull_down)
				i := i + 1
			end
		end

	test_mode_features
			-- Test featues dealing with the mode setting
		local
			i: INTEGER
		do
			divider ("set_mode_on_pin")
			from i := 0
			until i > pi.pin_last.number
			loop
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.Input), "set_mode_on_pin (Input)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.Input)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.Output), "set_mode_on_pin (Output)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.Output)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt0), "set_mode_on_pin (Alt0)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.alt0)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt1), "set_mode_on_pin (Alt1)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.alt1)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt2), "set_mode_on_pin (Alt2)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.alt2)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt3), "set_mode_on_pin (Alt3)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.alt3)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt4), "set_mode_on_pin (Alt4)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.alt4)
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.alt5), "set_mode_on_pin (Alt5)")
				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.alt5)
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
			from i := 0
			until i > pi.pin_last.number
			loop
				procedure (agent gpio.set_mode_on_pin (i, {GPIO_PIN_CONSTANTS}.Output), "set_mode_on_pin")
				i := i + 1
			end
				-- Set output to high or low
			from i := 0
			until i > pi.pin_last.number
			loop
				if i /= 10 then

				function (agent gpio.mode_on_pin (i), "mode_on_pin", {GPIO_PIN_CONSTANTS}.Output)
				procedure (agent gpio.write_signal_on_pin (i, {GPIO_PIN_CONSTANTS}.Low), "write_signal_on_pin")
				function (agent gpio.read_signal_on_pin (i), "read_signal_on_pin", {GPIO_PIN_CONSTANTS}.Low)
				procedure (agent gpio.write_signal_on_pin (i, {GPIO_PIN_CONSTANTS}.High), "write_signal_on_pin")
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
