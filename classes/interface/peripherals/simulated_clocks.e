note
	description: "[
		Contains the clocks in the {SIMULATED_RPI_PROCESSOR}.

		This class simulates ALL three GPIO clocks [for the 2711] and the
		PCM and PWM clocks, because they all are defined from the same
		base address.
		]"
	author: "Jimmy J Johnson"
	date: "10/17/20"

class
	SIMULATED_CLOCKS
	
inherit

	CLOCKS
		redefine
			clock_0,
			clock_1,
			clock_2,
			pcm_clock,
			pwm_clock
		end

create
	make
	
feature {NONE} -- Implementation

	 clock_0: SIMULATED_CLOCK
			-- One of three GPIO clocks

	clock_1: SIMULATED_CLOCK
			-- One of three GPIO clocks

	clock_2: SIMULATED_CLOCK
			-- One of three GPIO clocks

	pcm_clock: SIMULATED_CLOCK
			-- The Pulse Code Modulator clock

	pwm_clock: SIMULATED_CLOCK
			-- The Pulse Width Modulator clock	

end
