/obj/mecha/combat/landsknecht
	desc = "A light combat exosuit manufactured by Cybersun Biodynamics for Syndicate and modified by GEC for simplified maintenance and repair after destruction. \n\
			Leg actuators are modified for faster movement and dashes, however latter may lead to exo failure. \n\
			Lightweight, streamlined, yet still unique."
	name = "\improper 502p heavily modified Exosuit"
	icon = 'mod_celadon/_storge_icons/icons/landsknecht.dmi'
	icon_state = "landsknecht"
	step_in = 2
	dir_in = 1
	max_integrity = 300
	deflect_chance = 5
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10, "energy" = 15, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	max_temperature = 25000
	//leg_overload_coeff = 80
	infra_luminosity = 6
	force = 25
	wreckage = /obj/structure/mecha_wreckage/landsknecht
	internal_damage_threshold = 35
	max_equip = 3
	base_step_energy_drain = 6 //Немного меньше, чем у гигакса из-за всех облегчений брони
	var/datum/action/innate/mecha/mech_charge_mode/landsknecht/l_charge_action = new

/obj/structure/mecha_wreckage/landsknecht
	name = "Landsknecht wreckage"
	desc = "Remains of some unfortunate mecha. Although, this one looks like it can still be repaired."
	icon = 'mod_celadon/_storge_icons/icons/landsknecht.dmi'
	icon_state = "landsknecht-broken"
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

/datum/action/innate/mecha/mech_charge_mode/landsknecht
	name = "Charge"
	button_icon_state = "mech_overload_off"

/datum/action/innate/mecha/mech_charge_mode/landsknecht/Activate()
	if(!owner || !chassis || chassis.occupant != owner)
		return
	if(chassis.charge_ready && !chassis.charging)
		chassis.log_message("Charged. Legs are overclocked out of safe conditions.", LOG_MECHA, color="red")
		chassis.take_damage(5, BURN, 0, 1)
		chassis.start_charge()
		chassis.charge_ready = FALSE
		addtimer(VARSET_CALLBACK(chassis, charge_ready, TRUE), chassis.charge_cooldown)
	else
		chassis.occupant_message(span_warning("The leg actuators are still recharging!"))

/obj/mecha/combat/landsknecht/GrantActions(mob/living/user, human_occupant = 0)
	..()
	overload_action.Remove(user)
	l_charge_action.Grant(user,src)

/obj/mecha/combat/landsknecht/RemoveActions(mob/living/user, human_occupant)
	. = ..()
	l_charge_action.Remove(user)
