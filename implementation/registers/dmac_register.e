note
	description: "[
		{REGISTER} for starting the DMA and setting threshold values for
		PWM in the {PI_CONTROLLER}.
		See BCM2711 ARM Peripherals.pdf, page 162.
		]"
	author: "Jimmy J. Johnson"
	date: "10/22/20"


class
	DMAC_REGISTER

inherit

	REGISTER
		redefine
			make
		end

create
	make

feature {NONE} -- Implementation

	make (a_pointer: POINTER)
			-- Set up the register
		do
			Precursor {REGISTER} (a_pointer)
			reset_panic_threshold
			reset_dreq_threshold
		ensure then
			panic_threshold_at_default: panic_threshold = default_panic_threshold
			dreq_threshold_at_default: dreq_threshold = default_dreq_threshold
		end

feature -- Access

	default_panic_threshold: NATURAL_32 = 0x00000007
			-- Default value for `panic_threshold'

	default_dreq_threshold: NATURAL_32 = 0x00000007
			-- Defaut_value for `dreq_threshold'

	max_panic_threshold: NATURAL_32 = 0x000000FF
			-- Max allowed value for `panic_threshold'

	max_dreq_threshold: NATURAL_32 = 0x000000FF
			-- Max allowed value for `dreq_threshold'

	panic_threshold: NATURAL_32
			-- The value at which the "PANIC signal" goes active
		do
			Result := value.bit_and (panic_mask).bit_shift_right (8)
		ensure
			valid_result: Result >= 0 and Result <= max_panic_threshold
		end

	dreq_threshold: NATURAL_32
			-- The value at which the "DREQ signal" goes active
		do
				-- no shifting required
			Result := value.bit_and (dreq_mask)
		ensure
			valid_result: Result >= 0 and Result <= max_dreq_threshold
		end

feature -- Element change

	set_panic_threshold (a_value: NATURAL_32)
			-- Set the `panic_threshold' to `a_value'
		require
			value_in_range: a_value >= 0 and a_value <= max_panic_threshold
		local
			v: NATURAL_32
		do
				-- Shift `a_value' for correct bit alignment
			v := a_value.bit_shift_left (8)
				-- Don't change the `dreq_threshold'
			v := v.bit_or (dreq_threshold)
			set_value (v)
		ensure
			panic_threshold_was_set: panic_threshold = a_value
			dreq_threshold_unchanged: dreq_threshold = old dreq_threshold
		end

	set_dreq_threshold (a_value: NATURAL_32)
			-- Set the `dreq_threshold' to `a_value'
		require
			value_in_range: a_value >= 0 and a_value <= max_dreq_threshold
		local
			v: NATURAL_32
		do
			v := a_value
				-- Don't change the `panic_threshold'
			v := v.bit_or (panic_threshold.bit_shift_left (8))
			set_value (v)
		ensure
			dreq_threshold_was_set: dreq_threshold = a_value
			panic_threshold_unchanged: panic_threshold = old panic_threshold
		end

feature -- Status report

	is_enabled: BOOLEAN
			-- Is DMA enabled?
		do
			Result := bit_value (enable_bit) = 1
		ensure
			definition: Result implies bit_value (enable_bit) = 1
		end

feature -- Basic operations

	enable
			-- Enable (i.e. start) DMA
		do
			set_bit (enable_bit)
		ensure
			is_enabled: is_enabled
		end

	disable
			-- Disable (i.e. stop) DMA
		do
			clear_bit (enable_bit)
		ensure
			not_enabled: not is_enabled
		end

	reset_panic_threshold
			-- Set the `panic_threshold' to its default value
		do
			set_panic_threshold (default_panic_threshold)
		ensure
			threshold_was_reset: panic_threshold = default_panic_threshold
		end

	reset_dreq_threshold
			-- Set the `dreq_threshold' to its default value
		do
			set_dreq_threshold (default_dreq_threshold)
		ensure
			threshold_was_reset: dreq_threshold = default_dreq_threshold
		end

feature {NONE} -- Implementation

	enable_bit: INTEGER_32 = 31
			-- Set to high to enable DMA
			-- "ENAB"

	panic_mask: NATURAL_32 = 0x0000FF00
			-- `bit_and' with `value' to return the "PANIC" bits (8..15)
			-- 0000 0000 0000 0000 1111 1111 0000 0000
			-- "PANIC"
			-- DMA Threshold for PANIC signal going active

	dreq_mask: NATURAL_32 = 0x000000FF
			-- `bit_and' with `value' to return the "DREQ" bits (0..7)
			-- 0000 0000 0000 0000 0000 0000 1111 1111
			-- "DREQ"
			-- DMA Threshold for DREQ signal going active
			-- Default value = "7"

end
