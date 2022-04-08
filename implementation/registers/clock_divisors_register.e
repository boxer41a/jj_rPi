note
	description: "[
		Represents a General Purpose Clock divisor register.
		Bits 12..23 represent the integer part of the divisor, and
		bits 0..11 represent the fractional part of the divisor.
		See BCM2711 ARM Peripherals.pdf, page 104-105.
		]"
	author: "Jimmy J Johnon"
	date: "4/3/22"

class
	CLOCK_DIVISORS_REGISTER

inherit

	REGISTER
		redefine
			make,
			is_valid_value
		end

create
	make

feature {NONE} -- Initialization

	make (a_pointer: POINTER)
			-- Create an instance
		do
			Precursor {REGISTER} (a_pointer)
			require_password
			set_write_only_mask (password_mask)
				-- Set the integer part of the devisor to one (to
				-- prevent divide-by-zero.
			set_default_value (0x00001000)
			reset
		end


feature -- Access

	integer_divisor: NATURAL_32
			-- The integer part of divisor
		do
			Result := value.bit_and (divi_mask).bit_shift_right (12)
		end

	real_divisor: NATURAL_32
			-- The floating point part of the devisor
		do
			Result := value.bit_and (divf_mask)
		end

feature -- Element change

	set_integer_divisor (a_value: NATURAL_32)
			-- Set the `integer_divisor' (DIVI)
			-- Must be <= 4095 because only have 10 digits to use in register.
		require
			value_big_enough: a_value >= 1
--			value_big_enough_for_mash_2: mash = {GPIO_CLOCK_CONSTANTS}.stage_2 implies
--										a_value > 1
--			value_big_enough_for_mash_3: mash = {GPIO_CLOCK_CONSTANTS}.stage_3 implies
--										a_value > 3
			value_small_enough: a_value < 4096
-- ?		not_busy: not is_busy
		local
			v: like value
		do
				-- Clear the bits
			v := value
			v := v.bit_and (divi_mask.bit_not)		-- clear bits
			v := v.bit_or (a_value.bit_shift_left (12))
			set_value (v)
		ensure
			divisor_was_set: integer_divisor = a_value
			real_divisor_unchanged: real_divisor = old real_divisor
		end

	set_real_divisor (a_value: NATURAL_32)
			-- Set the floating point value of the divisor (DIVF)
			-- Must be <= 4095 because only have 10 digits to use in register.
		require
			value_big_enough: a_value >= 0
			value_small_enough: a_value < 4096
--			control_register_not_busy:  fix me!  ?
		local
			v: NATURAL_32
		do
			v := value
			v := v.bit_and (divf_mask.bit_not)		-- clear bits
			v := v.bit_or (a_value)
			set_value (v)
		ensure
			divisor_was_set: real_divisor = a_value
			integer_divisor_unchanged: integer_divisor = old integer_divisor
		end

feature -- Query

	is_valid_value (a_value: NATURAL_32): BOOLEAN
			-- Can `a_value' be written to Current?
			-- Cannot `set_value' some values, because some bits in
			-- certain registers are "write as 0" (i.e. reserved bits)
		do
			Result := Precursor (a_value) -- and then prevent divide by zero?
		end

feature {NONE} -- Implementation

	divi_mask: NATURAL_32 = 0x00FFF000
			-- `bit_and' with `value' to return the "DIVI" bits (12..23)
			-- 0000 0000 1111 1111 1111 0000 0000 0000

	divf_mask: NATURAL_32 = 0x00000FFF
			-- `bit_and' with `value' to return the "DIVF" bits (0..11)
			-- 0000 0000 0000 0000 0000 1111 1111 1111

invariant

	no_divide_by_zero: integer_divisor > 0

	is_read_writable: is_read_writable
		-- Password bits
	is_bit_31_write_only: is_bit_write_only (31)
	is_bit_30_write_only: is_bit_write_only (30)
	is_bit_29_write_only: is_bit_write_only (29)
	is_bit_28_write_only: is_bit_write_only (28)
	is_bit_27_write_only: is_bit_write_only (27)
	is_bit_26_write_only: is_bit_write_only (26)
	is_bit_25_write_only: is_bit_write_only (25)
	is_bit_24_write_only: is_bit_write_only (24)
	is_bit_23_read_writable: is_bit_read_writable (23)
	is_bit_22_read_writable: is_bit_read_writable (22)
	is_bit_21_read_writable: is_bit_read_writable (21)
	is_bit_20_read_writable: is_bit_read_writable (20)
	is_bit_19_read_writable: is_bit_read_writable (19)
	is_bit_18_read_writable: is_bit_read_writable (18)
	is_bit_17_read_writable: is_bit_read_writable (17)
	is_bit_16_read_writable: is_bit_read_writable (16)
	is_bit_15_read_writable: is_bit_read_writable (15)
	is_bit_14_read_writable: is_bit_read_writable (14)
	is_bit_13_read_writable: is_bit_read_writable (13)
	is_bit_12_read_writable: is_bit_read_writable (12)
	is_bit_11_read_writable: is_bit_read_writable (11)
	is_bit_10_read_writable: is_bit_read_writable (10)
	is_bit_9_read_writable: is_bit_read_writable (9)
	is_bit_8_read_writable: is_bit_read_writable (8)
	is_bit_7_read_writable: is_bit_read_writable (7)
	is_bit_6_read_writable: is_bit_read_writable (6)
	is_bit_5_read_writable: is_bit_read_writable (5)
	is_bit_4_read_writable: is_bit_read_writable (4)
	is_bit_3_read_writable: is_bit_read_writable (3)
	is_bit_2_read_writable: is_bit_read_writable (2)
	is_bit_1_read_writable: is_bit_read_writable (1)
	is_bit_0_read_writable: is_bit_read_writable (0)


end
