note
	description: "[
		A view (i.e. a model) to display information about a single register
		for placement in an {JJ_MODEL_WORLD_GRID}.
	]"
	author: "Jimmy J. Johnson"
	date: "10/25/20"

class
	REGISTER_ROW_VIEW

inherit

	JJ_MODEL_WORLD_VIEW
		rename
			target as register
		redefine
			create_interface_objects,
			initialize,
--			set_target,
			draw,
			target_imp
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
            -- bridge pattern.
		do
			Precursor {JJ_MODEL_WORLD_VIEW}
		end

	initialize
			-- Set up the tool
		do
			Precursor
--			disable_history
		end

feature -- Element change

--	set_target (a_target: like target)
--			-- Change the object dislpayed in this tool
--		local
--			p: RPI_PROCESSOR
--		do
--			Precursor (a_target)
--		end

feature -- Basic operations

	draw
			-- Build the view, displaying info about the `register'
		do

		end

feature {NONE} -- Implementation

--	name_text: EV_MODEL_TEXT
--			-- To display the name of the register

--	value_text: EV_MODEL_TEXT

	target_imp: detachable REGISTER
			-- Implementation of the `target' (i.e. the register)

end
