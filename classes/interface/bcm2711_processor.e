once class
	BCM2711_PROCESSOR

inherit

	RPI_PROCESSOR
		redefine
			default_create,
			expected_pin_count
--			header
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Redefined here because creation features of once classes must
			-- be declared in the class.
		once ("PROCESS")
			Precursor
		end

	Expected_pin_count: INTEGER
			-- The number of pins available on this RPi.
			-- Used during creation features.
		do
			Result := 27
		end

	initialize_pin_functions
			-- Add default (input and output) and alternate functions
			-- to each pin in Current
		do
				-- Pin 0
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.sda0, {GPIO_PIN_CONSTANTS}.alt0)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.sa5, {GPIO_PIN_CONSTANTS}.alt1)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.pclk, {GPIO_PIN_CONSTANTS}.alt2)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.spi3_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.txd2, {GPIO_PIN_CONSTANTS}.alt4)
			pin (0).extend_function ({GPIO_PIN_CONSTANTS}.sda6, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 1
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.scl0, {GPIO_PIN_CONSTANTS}.alt0)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.sa4, {GPIO_PIN_CONSTANTS}.alt1)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.de, {GPIO_PIN_CONSTANTS}.alt2)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.spi3_miso, {GPIO_PIN_CONSTANTS}.alt3)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.rxd2, {GPIO_PIN_CONSTANTS}.alt4)
			pin (1).extend_function ({GPIO_PIN_CONSTANTS}.scl6, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 2
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.sda1, {GPIO_PIN_CONSTANTS}.alt0)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.sa3, {GPIO_PIN_CONSTANTS}.alt1)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.lcd_vsync, {GPIO_PIN_CONSTANTS}.alt2)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.spi3_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.cts2, {GPIO_PIN_CONSTANTS}.alt4)
			pin (2).extend_function ({GPIO_PIN_CONSTANTS}.sda3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 3
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.scl1, {GPIO_PIN_CONSTANTS}.alt0)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.sa2, {GPIO_PIN_CONSTANTS}.alt1)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.lcd_hsync, {GPIO_PIN_CONSTANTS}.alt2)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.spi3_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.rts2, {GPIO_PIN_CONSTANTS}.alt4)
			pin (3).extend_function ({GPIO_PIN_CONSTANTS}.scl3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 4
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.gpclk0, {GPIO_PIN_CONSTANTS}.alt0)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.sa1, {GPIO_PIN_CONSTANTS}.alt1)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d0, {GPIO_PIN_CONSTANTS}.alt2)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.spi4_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.txd3, {GPIO_PIN_CONSTANTS}.alt4)
			pin (4).extend_function ({GPIO_PIN_CONSTANTS}.sda3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 5
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.gpclk1, {GPIO_PIN_CONSTANTS}.alt0)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.sa0, {GPIO_PIN_CONSTANTS}.alt1)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d1, {GPIO_PIN_CONSTANTS}.alt2)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.spi4_miso, {GPIO_PIN_CONSTANTS}.alt3)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.rxd3, {GPIO_PIN_CONSTANTS}.alt4)
			pin (5).extend_function ({GPIO_PIN_CONSTANTS}.scl3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 6
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.gpclk2, {GPIO_PIN_CONSTANTS}.alt0)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.soe_n_se, {GPIO_PIN_CONSTANTS}.alt1)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d2, {GPIO_PIN_CONSTANTS}.alt2)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.spi4_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.cts3, {GPIO_PIN_CONSTANTS}.alt4)
			pin (6).extend_function ({GPIO_PIN_CONSTANTS}.sda4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 7
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.spi0_ce1_n, {GPIO_PIN_CONSTANTS}.alt0)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.swe_n_srw_n, {GPIO_PIN_CONSTANTS}.alt1)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d3, {GPIO_PIN_CONSTANTS}.alt2)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.spi4_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.rts3, {GPIO_PIN_CONSTANTS}.alt4)
			pin (7).extend_function ({GPIO_PIN_CONSTANTS}.scl4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 8
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.spi0_ce0_n, {GPIO_PIN_CONSTANTS}.alt0)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.sd0, {GPIO_PIN_CONSTANTS}.alt1)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d4, {GPIO_PIN_CONSTANTS}.alt2)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.bscsl_ce_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.txd4, {GPIO_PIN_CONSTANTS}.alt4)
			pin (8).extend_function ({GPIO_PIN_CONSTANTS}.sda4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 9
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.spi0_miso, {GPIO_PIN_CONSTANTS}.alt0)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.sd1, {GPIO_PIN_CONSTANTS}.alt1)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d5, {GPIO_PIN_CONSTANTS}.alt2)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.bscsl_miso, {GPIO_PIN_CONSTANTS}.alt3)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.rxd4, {GPIO_PIN_CONSTANTS}.alt4)
			pin (9).extend_function ({GPIO_PIN_CONSTANTS}.scl4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 10
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.spi0_mosi, {GPIO_PIN_CONSTANTS}.alt0)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.sd2, {GPIO_PIN_CONSTANTS}.alt1)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d6, {GPIO_PIN_CONSTANTS}.alt2)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.bscsl_sda_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.cts4, {GPIO_PIN_CONSTANTS}.alt4)
			pin (10).extend_function ({GPIO_PIN_CONSTANTS}.sda5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 11
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.spi0_sclk, {GPIO_PIN_CONSTANTS}.alt0)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.sd3, {GPIO_PIN_CONSTANTS}.alt1)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d7, {GPIO_PIN_CONSTANTS}.alt2)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.bscsl_scl_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.rts4, {GPIO_PIN_CONSTANTS}.alt4)
			pin (11).extend_function ({GPIO_PIN_CONSTANTS}.scl5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 12
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.pwm0_0, {GPIO_PIN_CONSTANTS}.alt0)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.sd4, {GPIO_PIN_CONSTANTS}.alt1)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d8, {GPIO_PIN_CONSTANTS}.alt2)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.spi5_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.txd5, {GPIO_PIN_CONSTANTS}.alt4)
			pin (12).extend_function ({GPIO_PIN_CONSTANTS}.sda5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 13
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.pwm0_1, {GPIO_PIN_CONSTANTS}.alt0)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.sd5, {GPIO_PIN_CONSTANTS}.alt1)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d9, {GPIO_PIN_CONSTANTS}.alt2)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.spi5_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.rxd5, {GPIO_PIN_CONSTANTS}.alt4)
			pin (13).extend_function ({GPIO_PIN_CONSTANTS}.scl5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 14
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.txd0, {GPIO_PIN_CONSTANTS}.alt0)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.sd6, {GPIO_PIN_CONSTANTS}.alt1)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d10, {GPIO_PIN_CONSTANTS}.alt2)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.spi5_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.cts5, {GPIO_PIN_CONSTANTS}.alt4)
			pin (14).extend_function ({GPIO_PIN_CONSTANTS}.txd1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 15
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.rxd0, {GPIO_PIN_CONSTANTS}.alt0)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.sd7, {GPIO_PIN_CONSTANTS}.alt1)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d11, {GPIO_PIN_CONSTANTS}.alt2)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.spi5_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.rts5, {GPIO_PIN_CONSTANTS}.alt4)
			pin (15).extend_function ({GPIO_PIN_CONSTANTS}.rxd1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 16
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.sd8, {GPIO_PIN_CONSTANTS}.alt1)
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d12, {GPIO_PIN_CONSTANTS}.alt2)
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.cts0, {GPIO_PIN_CONSTANTS}.alt3)
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.spi1_ce2_n, {GPIO_PIN_CONSTANTS}.alt4)
			pin (16).extend_function ({GPIO_PIN_CONSTANTS}.cts1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 17
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.sd9, {GPIO_PIN_CONSTANTS}.alt1)
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d13, {GPIO_PIN_CONSTANTS}.alt2)
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.rts0, {GPIO_PIN_CONSTANTS}.alt3)
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.spi1_ce1_n, {GPIO_PIN_CONSTANTS}.alt4)
			pin (17).extend_function ({GPIO_PIN_CONSTANTS}.rts1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 18
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.pcm_clk, {GPIO_PIN_CONSTANTS}.alt0)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.sd10, {GPIO_PIN_CONSTANTS}.alt1)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.dpi_d14, {GPIO_PIN_CONSTANTS}.alt2)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.spi6_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.spi1_ce0_n, {GPIO_PIN_CONSTANTS}.alt4)
			pin (18).extend_function ({GPIO_PIN_CONSTANTS}.pwm0_0, {GPIO_PIN_CONSTANTS}.alt5)
		end

feature -- Access

-- fix me?  Do I need the other pins? The ones not on header?	



feature {NONE} -- Implementation

	peripheral_base_address: NATURAL_32 = 0xFE000000
			-- Physical address of the first peripheral register
			-- Specific for this model.
			-- Not sure where this number originates, but it is in WiringPi
			-- and other software, and it seems to work.

	gpio_offset: NATURAL_32 = 0x00200000
			-- Offset from `peripheral_base_address' to GPIO registers.
			-- BCM2711 ARM Peripherals, page

	gpio_clocks_offset: NATURAL_32 = 0x00101000
			-- Offset from `peripheral_base_address' to GPIO clock registers.
			-- BCM2711 ARM Peripherals, page

	pwm_offset: NATURAL_32 = 0x0020C000
			-- Offsett from `peripheral_ase_address' to the PWM registers.
			-- BCM2711 ARM Peripherals, page

--	header: PI_HEADER_MAP_40_PIN
			-- Mapping from a {GPIO_PIN} (i.e. BCM or Broadcom
			-- numbering scheme) to the physical pin number.

--	gpio_base_address: NATURAL_32 = 0x7E21_5000
			-- GPIO register base address per BCM2711 ARM Peripherals
			-- Manual, page 83.  Seems to be wrong; see `gpio_offset'.

end
