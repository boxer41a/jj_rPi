note
	description: "[
		Main window for the {PI_SIMULATOR_APPLICATION}
		]"
	author: "Jimmy J. Johnson"

class
	PI_MAIN_WINDOW

inherit

	JJ_MAIN_WINDOW
		redefine
			create_interface_objects,
			initialize,
--			initialize_interface,
			add_actions,
			target_imp,
			set_target,
			draw
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
--		local
--			g: VITP_GAME
		do
			Precursor {JJ_MAIN_WINDOW}
			create command_tool_bar
			create pi_tool
--			create {PI_4_CONTROLLER} target_imp
		end

	initialize
			-- Set up the window
		do
			build_commands_tool_bar
			Precursor {JJ_MAIN_WINDOW}
			split_manager.enable_mode_changes
			split_manager.set_vertical
			split_manager.extend (pi_tool)
--			set_target (target)
			set_size (800, 1000)
			set_position (600, 100)
		end

	add_actions
			-- Assign actions to the buttons
		do
			Precursor {JJ_MAIN_WINDOW}
		end

	build_commands_tool_bar
			-- Create and populate the `command_tool_bar'.
		do
--			command_tool_bar.extend (reset_button)
--			command_tool_bar.disable_item_expand (reset_button)
--			command_tool_bar.extend (turn_label)
--			command_tool_bar.extend (reinforce_button)
--			command_tool_bar.disable_item_expand (reinforce_button)
--			command_tool_bar.extend (advance_button)
--			command_tool_bar.disable_item_expand (advance_button)
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the target
		do
			Precursor {JJ_MAIN_WINDOW} (a_target)
			pi_tool.set_target (a_target)
		end

feature -- Basic operations

	draw
			--
		do
			Precursor {JJ_MAIN_WINDOW}
			paint_buttons
		end

feature {NONE} -- Implementation (actions)


feature {NONE} -- Implementation

	paint_buttons
			-- Add/remove appropriate buttons from the bar, enable/disable them,
			-- and set their colors
		do
		end

feature {NONE} -- Implementation

	pi_tool: PI_TOOL
			-- Drawing will be done here.


	command_tool_bar: EV_HORIZONTAL_BOX
			-- Holds buttons for testing some features.

	target_imp: detachable PI_4_CONTROLLER
			-- Implementation of the `target'


end
