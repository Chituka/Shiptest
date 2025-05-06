/obj/mecha/combat/landsknecht
	desc = "A light security exosuit manufactured by Cybersun Biodynamics. The basic version of the 500 Series combat exosuits, the 501p can overload its leg actuators to further enhance mobility."
	name = "\improper 502p heavily modified Exosuit"
	icon = 'mod_celadon/_storge_icons/icons/landsknecht.dmi'
	icon_state = "landsknecht"
	step_in = 2
	dir_in = 1
	max_integrity = 300
	deflect_chance = 5
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10, "energy" = 15, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	max_temperature = 25000
	leg_overload_coeff = 80
	infra_luminosity = 6
	force = 25
	wreckage = /obj/structure/mecha_wreckage/landsknecht
	internal_damage_threshold = 35
	max_equip = 3
	base_step_energy_drain = 6 //Немного меньше, чем у гигакса из-за всех облегчений брони

/obj/mecha/combat/landsknecht/Initialize(obj/item/stock_parts/cell/C)
	. = ..()
	add_cell(C)

/obj/structure/mecha_wreckage/landsknecht
	name = "Landsknecht wreckage"
	desc = "Remains of some unfortunate mecha. Although, this one looks like it can still be repaired."
	icon = 'mod_celadon/_storge_icons/icons/landsknecht.dmi'
	icon_state = "landsknecht-broken"
	var/req_plast = TRUE
	var/req_cables = TRUE
	var/req_cell = TRUE
	var/used_cell = null

/obj/structure/mecha_wreckage/landsknecht/attackby(obj/item/stack/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/sheet/plasteel))
		if(!req_plast)
			to_chat(user, span_danger("I already fixed everything I could with plasteel!"))
			return

		if(I.amount >= 20)
			I.use_tool(src, user, 30, volume=50, amount=20)
			req_plast = FALSE
			to_chat(user, span_danger("Trying to patch this scrap up..."))
			return

		to_chat(user, span_danger("I need at least 20 plasteel sheets!"))
		return


	if(istype(I, /obj/item/stack/cable_coil))
		if(!req_cables)
			to_chat(user, span_danger("I already did all the wiring!"))
			return

		if(I.amount >= 20)
			to_chat(user, span_danger("Doing my best at wiring this mess..."))
			I.use_tool(src, user, 30, volume=50, amount=20)
			req_cables = FALSE
			return

		to_chat(user, span_danger("I need at least 20 cable pieces!"))
		return


	if(istype(I, /obj/item/stock_parts/cell))
		if(!req_cell)
			to_chat(user, span_danger("Cell is already installed!"))
			return
		to_chat(user, span_danger("Where the hell do I install the cell..."))
		I.use_tool(src, user, 30, volume=50, amount=1)
		used_cell = I
		req_cell = FALSE
		qdel(I)
		return
	if(istype(I, /obj/item/screwdriver))
		return
	else
		to_chat(user, span_danger("It doesn't belong here!"))
		return

/obj/structure/mecha_wreckage/landsknecht/screwdriver_act(mob/living/user, obj/item/I)
	if(!req_plast && !req_cables && !req_cell)
		new /obj/mecha/combat/landsknecht(loc, used_cell)
		qdel(src)
	. = ..()

/obj/mecha/combat/landsknecht/mechturn(direction)
	. = ..()
	if(!strafe && !occupant.client.keys_held["Alt"])
		mechstep(direction) //agile mechs get to move and turn in the same step
