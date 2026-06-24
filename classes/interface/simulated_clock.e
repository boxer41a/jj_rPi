note
	description: "[
		A simulated General Purpose GPIO Clock, the PCM Clock or the PWM 
		Clock used by the {SIMULATED_RPI_PROCESSOR}.
		See BCM2711 ARM Peripheral, page 102-105
		See BCM2835 Audio & PWM Clocks, Feb 2013.

		See class {CLOCK} for more details
		]"
	author: "Jimmy J Johnson"
	date: "5/26/26"

class
	SIMULATED_CLOCK

inherit

	CLOCK
		redefine
			controller
		end

create
	make
	
feature {NONE} -- Implementaton

	controller: SIMULATED_CLOCK_CONTROL_REGISTER
			-- The General Purpose Clock Control register

end
