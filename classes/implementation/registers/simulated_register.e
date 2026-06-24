note
	description: "[
		Simulates a {REGISTER} for use in a {SIMPLATED_PROCESSOR},
		giving access to features that are not exported from {REGISTER}.
		]"
	author: "Jimmy J Johnson"
	date: "4/26/26"

class
	SIMULATED_REGISTER
	
inherit

	REGISTER
		export
			{ANY}
				all
		end
		
create
	make

end
