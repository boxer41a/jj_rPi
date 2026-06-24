note
	description: "[
		Tool to display the peripherals
		]"
	author: "Jimmy J. Johnson"
	date: "4/23/26"
class
	PERIPHERAL_TOOL

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
			Precursor {TOOL}
			create gpio_tool
			create clocks_tool
			create pwm_tool
		end

	initialize
			-- Set up the tool
		do
			Precursor
--			disable_history
			split_manager.extend (gpio_tool)
--			split_manager.extend (clocks_tool)
--			split_manager.extend (pwm_tool)
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the object dislpayed in this tool
		local
			env: EV_ENVIRONMENT
			p, p2: RPI_PROCESSOR
		do
			if not is_view_empty then
				p2 := target.processor
			end
			Precursor (a_target)
			p := target.processor
			gpio_tool.set_target (p.gpio)
			clocks_tool.set_target (p.clocks)
			pwm_tool.set_target (p.pwm)
			if not has_idle_actions then
				create env
				check attached env.application as a then
					a.add_idle_action (agent gpio_tool.draw)
				end
				has_idle_actions := True
			end
		end

feature {NONE} -- Implementation

	has_idle_actions: BOOLEAN
			-- Have actions to be performed on idle been added to Current?

	gpio_tool: GPIO_TOOL
			-- Shows info about the RPI's `gpio' peripheral

	clocks_tool: CLOCKS_TOOL
			-- Shows info about the RPI's `clocks' peripheral

	pwm_tool: PWM_TOOL
			-- Show info about the RPI's `pwm' peripheral

	target_imp: detachable RPI
			-- Implementation of the `target'

end
