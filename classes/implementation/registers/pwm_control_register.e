note
	description: "[
		{REGISTER} for controlling each PWM channel in the {PI_CONTROLLER}.
		See BCM2711 ARM Peripherals.pdf, page 159-160.
		]"
	author: "Jimmy J. Johnso"
	date: "10/21/20"

class
	PWM_CONTROL_REGISTER

inherit

	REGISTER

create
	make

feature -- Status report

	is_enabled (a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' able to transmit data?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_enable_bit) = 1
			else
				Result := bit_value (channel_2_enable_bit) = 1
			end
		end

	is_serialiser_mode (a_channel: INTEGER_32): BOOLEAN
			-- Is the channel in serializer mode?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_mode_bit) = 1
			else
				Result := bit_value (channel_2_mode_bit) = 1
			end
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
			if a_channel = 1 then
				Result := bit_value (channel_1_ms_enable_bit) = 1
			else
				Result := bit_value (channel_2_ms_enable_bit) = 1
			end
		end

	is_polarity_inverted (a_channel: INTEGER_32): BOOLEAN
			-- Is the final output polarity	inverted on `a_channel'?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_polarity_bit) = 1
			else
				Result := bit_value (channel_2_polarity_bit) = 1
			end
		end

	is_silenced_high (a_channel: INTEGER_32): BOOLEAN
			-- Is the output state high when no transmission
			-- is taking place?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
		  		Result := bit_value (channel_1_silence_bit) = 1
			else
				Result := bit_value (channel_2_silence_bit) = 1
			end
		end

	is_repeating_last_data (a_channel: INTEGER_32): BOOLEAN
			-- Is last data in the FIFO register transmitted reeatedly until
			-- the FIFO is not empty?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_repeat_bit) = 1
			else
				Result := bit_value (channel_2_repeat_bit) = 1
			end
		end

	is_fifo_enabled (a_channel: INTEGER_32): BOOLEAN
			-- Is `a_channel' in FIFO mode?
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				Result := bit_value (channel_1_use_fifo_bit) = 1
			else
				Result := bit_value (channel_2_use_fifo_bit) = 1
			end
		end

feature -- Basic operations

	enable_channel (a_channel: INTEGER_32)
			-- Enable `a_channel' (i.e. let it transmit)
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				set_bit (channel_1_enable_bit)
			else
				set_bit (channel_2_enable_bit)
			end
		ensure
			channel_enabled: is_enabled (a_channel)
		end

	disable_channel (a_channel: INTEGER_32)
			-- Disable `a_channel' (i.e. don't let it transmit)
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				clear_bit (channel_1_enable_bit)
			else
				clear_bit (channel_2_enable_bit)
			end
		ensure
			channel_disable: not is_enabled (a_channel)
		end

	set_pmw_mode (a_channel: INTEGER_32)
			-- Set `a_channel' to PMW mode
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				clear_bit (channel_1_mode_bit)
			else
				clear_bit (channel_2_mode_bit)
			end
		ensure
			mode_set_for_channel: not is_serialiser_mode (a_channel)
		end

	set_serialiser_mode (a_channel: INTEGER_32)
			-- Set `a_channel' to serializer mode
		do
			if a_channel = 1 then
				set_bit (channel_1_mode_bit)
			else
				set_bit (channel_2_mode_bit)
			end
		ensure
			mode_set_for_channel: is_serialiser_mode (a_channel)
		end

	set_pwm_sub_mode (a_channel: INTEGER_32)
			-- Change PWM_sub-mode to transmit using N/M algorithm
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				clear_bit (channel_1_ms_enable_bit)
			else
				clear_bit (channel_2_ms_enable_bit)
			end
		ensure
			pwm_sub_mode_for_channel: not is_ms_sub_mode (a_channel)
		end

	set_ms_sub_mode (a_channel: INTEGER_32)
			-- Change PMW sub-mode to transmit serially.  See `is_ms_sub_mode'.
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				set_bit (channel_1_ms_enable_bit)
			else
				set_bit (channel_2_ms_enable_bit)
			end
		ensure
			is_ms_sub_mode: is_ms_sub_mode (a_channel)
		end

	invert_polarity (a_channel: INTEGER_32)
			-- Invert the final output polarity
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				set_bit (channel_1_polarity_bit)
			else
				set_bit (channel_2_polarity_bit)
			end
		ensure
			polarity_is_inverted: is_polarity_inverted (a_channel)
		end

	restore_polarity (a_channel: INTEGER_32)
			-- Restore final output polarity to default
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				clear_bit (channel_1_polarity_bit)
			else
				clear_bit (channel_1_polarity_bit)
			end
		ensure
			not_polarity_inverted: not is_polarity_inverted (a_channel)
		end

	set_silenced_bit (a_channel: INTEGER_32; a_value: NATURAL_32)
			-- Set the state (HIGH or LOW) of the silence bit on `a_channel'.
			-- This bit defines the state of the output when no transmission takes place.
			-- It is padded between two consecutive transfers as well as tail of data
			-- in certain cases.
		require
			valid_channel: a_channel = 1 or a_channel = 2
			valid_signal: a_value = 1 or a_value = 0
		do
			if a_channel = 1 then
				if a_value = 1 then
					set_bit (channel_1_silence_bit)
				else
					clear_bit (channel_1_silence_bit)
				end
			else
				if a_value = 1 then
					set_bit (channel_2_silence_bit)
				else
					clear_bit (channel_2_silence_bit)
				end
			end
		ensure
			set_high_implication: a_value = 1 implies is_silenced_high (a_channel)
			set_low_implication: a_value = 0 implies not is_silenced_high (a_channel)
		end

	repeat_last_data	 (a_channel: INTEGER_32)
			-- Make `a_channel' transmit last data in FIFO repeatedly until FIFO
			-- is not empty
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				clear_bit (channel_1_repeat_bit)
			else
				clear_bit (channel_2_repeat_bit)
			end
		ensure
			is_repeating_last_data: is_repeating_last_data (a_channel)
		end

	interupt_last_data (a_channel: INTEGER_32)
			-- Make `a_channel' interupt transmission when FIFO is empty
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				clear_bit (channel_1_repeat_bit)
			else
				clear_bit (channel_2_repeat_bit)
			end
		ensure
			not_repeating_data: not is_repeating_last_data (a_channel)
		end

	use_fifo (a_channel: INTEGER_32)
		require
			valid_channel: a_channel = 1 or a_channel = 2
		do
			if a_channel = 1 then
				set_bit (channel_1_use_fifo_bit)
			else
				set_bit (channel_2_use_fifo_bit)
			end
		ensure
			fifo_set_for_channel: is_fifo_enabled (a_channel)
		end

	clear_fifo
			-- Clear the FIFO register
		do
			set_bit (clear_fifo_bit)
		end

feature {NONE} -- Implementation

	channel_2_ms_enable_bit: INTEGER_32 = 15
			-- Used to select PWM sub-mode, PWM algorithm or M/S transmission.
			--  No effect if `channel_2_mode_bit' is "1"
			-- "MSEN2"

	channel_2_use_fifo_bit: INTEGER_32 = 13
			-- Enable/disable FIFO transfer.  When high use FIFO, when
			-- LOW data use data register
			-- "USEF2"

	channel_2_polarity_bit: INTEGER_32 = 12
			-- Set high to invert the final output polarity of channel 2
			-- "POLA2"

	channel_2_silence_bit: INTEGER_32 = 11
			-- Defines state of output when no transmission takes place on channel 2
			-- "SBIT2"

	channel_2_repeat_bit: INTEGER_32 = 10
			-- If "1", channel 2 repeatedly transmits last data in FIFO when
			-- channel 2 is empty
			-- "RPTL2"

	channel_2_mode_bit: INTEGER_32 = 9
			-- Sets channel 2 to PWM mode or Serialiser mode
			-- "MODE2"

	channel_2_enable_bit: INTEGER_32 = 8
			-- Enable/disable channel 2
			-- "PWEN2"

	clear_fifo_bit: INTEGER_32 = 6
			-- Used to clear the FIFO.  One shot operations, always returns "0".
			-- "CLRF"

	channel_1_ms_enable_bit: INTEGER_32 = 7
			-- Used to select PWM sub-mode, PWM algorithm or M/S transmission.
			--  No effect if `channel_1_mode_bit' is "1"
			-- "MSEN1"

	channel_1_use_fifo_bit: INTEGER_32 = 5
			-- Enable/disable FIFO transfer.  When high use FIFO, when
			-- LOW data use data register
			-- "USEF1"

	channel_1_polarity_bit: INTEGER_32 = 4
			-- Set high to invert the final output polarity of channel 1
			-- "POLA1"

	channel_1_silence_bit: INTEGER_32 = 3
			-- Defines state of output when no transmission takes place on channel 1
			-- "SBIT1"

	channel_1_repeat_bit: INTEGER_32 = 2
			-- If "1", channel 1 repeatedly transmits last data in FIFO when
			-- channel 1 is empty
			-- "RPTL1"

	channel_1_mode_bit: INTEGER_32 = 1
			-- Sets channel 2 to PWM mode or Serialiser mode
			-- "MODE1"

	channel_1_enable_bit: INTEGER_32 = 0
			-- Enable/disable channel 2
			-- "PWEN1"

invariant


end
