note
	description: "[
		A {VIEW} to display information about the registers used
		by a `periferal'
		]"
	author: "Jimmy J. Johnson"
	date: "5/23/26"

class
	REGISTERS_VIEW

inherit

	JJ_MODEL_WORLD_CELL_VIEW
		rename
			target as peripheral
		redefine
			create_interface_objects,
			initialize,
			set_target,
			draw,
			target_imp
		end

create
	default_create

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
--			world.extend (grid.world)
		end

feature -- Element change

	set_target (a_target: like peripheral)
			-- Change the target (i.e. the `peripheral') whose registers
			-- are displayed by Current
		do
			fill_grid
			Precursor (a_target)
		end

feature -- Basic operations

	draw
			-- Show information about the `target' (i.e. the RPI)
		local
			s: STRING
		do
				-- Build the table

		end

feature {NONE} -- Implementation

--	grid: JJ_MODEL_WORLD_GRID
			-- Grid/table which displays the registers

	fill_grid
			--	Add register rows to the `grid'
		do
		end

	target_imp: detachable PERIPHERAL
			-- Implementation of the `target'

end

