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
	// var/req_plast = TRUE
	// var/req_cables = TRUE
	// var/req_cell = TRUE
	// var/used_cell = null
	var/list/req_comps = list(/obj/item/stack/sheet/plasteel = 20,
	/obj/item/stack/cable_coil = 20,
	)
	var/list/req_stock_parts = list(/obj/item/stock_parts/capacitor,
	/obj/item/stock_parts/scanning_module,
	/obj/item/stock_parts/cell)


/obj/structure/mecha_wreckage/landsknecht/attackby(obj/item/I, mob/user, params)
	for(var/type in req_comps)
		if(istype(I,type))
			if(I.use_tool(src, user, 30, volume=50, amount = req_comps[type]))
				req_comps.Remove(I.type)
				return
			to_chat(user, span_warning("I need at least [req_comps[type]] pieces!"))
			return

	for(var/type1 in req_stock_parts)
		if(istype(I, type1))
			I.forceMove(src)
			req_stock_parts.Remove(type1)
			return


/obj/structure/mecha_wreckage/landsknecht/screwdriver_act(mob/living/user, obj/item/I)
	if(length(req_comps) == 0)
		var/obj/mecha/M = new /obj/mecha/combat/landsknecht(loc)
		QDEL_NULL(M.cell)
		QDEL_NULL(M.scanmod)
		QDEL_NULL(M.capacitor)
		M.CheckParts(contents)
		SSblackbox.record_feedback("tally", "mechas_created", 1, M.name)
		qdel(src)
	. = ..()

/obj/mecha/combat/landsknecht/mechturn(direction)
	. = ..()
	if(!strafe && !occupant.client.keys_held["Alt"])
		mechstep(direction) //agile mechs get to move and turn in the same step
