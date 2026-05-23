note
	description: "[
		Tool to display information about the rPi for the {RPI_VIEWER}
		]"
	author: "Jimmy J. Johnson"
	date: "4/20/26"

class
	RPI_TOOL

inherit

	TOOL
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
			print ("RPI_TOOL.create_interface_objects %N")
			Precursor {TOOL}
			create rpi_view
			create processor_view
		end

	initialize
			-- Set up the tool
		do
			Precursor
--			disable_history
			split_manager.extend (rpi_view)
			split_manager.extend (processor_view)
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the object dislpayed in this tool
		do
			Precursor (a_target)
			rpi_view.set_target (a_target)
			processor_view.set_target (a_target.processor)
		end

feature {NONE} -- Implementation

	rpi_view: RPI_VIEW
			-- Shows info about the RPI

	processor_view: PROCESSOR_VIEW
			--Shows info about the processor

	target_imp: detachable RPI
			-- Implementation of the `target'

end
