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
--			create_interface_objects,
--			initialize,
--			set_target,
			fill_grid,
--			draw,
			target_imp
		end

feature {NONE} -- Implementation

	fill_grid
			--	Add register rows to the `grid'
		local
--			r: REGISTER
		do
				-- Create a register row for each register

		end

	target_imp: detachable gpio
			-- Implementation of the `target'/`peripheral'/`gpio'

end
