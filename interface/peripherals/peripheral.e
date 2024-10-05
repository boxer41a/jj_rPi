note
	description: "[
		A {PERIPHERAL} (e.g. {GPIO}, {CLOCKS}, {PWM}, etc) in
		a {PI_CONTROLLER}.
	]"
	author: "Jimmy J. Johnson"
	date: "10/25/20"

deferred class
	PERIPHERAL

inherit

	ANY

	PI_SHARED
		export
			{NONE}
				all
		end

	MEMORY
		export
			{NONE}
				all
		redefine
			dispose
		end

feature {NONE} -- Initialization

	make (a_file_descriptor: INTEGER_32; a_length: INTEGER_32; a_address: NATURAL_32)
			-- Initialize by mapping `a_length' bytes of the file referenced
			-- by `a_file_descriptor' starting at `a_address', which may be
			-- zero, plus the `offset'.
		do
			base_address := c_mmap (a_file_descriptor, a_length, a_address)
			check
				not_mmap_failed: not c_mmap_failed (base_address)
					-- because the file should have been opened
			end
		end

	dispose
			-- Close the file referenced by `file_descriptor', which
			-- was opened in the call to `c_open_dev'.
		do
			Precursor {MEMORY}
			if not c_mmap_failed (base_address) then
				c_munmap (base_address, block_size)
			end
		end

feature {NONE} -- Implementation

	base_address: POINTER
			-- Mapped address of this peripheral.
			-- The address of the first register (e.g. "GPFSEL0")

	block_size: INTEGER_32 = 4096
			-- Passed to `c_mmap'.  Same as used by WiringPi.

	page_size: INTEGER_32
			-- Get the memory page size with C call
		do
			Result := c_page_size
		end

	file_state: INTEGER_32
			-- Indicates how well the setup (i.e. C calls in `make') went
			-- Was the program able to open the appropriate files to
			-- map memory?

	state_uninitialized: INTEGER_32 = 0
			-- Used by `file_state' to indicate that there has not yet
			-- been an attempt to open the "/dev/..." file

	state_good: INTEGER_32 = 1
			-- Used by `file_state' to indicate that the "/dev/mem" file
			-- was read by Current

	state_degraded: INTEGER_32 = 2
			-- Used by `file_state' to indicate that the "/dev/mem" file
			-- was NOT read by Current, so using "dev/gpiomem".

	state_testing: INTEGER_32 = 3
			-- Used by `file_state' to indecate that program is
			-- mapping to a test file.

	state_failed: INTEGER_32 = -1
			-- Used by `file_state' to indicate that neither the "/dev/mem"
			-- or "/dev/gpiomem" file was read.  Program should not run.

feature {NONE} -- Externals

--	c_open_and_mmap (a_filename: POINTER; a_offset: NATURAL_32): POINTER
--			-- Try to map contents of `a_filename', returning the file
--			-- descriptor handle.
--		require
--			multiple_of_page_size: a_offset \\ c_page_size.as_natural_32 = 0
--		external
--			"C inline use <fcntl.h>"
--		alias
--			"[
--				unsigned int* r = 0;
--				int* s = (char*)$a_filename;
--				printf ("s = %s \n", s);
--				int flags = O_RDWR | O_SYNC | O_CLOEXEC;
--				int f = open (s, flags);
--				if (f < 0) {
--				    printf ("f = %d     Unable to open %s \n", f, s);
--					r = MAP_FAILED;
--				} else {
--					flags = PROT_READ|PROT_WRITE;
--						// Map 4096 bytes (on page) into virtual memory using the
--						// contents in the file referenced by `f' starting a `a_offset'
--						// within the file.
--					r = (uint32_t *)mmap(0, 4096, flags, MAP_SHARED, f, $a_offset);
--					if (r == MAP_FAILED) {
--						printf ("   c_open_and_mmap:  MAP_FAILED \n");
-- 					} else {
-- 						printf ("   c_open_and_mmap:  Mapping succeeded, r = %p \n", r);
-- 					}
-- 				}
-- 				printf ("    c_open_and_mmap:  r = %p \n", r);
-- 				close(f);
--				return (EIF_POINTER) (r);
--			]"
--		end

--	c_open_dev (a_fd: TYPED_POINTER [INTEGER_32]): INTEGER_32
--			-- Attempt to open the master /dev/... memory control device,
--			-- placing the file descriptor in the value within `a_fd' and
--			-- returning 1 if using "/dev/mem" or 2 if using "/dev/gpiomem".
--			-- Return -1 if neither file could be opened.
--		external
--			"C inline use <fcntl.h>,<sys/mman.h>"
--		alias
--			"[
--				int r = 0;
--			    int v = 0;
--			    	// read-write, synchronized I/O, close descriptor[?]
--			    int flags = O_RDWR | O_SYNC | O_CLOEXEC;
--			    v = open ("/dev/mem", flags);		
--			    if (v < 0) {
--			    		// failed to open "/dev/mem", so look elsewhere
--		    //	printf ("v = %d     Unable to open '/dev/mem' \n", v);
--			    	v = open ("/dev/gpiomem", flags);
--			    	if (v < 0) {
--			    			// failed to open "dev/gpiomem"
--			    		r = -1;
--			//    	printf ("%s", "  Unable to open '/dev/gpio' \n");
--			    	} else {
--			    		r = 2;
--			    	}
--			    } else {
--			    	r = -1;
--			    }
--			    * $a_fd = v;
--			//   printf ("  a_fd = %d    v = %d \n", $a_fd, v);
--			    return (EIF_INTEGER) (r);
--			]"
--		ensure
--			valid_result: Result = state_good or
--							Result = state_degraded or
--							Result = state_failed
--		end

	c_mmap (a_fd: INTEGER_32; a_length: INTEGER_32; a_offset: NATURAL_32): POINTER
			-- Map this hardware component, returning the mapped (i.e. virtual)
			-- address to this paripheral's physical device.
			-- Map `a_length' bytes from the file referenced by `a_fd' starting
			-- at `a_offset'.
		require
			valid_length: a_length > 0
			offset_on_page_boundary: a_offset \\ c_page_size.as_natural_32 = 0
		external
			"C inline use <sys/mman.h> "
		alias
			"[
//				printf ("c_mmap \n");
//				printf ("   a_fd = %d, a_length = %d, a_offset = %d \n",
//							$a_fd, $a_length, $a_offset);
				unsigned int* p;
				p = (uint32_t *)mmap(0, $a_length, PROT_READ|PROT_WRITE, MAP_SHARED, $a_fd, $a_offset);
					// could possibly be MAP_FAILED
				if (p == MAP_FAILED) {
					printf ("   c_mmap  MAP_FAILED \n");
 				}
//				printf ("  value in p = %p     address = %p  \n", &p, p);
					// Return the value referenced by `p'
				return (EIF_POINTER) (p);
			]"
		end

	c_close_dev (a_fd: INTEGER_32)
			-- Close the file opened in `c_open_dev'
		require
			file_descriptor_not_null: a_fd > 0
		external
			"C inline"
		alias
			"[
				close($a_fd);
			]"
		end

	c_munmap (a_pointer: POINTER; a_block_size: INTEGER_32)
			-- Unmapped the area mapped in `c_mmap'.
		require
			valid_pointer: not c_mmap_failed (a_pointer)
		external
			"C inline"
		alias
			"[
				munmap ($a_pointer, $a_block_size);
			]"
		end

	c_mmap_failed (a_pointer: POINTER): BOOLEAN
			-- Is `a_pointer' equal to MAP_FAILED (from sys/mman.h)?
		external
			"C inline use <sys/mman.h> "
		alias
			"[
				return (EIF_BOOLEAN) ($a_pointer == MAP_FAILED);
			]"
		end

	c_page_size: INTEGER_32
			-- The page size in bytes
		external
			"C inline"
		alias
			"[
				return (EIF_INTEGER) (size_t) sysconf (_SC_PAGESIZE);
			]"
		end

invariant

--	using_system_memory_implication: is_using_system_memory implies
--							not (is_using_gpio_memory or is_using_array_memory)
--	using_gpio_memory_implication: is_using_gpio_memory implies
--							not (is_using_system_memory or is_using_array_memory)
--	using_array_memory_implication: is_using_array_memory implies
--							not (is_using_system_memory or is_using_gpio_memory)
--	is_mapped_implication: is_mapped implies (is_using_system_memory or is_using_gpio_memory)

end
