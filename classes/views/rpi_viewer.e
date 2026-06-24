note
	description: "[
		Used as root class for RPi projects in order to visually 
		monitor the state of peripherals and registers.
		]"
	author: "Jimmy J. Johnson"
	date: "5/28/26"


class
	RPI_VIEWER

inherit

    JJ_APPLICATION
        redefine
--        	prepare,
			target_anchor,
            window_anchor
        end

create
	default_create

feature {NONE} -- Implementation

	target_anchor: RPI
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	window_anchor: VIEWER_MAIN_WINDOW
			-- Anchor for the type of `first_window'
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
