note
	description: "[
		A {VIEW} to display information about the RPi for
		the {RPI_VIEWER}
		]"
	author: "Jimmy J. Johnson"
	date: "5/21/26"

class
	PROCESSOR_VIEW
inherit

	JJ_MODEL_WORLD_CELL_VIEW
		redefine
			create_interface_objects,
			initialize,
			draw,
			target_imp
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor
			create text
		end

	initialize
			-- Set up the view
		local
			f: EV_FONT
		do
			Precursor
			world.extend (text)
			create f
			f.set_height (30)
			text.set_font (f)
		end

feature -- Basic operations

	draw
			-- Show information about the `target' (i.e. the RPI)
		local
			s: STRING
		do
				-- Build the string
			s := "%N%N"
			s := s + "  Processor:  " + target.generating_type.name + "%N"
			s := s + "%N"
			s := s + "    Peripheral Base Address:  " + target.peripheral_base_address.to_hex_string + "%N"
			s := s + "    GPIO offset:  " + target.gpio_offset.to_hex_string + "%N"
			s := s + "    GPIO Clocks Offset:  " + target.gpio_clocks_offset.to_hex_string + "%N"
			s := s + "    PWM offset:  " + target.gpio_offset.to_hex_string + "%N"
			s := s + "%N"
			s := s + "    is_degraded_mode:  "  + target.is_degraded_mode.out + "%N"
			s := s + "    is_periferal_inialization_failed:  " + target.is_peripheral_initialization_failed.out + "%N"
				-- Put it into the view
			text.set_text (s)
		end

feature {NONE} -- Implementation

	text: EV_MODEL_TEXT
			-- The text to display in the view

	target_imp: detachable RPI_PROCESSOR
			-- Implementation of the `target'

end
