note
	description: "[
		A {VIEW} to display information about the registers used
		by a `periferal'
		]"
	author: "Jimmy J. Johnson"
	date: "5/23/26"

class
	REGISTERS_VIEW

inherit

	JJ_GRID_VIEW
		rename
			target as peripheral
		redefine
			create_interface_objects,
			initialize,
			set_target,
			draw,
			target_imp,
			row_type
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor
--			create grid
--			create registers_imp.make
		end

	initialize
			-- Set up the view
		local
			f: EV_FONT
		do
			Precursor
			enable_tree
			set_column_count_to (4)
			set_row_count_to (0)
			column (1).set_title ("Address")
			column (2).set_title ("Name")
			column (3).set_title ("Description")
			column (4).set_title ("Value")
		end

feature -- Element change

	set_target (a_target: like peripheral)
			-- Change the target (i.e. the `peripheral') whose registers
			-- are displayed by Current
		do
			Precursor (a_target)
			build_rows
			draw
		end

feature -- Basic operations

	draw
			-- Show information about the `target' (i.e. the `register')
		local
			i: INTEGER
			r_list: LINEAR [REGISTER]
			r: REGISTER
		do
			print (generating_type.name_32.out + ":  draw %N")
			Precursor {JJ_GRID_VIEW}
			if row_count > 0 then
					-- Rows have been added
				r_list := peripheral.registers
				from
					i := 1
					r_list.start
				until r_list.after
				loop
					r := r_list.item_for_iteration
					check attached {REGISTER_ROW_VIEW} row (i) as rrv then
						rrv.set_target (r)
						if attached {RESERVED_REGISTER} r then
							rrv.set_background_color (create {EV_COLOR}.make_with_rgb (0.95, 0.95, 0.95))
						end
	--					rrv.set_item (1, create {EV_GRID_LABEL_ITEM}.make_with_text (r.address.out))
	--					rrv.set_item (2, create {EV_GRID_LABEL_ITEM}.make_with_text (r.name))
	--					rrv.set_item (4, create {EV_GRID_LABEL_ITEM}.make_with_text (r.value.to_binary_string))
					end
					i := i + 1
					r_list.forth
				end
				from i := 1
				until i > column_count
				loop
					if i /= 2 then
						column (i).resize_to_content
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	build_rows
			--	Put info into the rows of the grid
		local
			i: INTEGER
			r_list: LINEAR [REGISTER]
		do
				-- Add a row for each register
			r_list := peripheral.registers
			from
				i := 1
				r_list.start
			until r_list.after
			loop
				if i > row_count then
					insert_new_row (i)
				end
				i := i + 1
				r_list.forth
			end
		end

	target_imp: detachable PERIPHERAL
			-- Implementation of the `target'

feature {NONE} -- Implementation

	row_type: REGISTER_ROW_VIEW		--JJ_GRID_ROW	--  EV_GRID_ROW
			-- Type used for row objects.
			-- May be redefined by EV_GRID descendents.
		require else
			callable: False
		do
			check
				do_not_call: False then
			end
		end

end

