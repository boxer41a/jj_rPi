note
	description: "[
		Tool to display attributes of a {PI_CONTROLLER}
		]"
	author: "Jimmy J Johnson"
	date: "11/5/20"

class
	PI_TOOL

inherit

	TOOL
		redefine
			create_interface_objects,
			set_target,
			target_imp
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
			-- bridge pattern.
		do
			Precursor {TOOL}
			create pi_view
		end

feature -- Element change

	set_target (a_pi: like target)
			-- Change the value of `target' and add it to the `target_set' (the set
			-- of objects contained in this view.  The old target is removed from
			-- the set.
		do
			Precursor {TOOL} (a_pi)
			pi_view.set_target (a_pi)
		end

feature -- Basic operations

feature {NONE} -- Implementation

feature {NONE} -- Implementation

	pi_view: PI_VIEW
			-- The {VIEW} inside Current that actually displays
			-- attributes of the `target'

	target_imp: detachable PI_CONTROLLER
			-- Implementation of the `target'

end
