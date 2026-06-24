note
	description: "[
		Simulated a GPIO {PERIPHERAL} to be used by the 
		{SIMULATED_RPI_PROCESSOR}.
		This handles functions involving more than one register, such as
		setting a pin's value to high, which uses a GPSETn register, and 
		the ensuring the value of the GPLEVn register corresponds.
		See BCM2711 ARM Peripheral, page 102-105
		See BCM2835 Audio & PWM Clocks, Feb 2013.
		]"
	author: "Jimmy J Johnson"
	date: "5/26/26"

class
	SIMULATED_GPIO

inherit

	GPIO
		redefine
			set_mode_on_pin,
			set_pin,
			clear_pin,
			gplev_0,
			gplev_1
		end

create
	make

feature -- Basic operations

	set_mode_on_pin (a_number: INTEGER_32; a_mode: NATURAL_32)
			-- Set pin number `a_number' to `a_mode' (e.g. `Pin_input',
			-- `Pin_output', `Pin_gpio_clock', etc).
		local
			prev_m: NATURAL_32
			c_reg, s_reg: REGISTER
			cv, sv: NATURAL_32
		do
			prev_m := mode_on_pin (a_number)
			Precursor (a_number, a_mode)
			if mode_on_pin (a_number) /= prev_m and mode_on_pin (a_number) = {GPIO_PIN_CONSTANTS}.output then
					-- The mode has changed to output, so update the GPLEVn register,
					-- based on the value of the corresponding GPSETn or GPCLEn register.
				c_reg := gpclr_register (a_number)
				s_reg := gpset_register (a_number)
				cv := c_reg.bit_value (a_number \\ 32)
				sv := s_reg.bit_value (a_number \\ 32)
				check
					not_cleared_if_set: sv = {GPIO_PIN_CONSTANTS}.high implies cv = {GPIO_PIN_CONSTANTS}.Low
					not_set_if_cleared: cv = {GPIO_PIN_CONSTANTS}.high implies sv = {GPIO_PIN_CONSTANTS}.Low
				end
				if sv = {GPIO_PIN_CONSTANTS}.high then
					set_pin (a_number)
				elseif cv = {GPIO_PIN_CONSTANTS}.high then
					clear_pin (a_number)
				end
			end
		end

	set_pin (a_number: INTEGER_32)
			-- Set the state of pin `a_number' to High.
			-- Note:  use clear_pin to set the state to Low.
		local
			b: BOOLEAN
			reg: REGISTER
		do
				-- Turn assertion checking off temporarily, because some registers
				-- simulated here may be read-only, but the simulation requires writing
				-- to these registers.
			b := {ISE_RUNTIME}.check_assert (False)
				-- Set the pin by setting the corresponding bit the the GPSETn register.
			Precursor (a_number)
				-- Clear the corresponding bit in the GPCLRn register.
			reg := gpclr_register (a_number)
			reg.clear_bit (a_number \\ 32)
				-- Set corresponding bit in the GPLEVn register if in output mode
			if mode_on_pin (a_number) =  {GPIO_PIN_CONSTANTS}.output then
				gplev_register (a_number).set_bit (a_number \\ 32)
			end
				-- Restore assertion checking
			b := {ISE_RUNTIME}.check_assert (b)
		end

	clear_pin (a_number: INTEGER_32)
			-- Set the state of pin `a_number' to Low.
			-- Note:  use `set_pin' to set the state to High.
		local
			b: BOOLEAN
			reg: REGISTER
		do
				-- Turn assertion checking off temporarily, because some registers
				-- simulated here may be read-only, but the simulation requires writing
				-- to these registers.
			b := {ISE_RUNTIME}.check_assert (False)
				-- Clear the pin by SETTING the corresponding bit in the GPCLRn register.
			Precursor (a_number)
				-- Clear the corresponding bit the GPSETn register.
			reg := gpset_register (a_number)
			reg.clear_bit (a_number \\ 32)
					-- Clear the corresponding bit the GPLEVn register if in output mode.
			if mode_on_pin (a_number) =  {GPIO_PIN_CONSTANTS}.output then
				gplev_register (a_number).clear_bit (a_number \\ 32)
			end
				-- Restore assertion checking
			b := {ISE_RUNTIME}.check_assert (b)
		end

feature {NONE} -- Implementation

	gplev_0: SIMULATED_REGISTER
			-- Used to return the level of a GPIO pin (0..31)
			-- Either low or high
			-- Redefined for access to write operations on this read-only register

	gplev_1: SIMULATED_REGISTER
			-- Used to return the level of a GPIO pin (32..max)
			-- Either low or high
			-- Redefined for access to write operations on this read-only register

end
