note
	description: "[
		Represents the PWM registers and functions of a {PI_CONTROLLER}.
		See BCM2711 ARM Peripherals.pdf, pages 154-163.
		]"
	author: "Jimmy J Johnson"
	date: "10/16/20"

class
	PULSE_WIDTH_MODULATOR

create
	make

feature {NONE} -- Initialization

	make (a_address: POINTER)
			-- Set up Current, creating the registers
		do
				-- create register
			create pwm_control.make (a_address + 0x00)
			create pwm_status.make (a_address + 0x04)
			create pwm_dmac.make (a_address + 0x08)
			create pwm_channel_1_range.make (a_address + 0x10)
			create pwm_channel_1_data.make (a_address + 0x14)
			create pwm_fifo_input.make (a_address + 0x18)
			create pwm_channel_2_range.make (a_address + 0x20)
			create pwm_channel_2_data.make (a_address + 0x24)
				-- name the registers
			pwm_control.set_name ("CTL")
			pwm_status.set_name ("STA")
			pwm_dmac.set_name ("DMAC")
			pwm_channel_1_range.set_name ("RNG1")
			pwm_channel_1_data.set_name ("DAT1")
			pwm_fifo_input.set_name ("FIF1")
			pwm_channel_2_range.set_name ("RNG2")
			pwm_channel_2_data.set_name ("DAT2")
				-- CTL
			pwm_control.set_reserved_mask (0xFFFF4000) -- bits 14,16..31
			pwm_control.set_bit_write_once (6)
				-- STA
			pwm_status.set_reserved_mask (0xFFFFF8C0)	-- bits 6,7,11..31
			pwm_status.set_read_only_mask (0x00000603)
			pwm_status.set_write_once_mask (0x0000013C)
				-- DMAC
			pwm_dmac.set_reserved_mask (0x7FFF0000)
				-- FIF1
			pwm_fifo_input.set_write_only
				-- Set defaults
			reset_range (1)
			reset_range (2)
		ensure

		end

feature -- Access

	default_range: NATURAL_32 = 0x20
			-- Default value for `range'

	range (a_channel: INTEGER_32): NATURAL_32
			-- Period of length over which data is sent over `a_channel'
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := pwm_channel_1_range.value
			else
				Result := pwm_channel_2_range.value
			end
		ensure
			definition_1: a_channel = 1 implies Result = pwm_channel_1_range.value
			definition_1: a_channel = 2 implies Result = pwm_channel_2_range.value
		end

	data (a_channel: INTEGER_32): NATURAL_32
			-- The number of pulses sent in PWM mode or data sent
			-- in serialised mode
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := pwm_channel_1_data.value
			else
				Result := pwm_channel_2_data.value
			end
		ensure
			definition_1: a_channel = 1 implies Result = pwm_channel_1_data.value
			definition_1: a_channel = 2 implies Result = pwm_channel_2_data.value
		end

feature -- Element change

	reset_range (a_channel: INTEGER_32)
			-- Restore the `range' for `a_channel' to the `default_range'
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			set_range (a_channel, default_range)
		end

	set_range (a_channel: INTEGER_32; a_value: NATURAL_32)
			-- Change the `range' for `a_channel' to `a_value'
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				pwm_channel_1_range.set_value (a_value)
			else
				pwm_channel_2_range.set_value (a_value)
			end
		ensure
			definition: range (a_channel) = a_value
		end

	set_data (a_channel: INTEGER_32; a_value: NATURAL_32)
			-- Change the `data' for `a_channel' to `a_value'
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				pwm_channel_1_data.set_value (a_value)
			else
				pwm_channel_2_data.set_value (a_value)
			end
		ensure
			definition: data (a_channel) = a_value
		end

	set_fifo_data (a_value: NATURAL_32)
			-- Data sent by one or both channels if that channel is
			-- in FIFO mode (i.e. `use_fifo' was called on that channel).
			-- See BCM2711 ARM Peripheral.pdf, page 163.
		do
			pwm_fifo_input.set_value (a_value)
		end

feature -- Access (`pwm_dmac')

	panic_threshold: NATURAL_32
			-- The value at which the "PANIC signal" goes active
		do
			Result := pwm_dmac.panic_threshold
		ensure
			valid_result: Result >= 0 and Result <= {DMAC_REGISTER}.max_panic_threshold
		end

	dreq_threshold: NATURAL_32
			-- The value at which the "DREQ signal" goes active
		do
				-- no shifting required
			Result := pwm_dmac.dreq_threshold
		ensure
			valid_result: Result >= 0 and Result <= {DMAC_REGISTER}.max_dreq_threshold
		end

	reset_panic_threshold
			-- Set the DMA `panic_threshold' to its default value
		do
			pwm_dmac.reset_panic_threshold
		ensure
			threshold_was_reset: panic_threshold = {DMAC_REGISTER}.default_panic_threshold
		end

	reset_dreq_threshold
			-- Set the DMA `dreq_threshold' to its default value
		do
			pwm_dmac.reset_dreq_threshold
		ensure
			threshold_was_reset: panic_threshold = {DMAC_REGISTER}.default_dreq_threshold
		end

feature -- Element change (`pwm_dmac')

	set_panic_threshold (a_value: NATURAL_32)
			-- Set the `panic_threshold' to `a_value'
		require
			value_in_range: a_value >= 0 and a_value <= {DMAC_REGISTER}.max_panic_threshold
		do
			pwm_dmac.set_panic_threshold (a_value)
		ensure
			value_was_set: panic_threshold = a_value
		end

	set_dreq_threshold (a_value: NATURAL_32)
			-- Set the `dreq_threshold' to `a_value'
		require
			value_in_range: a_value >= 0 and a_value <= {DMAC_REGISTER}.max_dreq_threshold
		do
			pwm_dmac.set_dreq_threshold (a_value)
		ensure
			value_was_set: dreq_threshold = a_value
		end

feature -- Status report (pwm control)

	is_enabled (a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' able to transmit data?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_enabled (a_channel)
		end

	is_serialiser_mode (a_channel: INTEGER_32): BOOLEAN
			-- Is the channel in serializer mode?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_serialiser_mode (a_channel)
		end

	is_ms_sub_mode (a_channel: INTEGER_32): BOOLEAN
			-- In PWM mode, is the channel sending serial data in M/S ratio
			-- where M is data sent, and S is the range.
			--              |<----- M ----->|
			--              ________________           _______
			--   ... ______/                \_________/       ...
			--             |<----------- S ------------------>|
			-- When false, the default, the channel sends data represented in periotic
			-- sequence of M cycles, output as "1" for N cycles and a "0" for M-N cyles
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_ms_sub_mode (a_channel)
		end

	is_polarity_inverted (a_channel: INTEGER_32): BOOLEAN
			-- Is the final output polarity	inverted on `a_channel'?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_polarity_inverted (a_channel)
		end

	is_silenced_high (a_channel: INTEGER_32): BOOLEAN
			-- Is the output state high when no transmission
			-- is taking place?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_silenced_high (a_channel)
		end

	is_repeating_last_data (a_channel: INTEGER_32): BOOLEAN
			-- Is last data in the FIFO register transmitted reeatedly until
			-- the FIFO is not empty?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_repeating_last_data (a_channel)
		end

	is_fifo_enabled (a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' in FIFO mode?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_control.is_fifo_enabled (a_channel)
		end

feature -- Status report (status register)

	is_transmitting (a_channel: INTEGER_32): BOOLEAN
			-- Is a_channel transmitting?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_status.is_transmitting (a_channel)
		ensure
			definition: Result implies pwm_status.is_transmitting (a_channel)
		end

	is_bus_error: BOOLEAN
			-- Did a bus error occur while writing to registers via APB?
		do
			Result := pwm_status.is_bus_error
		ensure
			definition: Result implies pwm_status.is_bus_error
		end

	is_gap_error (a_channel: INTEGER_32): BOOLEAN
			-- Has there been a gap between transmission of two consecutive data
			-- from FIFO?  This may happen when the FIFO becomes empty after the
			-- state machine has sent a word and is waiting for the next word.
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			Result := pwm_status.is_gap_error (a_channel)
		ensure
			definition: Result implies pwm_status.is_gap_error (a_channel)
		end

	is_fifo_read_empty_error: BOOLEAN
			-- Has there been a FIFO read-when-empty error?
			-- "RERR1" bit.
		do
			Result := pwm_status.is_fifo_read_empty_error
		ensure
			definition: Result implies pwm_status.is_fifo_read_empty_error
		end

	is_fifo_write_full_error: BOOLEAN
			-- Has there been a FIFO write-when-full error?
			-- "WERR1" bit.
		do
			Result := pwm_status.is_fifo_write_full_error
		ensure
			definition: Result implies pwm_status.is_fifo_write_full_error
		end

	is_empty: BOOLEAN
			-- Is the FIFO empty?
			-- "EMPT1" bit
		do
			Result := pwm_status.is_empty
		ensure
			definition: Result implies pwm_status.is_empty
		end

	is_full: BOOLEAN
			-- Is the FIFO full?
			-- "FULL1" bit
		do
			Result := pwm_status.is_full
		ensure
			definition: Result implies pwm_status.is_full
		end

feature -- Status report (DMA)

	is_dma_enabled: BOOLEAN
			-- Is direct-memory access enabled?
		do
			Result := pwm_dmac.is_enabled
		end

feature -- Basic operations (pwm control)

	enable_channel (a_channel: INTEGER_32)
			-- Enable `a_channel' (i.e. let it transmit)
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.enable_channel (a_channel)
		ensure
			channel_enabled: is_enabled (a_channel)
		end

	disable_channel (a_channel: INTEGER_32)
			-- Disable `a_channel' (i.e. don't let it transmit)
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.disable_channel (a_channel)
		ensure
			channel_disable: not is_enabled (a_channel)
		end

	set_pmw_mode (a_channel: INTEGER_32)
			-- Set `a_channel' to PMW mode
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.set_pmw_mode (a_channel)
		ensure
			mode_set_for_channel: not is_serialiser_mode (a_channel)
		end

	set_serialiser_mode (a_channel: INTEGER_32)
			-- Set `a_channel' to serializer mode
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.set_serialiser_mode (a_channel)
		ensure
			mode_set_for_channel: is_serialiser_mode (a_channel)
		end

	set_pwm_sub_mode (a_channel: INTEGER_32)
			-- Change PWM sub-mode to transmit using N/M algorithm
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.set_pwm_sub_mode (a_channel)
		ensure
			pwm_sub_mode_for_channel: not is_ms_sub_mode (a_channel)
		end

	set_ms_sub_mode (a_channel: INTEGER_32)
			-- Change PMW sub-mode to transmit serially.  See `is_ms_sub_mode'.
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.set_ms_sub_mode (a_channel)
		ensure
			is_ms_sub_mode: is_ms_sub_mode (a_channel)
		end

	invert_polarity (a_channel: INTEGER_32)
			-- Invert the final output polarity
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.invert_polarity (a_channel)
		ensure
			polarity_is_inverted: is_polarity_inverted (a_channel)
		end

	restore_polarity (a_channel: INTEGER_32)
			-- Restore final output polarity to default
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.restore_polarity (a_channel)
		ensure
			not_polarity_inverted: not is_polarity_inverted (a_channel)
		end

	set_silenced_bit (a_channel: INTEGER_32; a_value: NATURAL_32)
			-- Set the state (HIGH or LOW) of the silence bit on `a_channel'.
			-- This bit defines the state of the output when no transmission takes place.
			-- It is padded between two consecutive transfers as well as tail of data
			-- in certain cases.
		require
			valid_signal: a_value = 1 or a_value = 2
		do
			pwm_control.set_silenced_bit (a_channel, a_value)
		ensure
			set_high_implication: a_value = 1 implies is_silenced_high (a_channel)
			set_low_implication: a_value =  0 implies not is_silenced_high (a_channel)
		end

	repeat_last_data	 (a_channel: INTEGER_32)
			-- Make `a_channel' transmit last data in FIFO repeatedly until FIFO
			-- is not empty
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.repeat_last_data (a_channel)
		ensure
			is_repeating_last_data: is_repeating_last_data (a_channel)
		end

	interupt_last_data (a_channel: INTEGER_32)
			-- Make `a_channel' interupt transmission when FIFO is empty
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.interupt_last_data (a_channel)
		ensure
			not_repeating_data: not is_repeating_last_data (a_channel)
		end

	use_fifo (a_channel: INTEGER_32)
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_control.use_fifo (a_channel)
		ensure
			fifo_set_for_channel: is_fifo_enabled (a_channel)
		end

	clear_fifo
			-- Clear the FIFO register (applies to both channels)
		do
			pwm_control.clear_fifo
		end

feature -- Basic operations (pwm status)

	clear_bus_error
			-- Clear a bus error
		do
			pwm_status.clear_bus_error
		ensure
			error_was_cleared: not is_bus_error
		end

	clear_gap_error (a_channel: INTEGER_32)
			-- Clear a gap error on `a_channel'
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			pwm_status.clear_gap_error (a_channel)
		ensure
			definition: not is_gap_error (a_channel)
		end

	clear_fifo_read_emtpy_error
			-- Reset the clear-when-empty error bit, "RERR1"
		do
			pwm_status.clear_fifo_read_emtpy_error
		ensure
			definition: not is_fifo_read_empty_error
		end

	clear_fifo_write_full_error
			-- Reset the write-when-full error bit, "WERR1"
		do
			pwm_status.clear_fifo_write_full_error
		ensure
			definition: not is_fifo_write_full_error
		end

feature -- Basic operations (DMA)

	enable_dma
			-- Enable (i.e. start) DMA
		do
			pwm_dmac.enable
		ensure
			is_enabled: is_dma_enabled
		end

	disable_dma
			-- Disable (i.e. stop) DMA
		do
			pwm_dmac.disable
		ensure
			not_enabled: not is_dma_enabled
		end

feature {NONE} -- Implementation

	pwm_control: PWM_CONTROL_REGISTER
			-- The "CTL" register for setting up and enabling PWM

	pwm_status: PWM_STATUS_REGISTER
			-- The "STA" register, for reporting empty, full, error, etc status

	pwm_dmac: DMAC_REGISTER
			-- The "DMAC" register to enable DMA and set threshold values that
			-- determine when the PANIC and DREQ signals go active

	pwm_channel_1_range: REGISTER
			-- Defines "a period of length" over which evenly distributed pulses
			-- are sent (in PMW mode) or over which serialized data is sent (in
			-- serialized mode)
			-- "If the value in PWM_RNGi is less than 32, only the first PWM_RNGi
			-- bits are sent resulting in a truncation. If it is larger than 32,
			-- excess zero bits are padded at the end of data. Default value for
			-- this register is 32.
			-- "RNG1"

	pwm_channel_1_data: REGISTER
			-- Defines the number of pulses to be sent within the period defined
			-- by the `pwm_channel_1_range' register using pulse width modulation
			-- when the PWM Controller is in PWM mode; or defines serialized data
			-- to be sent in serialiser mode.
			-- "DAT1"

	pwm_fifo_input: REGISTER
			-- FIFO register possibly shared between channel 1 and 2 holding data
			-- sent  when `is_fifo_enabled'.  Words are interleaved between channels
			-- if shared.
			-- "FIF1"

	pwm_channel_2_range: REGISTER
			-- See `pwm_channel_1_range'
			-- "RNG2"

	pwm_channel_2_data: REGISTER
			-- See `pwm_channel_1_data'
			-- "DAT2"

invariant

		-- PWM  CTL
	pwm_control.is_readable
	pwm_control.is_writable
	pwm_control.is_bit_reserved (31)
	pwm_control.is_bit_reserved (30)
	pwm_control.is_bit_reserved (29)
	pwm_control.is_bit_reserved (28)
	pwm_control.is_bit_reserved (27)
	pwm_control.is_bit_reserved (26)
	pwm_control.is_bit_reserved (25)
	pwm_control.is_bit_reserved (24)
	pwm_control.is_bit_reserved (23)
	pwm_control.is_bit_reserved (22)
	pwm_control.is_bit_reserved (21)
	pwm_control.is_bit_reserved (20)
	pwm_control.is_bit_reserved (19)
	pwm_control.is_bit_reserved (18)
	pwm_control.is_bit_reserved (17)
	pwm_control.is_bit_reserved (16)
	pwm_control.is_bit_read_writable (15)
	pwm_control.is_bit_reserved (14)
	pwm_control.is_bit_read_writable (13)
	pwm_control.is_bit_read_writable (12)
	pwm_control.is_bit_read_writable (11)
	pwm_control.is_bit_read_writable (10)
	pwm_control.is_bit_read_writable (9)
	pwm_control.is_bit_read_writable (8)
	pwm_control.is_bit_read_writable (7)
	pwm_control.is_bit_write_once (6)
	pwm_control.is_bit_read_writable (5)
	pwm_control.is_bit_read_writable (4)
	pwm_control.is_bit_read_writable (3)
	pwm_control.is_bit_read_writable (2)
	pwm_control.is_bit_read_writable (1)
	pwm_control.is_bit_read_writable (2)
		-- PWM  STA
	pwm_status.is_readable
	pwm_status.is_writable
	pwm_status.is_bit_reserved (31)
	pwm_status.is_bit_reserved (30)
	pwm_status.is_bit_reserved (29)
	pwm_status.is_bit_reserved (28)
	pwm_status.is_bit_reserved (27)
	pwm_status.is_bit_reserved (26)
	pwm_status.is_bit_reserved (25)
	pwm_status.is_bit_reserved (24)
	pwm_status.is_bit_reserved (23)
	pwm_status.is_bit_reserved (22)
	pwm_status.is_bit_reserved (21)
	pwm_status.is_bit_reserved (20)
	pwm_status.is_bit_reserved (19)
	pwm_status.is_bit_reserved (18)
	pwm_status.is_bit_reserved (17)
	pwm_status.is_bit_reserved (16)
	pwm_status.is_bit_reserved (15)
	pwm_status.is_bit_reserved (14)
	pwm_status.is_bit_reserved (13)
	pwm_status.is_bit_reserved (12)
	pwm_status.is_bit_reserved (11)
	pwm_status.is_bit_read_only (10)
	pwm_status.is_bit_read_only (9)
	pwm_status.is_bit_write_once (8)
	pwm_status.is_bit_reserved (7)
	pwm_status.is_bit_reserved (6)
	pwm_status.is_bit_write_once (5)
	pwm_status.is_bit_write_once (4)
	pwm_status.is_bit_write_once (3)
	pwm_status.is_bit_write_once (2)
	pwm_status.is_bit_read_only (1)
	pwm_status.is_bit_read_only (0)
		-- PWM  DMAC
	pwm_dmac.is_readable
	pwm_dmac.is_writable
	pwm_dmac.is_bit_read_writable (31)
	pwm_dmac.is_bit_reserved (30)
	pwm_dmac.is_bit_reserved (29)
	pwm_dmac.is_bit_reserved (28)
	pwm_dmac.is_bit_reserved (27)
	pwm_dmac.is_bit_reserved (26)
	pwm_dmac.is_bit_reserved (25)
	pwm_dmac.is_bit_reserved (24)
	pwm_dmac.is_bit_reserved (23)
	pwm_dmac.is_bit_reserved (22)
	pwm_dmac.is_bit_reserved (21)
	pwm_dmac.is_bit_reserved (20)
	pwm_dmac.is_bit_reserved (19)
	pwm_dmac.is_bit_reserved (18)
	pwm_dmac.is_bit_reserved (17)
	pwm_dmac.is_bit_reserved (16)
	pwm_dmac.is_bit_read_writable (15)
	pwm_dmac.is_bit_read_writable (14)
	pwm_dmac.is_bit_read_writable (13)
	pwm_dmac.is_bit_read_writable (12)
	pwm_dmac.is_bit_read_writable (11)
	pwm_dmac.is_bit_read_writable (10)
	pwm_dmac.is_bit_read_writable (9)
	pwm_dmac.is_bit_read_writable (8)
	pwm_dmac.is_bit_read_writable (7)
	pwm_dmac.is_bit_read_writable (6)
	pwm_dmac.is_bit_read_writable (5)
	pwm_dmac.is_bit_read_writable (4)
	pwm_dmac.is_bit_read_writable (3)
	pwm_dmac.is_bit_read_writable (2)
	pwm_dmac.is_bit_read_writable (1)
	pwm_dmac.is_bit_read_writable (0)
		-- PWM  RNG1
	pwm_channel_1_range.is_readable
	pwm_channel_1_range.is_writable
	pwm_channel_1_range.is_bit_read_writable (31)
	pwm_channel_1_range.is_bit_read_writable (30)
	pwm_channel_1_range.is_bit_read_writable (29)
	pwm_channel_1_range.is_bit_read_writable (28)
	pwm_channel_1_range.is_bit_read_writable (27)
	pwm_channel_1_range.is_bit_read_writable (26)
	pwm_channel_1_range.is_bit_read_writable (25)
	pwm_channel_1_range.is_bit_read_writable (24)
	pwm_channel_1_range.is_bit_read_writable (23)
	pwm_channel_1_range.is_bit_read_writable (22)
	pwm_channel_1_range.is_bit_read_writable (21)
	pwm_channel_1_range.is_bit_read_writable (20)
	pwm_channel_1_range.is_bit_read_writable (19)
	pwm_channel_1_range.is_bit_read_writable (18)
	pwm_channel_1_range.is_bit_read_writable (17)
	pwm_channel_1_range.is_bit_read_writable (16)
	pwm_channel_1_range.is_bit_read_writable (15)
	pwm_channel_1_range.is_bit_read_writable (14)
	pwm_channel_1_range.is_bit_read_writable (13)
	pwm_channel_1_range.is_bit_read_writable (12)
	pwm_channel_1_range.is_bit_read_writable (11)
	pwm_channel_1_range.is_bit_read_writable (10)
	pwm_channel_1_range.is_bit_read_writable (9)
	pwm_channel_1_range.is_bit_read_writable (8)
	pwm_channel_1_range.is_bit_read_writable (7)
	pwm_channel_1_range.is_bit_read_writable (6)
	pwm_channel_1_range.is_bit_read_writable (5)
	pwm_channel_1_range.is_bit_read_writable (4)
	pwm_channel_1_range.is_bit_read_writable (3)
	pwm_channel_1_range.is_bit_read_writable (2)
	pwm_channel_1_range.is_bit_read_writable (1)
	pwm_channel_1_range.is_bit_read_writable (0)
		-- PWM  RNG2
	pwm_channel_2_range.is_readable
	pwm_channel_2_range.is_writable
	pwm_channel_2_range.is_bit_read_writable (31)
	pwm_channel_2_range.is_bit_read_writable (30)
	pwm_channel_2_range.is_bit_read_writable (29)
	pwm_channel_2_range.is_bit_read_writable (28)
	pwm_channel_2_range.is_bit_read_writable (27)
	pwm_channel_2_range.is_bit_read_writable (26)
	pwm_channel_2_range.is_bit_read_writable (25)
	pwm_channel_2_range.is_bit_read_writable (24)
	pwm_channel_2_range.is_bit_read_writable (23)
	pwm_channel_2_range.is_bit_read_writable (22)
	pwm_channel_2_range.is_bit_read_writable (21)
	pwm_channel_2_range.is_bit_read_writable (20)
	pwm_channel_2_range.is_bit_read_writable (19)
	pwm_channel_2_range.is_bit_read_writable (18)
	pwm_channel_2_range.is_bit_read_writable (17)
	pwm_channel_2_range.is_bit_read_writable (16)
	pwm_channel_2_range.is_bit_read_writable (15)
	pwm_channel_2_range.is_bit_read_writable (14)
	pwm_channel_2_range.is_bit_read_writable (13)
	pwm_channel_2_range.is_bit_read_writable (12)
	pwm_channel_2_range.is_bit_read_writable (11)
	pwm_channel_2_range.is_bit_read_writable (10)
	pwm_channel_2_range.is_bit_read_writable (9)
	pwm_channel_2_range.is_bit_read_writable (8)
	pwm_channel_2_range.is_bit_read_writable (7)
	pwm_channel_2_range.is_bit_read_writable (6)
	pwm_channel_2_range.is_bit_read_writable (5)
	pwm_channel_2_range.is_bit_read_writable (4)
	pwm_channel_2_range.is_bit_read_writable (3)
	pwm_channel_2_range.is_bit_read_writable (2)
	pwm_channel_2_range.is_bit_read_writable (1)
	pwm_channel_2_range.is_bit_read_writable (0)
		-- PWM  DAT1
	pwm_channel_1_data.is_readable
	pwm_channel_1_data.is_writable
		-- PWM  DAT2
	pwm_channel_2_data.is_readable
	pwm_channel_2_data.is_writable
		-- PWM  FIF1
	pwm_fifo_input.is_write_only
end
