note
	description: "[
		A {VIEW} for displaying attributes of a {PI_CONTROLLER}.
		]"
	author: "Jimmy J Johnson"
	date: "11/5/20"

class
	PI_VIEW

inherit

	VIEW
		undefine
			copy
		redefine
			create_interface_objects,
			initialize
		end

	EV_CELL
		undefine
			is_in_default_state
		redefine
			create_interface_objects,
			initialize
		end


feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			create grid
			Precursor {EV_CELL}
			Precursor {VIEW}
		end

	initialize
			-- Set up by calling both precursor versions
		do
			Precursor {EV_CELL}
			Precursor {VIEW}
			extend (grid)
		end

feature {NONE} -- Implementation

	grid: EV_GRID
			-- Holds the data in a table

end
