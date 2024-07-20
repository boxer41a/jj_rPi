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
		do

		end


	test
			-- Pick a register from the `pi' and run test on it
		local
			r: REGISTER
		do
		end

feature -- Implementation

	register_anchor: detachable TESTABLE_REGISTER
			-- Anchor for type of objects to test
		require
			never_called: false
		do
			check
				do_not_call: false then
					-- Because gives no info; simply used as anchor.
			end
		end

end
