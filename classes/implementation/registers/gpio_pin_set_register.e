note
	description: "[
		Represents a "GPIO Pin Set" register in the {RPI_PROCESSOR}.
		If a pin is set to output mode, callng `set_pin' sets the pin corresponding
		to the argument is set to High.  If a pin is in input node the result of calling
		`set_pin' is ignored unless the mode of that pin is subsequently set
		to output mode, provided there was not an intervening clear operation 
		performed on that pin by a {GPIO_PIN_CLEAR_REGISTER}.
		See BCM2711 Peripherals.pdf, page 88.
		]"
	author: "Jimmy J Johnson"
	date: "6/1/20"


class
	GPIO_PIN_SET_REGISTER

inherit

	REGISTER

create
	make

feature -- Basic operations

	set_pin (a_pin: INTEGER_32)
			-- Set the state of pin number `a_pin' to High, if the pin is
			-- in output mode.  The effect of this feature could be delayed
			-- until the pin subsequently is set to output mode.
		do
			set_bit (a_pin)
		end

invariant

	is_write_only: is_write_only

end
