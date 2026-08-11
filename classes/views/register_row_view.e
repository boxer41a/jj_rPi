note
	description: "[
		A view (i.e. a model) to display information about a single register
		for placement in an {JJ_MODEL_WORLD_GRID}.
	]"
	author: "Jimmy J. Johnson"
	date: "5/24/26"

class
	REGISTER_ROW_VIEW

inherit

	JJ_GRID_ROW
		rename
			target as register
		redefine
			create_interface_objects,
			initialize,
			set_target,
			draw,
			target_imp
		end

create
	default_create,
	make

--create {JJ_MODEL_WORLD_VIEW}
--	list_make

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation
            -- bridge pattern.
 		do
			Precursor
			create address_text
			create name_text
			create description_text
			create value_text
			create bit_texts.make (0)
		end

	initialize
			-- Set up the tool
       local
        	i: INTEGER
		do
			Precursor
			from i := 1
			until i > 32
			loop
				bit_texts.extend (create {EV_GRID_LABEL_ITEM}.make_with_text ("9"))
				i := i + 1
			end
		end

feature -- Element change

	set_target (a_target: like register)
			-- Change the object dislpayed in this tool
		local
			i: INTEGER
		do
			Precursor (a_target)
			check
				is_in_grid: parent /= Void
			end
			if not is_items_added then
				set_item (1, address_text)
				set_item (2, name_text)
				set_item (3, description_text)
				set_item (4, value_text)
--				from i := 1
--				until i > 32
--				loop
--					set_item (3 + i, bit_texts [i])
--					i := i + 1
--				end
					-- set margins
				from i := 1
				until i > 3
				loop
					check attached {EV_GRID_LABEL_ITEM}  item (i) as it then
						it.set_left_border (10)
						it.set_right_border (10)
						if i /= 3 then
--							it.align_text_center
						end
					end
					i := i + 1
				end
				is_items_added := true
			end
			draw
		end

feature -- Basic operations

	draw
			-- Build the view, displaying info about the `register'
		do
			Precursor
			address_text.set_text (register.address.out)
			name_text.set_text (register.name)
--			name_text.set_text (create {STRING}.make_from_separate (register.name))
			description_text.set_text (register.description)
--			description_text.set_text (create {STRING}.make_from_separate (register.description))
			if register.is_readable then
--				draw_bits
--				value_text.set_text (create {STRING}.make_from_separate (register.value.to_binary_string))
				value_text.set_text (register.value.to_binary_string)
			end
		end

feature {NONE} -- Implementation

	draw_bits
			-- Display each bit value in the register
		local
			i: INTEGER
		do
			from i := 1
			until i > 32
			loop
				bit_texts [i].set_text (register.bit_value (i - 1).out)
				i := i + 1
			end
		end

	is_items_added: BOOLEAN
			-- Flag saying that Current contains the text fields.
			-- Unable to add them until Current is in a grid, so add on first call
			-- to draw and set this flag there.

	address_text: EV_GRID_LABEL_ITEM
			-- T display the address of the register

	name_text: EV_GRID_LABEL_ITEM
			-- To display the name of the register

	description_text: EV_GRID_LABEL_ITEM
			-- To display the description of the register

	value_text: EV_GRID_LABEL_ITEM
			-- To display the value

	bit_texts: ARRAYED_LIST [EV_GRID_LABEL_ITEM]
			-- Holds ev_text items for displaying a single bit

	target_imp: detachable REGISTER
			-- Implementation of the `target' (i.e. the register)

end
