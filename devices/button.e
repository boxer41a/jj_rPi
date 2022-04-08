note
	description: "[
		Represents a button to be pressed or released.
		See FreeNova chapter 2 example.
		]"
	author: "Jimmy J Johnson"
	date: "10/12/20"

class
	BUTTON

create
	connect

feature {NONE} -- Initialization

	connect (a_pin: GPIO_PIN)
			-- Connect Current to `a_pin'
		do
			pin := a_pin
			pin.set_mode ({GPIO_PIN_CONSTANTS}.input)
				-- Pull up the pin to HIGH
-- fix me?		-- Is this really right for all cases?  Probably not!
-- fix me		-- Depends on circuit.
--			pi.set_pull_state (a_pin, {GPIO_PIN_CONSTANTS}.pull_up)
			debounce_time := 1
		end

feature -- Access

--	pi: RASPBERRY_PI
			-- The Raspberry Pi to which Current should be
			-- phyically connected

	pin: GPIO_PIN
			-- The GPIO pin to which Current should be
			-- phyically connected

	debounce_time: INTEGER_32
			-- The time for which `press'

feature -- Status report

	is_activated: BOOLEAN
			-- Is Current in an activated state?

	is_pressed: BOOLEAN
			-- Is Current seeing a low value on `pin'?
		do
			Result := pin.state = {GPIO_PIN_CONSTANTS}.low
		end

	is_released: BOOLEAN
			-- Is Current seeing a high value on `pin'
		do
			Result := pin.state = {GPIO_PIN_CONSTANTS}.high
		end

feature -- Status setting

	set_debounce_time (a_time: like debounce_time)
			-- Set the time for which Current must be pressed in order
			-- to change the state
		do
			debounce_time := a_time
		end

feature -- Basic operations

	debounce
			-- Toggle state if enough time passes before `is_released'
		require
			is_pressed: is_pressed
		local
			n: TIME
			press_t: TIME
			release_t: TIME
			et: INTEGER_32
		do
			create n.make_now
			press_t := n
			release_t := n.deep_twin
			from et := release_t.seconds - press_t.seconds
			until is_released or else et > debounce_time
			loop
					-- Do something in the loop
				release_t.make_now
				et := release_t.seconds - press_t.seconds
			end
			print ("    debounce_time = " + debounce_time.out + "    elapsed time = " + (release_t.seconds - press_t.seconds).out + "%N")
				-- Toggle state if enough time has passed
			if et > debounce_time then
				is_activated := not is_activated
			end
		end

feature {NONE} -- Implementation

	last_state: BOOLEAN
			-- Was the button activated or not with last toggle?

end
