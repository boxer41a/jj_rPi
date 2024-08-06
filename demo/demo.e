note
	description: "a_rPi application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	DEMO

inherit

	SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			clear_screen
--			pi.pin_17.set_state (0)
--			pi.show_revision_information
			chap_1_led (10)
--			run_register_tests
--			run_gpio_tests
--			chap_2_button_and_led (20)
--			chap_2_debounce_button_and_led (10)
			if not pi.is_degraded_mode then
--				chap_4_pwm_led (1)
				pwm_motor_run (4)
			end
				-- Run test routines
			print ("End program %N")
		end

feature -- Access

--	pi: PI_4_CONTROLLER
			-- To test the system

feature -- Basic operations

	clear_screen
			-- Write some blank lines to move previous outputs
			-- off the top of the terminal window.
		local
			i: INTEGER
		do
			from i := 1
			until i > 40
			loop
				print ("%N")
				i := i + 1
			end
		end

	run_register_tests
			-- Run tests on {REGISTER}
		local
			t: REGISTER_TESTS
		do
			create t
			t.run_all
		end

	run_gpio_tests
			-- Run test of the {GPIO} features
		local
			t: GPIO_TESTS
		do
			create t
			t.test_pull_state_features
			t.test_mode_features
			t.test_signal_features
		end

 	chap_1_led (a_count: INTEGER)
			-- Blink the led `a_count' times
		local
			i: INTEGER_32
			led: LED
		do
			print ("Blink an LED %N")
			create led.connect (pi.pin_18)
			from i := 1
			until i > a_count
			loop
				led.turn_on
				print ("LED should be ON %N")
				sleep
				sleep
				led.turn_off
				print ("LED should be OFF %N")
				sleep
				i := i + 1
			end
		end

	chap_2_button_and_led (a_count: INTEGER_32)
			-- Light an LED when button is pressed.
			-- Only runs for `a_count' "time".
		local
			i: INTEGER_32
			led: LED
			button: BUTTON
		do
			print ("Hold button to turn LED on/off %N")
			create led.connect (pi.pin_1)
			create button.connect (pi.pin_18)
			from i := 1
			until i > a_count
			loop
				if button.is_pressed then
					led.turn_on
					print ("  " + i.out + ".  Button is pressed.  LED should be on.  %N")
				else
					led.turn_off
					print ("  " + i.out + ".  Button is released.  LED should be off %N")
				end
				sleep
				i := i + 1
			end
			print ("%N")
		end

	chap_2_debounce_button_and_led (a_count: INTEGER_32)
			-- Toggle an LED, but only after the button has been held
			-- down a certain amount of time.
		local
			i: INTEGER_32
			led: LED
			button: BUTTON
		do
				-- Use default debounce time from {BUTTON}
			print ("Press button for more than 1 second to toggle LED on/off %N")
			create led.connect (pi.pin_17)
			create button.connect (pi.pin_18)
			from i := 1
			until i > a_count
			loop
				if button.is_pressed then
					print (i.out + ".  Button pressed %N")
					button.debounce
					if button.is_activated then
						led.turn_on
						print ("     Button activated; LED should be on %N")
					else
						led.turn_off
						print ("     Button NOT activated; LED should be off %N")
					end
				end
--				sleep
				i := i + 1
			end
			led.turn_off
			print ("%N")
		end

-- Send clock signal to a GPIO Pin
--	#define CM_GP0CTL (*(volatile uint32_t *)0x20101070)
--	#define CM_GP0DIV (*(volatile uint32_t *)0x20101074)

--	CM_GP0CTL=CM_GP0CTL&~0x10; // Turn off enable flag.
--	while(CM_GP0CTL&0x80); // Wait for busy flag to turn off.
--	CM_GP0DIV=0x5a000000|(10<<12); // Configure divider.
--	CM_GP0CTL=0x5a000206; // Source=PLLD (500 MHz), 1-stage MASH.
--	CM_GP0CTL=0x5a000216; // Enable clock.
--	while(!(CM_GP0CTL&0x80)); // Wait for busy flag to turn on.

--	SetGPIOAlternateMode(4,0);



	chap_4_pwm_led (a_count: INTEGER_32)
			-- Make an LED get bright then dim `a_count' times.
			-- This uses a clock and PWM.
		local
			i: INTEGER_32
			v: NATURAL_32
			n: NATURAL_32
		do
			print ("LED should get bright then dim %N")
			pi.clocks.show ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			pi.clocks.disable ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			pi.clocks.set_frequency ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index, 500_000, 0)
			pi.pwm.enable_channel (0, 1)
			pi.clocks.enable ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			pi.pin_18.set_mode ({GPIO_PIN_CONSTANTS}.alt5)
--			pi.clocks.show ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
--			pi.pwm.show (0, 1)
				-- Do it `a_count' times
			from i := 1
			until i > a_count
			loop
				n := pi.pwm.range (0, 1)
				from v := 0
				until v > n
				loop
					pi.pwm.set_data (0, 1, v)	-- sets data register
--					pi.pwm.show (0, 1)
					v := v + 1
					sleep
				end
					-- Decrease brightness
				from v := n
				until v <= 0
				loop
					pi.pwm.set_data (0, 1, v)	-- sets data register
--					pi.pwm.show (0, 1)
					v := v - 1
					sleep
				end
				i := i + 1
					-- For competeness, go down to zero
				pi.pwm.set_data (0, 1, 0)		-- sets data register
			end
			pi.pwm.disable_channel (0, 1)
			pi.clocks.disable ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			print ("%N")
		end

	pwm_motor_run (a_count: INTEGER_32)
			-- Control a dc motor with PWM.
			-- This uses a clock and PWM.
		local
			i: INTEGER_32
			v: NATURAL_32
			n: NATURAL_32
			mot: MOTOR
			enab, in_1, in_2: GPIO_PIN
		do
			print ("%N")
			print ("DEMO.pwm_motor_run %N")
			enab := pi.pin_18
			in_1 := pi.pin_12
			in_2 := pi.pin_16
--			pi.clocks.show ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
				-- Set up
			pi.clocks.disable ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			pi.clocks.set_frequency ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index, 500_000, 0)
			pi.pwm.enable_channel (0, 1)
			pi.clocks.enable ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			enab.set_mode ({GPIO_PIN_CONSTANTS}.alt5)
			in_1.set_mode ({GPIO_PIN_CONSTANTS}.output)
			in_2.set_mode ({GPIO_PIN_CONSTANTS}.output)
			create mot.connect (enab, in_1, in_2)
--			pi.clocks.show ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
--			pi.pwm.show (0, 1)
				-- Do it `a_count' times
			from i := 1
			until i > a_count
			loop
				if mot.is_reversed then
					mot.run_forward
				else
					mot.run_backward
				end
				n := 100
				from v := 0
				until v > n
				loop
					mot.set_speed (v)
--					print ("moter speed = " + mot.speed.out + "%N")
--					pi.pwm.show (0, 1)
					mot.show
					v := v + 5
					sleep
					sleep
				end
				i := i + 1
			end
			mot.stop
			mot.show
			pi.pwm.disable_channel (0, 1)
			pi.clocks.disable ({GPIO_CLOCK_CONSTANTS}.clock_pwm_index)
			print ("%N")
			enab.set_mode ({GPIO_PIN_CONSTANTS}.output)
		end

feature {NONE} -- Implementation

	Sleep
			-- Pause execution
		do
			{EXECUTION_ENVIRONMENT}.sleep ({INTEGER_64} 300_000_000)
		end

end
