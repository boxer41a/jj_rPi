note
	description: "[
		Routines used by test classes to show the signature of
		a routine as it calls and tests that routine.
		]"
	author: "Jimmy J Johnson"
	date: "7/19/24"

deferred class
	JJ_TEST_ROUTINES

feature -- Basic operations

	add_valid_target_type (a_string: STRING_8)
			-- Add the type given by `a_string' to the list of types
			-- that these test routines can recognize.
		local
			t: INTEGER
		do
			t := reflector.dynamic_type_from_string (a_string)
			valid_target_types.extend (t)
		end

	assert_32 (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
			-- Assert `a_condition'.
		deferred
		end

	assert (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
			-- Assert `a_condition'.
		deferred
		end

feature {NONE} -- Implementation

	reflector: REFLECTOR
			-- For getting and checking types
		once
			create Result
		end

	valid_target_types: LINKED_SET [INTEGER]
			-- List of types that the tests can recognize
		attribute
			create Result.make
		end

	is_valid_target_type (a_routine: ROUTINE): BOOLEAN
			-- Is the target of `a_routine' a type that this class can test?
		do
			Result := attached a_routine.target as t and then
				(attached {REGISTER} t)
			if not Result then
					-- The check for attached like Current seems to handle the case where
					-- `a_routine' is referencing an attribute.  In that case, the actual
					-- target is the second argument of the `closed operands' not the first
					-- argument as I would expect.
				check attached a_routine.target as t then
					check attached a_routine.closed_operands as args and then args.count >= 2 then
						Result := (attached {REGISTER} args [2])
					end
				end
			end
		end

	function (a_function: FUNCTION [TUPLE, ANY]; a_name: STRING_8; a_expected: ANY)
			-- Execute `a_function', printing the `signature' of the call
			-- and asserting that the result of the call is equivalent
			-- to `a_expected'.
		require
			target_closed: attached a_function.target
			no_open_arguments: a_function.open_count = 0
			expected_types: is_valid_target_type (a_function)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_function, a_name)
			ans := a_function.item (a_function.operands)
			is_ok := ans.out ~ a_expected.out
			s := s + " ==> " + as_named (ans)
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	predicate (a_predicate: PREDICATE; a_name: STRING_8; a_expected: BOOLEAN)
			-- Execute `a_function', printing the `signature' of the call
			-- and asserting that the result of the call is equivalent
			-- to `a_expected'.
		require
			target_closed: attached a_predicate.target
			no_open_arguments: a_predicate.open_count = 0
			expected_types: is_valid_target_type (a_predicate)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_predicate, a_name)
			ans := a_predicate.item (a_predicate.operands)
			is_ok := ans.out ~ a_expected.out
			s := s + " ==> " + as_named (ans)
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	procedure (a_procedure: PROCEDURE; a_name: STRING_8)
			-- Execute `a_procedure', printing the `signature' of the call.
		require
			target_closed: attached a_procedure.target
			no_open_arguments: a_procedure.open_count = 0
			expected_types: is_valid_target_type (a_procedure)
		local
			s: STRING_8
		do
			s := signature (a_procedure, a_name)
			a_procedure.call
			io.put_string (s + "%N")
		end

	execute (a_routine: ROUTINE;
		a_name: STRING_8; a_expected: ANY)
			-- execute `a_routine' and output the `signature' of the call.
			-- If `a_routine' is a function, assert the result of the call
			-- is equivalent to `a_expected'.
		require
			target_closed: attached a_routine.target
			no_open_arguments: a_routine.open_count = 0
			expected_types: is_valid_target_type (a_routine)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_routine, a_name)
			if attached {PROCEDURE} a_routine as p then
				p.call
				is_ok := true
			elseif attached {PREDICATE} a_routine as p then
				ans := p.item (p.operands)
				is_ok := ans.out ~ a_expected.out
				s := s + " ==> " + as_named (ans)
			elseif attached {FUNCTION [TUPLE, ANY]} a_routine as f then
				ans := f.item (f.operands)
				is_ok := ans.out ~ a_expected.out
				s := s + " ==> " + as_named (ans)
			else
				check
					should_not_happen: False
					-- because `a_routine' is a {PROCEDURE} or a {FUNCTION}
				end
				ans := " should_not_happen "
			end
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	signature (a_routine: ROUTINE; a_feature: STRING): STRING
			-- Create a string representing a feature's signature.
		require
			target_closed: attached a_routine.target
			no_open_arguments: a_routine.open_count = 0
			expected_types: is_valid_target_type (a_routine)
		local
			i: INTEGER
			a: detachable ANY
			c: INTEGER  -- temp for testing
		do
			Result := ""
			check attached a_routine.target as t and attached a_routine.closed_operands as args then
				if attached {like Current} t then
						-- This must be a agent for an attribute
					check args.count >= 2 and then attached args [2] as a2 then
						Result := Result + a2.generating_type + ":  "
						Result := Result + "(" + as_named (args [2]) + ")." + a_feature
						if args.count >= 3 then
							Result := Result + "("
							from i := 3
							until i > args.count
							loop
								a := args [i]
								Result := Result + as_named (a)
								if i < args.count then
									Result := Result + ", "
								end
								i := i + 1
							end
							Result := Result + ")"
						end
					end
				else
					Result := t.generating_type.out + ":  "
					Result := Result + "(" + as_named (t) + ")." + a_feature
					c := args.count
					if args.count >= 2 then
						Result := Result + " ("
						from i := 2
						until i > args.count
						loop
							a := args [i]
							Result := Result + as_named (a)
							if i < args.count then
								Result := Result + ", "
							end
							i := i + 1
						end
						Result := Result + ")"
					end
				end
			end
		end

	as_named (a_any: detachable ANY): STRING_8
		do
			Result := ""
			if attached {LINKED_SET [COMPARABLE]} a_any as set then
				Result := ""
				from set.start
				until set.after
				loop
					Result := Result + as_named (set.item)
					if set.index < set.count then
						Result := Result + ","
					end
					set.forth
				end
			elseif attached {STRING} a_any as s then
--				Result := Result + "%"" + s.out + "%""
				Result := Result + s.out
			else
				Result := "Void"
			end
		end

end
