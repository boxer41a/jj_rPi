note
	description: "[
		Simulates the processor in a Raspberry Pi 4b (i.e. the BCM2711),
		defining the offsets for the periferals.
		These offsets will be into a memory area mapped to a temp file.
		]"
	author: "Jimmy J. Johnson"
	date: "5/22/26"

once class
	SIMULATED_PROCESSOR

inherit

	RPI_PROCESSOR
		redefine
			default_create,
			initialize_peripherals,
			expected_pin_count
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

	Expected_pin_count: INTEGER = 27
			-- The number of pins available on this RPi.
			-- Used during creation features.

	initialize_peripherals
			-- Set the addresses for the peripherals
		local
			a: ANY
			add: NATURAL_32
		do
			gpio_clocks_fd := memory_file_descriptor ("gpio_clocks")
			gpio_fd := memory_file_descriptor ("gpio")
			pcm_fd := memory_file_descriptor ("pcm")
			bcs_fd := memory_file_descriptor ("bcs")
			pwm_fd := memory_file_descriptor ("pwm")
			uart_fd := memory_file_descriptor ("uart")
			dma_fd := memory_file_descriptor ("dma")
			interupts_fd := memory_file_descriptor ("interupts")
			add := peripheral_base_address
				-- Create the peripherals
			create gpio_imp.make (gpio_fd, gpio_map_length, add + gpio_offset)
			create clocks_imp.make (gpio_clocks_fd, clocks_map_length, add + gpio_clocks_offset)
			create pwm_imp.make (pwm_fd, pwm_map_length, add + pwm_offset)
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

	peripheral_base_address: NATURAL_32 = 0x00000000
			-- Physical address of the periferal memory area.  The specific periferals
			-- reside at some offset from this address.
			-- This simulator uses a separate mapped file for each peripheral,
			-- so, simply start memory at the beginning of the
			-- mapped memory file (see `memory_file_descriptor').
			-- The offsets are in order by memory location as defined in
			-- the BCM2711 ARM Peripherals document.

	gpio_clocks_offset: NATURAL_32 = 0x00000000		-- 0x00101000
			-- Offset from `peripheral_base_address' to GPIO clock registers.
			-- Requires 88 bytes.

	gpio_offset: NATURAL_32 = 0x0		--0x0000100		-- 0x00200000
			-- Offset from `peripheral_base_address' to GPIO registers.
			-- Requires 244 bytes.

-- 	pcm_offset: NATURAL_32 = 0x0		--0x00000400		-- 0x00203000
 			-- Offset from `peripheral_base_address' to PCM/I2S Audio
 			-- Requires 24 bytes.

-- 	bcs_offset: NATURAL_32 = 0x0		--0x00000500		-- 0x00205000
 			-- Offset from `peripheral_base_address' to PCM/I2S Audio
 			-- Requires 3,096 bytes.

 	pwm_offset: NATURAL_32 = 0x0		--0x00003600		-- 0x0020C000
			-- Offsett from `peripheral_base_address' to the PWM registers.
			-- Requires 828 bytes

--	uart_offset: NATURAL_32 = 	0x0		--0x00003F00	-- 0x00215000
			-- Offsett from `peripheral_base_address' to the UART registers.
			-- Requires 100 bytes

-- 	dma_offset: NATURAL_32 = 0x0		--0x00004000		-- 0x00E05000
			-- Offsett from `peripheral_base_address' to the DMA registers.
			-- Requires 4,048 bytes bytes

-- 	interupts_offset: NATURAL_32 = 0x0		--0x00004200		-- 0xFF840000
			-- Offsett from `peripheral_base_address' to the DMA registers.
			-- Low Peripheral mode required for offset 0xFF84 0000, otherwise
			-- offset is 0x4_C004_0000.
			-- Requires 124 bytes bytes


feature {NONE} -- Implementation

	gpio_clocks_fd: INTEGER_32
			-- File descriptor for mapping memory for the GPIO Clocks peripheral.

	gpio_fd: INTEGER_32
			-- File descriptor for mapping memory for the GPIO peripheral.

	pcm_fd: INTEGER_32
			-- File descriptor for mapping memory for the PCM/I2S Audio peripheral.

	bcs_fd: INTEGER_32
			-- File descriptor for mapping memory for the BCS peripheral.

	pwm_fd: INTEGER_32
			-- File descriptor for mapping memory for the PWM peripheral.

	uart_fd: INTEGER_32
			-- File descriptor for mapping memory for the UART peripheral.

	dma_fd: INTEGER_32
			-- File descriptor for mapping memory for the DMA peripheral.

	interupts_fd: INTEGER_32
			-- File descriptor for mapping memory for the Interupts peripheral.

	memory_file_descriptor (a_filename: STRING_8): INTEGER_32
			-- Create a file for mapping a simulated paripheral to memory,
			-- returning a "file_descriptor" for that file.
			-- The resulting file will contain 4096 bytes, which is enough
			-- to handle the perfipheral with the most registers.
		local
			f: RAW_FILE
			n: NATURAL_32
			i: INTEGER_32
			a: ANY
		do
			create f.make_open_write (a_filename)
				-- Each 32-bit natural (4 bytes) simulates one RPI register.
				-- 8,800 bytes required for offsets listed above.
			from i := 1
			until i > 4096 // 4
			loop
				f.put_natural_32 (n)	-- writes a zero
				i := i + 1
			end
			f.close
			a := (a_filename).to_c
			Result := c_open_file ($a)
		ensure
			is_memory_file_opened: Result /= -1
		end

end
