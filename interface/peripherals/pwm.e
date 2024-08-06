note
	description: "[
		Controls the two PWM (Pulse-Width Modulators) in a {PI_CONTROLLER}
		BCM2711 ARM Peripherals, page 156-163
		]"
	author: "Jimmy J Johnson"
	date: "10/27/20"

class
	PWM

inherit

	PERIPHERAL
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_descriptor: INTEGER_32; a_length: INTEGER_32; a_address: NATURAL_32)
			-- Set up Current, creating the registers
			-- See BCM2711 Arm Peripherals, page 158
		do
			Precursor (a_file_descriptor, a_length, a_address)
			create pwm_0.make (base_address)
			create pwm_1.make (base_address + 0x0800)
		end

feature -- Access

	default_range: NATURAL_32 = 32
			-- Default value for `range'

	range (a_index: INTEGER_32; a_channel: INTEGER_32): NATURAL_32
			-- Period of length over which data is sent over `a_channel'
			-- for the PWM (0 or 1) indexed by `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.range (a_channel)
			else
				Result := pwm_1.range (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies Result = pwm_0.range (a_channel)
			definition_1: a_index = 1 implies Result = pwm_1.range (a_channel)
		end

	data (a_index: INTEGER_32; a_channel: INTEGER_32): NATURAL_32
			-- The number of pulses sent in PWM mode or data sent
			-- in serialised mode over `a_channel' of the PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.data (a_channel)
			else
				Result := pwm_1.data (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies Result = pwm_0.data (a_channel)
			definition_1: a_index = 1 implies Result = pwm_1.data (a_channel)
		end

feature -- Element change

	reset_range (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Restore the `range' for `a_channel' of PWM `a_index'
			-- to the `default_range'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			set_range (a_index, a_channel, default_range)
		end

	set_range (a_index: INTEGER_32; a_channel: INTEGER_32; a_value: NATURAL_32)
			-- Set the `range' for `a_channel' of PWM `a_index'
			-- to the `a_value'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_range (a_channel, a_value)
			else
				pwm_1.set_range (a_channel, a_value)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.range (a_channel) = a_value
			definition_1: a_index = 1 implies pwm_1.range (a_channel) = a_value
		end

	set_data (a_index: INTEGER_32; a_channel: INTEGER_32; a_value: NATURAL_32)
			-- Set the `data' for `a_channel' of PWM `a_index'
			-- to the `a_value'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_data (a_channel, a_value)
			else
				pwm_1.set_data (a_channel, a_value)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.data (a_channel) = a_value
			definition_1: a_index = 1 implies pwm_1.data (a_channel) = a_value
		end

	set_fifo_data (a_index: INTEGER_32; a_value: NATURAL_32)
			-- Set the data sent by one or both channels of PCM `a_index' if
			-- the channel is in FIFO mode (i.e. `use_fifo' was called on
			-- that channel).
			-- See BCM2711 ARM Peripheral.pdf, page 163.
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.set_fifo_data (a_value)
			else
				pwm_1.set_fifo_data (a_value)
			end
		ensure
			definition: -- reads zeros so no assertion here?
		end

feature -- Access

	panic_threshold (a_index: INTEGER_32): NATURAL_32
			-- The value at which the "PANIC signal" goes active
			-- for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.panic_threshold
			else
				Result := pwm_1.panic_threshold
			end
		ensure
			definition_1: a_index = 0 implies Result = pwm_0.panic_threshold
			definition_1: a_index = 1 implies Result = pwm_1.panic_threshold
		end

	dreq_threshold (a_index: INTEGER_32): NATURAL_32
			-- The value at which the "DREQ signal" goes active
			-- for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.dreq_threshold
			else
				Result := pwm_1.dreq_threshold
			end
		ensure
			definition_1: a_index = 0 implies Result = pwm_0.dreq_threshold
			definition_1: a_index = 1 implies Result = pwm_1.dreq_threshold
		end

feature -- Element change (`pwm_dma_configuration')

	set_panic_threshold (a_index: INTEGER_32; a_value: NATURAL_32)
			-- Set the `panic_threshold' to `a_value'
			-- for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			value_in_range: a_value >= 0 and a_value <= {DMAC_REGISTER}.max_panic_threshold
		do
			if a_index = 0 then
				pwm_0.set_panic_threshold (a_value)
			else
				pwm_1.set_panic_threshold (a_value)
			end
		ensure
			value_was_set: panic_threshold (a_index) = a_value
		end

	set_dreq_threshold (a_index: INTEGER_32; a_value: NATURAL_32)
			-- Set the `dreq_threshold' to `a_value'
			-- for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			value_in_range: a_value >= 0 and a_value <= {DMAC_REGISTER}.max_dreq_threshold
		do
			if a_index = 0 then
				pwm_0.set_dreq_threshold (a_value)
			else
				pwm_1.set_dreq_threshold (a_value)
			end
		ensure
			value_was_set: dreq_threshold (a_index) = a_value
		end

	reset_panic_threshold (a_index: INTEGER_32)
			-- Set the DMA `panic_threshold' for DMA `a_index' to
			-- its default value
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.set_panic_threshold ({DMAC_REGISTER}.default_panic_threshold)
			else
				pwm_1.set_panic_threshold ({DMAC_REGISTER}.default_panic_threshold)
			end
		ensure
			threshold_was_reset: panic_threshold (a_index) = {DMAC_REGISTER}.default_panic_threshold
		end

	reset_dreq_threshold (a_index: INTEGER_32)
			-- Set the DMA `dreq_threshold' for DMA `a_index' to
			-- its default value
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.set_dreq_threshold ({DMAC_REGISTER}.default_dreq_threshold)
			else
				pwm_1.set_dreq_threshold ({DMAC_REGISTER}.default_dreq_threshold)
			end
		ensure
			threshold_was_reset: dreq_threshold (a_index) = {DMAC_REGISTER}.default_dreq_threshold
		end

feature -- Status report (pwm control)

	is_enabled (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' able to transmit data?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_enabled (a_channel)
			else
				Result := pwm_1.is_enabled (a_channel)
			end
		end

	is_serialiser_mode (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is the channel in serializer mode?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_serialiser_mode (a_channel)
			else
				Result := pwm_1.is_serialiser_mode (a_channel)
			end
		end

	is_ms_sub_mode (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- In PWM mode, is the channel sending serial data in M/S ratio
			-- where M is data sent, and S is the range.
			--              |<----- M ----->|
			--              ________________           _______
			--   ... ______/                \_________/       ...
			--             |<----------- S ------------------>|
			-- When false, the default, the channel sends data represented in periotic
			-- sequence of M cycles, output as "1" for N cycles and a "0" for M-N cyles
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_ms_sub_mode (a_channel)
			else
				Result := pwm_1.is_ms_sub_mode (a_channel)
			end
		end

	is_polarity_inverted (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is the final output polarity	inverted on `a_channel'?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_polarity_inverted (a_channel)
			else
				Result := pwm_1.is_polarity_inverted (a_channel)
			end
		end

	is_silenced_high (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is the output state high when no transmission
			-- is taking place?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_silenced_high (a_channel)
			else
				Result := pwm_1.is_silenced_high (a_channel)
			end
		end

	is_repeating_last_data (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is last data in the FIFO register transmitted reeatedly until
			-- the FIFO is not empty?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_repeating_last_data (a_channel)
			else
				Result := pwm_1.is_repeating_last_data (a_channel)
			end
		end

	is_fifo_enabled (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' in FIFO mode?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_fifo_enabled (a_channel)
			else
				Result := pwm_1.is_fifo_enabled (a_channel)
			end
		end

feature -- Status report (status register)

	is_transmitting (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' of PWM `a_index' transmitting?
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_transmitting (a_channel)
			else
				Result := pwm_1.is_transmitting (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies Result implies pwm_0.is_transmitting (a_channel)
			definition_2: a_index = 1 implies Result implies pwm_1.is_transmitting (a_channel)
		end

	is_bus_error (a_index: INTEGER_32): BOOLEAN
			-- Did a bus error occur while writing to registers via APB?
			-- Could be on either channel
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.is_bus_error
			else
				Result := pwm_1.is_bus_error
			end
		end

	is_gap_error (a_index: INTEGER_32; a_channel: INTEGER_32): BOOLEAN
			-- Has there been a gap between transmission of two consecutive data
			-- from FIFO?  This may happen when the FIFO becomes empty after the
			-- state machine has sent a word and is waiting for the next word.
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				Result := pwm_0.is_gap_error (a_channel)
			else
				Result := pwm_1.is_gap_error (a_channel)
			end
		ensure
		end

	is_fifo_read_empty_error (a_index: INTEGER_32): BOOLEAN
			-- Has there been a FIFO read-when-empty error on PWM `a_index'?
			-- "RERR1" bit.
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.is_fifo_read_empty_error
			else
				Result := pwm_1.is_fifo_read_empty_error
			end
		ensure
		end

	is_fifo_write_full_error(a_index: INTEGER_32): BOOLEAN
			-- Has there been a FIFO write-when-full error on PWM `a_index'?
			-- "WERR1" bit.
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.is_fifo_write_full_error
			else
				Result := pwm_1.is_fifo_write_full_error
			end
		ensure
		end

	is_empty (a_index: INTEGER_32): BOOLEAN
			-- Is the FIFO empty?
			-- "EMPT1" bit
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.is_empty
			else
				Result := pwm_1.is_empty
			end
		ensure
		end

	is_full (a_index: INTEGER_32): BOOLEAN
			-- Is the FIFO full?
			-- "FULL1" bit
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.is_full
			else
				Result := pwm_1.is_full
			end
		ensure
		end

feature -- Status report (DMA)

	is_dma_enabled (a_index: INTEGER_32): BOOLEAN
			-- Is direct-memory access enabled for PWM `a_index'?
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				Result := pwm_0.is_dma_enabled
			else
				Result := pwm_1.is_dma_enabled
			end
		ensure
		end

feature -- Basic operations (pwm control)

	enable_channel (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Enable `a_channel' for PWM `a_index' (i.e. let it transmit)
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.enable_channel (a_channel)
			else
				pwm_1.enable_channel (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_enabled (a_channel)
			definition_2: a_index = 1 implies pwm_1.is_enabled (a_channel)
		end

	disable_channel (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Disable `a_channel' for PWM `a_index' (i.e. don't let it transmit)
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.disable_channel (a_channel)
			else
				pwm_1.disable_channel (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_enabled (a_channel)
			definition_2: a_index = 1 implies not pwm_1.is_enabled (a_channel)
		end

	set_pmw_mode (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Set `a_channel' to PMW mode for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_pmw_mode (a_channel)
			else
				pwm_1.set_pmw_mode (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_serialiser_mode (a_channel)
			definition_2: a_index = 1 implies not pwm_1.is_serialiser_mode (a_channel)
		end

	set_serialiser_mode (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Set `a_channel' to Serializer mode for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_serialiser_mode (a_channel)
			else
				pwm_1.set_serialiser_mode (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_serialiser_mode (a_channel)
			definition_2: a_index = 1 implies pwm_1.is_serialiser_mode (a_channel)
		end

	set_pwm_sub_mode (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Change PWM sub-mode to transmit using N/M algorithm
			-- on `a_channel' for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_pwm_sub_mode (a_channel)
			else
				pwm_1.set_pwm_sub_mode (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_ms_sub_mode (a_channel)
			definition_2: a_index = 1 implies not pwm_1.is_ms_sub_mode (a_channel)
		end

	set_ms_sub_mode (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Change PMW sub-mode to transmit serially
			-- on `a_channel' for PWM `a_index'.
			--  See `is_ms_sub_mode'.
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_ms_sub_mode (a_channel)
			else
				pwm_1.set_ms_sub_mode (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_ms_sub_mode (a_channel)
			definition_2: a_index = 1 implies pwm_1.is_ms_sub_mode (a_channel)
		end

	invert_polarity (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Invert the final output polarity for `a_channel'
			-- of PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.invert_polarity (a_channel)
			else
				pwm_1.invert_polarity (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_polarity_inverted (a_channel)
			definition_2: a_index = 1 implies pwm_1.is_polarity_inverted (a_channel)
		end

	restore_polarity (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Restore the final output polarity for `a_channel'
			-- of PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.restore_polarity (a_channel)
			else
				pwm_1.restore_polarity (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_polarity_inverted (a_channel)
			definition_2: a_index = 1 implies not pwm_1.is_polarity_inverted (a_channel)
		end


	set_silenced_bit (a_index: INTEGER_32; a_channel: INTEGER_32; a_value: NATURAL_32;)
			-- Set the state (HIGH or LOW) of the silence bit on `a_channel' for
			-- PWM `a_index'.
			-- This bit defines the state of the output when no transmission takes place.
			-- It is padded between two consecutive transfers as well as tail of data
			-- in certain cases.
		require
			valid_index: a_index = 0 or a_index = 1
			valid_signal: a_value = 0 or a_value = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.set_silenced_bit (a_channel, a_value)
			else
				pwm_1.set_silenced_bit (a_channel, a_value)
			end
		ensure
			definition_0_0: (a_index = 0 and a_value = 0) implies not pwm_0.is_silenced_high (a_channel)
			definition_0_1: (a_index = 0 and a_value = 1) implies pwm_0.is_silenced_high (a_channel)
			definition_1_0: (a_index = 1 and a_value = 0) implies not pwm_1.is_silenced_high (a_channel)
			definition_1_1: (a_index = 1 and a_value = 1) implies pwm_1.is_silenced_high (a_channel)
		end

	repeat_last_data (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Make `a_channel' for PWM `a_index' transmit last data in
			-- FIFO repeatedly until FIFO is not empty
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.repeat_last_data (a_channel)
			else
				pwm_1.repeat_last_data (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_repeating_last_data (a_channel)
			definition_2: a_index = 1 implies pwm_1.is_repeating_last_data (a_channel)
		end

	interupt_last_data(a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Make `a_channel' for PWM `a_index' interupt transmission
			-- when FIFO is empty
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.interupt_last_data (a_channel)
			else
				pwm_1.interupt_last_data (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_repeating_last_data (a_channel)
			definition_2: a_index = 1 implies not pwm_1.is_repeating_last_data (a_channel)
		end

	use_fifo (a_index: INTEGER_32; a_channel: INTEGER_32)
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.use_fifo (a_channel)
			else
				pwm_1.use_fifo (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_fifo_enabled (a_channel)
			definition_2: a_index = 1 implies pwm_1.is_fifo_enabled (a_channel)
		end

	clear_fifo (a_index: INTEGER_32)
			-- Clear the FIFO register (applies to both channels)
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.clear_fifo
			else
				pwm_1.clear_fifo
			end
		end

feature -- Basic operations (pwm status)

	clear_bus_error (a_index: INTEGER)
			-- Clear a bus error for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.clear_bus_error
			else
				pwm_1.clear_bus_error
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_bus_error
			definition_2: a_index = 1 implies not pwm_1.is_bus_error
		end

	clear_gap_error (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Clear a gap error on `a_channel' for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_index = 0 then
				pwm_0.clear_gap_error (a_channel)
			else
				pwm_1.clear_gap_error (a_channel)
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_gap_error (a_channel)
			definition_2: a_index = 1 implies not pwm_1.is_gap_error (a_channel)
		end

	clear_fifo_read_emtpy_error (a_index: INTEGER_32)
			-- Reset the clear-when-empty error bit, "RERR1",
			-- for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.clear_fifo_read_emtpy_error
			else
				pwm_1.clear_fifo_read_emtpy_error
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_fifo_read_empty_error
			definition_2: a_index = 1 implies not pwm_1.is_fifo_read_empty_error
		end

	clear_fifo_write_full_error (a_index: INTEGER_32)
			-- Reset the write-when-full error bit, "WERR1",
			-- for PWM_`a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.clear_fifo_write_full_error
			else
				pwm_1.clear_fifo_write_full_error
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_fifo_write_full_error
			definition_2: a_index = 1 implies not pwm_1.is_fifo_write_full_error
		end

feature -- Basic operations (DMA)

	enable_dma (a_index: INTEGER_32)
			-- Enable (i.e. start) DMA for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.enable_dma
			else
				pwm_1.enable_dma
			end
		ensure
			definition_1: a_index = 0 implies pwm_0.is_dma_enabled
			definition_2: a_index = 1 implies pwm_1.is_dma_enabled
		end

	disable_dma (a_index: INTEGER_32)
			-- Disable (i.e. stop) DMA for PWM `a_index'
		require
			valid_index: a_index = 0 or a_index = 1
		do
			if a_index = 0 then
				pwm_0.disable_dma
			else
				pwm_1.disable_dma
			end
		ensure
			definition_1: a_index = 0 implies not pwm_0.is_dma_enabled
			definition_2: a_index = 1 implies not pwm_1.is_dma_enabled
		end

	show (a_index: INTEGER_32; a_channel: INTEGER_32)
			-- Display information about this modulator
		require
			valid_index: a_index = 0 or a_index = 1
			valid_channel: a_channel = 1 or a_channel = 2
		local
			m: PULSE_WIDTH_MODULATOR
		do
			print ("{PWM}.show:  ")
			if a_index = 0 then
				m := pwm_0
				print ("PWM 0")
			else
				m := pwm_1
				print ("PWM 1")
			end
			print ("%N")
				-- Display the attributes
			print ("    range (" + a_channel.out + ") = " + m.range (a_channel).out + "%N")
			print ("    data (" + a_channel.out + ") =  " + m.data (a_channel).out + "%N")
			print ("    panic_threshold =  " + m.panic_threshold.out + "%N")
			print ("    dreq_threhold =  " + m.dreq_threshold.out + "%N")
			print ("    is_enabled (" + a_channel.out + ") =  " + m.is_enabled (a_channel).out + "%N")
			print ("    is_in_serialiser_mode (" + a_channel.out + ") =  " + m.is_serialiser_mode (a_channel).out + "%N")
			print ("    is_ms_sub_mode (" + a_channel.out + ") =  " + m.is_ms_sub_mode (a_channel).out + "%N")
			print ("    is_polarity_inverted (" + a_channel.out + ") =  " + m.is_polarity_inverted (a_channel).out + "%N")
			print ("    is_silenced_high (" + a_channel.out + ") =  " + m.is_silenced_high (a_channel).out + "%N")
			print ("    is_repeating_last_data (" + a_channel.out + ") =  " + m.is_repeating_last_data (a_channel).out + "%N")
			print ("    is_is_fifo_nabled (" + a_channel.out + ") =  " + m.is_fifo_enabled (a_channel).out + "%N")
			print ("    is_transmitting (" + a_channel.out + ") =  " + m.is_transmitting (a_channel).out + "%N")
			print ("    is_bus_error (" + a_channel.out + ") =  " + m.is_bus_error.out + "%N")
			print ("    is_gap_error (" + a_channel.out + ") =  " + m.is_gap_error (a_channel).out + "%N")
			print ("    is_fifo_read_empty_error (" + a_channel.out + ") =  " + m.is_fifo_read_empty_error.out + "%N")
			print ("    is_fifo_write_full_error (" + a_channel.out + ") =  " + m.is_fifo_write_full_error.out + "%N")
			print ("    is_empty (" + a_channel.out + ") =  " + m.is_empty.out + "%N")
			print ("    is_full (" + a_channel.out + ") =  " + m.is_full.out + "%N")
		end

feature {NONE} -- Implementation

	pwm_0: PULSE_WIDTH_MODULATOR
			-- One of two in a Pi

	pwm_1: PULSE_WIDTH_MODULATOR
			-- One of two in a Pi

end
