note
	description: "[
		Global infrmation at the one {PI_CONTROLLER} in the system.
		]"
	author: "Jimmy J Johnson"
	date: "11/14/20"

class
	SHARED

inherit {NONE}

	PI_CONSTANTS
		export
			{NONE}
				all
		end

feature -- Access

	pi: PI_CONTROLLER
			-- The one {PI_CONTROLLER} in the system
		once
			inspect processor
--			when {PI_CONSTANTS}.Processor_bcm2835 then
--			when {PI_CONSTANTS}.Processor_bcm2836 then
--			when {PI_CONSTANTS}.Processor_bcm2837 then
			when {PI_CONSTANTS}.Processor_bcm2711 then
				Result := create {PI_4_CONTROLLER}
			else
					-- Assume Pi-4 platform for testing?
				Result := create {PI_4_CONTROLLER}
			end

		end

	memory_size: NATURAL_32
			-- Constant representing amount of memory in this Pi
			-- Use `constant_as_string' to get a string representation.
		local
			n: NATURAL_32
		once
			n := revision_code.bit_and (Memory_size_mask).bit_shift_right (20)
			inspect n
			when 0 then  Result := {PI_CONSTANTS}.Memory_256mb
			when 1 then  Result := {PI_CONSTANTS}.Memory_512mb
			when 2 then  Result := {PI_CONSTANTS}.Memory_1gb
			when 3 then  Result := {PI_CONSTANTS}.Memory_2gb
			when 4 then  Result := {PI_CONSTANTS}.Memory_4gb
			when 5 then  Result := {PI_CONSTANTS}.Memory_8gb
			else
--				check
--					not_support: false
--						-- should not happen
--				end
				Result := {PI_CONSTANTS}.Unknown
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
			when 0 then  Result := {PI_CONSTANTS}.Manufacturer_sony_uk
			when 1 then  Result := {PI_CONSTANTS}.Manufacturer_egoman
			when 2 then  Result := {PI_CONSTANTS}.Manufacturer_embest
			when 3 then  Result := {PI_CONSTANTS}.Manufacturer_sony_japan
			when 4 then  Result := {PI_CONSTANTS}.Manufacturer_embest
			when 5 then  Result := {PI_CONSTANTS}.Manufacturer_stadium
			else
--				check
--					not_support: false
--						-- should not happen
--				end
				Result := {PI_CONSTANTS}.Unknown
			end
		end

	processor: NATURAL_32
			-- Constant representing the type processor
			-- Use `constant_as_string' to get a string representation.
		local
			n: NATURAL_32
		once
			n := (revision_code.bit_and (Processor_mask)).bit_shift_right (12)
			inspect n
			when 0 then  Result := {PI_CONSTANTS}.Processor_bcm2835
			when 1 then  Result := {PI_CONSTANTS}.Processor_bcm2836
			when 2 then  Result := {PI_CONSTANTS}.Processor_bcm2837
			when 3 then  Result := {PI_CONSTANTS}.Processor_bcm2711
			else
--				check
--					not_supported: false
--						-- should not happen
--				end
				Result := {PI_CONSTANTS}.Unknown
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
			when 0 then  Result := {PI_CONSTANTS}.Model_a
			when 1 then  Result := {PI_CONSTANTS}.Model_b
			when 2 then  Result := {PI_CONSTANTS}.Model_a_plus
			when 3 then  Result := {PI_CONSTANTS}.Model_b_plus
			when 4 then  Result := {PI_CONSTANTS}.Model_2b
			when 5 then  Result := {PI_CONSTANTS}.Model_alpha
			when 6 then  Result := {PI_CONSTANTS}.Model_cm1
			when 8 then  Result := {PI_CONSTANTS}.Model_3b
			when 9 then  Result := {PI_CONSTANTS}.Model_zero
			when 10 then  Result := {PI_CONSTANTS}.Model_cm3
			when 12 then  Result := {PI_CONSTANTS}.Model_zero_w
			when 13 then  Result := {PI_CONSTANTS}.Model_3b_plus
			when 14 then  Result := {PI_CONSTANTS}.Model_3a_plus
			when 16 then  Result := {PI_CONSTANTS}.Model_cm3_plus
			when 17 then  Result := {PI_CONSTANTS}.Model_4b
			else
--				check
--					not_support: false
--						-- should not happen
--				end
				Result := {PI_CONSTANTS}.Unknown
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
				io.put_string ("    Processor:  " + constant_as_string (processor) + "%N")
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
