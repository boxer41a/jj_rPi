note
	description: "[
		Represents a Raspberry Pi
		]"
	author: "Jimmy J. Johnson"
	date: "9/25/20"

deferred class
	PI_CONTROLLER

inherit

	PI_SHARED
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Create an instance, assuming program in running
			-- on a Pi with a BCM2835 processor.
		do
			create_interface_objects
			initialize_pin_functions
--			show_revision_information
--			io.put_string (gpio.out)
--			io.put_string (gpio_out)
		ensure then
--			is_expected_processor: is_expected_processor
		end

	create_interface_objects
			-- Create all the attributes
		local
			fd: INTEGER_32 	-- file descriptor
			a: ANY
			add: NATURAL_32
		do
--			create header.make
				-- Use mmap (in `c_open_file') to give access to memory
			a := ("/dev/mem").to_c
print ("{PI_CONTROLLER}.create_interface_objects:  %N")
print ("            generating_type of `a' is {" + a.generating_type + "} %N")
			fd := c_open_file ($a)
			if fd > 0 then
					-- All functions available
				add := peripheral_base_address
				print ("{PI_CONTROLLER}.make:  `perpheral_base_address = " + add.out + "%N")
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
				create gpio.make (fd, gpio_map_length, 0)
--				create clocks_imp.make (fd, clocks_map_length, 0)
--				create pwm_imp.make (fd, pwm_map_length, 0)
			elseif is_degraded_mode then
					-- The GPIO is the only {PERIPHERAL} available
				create gpio.make(fd, gpio_map_length, gpio_offset)
			else
					-- Must be running on a Pi as sudo, so all peripherals available
				create gpio.make (fd, gpio_map_length, add + gpio_offset)
				create clocks_imp.make (fd, clocks_map_length, add + gpio_clocks_offset)
				create pwm_imp.make (fd, pwm_map_length, add + pwm_offset)
			end
				-- Create the pins
			create pin_0.make (0)
			create pin_1.make (1)
			create pin_2.make (2)
			create pin_3.make (3)
			create pin_4.make (4)
			create pin_5.make (5)
			create pin_6.make (6)
			create pin_7.make (7)
			create pin_8.make (8)
			create pin_9.make (9)
			create pin_10.make (10)
			create pin_11.make (11)
			create pin_12.make (12)
			create pin_13.make (13)
			create pin_14.make (14)
			create pin_15.make (15)
			create pin_16.make (16)
			create pin_17.make (17)
			create pin_18.make (18)
			create pin_19.make (19)
			create pin_20.make (20)
			create pin_21.make (21)
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

	initialize_pin_functions
			-- Add functions available to pins specific for this processor
		do
			-- pin_0.extend (a_function, a_mode)
			-- redefine
		end

	is_expected_processor: BOOLEAN
			-- Is the processor of the Pi on which this program is
			-- running the type expected for Current?
			-- The processor determines addresses for registers, etc.
		deferred
		end

feature -- Access

	gpio: GPIO
			-- {PERIPHERAL} giving access to the GPIO pins

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

	pin_0: GPIO_PIN
			-- GPIO pin number 0

	pin_1: GPIO_PIN
			-- GPIO pin number 1

	pin_2: GPIO_PIN
			-- GPIO pin number 2

	pin_3: GPIO_PIN
			-- GPIO pin number 3

	pin_4: GPIO_PIN
			-- GPIO pin number 4

	pin_5: GPIO_PIN
			-- GPIO pin number 5

	pin_6: GPIO_PIN
			-- GPIO pin number 6

	pin_7: GPIO_PIN
			-- GPIO pin number 7

	pin_8: GPIO_PIN
			-- GPIO pin number 8

	pin_9: GPIO_PIN
			-- GPIO pin number 9

	pin_10: GPIO_PIN
			-- GPIO pin number 10

	pin_11: GPIO_PIN
			-- GPIO pin number 11

	pin_12: GPIO_PIN
			-- GPIO pin number 12

	pin_13: GPIO_PIN
			-- GPIO pin number 13

	pin_14: GPIO_PIN
			-- GPIO pin number 14

	pin_15: GPIO_PIN
			-- GPIO pin number 15

	pin_16: GPIO_PIN
			-- GPIO pin number 16

	pin_17: GPIO_PIN
			-- GPIO pin number 17

	pin_18: GPIO_PIN
			-- GPIO pin number 18

	pin_19: GPIO_PIN
			-- GPIO pin number 19

	pin_20: GPIO_PIN
			-- GPIO pin number 20

	pin_21: GPIO_PIN
			-- GPIO pin number 21

	pin_last: GPIO_PIN
			-- The last pin (i.e. the one with highest pin number)
		do
			Result := pin_21
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
			io.put_string ("{PI_CONTROLLER}.terminate_mode:  Fix me! %N")
---			check
--				fix_me:  false
--					-- because
--			end
		end

feature {NONE} -- Implementation (pin mapping)

--	header: PI_HEADER_MAP
			-- Mapping from a {GPIO_PIN} (i.e. BCM or Broadcom
			-- numbering scheme) to the physical pin number.

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
