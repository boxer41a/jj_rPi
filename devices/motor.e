note
	description: "[
		Interface to control a small DC motor through a L293D 
		motor control chip.  This class controls a single motor
		by changing the values (high or low) output by two GPIO 
		pins and the PWM pulse coming from one of the PWM pins
		(pins 12, 13, 17, or 18).
		
		  ***********************
		1 * Enable 1        VSS * 16
		2 * Input_1     Input 4 * 15
		3 * Output 1   Output 4 * 14
		4 * GND             GND * 13
		5 * GND             GND * 12
		6 * Output 2   Output 3 * 11
		7 * Input 2     Input 3 * 10
		8 * Vs         Enable 2 * 9
		  ***********************
		
		
		 Wire this controller to
		the Raspberry Pi as follows:
		    VSS (pin 16) to 3.3V

	]"
	author: "Jimmy J Johnson"
	date: "10/2/2"

class
	MOTOR

create
	connect

feature {NONE} -- Implementation

	connect (a_pwm_pin, a_input_1, a_input_2: GPIO_PIN)
			-- Create an instance where the value on `a_pwm_pin'
			-- controls the `speed' and the values on `a_input_1'
			-- and `a_input_2' controls the direction
		require
			is_pwm_pin: a_pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm0_0 or else
							a_pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm0_1 or else
		do

		end

feature -- Access


feature -- Basic operations


end
