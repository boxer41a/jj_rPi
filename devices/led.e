note
	description: "[
		Provide interface to an LED to be attached to
		and controlled by a Rasberry Pi
	]"
	author: "Jimmy J Johnson"
	date: "10/2/2"

class
	LED

create
	connect

feature {NONE} -- Initialization

	connect (a_pin: GPIO_PIN)
			-- Connect Current to `a_pin'
		do
			pin := a_pin
			pin.set_mode ({GPIO_PIN_CONSTANTS}.output)
		end

feature -- Access

	pin: GPIO_PIN
			-- The pin to which Current should be physically connected

feature -- Status report

	is_on: BOOLEAN
			-- Is Current illuminated?
		do
			Result := pin.state = {GPIO_PIN_CONSTANTS}.high
		ensure
			implication: Result implies pin.state = {GPIO_PIN_CONSTANTS}.high
		end

	is_off: BOOLEAN
			-- Is Current extinguished
		do
			Result := not is_on
		ensure
			implication: Result implies pin.state = {GPIO_PIN_CONSTANTS}.low
		end

feature -- Status setting

	turn_on
			-- Turn the led on
		do
			pin.set_state ({GPIO_PIN_CONSTANTS}.high)
		ensure
			is_on: is_on
		end

	turn_off
			-- Turn the led off
		do
			pin.set_state ({GPIO_PIN_CONSTANTS}.low)
		ensure
			not_on: is_off
		end

feature -- Query

feature -- Basic operations

feature {NONE} -- Implementation

invariant

	is_valid_mode: pin.mode = {GPIO_PIN_CONSTANTS}.output

end
