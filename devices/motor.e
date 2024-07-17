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

	connect (a_pwm_pin, a_pin_1, a_pin_2: GPIO_PIN)
			-- Create an instance where the value on `a_pwm_pin'
			-- controls the `speed' and the values on `a_pin_1'
			-- and `a_pin_2' controls the direction
		require
			is_pwm_pin: a_pwm_pin.is_set_for_pwm
			pin_1_is_output: a_pin_1.mode = {GPIO_PIN_CONSTANTS}.output
			pin_2_is_output: a_pin_2.mode = {GPIO_PIN_CONSTANTS}.output
		do
			pwm_pin := a_pwm_pin
			pin_1 := a_pin_1
			pin_2 := a_pin_2
			pwm := pwm_pin.pi.pwm
			pwm.set_range (pwm_index, pwm_channel, 100)
		end

feature -- Access

	pwm_pin: GPIO_PIN
			-- The GPIO pin connected to one of the enable terminals
			-- of the L293D motor-control chip.  This pin sends the PWM
			-- pulse from the Raspberry Pi.

	pin_1: GPIO_PIN
			-- One of the two GPIO pins connected to one of the input
			-- terminals of the L293D motor-control chip.

	pin_2: GPIO_PIN
			-- One of the two GPIO pins connected to one of the input
			-- terminals of the L293D motor-control chip.

	speed: NATURAL_32
			-- The speed as a percent of the motor's maximum speed at
			-- which it should run if not `is_stopped'

	pwm_channel: INTEGER
			-- The pwm channel used by Current
			-- Convenience feature to access attribute of `pwm_pin'
		do
			Result := pwm_pin.pwm_channel
		ensure
			valid_result: Result = 1 or else Result = 2
			sefinition: Result = pwm_pin.pwm_channel
			definition_zero: Result = 1 implies pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm0_0 or
											pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm0_1
			definition_one: Result = 2 implies pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm1_0 or
											pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm1_1
		end

	pwm_index: INTEGER
			-- PWM number 0 or 1 in use of the `pwm_channel'
			-- Convenience feature to access attribute of `pwm_pin'
		do
			Result := pwm_pin.pwm_index
		ensure
			valid_result: Result = 0 or else Result = 1
			sefinition: Result = pwm_pin.pwm_index
			definition_zero: Result = 0 implies pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm0_0 or
											pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm1_1
			definition_one: Result = 1 implies pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm0_1 or
											pwm_pin.function = {GPIO_PIN_CONSTANTS}.pwm1_1
		end

feature -- Element change

	set_pwm_pin (a_pin: GPIO_PIN)
			-- Set the `pwm_pin'
		require
			is_pwm_pin: a_pin.is_set_for_pwm
		do
			pwm_pin := a_pin
		ensure
			pin_assigned: pwm_pin = a_pin
		end

	set_speed (a_speed: like speed)
			-- Set the `speed' (in percent of the motore's max speed) at
			-- which the motore should run when it is running
		require
			speed_fast_enough: a_speed >= 0
			speed_slow_enough: a_speed <= 100
		do
			speed := a_speed
			pwm.set_data (pwm_index, pwm_channel, speed)
		ensure
			assigned: speed = a_speed
		end

feature -- Status report

	is_running: BOOLEAN
			-- Should the motor be running?
			-- True if the state of `input_pin_1' and `input_pin_2' are
			-- both High or both Low.
		do
			Result := not is_stopped
		ensure
-- 			definition: not is_stopped
		end

	is_stopped: BOOLEAN
			-- Should the motor be stopped?
		do
			Result := pin_1.state = pin_2.state
		ensure
--			definition: Result implies (pin_1.state = pin_2.state or speed = 0)
		end

	is_reversed: BOOLEAN
			-- Is the motor running in reverse (arbitrarily picked).
		do
			Result := pin_1.state = {GPIO_PIN_CONSTANTS}.Low and pin_2.state = {GPIO_PIN_CONSTANTS}.High
		ensure
			definition: Result implies pin_1.state = {GPIO_PIN_CONSTANTS}.Low and pin_2.state = {GPIO_PIN_CONSTANTS}.High
		end

feature -- Basic operations

	run_forward
			-- Ensure the motor runs in the forward direction at
			-- its current `speed'
		do
			pin_1.set_state ({GPIO_PIN_CONSTANTS}.High)
			pin_2.set_state ({GPIO_PIN_CONSTANTS}.Low)
		ensure
			not_reversed: not is_reversed
			is_running: speed > 0 implies is_running
			pin_1_state: pin_1.state = {GPIO_PIN_CONSTANTS}.High
			pin_2_state: pin_2.state = {GPIO_PIN_CONSTANTS}.Low
		end

	run_backward
			-- Ensure the motor runs in the backward direction at
			-- its current speed
		do
			pin_1.set_state ({GPIO_PIN_CONSTANTS}.Low)
			pin_2.set_state ({GPIO_PIN_CONSTANTS}.High)
		ensure
			not_reversed: not is_reversed
			is_running: speed > 0 implies is_running
		end

	stop
			-- Stop the motor; don't change the speed or direction
		do
			pin_1.set_state ({GPIO_PIN_CONSTANTS}.Low)
			pin_2.set_state ({GPIO_PIN_CONSTANTS}.Low)
		ensure
			is_stopped: is_stopped
		end

	show
			-- Display info about Current
		do
			print ("{MOTOR}.show:%N")
			print ("%T pin_1:  " + pin_1.name + " = " + pin_1.state.out + "%N")
			print ("%T pin_2:  " + pin_2.name + " = " + pin_2.state.out  + "%N")
			print ("%T pwm_channel:  " + pwm_channel.out + "%N")
			print ("%T pwm_index:  " + pwm_index.out + "%N")
			print ("%T speed:  " + speed.out + "%N")
			print ("%T is_running:  " + is_running.out + "%N")
			print ("%T is_stopped:  " + is_stopped.out + "%N")
			print ("%T is_reversed:  " + is_reversed.out + "%N")
		end

feature -- Query


feature {NONE} -- Implementation

	pwm: PWM
			-- Convinience feature to access the PWM peripheral of the Pi

invariant

	is_pwm_pin: pwm_pin.is_set_for_pwm


end
