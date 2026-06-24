note
	description: "[
		A Clock Manager General Purpose Clock Control register for the
		Raspberry Pi with a {SIMULATED_PROCESSOR}.
		See BCM2711 ARM Peripherals.pdf, page 104.
		]"
	author: "Jimmy J Johnson"
	date: "4/26/26"

class
	SIMULATED_CLOCK_CONTROL_REGISTER

inherit

	CLOCK_CONTROL_REGISTER
		redefine
			enable,
			disable
		end

create
	make

feature -- Status setting

	 enable
			-- Enable the clock generator (i.e. turn it on)
			-- Request the clock to start after the clock cycle completes.
			-- Waiting for cycle completion avoids glitches, but requires this feature
			-- to `wait' for a short time to allow the "busy" bit to become set.
		local
			v: like value
		do
				-- Set the "ENAB" bit; no Precursor call avoids post-conditions
			set_bit (4)
				-- To simulate the operation, set the busy bit (i.e. bit 7).
				-- Calling the C features directly, bypasses preconditions
				-- that would be imposed by a call to `set_value'.
			v := c_register_value (address)
			v := v.bit_or (0x00000080)	-- change only bit-7 (i.e. set it)
			c_set_register_value (address, v)
		end

	 disable
			-- Disable the clock generator (i.e. turn it off)
			-- Request the clock to stop after the clock cycle completes.
			-- Waiting for cycle completion avoids glitches, but requires this feature
			-- to `wait' for a short time to allow the "busy" bit to clear.
		local
			v: like value
		do
				-- Clear the "ENAB" bit; no Precursor call avoids post-conditions
			clear_bit (4)
				-- To simulate the operation, clear the busy bit (i.e. bit 7).
				-- Calling the C features directly, bypasses preconditions
				-- that would be imposed by a call to `set_value'.
			v := c_register_value (address)
			v := v.bit_and (0xFFFFFF7F)	-- change only bit 7 (i.e. clear it)
			c_set_register_value (address, v)
		end

end
