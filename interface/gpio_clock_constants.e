
note
	description: "[
		Constants used by a {GPIO_CONTROL_REGISTER} to control the
		gpio clock.
		]"
	author: "Jimmy J Johnson"
	date: "10/18/20"

class
	GPIO_CLOCK_CONSTANTS

feature -- Clock numbers

	clock_0_index: INTEGER_32 = 0
	clock_1_index: INTEGER_32 = 1
	clock_2_index: INTEGER_32 = 2
	clock_pcm_index: INTEGER_32 = 3
	clock_pwm_index: INTEGER_32 = 4

feature -- Frequencies

	minimum_allowed_frequency: NATURAL_32 = 4689
			-- Do not go below this frequency in Hz

	maximum_allowed_frequency: NATURAL_32 = 25_000_000
			-- Do not exceed this frequency in Hz

	oscillator_frequency: NATURAL_32 = 19_200_000
			-- Frequency in Hz provided by the on-board oscillator on Pi4

	plla_frequency: NATURAL_32 = 0
			-- Frequency in Hz provided by PLLA on Pi4
			-- Fix me!   What is it really?

	pllc_frequency: NATURAL_32 = 1_000_000
			-- Frequency in Hz provided by PLLC on Pi4

	plld_frequency: NATURAL_32 = 500_000
			-- Frequency in Hz provided by PLLD on Pi4

	hdmi_frequency: NATURAL_32 = 216_000
			-- Frequency in Hz provided by HDMI on Pi4

feature -- GPIO MASH control

	integer_division: NATURAL_32 = 0x00000000
			-- Used to set GPIO clock MASH filtering to integer division

	stage_1: NATURAL_32 = 0x00000001
			-- Used to set GPIO clock MASH filtering to 1-stage MASH

	stage_2: NATURAL_32 = 0x00000002
			-- Used to set GPIO clock MASH filtering to 2-stage MASH

	stage_3: NATURAL_32 = 0x00000003
			-- Used to set GPIO clock MASH filtering to 3-stage MASH

feature -- GPIO clock sources

	ground_0: NATURAL_32 = 0x00000000
			-- 0 Mhz

	oscillator: NATURAL_32 = 0x00000001
			-- Use the on-board crystal resonator for 19.2 MHz signal

	testdebug_0: NATURAL_32 = 0x00000002
			-- 0 Mhz

	testdebug_1: NATURAL_32 = 0x00000003
			-- 0 Mhz

	plla: NATURAL_32 = 0x00000004
			-- `oscillator' routed through a phased-locked loop
			-- * 100 for a 1920 MHz signal (see https://www.tablix.org/~avian/
			-- blog/archives/2018/02/notes_on_the_general_purpose_clock_on_bcm2835/
			-- or 0 MHz according to https://pinout.xyz/pinout/gpclk#
			-- Which one?  I don't know yet.

	pllc: NATURAL_32 = 0x00000005
			-- `oscillator' routed through a phased-locked loop
			-- 1000 MHz according to https://pinout.xyz/pinout/gpclk#
			-- May vary if the Raspberry Pi is overclocked

	plld: NATURAL_32 = 0x00000006
			-- `oscillator' routed through a phased-locked loop
			-- 500 MHz according to https://pinout.xyz/pinout/gpclk#

	hdmi: NATURAL_32 = 0x00000007
			-- `oscillator' routed through a phased-locked loop
			-- 216 MHz according to https://pinout.xyz/pinout/gpclk#
			-- May vary if a monitor is attached to HDMI

	ground_8: NATURAL_32 = 0x00000008
			-- 0 Mhz

	ground_9: NATURAL_32 = 0x00000009
			-- 0 Mhz

	ground_10: NATURAL_32 = 0x0000000A
			-- 0 Mhz

	ground_11: NATURAL_32 = 0x0000000B
			-- 0 Mhz

	ground_12: NATURAL_32 = 0x0000000C
			-- 0 Mhz

	ground_13: NATURAL_32 = 0x0000000D
			-- 0 Mhz

	ground_14: NATURAL_32 = 0x0000000E
			-- 0 Mhz

	ground_15: NATURAL_32 = 0x0000000F
			-- 0 Mhz

feature -- Tables for lookup

	source_frequency_table: HASH_TABLE [NATURAL_32, NATURAL_32]
			-- To get the frequency of a particular clock source
			-- [frequency,  source] (i.e. frequency indexed by source)
		once
			create Result.make (10)
			Result.extend (0, ground_0)
			Result.extend (oscillator_frequency, oscillator)
			Result.extend (0, testdebug_0)
			Result.extend (0, testdebug_1)
			Result.extend (plla_frequency, plla)
			Result.extend (pllc_frequency, pllc)
			Result.extend (plld_frequency, plld)
			Result.extend (hdmi_frequency, hdmi)
		end

	mash_minimum_divisor_table: HASH_TABLE [NATURAL_32, NATURAL_32]
			-- The minimum allowed divider (i.e. "DIVI") index by mash filter
		once
			create Result.make (10)
			Result.extend (1, integer_division)
			Result.extend (2, stage_1)
			Result.extend (3, stage_2)
			Result.extend (5, stage_3)
		end

feature -- Query

	is_valid_mash (a_mash: NATURAL_32): BOOLEAN
			-- Is `a_mash' one of the GPIO MASH Control constants?
		do
			Result := a_mash = integer_division or
						 a_mash = stage_1 or
						 a_mash = stage_2 or
						 a_mash = stage_3
		end

	is_valid_clock_source (a_source: NATURAL_32): BOOLEAN
			-- Is `a_source' one of the GPIO clck sources?
		do
			Result := a_source >= ground_0 and a_source <= ground_15
		end

	is_valid_clock_index (a_index: INTEGER_32): BOOLEAN
			-- Is `a_index' one of the "Clock numbers"
		do
			Result := a_index = clock_0_index or
					a_index = clock_1_index or
					a_index = clock_2_index or
					a_index = clock_pcm_index or
					a_index = clock_pwm_index
		end

end
