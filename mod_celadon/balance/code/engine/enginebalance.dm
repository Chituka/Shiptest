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
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech3
	icon = 'mod_celadon/_storge_icons/icons/3x3.dmi'
	icon_state = "huge_engine"
	icon_state_off = "huge_engine"
	icon_state_closed = "huge_engine"
	icon_state_open = "huge_engine"
	thrust = 40
	power_per_burn = 2500000
	pixel_y = -32
	pixel_x = -64
	//bound_width = 32
	//bound_x = -64
	bound_height = 96
	bound_width = 96
/*
/obj/machinery/power/shuttle/engine/electric/huge/Initialize()
	//Copy-paste from DNA vault... Yeah. I don't really remember other big machinery that works and doesn't have borken
	var/list/occupied = list()
	for(var/direct in list(EAST,WEST,SOUTHEAST,SOUTHWEST))
		occupied += get_step(src,direct)
	occupied += locate(x+1,y-2,z)
	occupied += locate(x-1,y-2,z)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F
*/
