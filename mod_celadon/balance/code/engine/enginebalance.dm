/obj/machinery/power/shuttle/engine/electric/tech1
	name = "1st gen ion thruster"
	desc = "A thruster that expels charged particles to generate thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech1
	icon_state = "tech1"
	icon_state_off = "tech1_off"
	icon_state_closed = "tech1"
	icon_state_open = "tech1_open"
	thrust = 6
	power_per_burn = 35000

/obj/machinery/power/shuttle/engine/electric/tech2
	name = "2nd gen ion thruster"
	desc = "A thruster that expels charged particles to generate thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech2
	icon_state = "tech2"
	icon_state_off = "tech2_off"
	icon_state_closed = "tech2"
	icon_state_open = "tech2_open"
	thrust = 11
	power_per_burn = 100000

/obj/machinery/power/shuttle/engine/electric/tech3
	name = "3rd gen ion thruster"
	desc = "A thruster that expels charged particles to generate thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech3
	icon_state = "tech3"
	icon_state_off = "tech3_off"
	icon_state_closed = "tech3"
	icon_state_open = "tech3_open"
	thrust = 30
	power_per_burn = 250000

/obj/machinery/power/shuttle/engine/electric/huge
	name = "huge thruster"
	desc = "A A thruster that uses insane amount of energy to expel super-accelerated charged particles to generate thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/huge
	icon = 'mod_celadon/_storge_icons/icons/3x3.dmi'
	icon_state = "huge_engine"
	icon_state_off = "huge_engine"
	icon_state_closed = "huge_engine"
	icon_state_open = "huge_engine"
	thrust = 300 //they wouldn't never get its power without t4 components
	power_per_burn = 2400000
	pixel_y = -32
	pixel_x = -32
	bound_y = -32
	bound_x = -32
	bound_height = 96
	bound_width = 96
/obj/machinery/power/shuttle/engine/electric/huge/default_deconstruction_crowbar(obj/item/crowbar/C)
	//you can't crowbar it
	return FALSE

/obj/machinery/power/smes/shuttle/massive
	name = "massive precharger"
	desc = "A high-capacity, high transfer superconducting magnetic energy storage unit specially made for use with shuttle engines."
	input_level = 200000
	input_level_max = 200000
	output_level = 200000
	input_level_max = 400000
	circuit = /obj/item/circuitboard/machine/shuttle/smes/massive

/obj/machinery/power/smes/shuttle/massive/precharged
	charge = 4e6

//фикс движков
/obj/machinery/power/shuttle/engine/electric/premium
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/premium
