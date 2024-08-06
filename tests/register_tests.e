  note
	description: "[
		FIX ME!
		Incomplete class intention is to test all register functions
		and display outputs.

		In addition to running assert statements, each test feature prints
		information pertinant to that test, so that these features can be
		called from {DEMO} to print demonstration values.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	REGISTER_TESTS

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
		local
			test: PI_CONTROLLER
		do
				-- Force call to once feature
			test := pi
			test_access_features
--			test_element_change_features
		end


	test_access_features
			-- Pick a register from the `pi' and run test on it
		do
			divider ("test_access_features")
			function (agent register.name, "name", "GPREN0")
			function (agent register.as_hex_string, "as_hex_string", "0x00000000")
			function (agent register.as_binary_string, "as_binary_string", "0b00000000000000000000000000000000")
			function (agent register.default_value, "default_value", 0)
		end

	test_element_change_features
			-- Test the element change operations
		do
			divider ("test_element_change_features")
			procedure (agent register.reset, "reset")
			function (agent register.as_hex_string, "as_hex_string", "0x00000000")
			procedure (agent register.set_value (0x12345678), "set_value")
			function (agent register.as_hex_string, "as_hex_string", "0x12345678")
		end

feature -- Implementation

	register: REGISTER
			-- A simple read-write register with no reserved bits, etc.
			-- Pick one from the {GPIO}
		once
			Result := pi.gpio.gpren_0
		end

end
