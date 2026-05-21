note
	description: "[
		Represents a Raspberry Pi
		]"
	author: "Jimmy J. Johnson"
	date: "9/25/20"

deferred class
	RPI_PROCESSOR

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Redefine as a "once feature" in descendants, simply calling Precursor.
			-- (Creation features in once classes must be declared in that class.)
		do
			create pins.make (21)
			initialize_pins
			initialize_pin_functions
			initialize_periferals
		ensure then
--			is_expected_processor: is_expected_processor
		end

	Expected_pin_count: INTEGER
			-- The number of pins available on this RPi.
			-- Used during creation features.
		do
			Result := 21
		end

	initialize_pins
			-- Create the GPIO pins
		local
			i: INTEGER
		do
				-- RPi pins start numbering at zero
			from i := 0
			until i > Expected_pin_count
			loop
				pins.extend (create {GPIO_PIN}.make (i))
				i := i + 1
			end
		end

	initialize_pin_functions
			-- Add default (input and output) and alternate functions
			-- to each pin in Current
		deferred
		end

	initialize_periferals
			-- Create all the attributes
		local
			fd: INTEGER_32 	-- file descriptor
			a: ANY
			add: NATURAL_32
		do
--			create header.make
				-- Use mmap (in `c_open_file') to give access to memory
			a := ("/dev/mem").to_c
print ("{RPI_PROCESSOR}.create_interface_objects:  %N")
print ("            generating_type of `a' is {" + a.generating_type + "} %N")
			fd := c_open_file ($a)
			if fd > 0 then
					-- All functions available
				add := peripheral_base_address
				print ("{RPI_PROCESSOR}.make:  `perpheral_base_address = " + add.out + "%N")
			else
				a := ("/dev/gpiomem").to_c
				fd := c_open_file ($a)
				if fd > 0 then
					is_degraded_mode := true
				else
					is_test_mode := true
				end
			end
				-- Create the peripherals
			if is_test_mode then
					-- Must not be on a Pi, so simulate by mapping using a file
				build_test_file
				a := ("test_file").to_c
				fd := c_open_file ($a)
				create gpio_imp.make (fd, gpio_map_length, 0)  --gpio_offset)
				create clocks_imp.make (fd, clocks_map_length, Block_size.to_natural_32)  --gpio_clocks_offset)
				create pwm_imp.make (fd, pwm_map_length, (Block_size * 2).to_natural_32)  --pwm_offset)
			elseif is_degraded_mode then
					-- The GPIO is the only {PERIPHERAL} available
				create gpio_imp.make(fd, gpio_map_length, gpio_offset)
			else
					-- Must be running on a Pi as sudo, so all peripherals available
				create gpio_imp.make (fd, gpio_map_length, add + gpio_offset)
				create clocks_imp.make (fd, clocks_map_length, add + gpio_clocks_offset)
				create pwm_imp.make (fd, pwm_map_length, add + pwm_offset)
			end
		end

	build_test_file
			-- Create a test file that can later be mmapped to simulate
			-- running on a Pi
		local
			f: RAW_FILE
			n: NATURAL_32	-- 4 bytes
			i: INTEGER_32
		do
				-- Create and open the file for writing
			create f.make_open_write ("test_file")
				-- Write four block's worth of data
				-- (at 32-bits per write)
			from i := 1
			until i > block_size * 3
			loop
					-- Just write zeros
				f.put_natural_32 (n)
				i := i + 1
			end
			f.close
		end

feature -- Access

	pin_count: INTEGER
			-- The number of GPIO pins accessible
		do
			Result := pins.count
		end

	pin (a_index: INTEGER): GPIO_PIN
			-- The pin at `a_index'.
			-- GPIO pins are numbered started with 0.
		require
			pin_number_big_enough: a_index >=0
			pin_number_small_enough: a_index <= pin_count - 1
		do
			Result := pins.i_th (a_index + 1)
		ensure
			correct_pin: Result.number = a_index
		end

	last_pin: GPIO_PIN
			-- The last pin (i.e. the one with highest pin number)
			-- The Pi 4 with the BCM2711 ARM Pripherals has 58 GPIO pins,
			-- but "GPIO46" through "GPIO57" are marked for internal use,
			-- so no interface is provided here for those pins.
		do
			Result := pins.i_th (pins.count)  -- last {GPIO_PIN} on 40-pin header
		end

	gpio: GPIO
			-- {PERIPHERAL} giving access to the GPIO pins
		do
			check attached gpio_imp as g then
				Result := g
			end
		end

	clocks: CLOCKS
			-- {PERIPHERAL} giving access to the clocks
		require
			not_is_degraded_mode: not is_degraded_mode
		do
			check attached clocks_imp as c then
				Result := c
			end
		end

	pwm: PWM
			-- {PERIPHERAL} giving access to the PWM controllers
		require
			not_is_degraded_mode: not is_degraded_mode
		do
			check attached pwm_imp as p then
				Result := p
			end
		end

feature -- Status report

	is_degraded_mode: BOOLEAN
			-- Is program running with reduced functionality?
			-- Yes if don't have full permissions with "sudo", in
			-- which case only the GPIO pin functions work

	is_test_mode: BOOLEAN
			-- Is the programming running in test mode?
			-- Yes when not running on a Pi.  This allows some
			-- functions to be simulated

feature -- Basic operations

	terminate_mode (a_pin: INTEGER_32)
			-- Some functions run for x amount of time,
			-- so can't just set mode until some condition?
		do
			io.put_string ("{RPI_PROCESSOR}.terminate_mode:  Fix me! %N")
---			check
--				fix_me:  false
--					-- because
--			end
		end

feature {NONE} -- Implementation (pin mapping)

--	header: PI_HEADER_MAP
			-- Mapping from a {GPIO_PIN} (i.e. BCM or Broadcom
			-- numbering scheme) to the physical pin number.

	pins: ARRAYED_SET [GPIO_PIN]
			-- List of pins in this RPi

	gpio_imp: detachable like gpio
			-- Implementation of `gpio'

	clocks_imp: detachable like clocks
			-- Implementation of `clocks'; Void when `is_degraded_mode'.
			-- (Happens if not running with full permissions with "sudo")

	pwm_imp: detachable like pwm
			-- Implementation of `pwm'; Void when `is_degraded_mode'
			-- (Happens if not running with full permissions as "sudo")

	peripheral_base_address: NATURAL_32
			-- Physical address of the first peripheral register
			-- Specific for this model.
		deferred
		end
--		do
--			Result := c_get_host_address
--		end

	gpio_offset: NATURAL_32
			-- Offset from `peripheral_base_address' to GPIO registers.
		deferred
		end

	gpio_clocks_offset: NATURAL_32
			-- Offset from `peripheral_base_address' to GPIO clock registers.
		deferred
		end

	pwm_offset: NATURAL_32
			-- Offsett from `peripheral_ase_address' to the PWM registers.
		deferred
		end

	block_size: INTEGER_32 = 4096
			-- Passed to `c_mmap'.  Same as used by WiringPi.

	gpio_map_length: INTEGER_32 = 4096
			-- Number of bytes to map for `gpio'

	clocks_map_length: INTEGER_32 = 4096
			-- Number of bytes to map for `clocks'

	pwm_map_length: INTEGER_32 = 4096
			-- Number of bytes to map for `pwm'

feature {NONE} -- Externals

	c_open_file (a_filename: POINTER): INTEGER_32
			-- Attempt to open the file `a_filename', returning -1 if failed.
		external
			"C inline use <fcntl.h>"
		alias
			"[
//				char* s = (char*)$a_filename;
				char* s = (EIF_CHARACTER_8*)$a_filename;
//				printf ("s = %s \n", s);
				int flags = O_RDWR | O_SYNC | O_CLOEXEC;
				int f = open (s, flags);
				return (EIF_INTEGER) (f);
			]"
		end

--	c_get_host_address: NATURAL_32
--			-- Call `bcm_host_get_peripheral_address()' function
--		external
--			"C inline use <bcm_host.h>"
--		alias
--			"[
--				unsigned a = bcm_host_get_peripheral_address();
--				return (EIF_NATURAL_32) a;
--			]"
--		end

invariant

	test_mode_implication: is_test_mode implies not is_degraded_mode
	degraded_mode_implication: is_degraded_mode implies not is_test_mode

--	valid_model: model >= 0 and model <= 19

end
