/obj/mecha/combat/landsknecht
	desc = "A light combat exosuit manufactured by Cybersun Biodynamics for Syndicate and modified by GEC for simplified maintenance and repair after destruction. \n\
			Leg actuators are modified for faster movement and dashes, however, latter may lead to exo failure. \n\
			Lightweight, streamlined, yet still unique."
	name = "\improper 502p heavily modified Exosuit"
	icon = 'mod_celadon/_storage_icons/icons/landsknecht.dmi'
	icon_state = "landsknecht"
	step_in = 2
	dir_in = 1
	max_integrity = 350
	deflect_chance = 5
	armor = list("melee" = 20, "bullet" = 15, "laser" = 15, "energy" = 15, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	max_temperature = 25000
	destruction_sleep_duration = 0
	charge_break_walls = TRUE
	infra_luminosity = 6
	force = 25
	wreckage = /obj/structure/mecha_wreckage/landsknecht
	internal_damage_threshold = 35
	max_equip = 3
	exit_delay = 15
	enter_delay = 20
	base_step_energy_drain = 6 //Немного меньше, чем у гигакса из-за всех облегчений брони

	var/datum/action/innate/mecha/mech_charge_mode/landsknecht/l_charge_action = new

/obj/mecha/combat/landsknecht/go_out(forced, atom/newloc = loc)
	if(!occupant)
		return
	var/atom/movable/mob_container
	occupant.clear_alert("charge")
	occupant.clear_alert("exosuit damage")
	if(ishuman(occupant))
		mob_container = occupant
		RemoveActions(occupant, human_occupant=1)
	else if(isbrain(occupant))
		var/mob/living/brain/brain = occupant
		RemoveActions(brain)
		mob_container = brain.container
	else if(isAI(occupant))
		var/mob/living/silicon/ai/AI = occupant
		if(forced)//This should only happen if there are multiple AIs in a round, and at least one is Malf.
			RemoveActions(occupant)
			occupant.gib()  //If one Malf decides to steal a mech from another AI (even other Malfs!), they are destroyed, as they have nowhere to go when replaced.
			occupant = null
			silicon_pilot = FALSE
			return
		else
			if(!AI.linked_core)
				to_chat(AI, span_userdanger("Inactive core destroyed. Unable to return."))
				AI.linked_core = null
				return
			to_chat(AI, span_notice("Returning to core..."))
			ADD_TRAIT(AI, TRAIT_HANDS_BLOCKED, ROUNDSTART_TRAIT) // Resets the AI's hand status
			AI.controlled_mech = null
			AI.remote_control = null
			RemoveActions(occupant, 1)
			mob_container = AI
			newloc = get_turf(AI.linked_core)
			qdel(AI.linked_core)
	else
		return
	var/mob/living/L = occupant
	occupant = null //we need it null when forceMove calls Exited().
	silicon_pilot = FALSE
	SEND_SIGNAL(src,COMSIG_MECH_EXITED,L)
	if(mob_container.forceMove(newloc))//ejecting mob container
// [CELADON-ADD] - FIX_MECH
		REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, VEHICLE_TRAIT)
// [/CELADON-ADD]
		log_message("[mob_container] moved out.", LOG_MECHA)
		L << browse(null, "window=exosuit")
		if(atom_integrity <= 0)
			L.throw_at(get_edge_target_turf(src, turn(dir,180)), 3, 5)
		if(istype(mob_container, /obj/item/mmi))
			var/obj/item/mmi/mmi = mob_container
			if(mmi.brainmob)
				L.forceMove(mmi)
				L.reset_perspective()
			mmi.set_mecha(null)
			mmi.update_appearance()
		icon_state = initial(icon_state)+"-open"
		set_dir_mecha(dir_in)

	if(L && L.client)
		L.update_mouse_pointer()
		L.client.view_size.resetToDefault()
		zoom_mode = 0

/obj/mecha/combat/landsknecht/Bump(atom/obstacle)
	var/atom/throw_target = get_edge_target_turf(obstacle, dir)
	if(phasing && get_charge() >= phasing_energy_drain && !throwing)
		if(!can_move)
			return
		if(istype(obstacle, /turf/closed/indestructible))
			return
		can_move = FALSE
		if(phase_state)
			flick(phase_state, src)
		forceMove(get_step(src,dir))
		use_power(phasing_energy_drain)
		addtimer(VARSET_CALLBACK(src, can_move, TRUE), step_in*3)
	else if(charging)
		if(charge_break_walls && iswallturf(obstacle))
			var/turf/closed/wall/crushed = obstacle
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
			visible_message(span_userdanger("[src] smashes through [obstacle]!")) //upd ладно, теперь не единственное. Enjoy
			crushed.dismantle_wall(TRUE)
			src.take_damage(rand(10,20),BRUTE,"melee") //Единственное, что я тут добавил лол
		if(isobj(obstacle))
			var/obj/object = obstacle
			obstacle.mech_melee_attack(src)
			if(!(object.resistance_flags & INDESTRUCTIBLE) && charge_toss_structures)
				object.throw_at(throw_target, 4, 3)
			visible_message(span_danger("[src] crashes into [obstacle]!"))
			playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		if(ishuman(obstacle))
			var/mob/living/carbon/human/H = obstacle
			H.throw_at(throw_target,4,3)
			visible_message(span_danger("[src] slams into \the [obstacle], sending [obstacle.p_them()] flying!"))
			playsound(H, 'sound/effects/bang.ogg', 100, FALSE, -1)
			H.Paralyze(20)
			H.adjustStaminaLoss(30)
			H.apply_damage(rand(20,35), BRUTE)
	else
		if(..()) //mech was thrown
			return
		if(bumpsmash && occupant) //Need a pilot to push the PUNCH button.
			if(nextsmash < world.time)
				obstacle.mech_melee_attack(src)
				nextsmash = world.time + smashcooldown
				if(!obstacle || obstacle.CanPass(src,get_step(src,dir)))
					step(src,dir)
		if(isobj(obstacle))
			var/obj/O = obstacle
			if(!O.anchored && O.move_resist <= move_force)
				step(obstacle, dir)
		else if(ismob(obstacle))
			var/mob/M = obstacle
			if(M.move_resist <= move_force)
				step(obstacle, dir)

/obj/structure/mecha_wreckage/landsknecht
	name = "Landsknecht wreckage"
	desc = "Remains of some unfortunate mecha. Although, this one looks like it can still be repaired."
	icon = 'mod_celadon/_storage_icons/icons/landsknecht.dmi'
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
			for(var/type2 in contents)
				if(istype(type2,type1))
					var/obj/item/E = type2
					to_chat(user, span_warning("There is already a [E.name]!"))
					return
			// if(is_type_in_list(type1,crowbar_salvage) || is_type_in_list(type1,contents))
			// 	to_chat(user, span_warning("There is already a [type1]!"))
			// 	return
			I.forceMove(src)
			req_stock_parts.Remove(type1)
			return
	to_chat(user,span_warning("It doesn't seem to fit in there!"))
	return


/obj/structure/mecha_wreckage/landsknecht/screwdriver_act(mob/living/user, obj/item/I)
	if(!(req_comps.len))
		var/obj/mecha/M = new /obj/mecha/combat/landsknecht(loc)
		for(var/X in crowbar_salvage)
			if (istype(X, /obj/item/mecha_parts/mecha_equipment))
				M.equipment += X
			if (istype(X, /obj/item/stock_parts))
				crowbar_salvage -= X
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
