note
	description: "[
		A {TOOL} to isplay informatin about the RPi's `gpio' peripheral
		]"
	author: "Jimmy J. Johnson"
	date: "5/23/26"

class
	GPIO_TOOL

inherit

	TOOL
		rename
			target as gpio
		redefine
			create_interface_objects,
			initialize,
			set_target,
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
			Precursor {TOOL}
			create registers_view
			create temp_view
		end

	initialize
			-- Set up the tool
		do
			Precursor
			disable_history
			split_manager.extend (registers_view)
			split_manager.extend (temp_view)
		end

feature -- Element change

	set_target (a_target: like gpio)
			-- Change the object dislpayed in this tool
		do
			Precursor (a_target)
			registers_view.set_target (gpio)
--			rpi_view.set_target (a_target)
--			processor_view.set_target (a_target.processor)
		end

feature -- Basic operations

	draw
			-- Redraw the view
		do
			Precursor
			registers_view.draw
		end

feature {NONE} -- Implementation

	registers_view: GPIO_REGISTERS_VIEW
			-- Shows info about the RPI

	temp_view: PROCESSOR_VIEW
			--Shows info about the processor

	target_imp: detachable GPIO
			-- Implementation of the `target' which was renamed as `gpio')

end
