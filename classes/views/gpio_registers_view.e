note
	description: "[
		A {VIEW} to display information about the registers used
		by a the GPIO `periperal'
		]"
	author: "Jimmy J. Johnson"
	date: "5/23/26"

class
	GPIO_REGISTERS_VIEW

inherit

	REGISTERS_VIEW
		rename
			peripheral as gpio
		redefine
			create_interface_objects,
			initialize,
--			set_target,
--			draw,
			target_imp
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor
--			create grid
--			create registers_imp.make
		end

	initialize
			-- Set up the view
		local
			f: EV_FONT
		do
			Precursor
		end

feature {NONE} -- Implementation


feature {NONE} -- Implementation

	target_imp: detachable gpio
			-- Implementation of the `target'/`peripheral'/`gpio'

end
