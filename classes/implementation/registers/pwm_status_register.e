note
	description: "[
		{REGISTER} for reporting full, empty, error, ect state of the
		rugisters used by PWM in the {PI_CONTROLLER}.
		See BCM2711 ARM Peripherals.pdf, page 161.
		]"
	author: "Jimmy J. Johnson"
	date: "10/22/20"



class
	PWM_STATUS_REGISTER

inherit

	REGISTER

create
	make

feature -- Status report

	is_transmitting (a_channel: INTEGER_32): BOOLEAN
			-- Is a_channel transmitting?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_state_bit) = 1
			else
				Result := bit_value (channel_2_state_bit) = 1
			end
		ensure
			definition_1: (Result and a_channel = 1) implies bit_value (channel_1_state_bit) = 1
			definition_2: (Result and a_channel = 2) implies bit_value (channel_2_state_bit) = 1
		end

	is_bus_error: BOOLEAN
			-- Did a bus error occur while writing to registers via APB?
		do
			Result := bit_value (bus_error_bit) = 1
		ensure
			definition: Result implies bit_value (bus_error_bit) = 1
		end

	is_gap_error (a_channel: INTEGER_32): BOOLEAN
			-- Has there been a gap between transmission of two consecutive data
			-- from FIFO?  This may happen when the FIFO becomes empty after the
			-- state machine has sent a word and is waiting for the next word.
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_gap_occurred_bit) = 1
			else
				Result := bit_value (channel_1_gap_occurred_bit) = 1
			end
		ensure
			definition_1: (Result and a_channel = 1) implies bit_value (channel_1_gap_occurred_bit) = 1
			definition_1: (Result and a_channel = 2) implies bit_value (channel_2_gap_occurred_bit) = 1
		end

	is_fifo_read_empty_error: BOOLEAN
			-- Has there been a FIFO read-when-empty error?
			-- "RERR1" bit.
		do
			Result := bit_value (fifo_read_error_bit) = 1
		ensure
			definition: Result implies bit_value (fifo_read_error_bit) = 1
		end

	is_fifo_write_full_error: BOOLEAN
			-- Has there been a FIFO write-when-full error?
			-- "wERR1" bit.
		do
			Result := bit_value (fifo_write_error_bit) = 1
		ensure
			definition: Result implies bit_value (fifo_write_error_bit) = 1
		end

	is_empty: BOOLEAN
			-- Is the FIFO empty?
			-- "EMPT1" bit
		do
			Result := bit_value (fifo_empty_bit) = 1
		ensure
			definition: Result implies bit_value (fifo_empty_bit) = 1
		end

	is_full: BOOLEAN
			-- Is the FIFO full?
			-- "FULL1" bit
		do
			Result := bit_value (fifo_full_bit) = 1
		ensure
			definition: Result implies bit_value (fifo_full_bit) = 1
		end

feature -- Basic operations

	clear_bus_error
			-- Clear a bus error
		do
			set_bit (bus_error_bit)
		ensure
			error_was_cleared: not is_bus_error
		end

	clear_gap_error (a_channel: INTEGER_32)
			-- Clear a gap error on `a_channel'
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				set_bit (channel_1_gap_occurred_bit)
			else
				set_bit (channel_2_gap_occurred_bit)
			end
		ensure
			definition: not is_gap_error (a_channel)
		end

	clear_fifo_read_emtpy_error
			-- Reset the clear-when-empty error bit, "RERR1"
		do
			set_bit (fifo_read_error_bit)
		ensure
			definition: not is_fifo_read_empty_error
		end

	clear_fifo_write_full_error
			-- Reset the write-when-full error bit, "WERR1"
		do
			set_bit (fifo_write_error_bit)
		ensure
			definition: not is_fifo_write_full_error
		end

feature {NONE} -- Implementation

	channel_2_state_bit: INTEGER_32 = 10
			-- "STA2"
			-- Indicates current state of channel, high when channel is transmitting data.
			-- Useful for debugging	

	channel_1_state_bit: INTEGER_32 = 9
			-- "STA1"
			-- See `channel_2_state_bit'

	bus_error_bit: INTEGER_32 = 8
			-- "BERR"
			-- Set to high when an error has occurred while writing to registers via APB.
			-- This may happen if the bus tries to write successively to same set of registers
			-- faster than the synchroniser block can cope with. Multiple switching may occur
			-- and contaminate the data during synchronisation.
			-- Software should clear this bit by writing 1.

	channel_2_gap_occurred_bit: INTEGER_32 = 5
			-- "GAPO2"
			-- Indicates that there has been a gap between transmission of two
			-- consecutive data from FIFO. This may happen when the FIFO becomes
			-- empty after the state machine has sent a word and is waiting for
			-- the next word. If control bit "RPTLi" (see {PWM_CONTROL_REGISTER} for
			-- the `channel_1_repeat_bit') is set to high this event will not occur.
			-- Software must clear this bit by writing 1.

	channel_1_gap_occurred_bit: INTEGER_32 = 4
			-- "GAPO1"
			-- See `channel_2_gap_occurred_bit'

	fifo_read_error_bit: INTEGER_32 = 3
			-- "RERR1'
			-- Is set to high when a read-when-empty error occurs. Software must
			-- clear this bit by writing 1.

	fifo_write_error_bit: INTEGER_32 = 2
			-- "WERR1"
			-- Is set to high when a write-when-full error occurs. Software must
			-- clear this bit by writing 1.

	fifo_empty_bit: INTEGER_32 = 1
			-- "EMPT1"
			-- High indicates FIFO is empty

	fifo_full_bit: INTEGER_32 = 0
			-- "FULL1"
			-- High indicates the FIFO is full

end

