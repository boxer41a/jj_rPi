note
	description: "[
		A {VIEW} to display information about the RPi for
		the {RPI_VIEWER}
		]"
	author: "Jimmy J. Johnson"
	date: "5/21/26"

class
	RPI_VIEW

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
			s := s + "  Revision_code:  " + target.revision_code.to_binary_string + "%N"
			s := s + "%N"
			if target.revision_code /= 0xFFFFFFFF then
				s := s + "  No revision information available %N"
				s := s + "  must be in test mode. %N"
			else
				s := s + "  Model:  " + target.model_string + "%N"
				s := s + "  Manufacturer:  " + target.manufacturer_string + "%N"
				s := s + "  Processor:  " + target.processor_string + "%N"
				s := s + "  Revision:  " + target.revision_string + "%N"
				s := s + "%N"
				s := s + "  Overvoltage Allowed:  " + target.is_overvoltage_allowed.out + "%N"
				s := s + "  OTP Programming Allowed:  " + target.is_otp_programming_allowed.out + "%N"
				s := s + "  OTP Reading Allowed:  " + target.is_otp_reading_allowed.out + "%N"
				s := s + "  Warranty Voided:  " + target.is_warranty_voided.out + "%N"
				s := s + "  New Revision Style:  " + target.is_new_style.out + "%N"
			end
				-- Put it into the view
			text.set_text (s)
		end

feature {NONE} -- Implementation

	text: EV_MODEL_TEXT
			-- The text to display in the view

	target_imp: detachable RPI
			-- Implementation of the `target'

end
