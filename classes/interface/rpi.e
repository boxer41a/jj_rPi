note
	description: "[
		Represents a Raspberry Pi.
		]"
	author: "Jimmy J Johnson"
	date: "5/21/26        11/14/20"

class
	RPI

inherit

	ANY
		redefine
			default_create
		end

inherit {NONE}

	RPI_CONSTANTS
		export
			{NONE}
				all
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance
		do
				-- The {RPI_PROCESSOR} (e.g. {BCM2711_PROCESSOR})
				-- should be effected as a once class where `default_create'
				-- is redefined as a once ("PROCESS"), meaning only one
				-- controller is created in a system.
			inspect processor_number
--			when {RPI_CONSTANTS}.Processor_bcm2835 then
--			when {RPI_CONSTANTS}.Processor_bcm2836 then
--			when {RPI_CONSTANTS}.Processor_bcm2837 then
			when {RPI_CONSTANTS}.Processor_bcm2711 then
				create {BCM2711_PROCESSOR} processor
			else
					-- Assume Pi-4 platform for testing?
				create {BCM2711_PROCESSOR} processor
			end

		end

feature -- Access

	processor: RPI_PROCESSOR
			-- The one {RPI_PROCESSOR} in the system, giving access to
			-- GPIO pins and other periferals (e.g. PWM, clocks, etc.)

	pin (a_index: INTEGER): GPIO_PIN
			-- The pin at `a_index'.
			-- GPIO pins are numbered started with 0.
			-- Convenience feature accessing through the  `controller'
		require
			pin_number_big_enough: a_index >=0
			pin_number_small_enough: a_index <= processor.pin_count - 1
		do
			Result := processor.pin (a_index)
		ensure
			correct_pin: Result.number = a_index
		end

	gpio: GPIO
			-- {PERIPHERAL} giving access to the GPIO pins
			-- Convenience feature accessing through the  `controller'
		do
			Result := processor.gpio
		end

	clocks: CLOCKS
			-- {PERIPHERAL} giving access to the clocks
			-- Convenience feature accessing through the  `controller'
		require
			not_is_degraded_mode: not processor.is_degraded_mode
		do
			Result := processor.clocks
		end

	pwm: PWM
			-- {PERIPHERAL} giving access to the PWM controllers
			-- Convenience feature accessing through the  `controller'
		require
			not_is_degraded_mode: not processor.is_degraded_mode
		do
			Result := processor.pwm
		end

feature -- Access

	memory_size: NATURAL_32
			-- Constant representing amount of memory in this Pi
			-- Use `constant_as_string' to get a string representation.
		local
			n: NATURAL_32
		once
			n := revision_code.bit_and (Memory_size_mask).bit_shift_right (20)
			inspect n
			when 0 then  Result := {RPI_CONSTANTS}.Memory_256mb
			when 1 then  Result := {RPI_CONSTANTS}.Memory_512mb
			when 2 then  Result := {RPI_CONSTANTS}.Memory_1gb
			when 3 then  Result := {RPI_CONSTANTS}.Memory_2gb
			when 4 then  Result := {RPI_CONSTANTS}.Memory_4gb
			when 5 then  Result := {RPI_CONSTANTS}.Memory_8gb
			else
--				check
--					not_support: false
--						-- should not happen
--				end
				Result := {RPI_CONSTANTS}.Unknown
			end
		end

	manufacturer: NATURAL_32
			-- Constant representing the manufacturer of this Pi
			-- Use `constant_as_string' to get a string representation.
		local
			n: NATURAL_32
		once
			n := revision_code.bit_and (Manufacturer_mask).bit_shift_right (16)
			inspect n
			when 0 then  Result := {RPI_CONSTANTS}.Manufacturer_sony_uk
			when 1 then  Result := {RPI_CONSTANTS}.Manufacturer_egoman
			when 2 then  Result := {RPI_CONSTANTS}.Manufacturer_embest
			when 3 then  Result := {RPI_CONSTANTS}.Manufacturer_sony_japan
			when 4 then  Result := {RPI_CONSTANTS}.Manufacturer_embest
			when 5 then  Result := {RPI_CONSTANTS}.Manufacturer_stadium
			else
--				check
--					not_support: false
--						-- should not happen
--				end
				Result := {RPI_CONSTANTS}.Unknown
			end
		end

	processor_number: NATURAL_32
			-- Constant representing the type processor
			-- Use `constant_as_string' to get a string representation.
		local
			n: NATURAL_32
		once
			n := (revision_code.bit_and (Processor_mask)).bit_shift_right (12)
			inspect n
			when 0 then  Result := {RPI_CONSTANTS}.Processor_bcm2835
			when 1 then  Result := {RPI_CONSTANTS}.Processor_bcm2836
			when 2 then  Result := {RPI_CONSTANTS}.Processor_bcm2837
			when 3 then  Result := {RPI_CONSTANTS}.Processor_bcm2711
			else
--				check
--					not_supported: false
--						-- should not happen
--				end
				Result := {RPI_CONSTANTS}.Unknown
			end
		end

	model_type: NATURAL_32
			-- Constant representing the model (e.g. A, B, 4b, etc)
			-- Use `constant_as_string' to get a string representation.
		local
			n: NATURAL_32
		once
			n := revision_code.bit_and (Model_mask).bit_shift_right (4)
			inspect n
			when 0 then  Result := {RPI_CONSTANTS}.Model_a
			when 1 then  Result := {RPI_CONSTANTS}.Model_b
			when 2 then  Result := {RPI_CONSTANTS}.Model_a_plus
			when 3 then  Result := {RPI_CONSTANTS}.Model_b_plus
			when 4 then  Result := {RPI_CONSTANTS}.Model_2b
			when 5 then  Result := {RPI_CONSTANTS}.Model_alpha
			when 6 then  Result := {RPI_CONSTANTS}.Model_cm1
			when 8 then  Result := {RPI_CONSTANTS}.Model_3b
			when 9 then  Result := {RPI_CONSTANTS}.Model_zero
			when 10 then  Result := {RPI_CONSTANTS}.Model_cm3
			when 12 then  Result := {RPI_CONSTANTS}.Model_zero_w
			when 13 then  Result := {RPI_CONSTANTS}.Model_3b_plus
			when 14 then  Result := {RPI_CONSTANTS}.Model_3a_plus
			when 16 then  Result := {RPI_CONSTANTS}.Model_cm3_plus
			when 17 then  Result := {RPI_CONSTANTS}.Model_4b
			else
--				check
--					not_support: false
--						-- should not happen
--				end
				Result := {RPI_CONSTANTS}.Unknown
			end
		end

	revision: NATURAL_32
			-- Revision number of this Pi
		once
			Result := revision_code.bit_and (Revision_mask)
		end

feature -- Status report

	is_overvoltage_allowed: BOOLEAN
			-- Can this pi be set to overvoltage?
		once
			Result := revision_code.bit_and (Overvoltage_mask) = 0
		end

	is_otp_programming_allowed: BOOLEAN
			-- Is one-time-programming (OTP) allowed for this Pi?
		once
			Result := revision_code.bit_and (otp_programming_mask) = 0
		end


	is_otp_reading_allowed: BOOLEAN
			-- Is one-time-programming (OTP) reading allowed for this Pi?
		once
			Result := revision_code.bit_and (otp_reading_mask) = 0
		end

	is_warranty_voided: BOOLEAN
			-- Has the warranty on this Pi been voided?
		once
			Result := revision_code.bit_and (warranty_mask) = 1
		end

	is_new_style: BOOLEAN
			-- Is this a new revision style?
		once
			Result := revision_code.bit_and (style_mask) = 1
		end

feature -- Basic operations

	show_revision_information
			-- Display manufacturing information about this Pi
		do
			io.put_string ("%N")
			io.put_string ("{SHARED}.show_revision_information: %N")
			if revision = 0 then
				io.put_string ("   No revision information available %N")
				io.put_string ("   Must be in test mode.  %N")
			else
				io.put_string ("    Model:  " + constant_as_string (model_type) + "%N")
				io.put_string ("    Manufacturer:  " + constant_as_string (manufacturer) + "%N")
				io.put_string ("    Processor:  " + constant_as_string (processor_number) + "%N")
				io.put_string ("    Memory:  " + constant_as_string (memory_size) + "%N")
				io.put_string ("    Revision:  " + constant_as_string (revision) + "%N")
			end
			io.put_string ("%N")
		end

feature {NONE} -- Implementation

	revision_code: NATURAL_32
			-- Revision hex code as determined from "/proc/cpuinfo"
			--
			-- https://www.raspberrypi.org/documentation/hardware/
			-- raspberrypi/revision-codes/README.md.
			--
			-- The following masks are used to decode the `revision_code' with
			-- format:
			--	  NOQu uuWu FMMM CCCC PPPP TTTT TTTT RRRR
			--	
			--	u	unused.
			--
			--    N     Overvoltage      0: allowed, 1: disallowed
			--    O     OTP Programming  0: allowed, 1: disallowed
			--    Q     OTP Reading      0: allowed, 1: disallowed
			--    W     Warranty         0: intact,	1: voided
			--    F     Style            0: old style, 1: new style
			--    MMM   Memory:          256KB up to 8GB (See feature `')
			--    CCCC  Manufacturer     (See feature `')
			--    PPPP  Processor        0: BCM2835, ect (See feature `')
			--    TTTTTTTT    Type       A, B, A+, B+, 4B, etc. (See feature `')
		once
			Result := c_revision
		end

	overvoltage_mask: NATURAL_32
			-- Mask to interpret the `revision_code'
		once
			Result := 0x80000000
		end

	otp_programming_mask: NATURAL_32
		once
			Result := 0x40000000
		end

	otp_reading_mask: NATURAL_32
		once
			Result := 0x20000000
		end

	warranty_mask: NATURAL_32
		once
			Result := 0x02000000
		end

	style_mask: NATURAL_32
		once
			Result := 0x00800000
		end

	memory_size_mask: NATURAL_32
		once
			Result := 0x00700000
		end

	manufacturer_mask: NATURAL_32
		once
			Result := 0x000f0000
		end

	processor_mask: NATURAL_32
		once
			Result := 0x0000f000
		end

	model_mask: NATURAL_32
		once
			Result := 0x000000ff0
		end

	revision_mask: NATURAL_32
		once
			Result := 0x000000f
		end

feature {NONE} -- Externals

	c_revision: NATURAL_32
			-- Line from "/proc/cpuinfo" showing the revision number.
			-- Returns zero if unable to read "/proc/cpuinfo" file.
		external
			"C inline use <ctype.h>"
		alias
			"[
				unsigned long n;
				FILE *f = fopen("/proc/cpuinfo", "r");
				if (f == NULL) {
					n = 0xFFFFFFFF;		// shows failure
				} else {
					char line [512];
					char *c = 0;
						// Make sure this is a Pi.
					while (fgets (line, 512, f) != NULL)
						if (strncmp (line, "Revision", 8) == 0)
							break;
					fclose (f);
						// Remove trailing CR/NL
					for (c = &line [strlen (line) - 1] ; (*c == '\n') || (*c == '\r') ; --c) {
						*c = 0;
					}
						// On rPi4 with 8GB RAM at this point have "Revision    : d03114"
						// Find the actual number (i.e. strip "Rivision    :" and spaces
					char *s;
					s = strchr(line, ':');
						// Now `s' = " do3114", so remove whitespace
						// (i.e. move the string pointer past color & spaces).
					s = s + 1;
						// isspace generates a warning
					while(isspace((unsigned char)*s)) s++;
						// Convert string "s" to unsign long.
					n = strtoul(s, NULL, 16);
				}
				return (EIF_NATURAL_32) (n);
			]"
		end



end

