note
	description: "[
		Represents a "function-select" register in the {PI_CONTROLLER}.
		]"
	author: "Jimmy J Johnson"
	date: "10/11/20"

class
	FUNCTION_SELECT_REGISTER

inherit

	REGISTER

create
	make

feature -- Query

	pin_mode (a_pin: INTEGER_32): NATURAL_32
			-- What function is `a_pin' performing?  Pin_input, Pin_output
			-- alt_function_0, 1, 2, 3, 4, or 5?
		require
--			valid_pin_number: is_valid_pin (a_pin)
		local
			v: NATURAL_32
			shift: INTEGER_32
		do
			v := value.bit_and (function_mask (a_pin))
				-- Now, only the three pin bits are possibly set.
			shift := (a_pin \\ 10) * 3
				-- Shift the bits to the right end
			Result := v.bit_shift_right (shift)
		end


feature -- Basic operations

	set_pin_mode (a_pin: INTEGER_32; a_mode: NATURAL_32)
			-- Set pin number `a_pin' to `a_mode' (e.g. `Pin_input',
			-- 'Pin_output', `Pin_gpio_clock', etc).
		require
--			is_valid_pin_number: is_valid_pin (a_pin)
--			is_valid_mode_for_pin: false   -- fix me
		local
			m: NATURAL_32
			v: NATURAL_32	-- Value currently in register
			mask: NATURAL_32
			shift: INTEGER
		do
				-- Update mode for `a_pin', preserving other pins' modes
				-- Clear mode for `a_pin' only
			mask := function_mask (a_pin).bit_not
			v := value.bit_and (mask)
				-- Align `a_mode' with correct three bits
			shift := (a_pin \\ 10) * 3
			m := a_mode.bit_shift_left (shift)
				-- Now set the mode and put back into register
			v := v.bit_or (m)
			set_value (v)
		ensure
			mode_was_set: pin_mode (a_pin) = a_mode
		end


feature {NONE} -- Implementation

	function_mask (a_pin: INTEGER): NATURAL_32
			-- Bitmask to be used to isolate the three bits in a function-
			-- select register that correspond to pin number `a_pin'.
		require
--			is_valid_pin_number: is_valid_gpio_pin (a_pin)
		local
			seven: NATURAL_32
		do
				-- Shift 7 (i.e. 111) over correct number of places
			seven := (7).to_natural_32
			Result := seven.bit_shift_left ((a_pin \\ 10) * 3)
				-- Example:   mask for pin number 4
				--      shift:  (4 \\ 10) * 3 = 12
				--    pin num:     9   8   7   6   5  4   3   2   1   0
				--      seven: 00 000 000 000 000 000 000 000 000 000 111
				--     Result: 00 000 000 000 000 000 111 000 000 000 000
		end

end
