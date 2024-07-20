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
			default_create
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

feature {NONE} -- Implementation

	gpio: GPIO
			-- Obtained from featue `pi' in {SHARED}
		attribute
			Result := pi.gpio
		end

	
end
