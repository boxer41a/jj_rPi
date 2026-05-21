note
	description: "[
		Represents a a Pull up/down register in a RASPBERRY_PI.
		]"
	author: "Jimmy J Johnson"
	date: "10/13/20"

class
	PULL_UP_DOWN_REGISTER

inherit

	REGISTER

create
	make

feature -- Query

	pull_state (a_pin: INTEGER_32): NATURAL_32
			-- The pull state (Pull_none, Pull_up, or Pull_down) for `a_pin'.'
		require
--			valid_pin_number: is_valid_pin (a_pin)
		local
			v: NATURAL_32
		do
			v := value.bit_and (state_mask (a_pin))
				-- Shift the bits to the right end
			Result := v.bit_shift_right (shift (a_pin))
		ensure
			valid_result: Result = {GPIO_PIN_CONSTANTS}.Pull_none or
							Result = {GPIO_PIN_CONSTANTS}.Pull_up or
							Result = {GPIO_PIN_CONSTANTS}.Pull_down
		end


feature -- Basic operations

	set_pin_state (a_pin: INTEGER_32; a_state: NATURAL_32)
			-- Set pin number `a_pin' to `a_state'
		require
--			is_valid_pin_number: is_valid_pin (a_pin)
			is_valid_pull_state: a_state = {GPIO_PIN_CONSTANTS}.Pull_none or
								a_state = {GPIO_PIN_CONSTANTS}.Pull_up or
								a_state = {GPIO_PIN_CONSTANTS}.Pull_down
		local
			s: NATURAL_32
			v: NATURAL_32	-- Value currently in register
			mask: NATURAL_32
		do
				-- Update mode for `a_pin', preserving other pins' modes
				-- Clear mode for `a_pin' only
			mask := state_mask (a_pin).bit_not
			v := value.bit_and (mask)
				-- Align `a_state' with correct two bits
			s := a_state.bit_shift_left (shift (a_pin))
				-- Now set the state and put back into register
			v := v.bit_or (s)
			set_value (v)
		ensure
			state_was_set: pull_state (a_pin) = a_state
		end


feature {NONE} -- Implementation

	state_mask (a_pin: INTEGER): NATURAL_32
			-- Bitmask to be used to isolate the two bits in a pull-up/
			-- pull-down register that corresponds to pin number `a_pin'.
		require
--			is_valid_pin_number: is_valid_gpio_pin (a_pin)
		local
			three: NATURAL_32
		do
				-- Shift 3 (i.e. 11) over correct number of places
			three := (3).to_natural_32
			Result := three.bit_shift_left (shift (a_pin))
				-- Example:   mask for pin number 4
				--      shift:  (4 \\ 15) * 2 = 12
				--    pin num: 15 14 13 ...  5  4  3  2  1  0
				--      three: 00 00 00 ... 00 00 00 00 00 11
				--     Result: 00 00 00 ... 00 11 00 00 00 00
		end

	shift (a_pin: INTEGER_32): INTEGER_32
			-- Distance to bit-shift values based on the implementation of the
			-- Pull-up/down registers as described in BCM2711 ARM Peripherals,
			-- page 94.
			-- Each of these register (except number 3) control the pull state
			-- for 15 pins, using two bits to represent a pin.
			-- So, modulo-divide the pin number by 15 and multiply by 2
		do
			Result := (a_pin \\ 15) * 2
		end

end
