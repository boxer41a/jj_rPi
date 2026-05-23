note
	description: "[
		A {TOOL} to isplay informatin about the RPi's `clocks' peripheral
		]"
	author: "Jimmy J. Johnson"
	date: "5/23/26"

class
	CLOCKS_TOOL

inherit

	TOOL
		rename
			target as clocks
		redefine
			create_interface_objects,
			initialize,
			set_target,
			target_imp
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
            -- bridge pattern.
		do
			Precursor {TOOL}
--			create rpi_view
--			create processor_view
		end

	initialize
			-- Set up the tool
		do
			Precursor
--			disable_history
--			split_manager.extend (rpi_view)
--			split_manager.extend (processor_view)
		end

feature -- Element change

	set_target (a_target: like clocks)
			-- Change the object dislpayed in this tool
		do
			Precursor (a_target)
--			rpi_view.set_target (a_target)
--			processor_view.set_target (a_target.processor)
		end

feature {NONE} -- Implementation

--	rpi_view: RPI_VIEW
			-- Shows info about the RPI

--	processor_view: PROCESSOR_VIEW
			--Shows info about the processor

	target_imp: detachable CLOCKS
			-- Implementation of the `target' which was renamed as `gpio')

end

