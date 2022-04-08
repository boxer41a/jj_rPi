class
	PI_4_CONTROLLER

inherit

	PI_CONTROLLER
		redefine
			create_interface_objects,
			initialize_pin_functions,
			pin_last
--			header
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create an instance
		do
			Precursor {PI_CONTROLLER}
				-- Create the additional pins
			create pin_22.make (22)
			create pin_23.make (23)
			create pin_24.make (24)
			create pin_25.make (25)
			create pin_26.make (26)
			create pin_27.make (27)
		end

	initialize_pin_functions
			-- Add default (input and output) and alternate functions
			-- to each pin in Current
		do
				-- Pin 0
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.sda0, {GPIO_PIN_CONSTANTS}.alt0)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.sa5, {GPIO_PIN_CONSTANTS}.alt1)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.pclk, {GPIO_PIN_CONSTANTS}.alt2)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.spi3_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.txd2, {GPIO_PIN_CONSTANTS}.alt4)
			pin_0.extend_function ({GPIO_PIN_CONSTANTS}.sda6, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 1
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.scl0, {GPIO_PIN_CONSTANTS}.alt0)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.sa4, {GPIO_PIN_CONSTANTS}.alt1)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.de, {GPIO_PIN_CONSTANTS}.alt2)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.spi3_miso, {GPIO_PIN_CONSTANTS}.alt3)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.rxd2, {GPIO_PIN_CONSTANTS}.alt4)
			pin_1.extend_function ({GPIO_PIN_CONSTANTS}.scl6, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 2
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.sda1, {GPIO_PIN_CONSTANTS}.alt0)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.sa3, {GPIO_PIN_CONSTANTS}.alt1)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.lcd_vsync, {GPIO_PIN_CONSTANTS}.alt2)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.spi3_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.cts2, {GPIO_PIN_CONSTANTS}.alt4)
			pin_2.extend_function ({GPIO_PIN_CONSTANTS}.sda3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 3
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.scl1, {GPIO_PIN_CONSTANTS}.alt0)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.sa2, {GPIO_PIN_CONSTANTS}.alt1)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.lcd_hsync, {GPIO_PIN_CONSTANTS}.alt2)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.spi3_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.rts2, {GPIO_PIN_CONSTANTS}.alt4)
			pin_3.extend_function ({GPIO_PIN_CONSTANTS}.scl3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 4
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.gpclk0, {GPIO_PIN_CONSTANTS}.alt0)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.sa1, {GPIO_PIN_CONSTANTS}.alt1)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d0, {GPIO_PIN_CONSTANTS}.alt2)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.spi4_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.txd3, {GPIO_PIN_CONSTANTS}.alt4)
			pin_4.extend_function ({GPIO_PIN_CONSTANTS}.sda3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 5
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.gpclk1, {GPIO_PIN_CONSTANTS}.alt0)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.sa0, {GPIO_PIN_CONSTANTS}.alt1)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d1, {GPIO_PIN_CONSTANTS}.alt2)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.spi4_miso, {GPIO_PIN_CONSTANTS}.alt3)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.rxd3, {GPIO_PIN_CONSTANTS}.alt4)
			pin_5.extend_function ({GPIO_PIN_CONSTANTS}.scl3, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 6
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.gpclk2, {GPIO_PIN_CONSTANTS}.alt0)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.soe_n_se, {GPIO_PIN_CONSTANTS}.alt1)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d2, {GPIO_PIN_CONSTANTS}.alt2)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.spi4_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.cts3, {GPIO_PIN_CONSTANTS}.alt4)
			pin_6.extend_function ({GPIO_PIN_CONSTANTS}.sda4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 7
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.spi0_ce1_n, {GPIO_PIN_CONSTANTS}.alt0)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.swe_n_srw_n, {GPIO_PIN_CONSTANTS}.alt1)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d3, {GPIO_PIN_CONSTANTS}.alt2)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.spi4_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.rts3, {GPIO_PIN_CONSTANTS}.alt4)
			pin_7.extend_function ({GPIO_PIN_CONSTANTS}.scl4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 8
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.spi0_ce0_n, {GPIO_PIN_CONSTANTS}.alt0)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.sd0, {GPIO_PIN_CONSTANTS}.alt1)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d4, {GPIO_PIN_CONSTANTS}.alt2)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.bscsl_ce_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.txd4, {GPIO_PIN_CONSTANTS}.alt4)
			pin_8.extend_function ({GPIO_PIN_CONSTANTS}.sda4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 9
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.spi0_miso, {GPIO_PIN_CONSTANTS}.alt0)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.sd1, {GPIO_PIN_CONSTANTS}.alt1)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d5, {GPIO_PIN_CONSTANTS}.alt2)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.bscsl_miso, {GPIO_PIN_CONSTANTS}.alt3)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.rxd4, {GPIO_PIN_CONSTANTS}.alt4)
			pin_9.extend_function ({GPIO_PIN_CONSTANTS}.scl4, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 10
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.spi0_mosi, {GPIO_PIN_CONSTANTS}.alt0)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.sd2, {GPIO_PIN_CONSTANTS}.alt1)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d6, {GPIO_PIN_CONSTANTS}.alt2)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.bscsl_sda_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.cts4, {GPIO_PIN_CONSTANTS}.alt4)
			pin_10.extend_function ({GPIO_PIN_CONSTANTS}.sda5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 11
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.spi0_sclk, {GPIO_PIN_CONSTANTS}.alt0)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.sd3, {GPIO_PIN_CONSTANTS}.alt1)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d7, {GPIO_PIN_CONSTANTS}.alt2)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.bscsl_scl_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.rts4, {GPIO_PIN_CONSTANTS}.alt4)
			pin_11.extend_function ({GPIO_PIN_CONSTANTS}.scl5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 12
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.pwm0_0, {GPIO_PIN_CONSTANTS}.alt0)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.sd4, {GPIO_PIN_CONSTANTS}.alt1)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d8, {GPIO_PIN_CONSTANTS}.alt2)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.spi5_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.txd5, {GPIO_PIN_CONSTANTS}.alt4)
			pin_12.extend_function ({GPIO_PIN_CONSTANTS}.sda5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 13
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.pwm0_1, {GPIO_PIN_CONSTANTS}.alt0)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.sd5, {GPIO_PIN_CONSTANTS}.alt1)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d9, {GPIO_PIN_CONSTANTS}.alt2)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.spi5_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.rxd5, {GPIO_PIN_CONSTANTS}.alt4)
			pin_13.extend_function ({GPIO_PIN_CONSTANTS}.scl5, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 14
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.txd0, {GPIO_PIN_CONSTANTS}.alt0)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.sd6, {GPIO_PIN_CONSTANTS}.alt1)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d10, {GPIO_PIN_CONSTANTS}.alt2)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.spi5_mosi, {GPIO_PIN_CONSTANTS}.alt3)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.cts5, {GPIO_PIN_CONSTANTS}.alt4)
			pin_14.extend_function ({GPIO_PIN_CONSTANTS}.txd1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 15
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.rxd0, {GPIO_PIN_CONSTANTS}.alt0)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.sd7, {GPIO_PIN_CONSTANTS}.alt1)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d11, {GPIO_PIN_CONSTANTS}.alt2)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.spi5_sclk, {GPIO_PIN_CONSTANTS}.alt3)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.rts5, {GPIO_PIN_CONSTANTS}.alt4)
			pin_15.extend_function ({GPIO_PIN_CONSTANTS}.rxd1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 16
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.sd8, {GPIO_PIN_CONSTANTS}.alt1)
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d12, {GPIO_PIN_CONSTANTS}.alt2)
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.cts0, {GPIO_PIN_CONSTANTS}.alt3)
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.spi1_ce2_n, {GPIO_PIN_CONSTANTS}.alt4)
			pin_16.extend_function ({GPIO_PIN_CONSTANTS}.cts1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 17
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.sd9, {GPIO_PIN_CONSTANTS}.alt1)
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d13, {GPIO_PIN_CONSTANTS}.alt2)
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.rts0, {GPIO_PIN_CONSTANTS}.alt3)
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.spi1_ce1_n, {GPIO_PIN_CONSTANTS}.alt4)
			pin_17.extend_function ({GPIO_PIN_CONSTANTS}.rts1, {GPIO_PIN_CONSTANTS}.alt5)
				-- Pin 18
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.alt_in , {GPIO_PIN_CONSTANTS}.input)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.alt_out, {GPIO_PIN_CONSTANTS}.output)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.pcm_clk, {GPIO_PIN_CONSTANTS}.alt0)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.sd10, {GPIO_PIN_CONSTANTS}.alt1)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.dpi_d14, {GPIO_PIN_CONSTANTS}.alt2)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.spi6_ce0_n, {GPIO_PIN_CONSTANTS}.alt3)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.spi1_ce0_n, {GPIO_PIN_CONSTANTS}.alt4)
			pin_18.extend_function ({GPIO_PIN_CONSTANTS}.pwm0_0, {GPIO_PIN_CONSTANTS}.alt5)
		end

	is_expected_processor: BOOLEAN
			-- Is the Pi on which this program is running the
			-- type expected for Current?
		do
			Result := processor = {PI_CONSTANTS}.Processor_bcm2711
		end

feature -- Access

	pin_22: GPIO_PIN
			-- A pin

	pin_23: GPIO_PIN
			-- A pin

	pin_24: GPIO_PIN
			-- A pin

	pin_25: GPIO_PIN
			-- A pin

	pin_26: GPIO_PIN
			-- A pin

	pin_27: GPIO_PIN
			-- A pin

	pin_last: GPIO_PIN
			-- The last pin (i.e. the one with highest pin number)
			-- The Pi 4 with the BCM2711 ARM Pripherals has 58 GPIO pins,
			-- but "GPIO46" through "GPIO57" are marked for internal use,
			-- so no interface is provided here for those pins.
		do
			Result := pin_27	-- last {GPIO_PIN} on 40-pin header
		end


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
