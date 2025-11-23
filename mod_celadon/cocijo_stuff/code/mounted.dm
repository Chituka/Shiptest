/obj/machinery/deployable_turret/mount
	name = "machine gun turret mount"
	desc = ""
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mounted_machinegun.dmi'
	icon_state = "mount"
	can_buckle = TRUE
	anchored = TRUE
	max_integrity = 200
	layer = ABOVE_MOB_LAYER
	// view_range = 2.5
	// cooldown = 0
	// projectile_type = null
	control_type = /obj/item/gun_control/mount
	/// Delay between shots in a burst
	rate_of_fire = null
	/// Number of shots fired from one click
	// number_of_shots = null
	/// How long it takes for the gun to allow firing after a burst
	cooldown_duration = 0 SECONDS
	/*
	calculated_projectile_vars
	/// Sound to play at the end of a burst
	var/overheatsound = 'sound/weapons/sear.ogg'
	/// Sound to play when firing
	var/firesound = 'sound/weapons/gun/smg/shot.ogg'
	*/
	/// If using a wrench on the turret will start undeploying it
	can_be_undeployed = TRUE
	/// What gets spawned if the object is undeployed
	spawned_on_undeploy = /obj/item/deployable_turret_folded/mount
	/// How long it takes for a wrench user to undeploy the object
	undeploy_time = 3 SECONDS
	// реализация пушки внутри
	var/obj/item/gun/ballistic/gun
	var/list/gun_properties
	var/can_be_removed = TRUE
	var/old_recoil
	var/old_spread

	var/message_cooldown = 10
	var/rapid_turn_cooldown = 5
	control_type = /obj/item/gun_control/mount

	var/datum/map_zone/mapzone // used for far_sound, so we don't search in GLOB every single shot

	///Allowed base types of magazines with the gun
	var/allowed_gun_types = list(
		/obj/item/gun/ballistic/automatic/hmg/superheavy,
		)
	///Incompatible magazines with the gun
	var/blacklisted_gun_types

/obj/machinery/deployable_turret/mount/Initialize(mapload)
	. = ..()
	allowed_gun_types = typecacheof(allowed_gun_types) - blacklisted_gun_types
/*
/obj/machinery/deployable_turret/mount/update_icon_state() // доделать
	if(has_cover)
		. += "[initial(icon_state)]_[gun.icon_state]_[sealed_magazine ? "closed" : "open"]"
	. += "[initial(icon_state)]_[gun.icon_state]_[sealed_magazine ? "closed" : "open"]"
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][sawn_off ? "_sawn" : ""]"
	else
		icon_state = "[base_icon_state || initial(icon_state)][sawn_off ? "_sawn" : ""]"
	return ..()
*/
/obj/machinery/deployable_turret/mount/proc/integrate(obj/item/gun/ballistic/B, mob/user)
	if(!(B.type in allowed_gun_types))
		to_chat(user, span_warning("\The [B] doesn't seem to fit onto \the [src]..."))
		return FALSE
	// if(istype(B, /obj/item/gun/ballistic))
	if(!user.transferItemToLoc(B, src))
		return
	can_be_undeployed = FALSE
	gun = B
	old_recoil = gun.recoil_unwielded
	old_spread = gun.spread_unwielded
	gun.recoil_unwielded = gun.recoil_mounted
	gun.spread_unwielded = gun.spread_mounted // it sucks
	update_appearance() // доделать
	return TRUE

/obj/machinery/deployable_turret/mount/proc/remove_gun(mob/user)
	if(!gun)
		return
	can_be_undeployed = FALSE
	gun.recoil_unwielded = old_recoil
	gun.spread_unwielded = old_spread
	// gun.recoil_unwielded -= recoil_bonus
	// gun.spread_unwielded -= spread_bonus
	user.put_in_hands(gun)
	gun = null
	update_appearance() // доделать
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	return TRUE

/obj/item/deployable_turret_folded/mount
	name = "Тренога"
	desc = "Нужна для постановки на себя пушки."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mounted_machinegun.dmi'
	icon_state = "kord_deployed"

/obj/item/deployable_turret_folded/mount/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable, 5 SECONDS, /obj/machinery/deployable_turret/mount, delete_on_use = TRUE)

/obj/machinery/deployable_turret/mount/proc/unique_action(mob/user)
	if(gun)
		gun?.unique_action(user) // пофикшен баг

/obj/machinery/deployable_turret/mount/interact(mob/user, special_state)
	. = ..()
	unique_action(user)

/obj/machinery/deployable_turret/mount/Destroy()
	if(gun)
		gun.recoil_unwielded = old_recoil
		gun.spread_unwielded = old_spread
	new spawned_on_undeploy(loc)
	. = ..()


// Открывает крышку пулемету / Ещё что-то.
/obj/machinery/deployable_turret/mount/AltClick(mob/user)
	. = ..()
	if(!user?.incapacitated() && gun)
		gun.AltClick(user)

// Вытаскивание магазина
/obj/machinery/deployable_turret/mount/MouseDrop(mob/over_user)
	. = ..()
	if(!over_user?.incapacitated() && gun) // КАК БЛЯТЬ ТЫ ЭТО ДЕЛАЕШЬ ЧУ
		if(istype(gun,/obj/item/gun/ballistic))
			if(gun.sealed_magazine)
				to_chat(over_user, span_warning("The [gun.magazine_wording] on [src] is sealed and cannot be accessed!"))
				return
			//if(bolt_type == BOLT_TYPE_NO_BOLT && (chambered || internal_magazine))
			// do it for if you want to make a mounted single-shot rifle... code it by yourself
			if(!gun.internal_magazine && gun.magazine)
				gun.eject_magazine(over_user)

		if(istype(gun,/obj/item/gun/energy)) // it's never used rn
			to_chat(over_user, span_alert("HOW THE MEOW YOU DID THIS"))

/obj/machinery/deployable_turret/mount/attack_hand(mob/living/user)
	if(gun && can_be_removed) // Нужно сделать проверку на свободные руки
		to_chat(user, span_notice("I'm removing \the [gun] from \the [src]...."))
		if(do_after(user, 3 SECONDS, src))
			to_chat(user, span_notice("Done!"))
			remove_gun(user)
		else
			return FALSE
	. = ..()

/obj/machinery/deployable_turret/mount/attackby(obj/item/A, mob/user, params)
	if(..())
		return FALSE

	if(!gun && istype(A,/obj/item/gun/ballistic))
		if(integrate(A,user))
			to_chat(user, span_notice("I placed \the [gun] on \the [src]."))
			gun.safety = FALSE
			return
		else
			to_chat(user, span_notice("You can't do that!"))
			return
	// Пофиксить, сломано
	if(istype(A,/obj/item/ammo_casing))
		to_chat(user, span_danger("Like a pro, I try to load the bullet directly into the [src]'s chamber."))
		gun.attackby(A,user,params)
		return

	if(istype(A, /obj/item/gun_control))
		unique_action(user)
		return

	if(istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!gun.magazine)
			gun.insert_magazine(user, AM)
		else
			to_chat(user, span_notice("There's already a [gun.magazine] in \the [src]."))
			return

	return FALSE

// БОГ ГРОМА БУДЕТ ДОВОЛЬНЫЫЫМ
/obj/machinery/deployable_turret/mount/Initialize(mapload, apply_default_parts)
	var/turf/T = get_turf(src)
	mapzone = T.get_map_zone()
	. = ..()

/obj/machinery/deployable_turret/mount/fire_helper(mob/user)
	if((user.incapacitated() || !(user in buckled_mobs)) || !gun)
		return FALSE
	if(can_be_removed) // hey it would break itself
		to_chat(user, span_danger("I can't fire when the gun is not installed securely!"))
		return FALSE
	if(QDELETED(target))
		target = target_turf
	if(!gun.process_fire(target, user))
		return FALSE
	return TRUE

/obj/machinery/deployable_turret/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(user.incapacitated() || !istype(user))
		return
	M.forceMove(get_turf(src))
	. = ..()
	if(!.)
		return
	for(var/V in M.held_items)
		var/obj/item/I = V
		if(istype(I))
			if(M.dropItemToGround(I))
				var/TC = new control_type(src) //саси
				M.put_in_hands(TC)
		else //Entries in the list should only ever be items or null, so if it's not an item, we can assume it's an empty hand
			var/TC = new control_type(src) //саси
			M.put_in_hands(TC)
	M.setDir(dir)
	update_pixels(M)
	layer = ABOVE_MOB_LAYER
	playsound(src,'sound/mecha/mechmove01.ogg', 50, TRUE)
	if(M.client)
		M.client.view_size.setTo(view_range)
	START_PROCESSING(SSfastprocess, src)

/obj/machinery/deployable_turret/mount/relaymove(mob/living/user, direction)
	if(user.incapacitated())
		return
	if(direction == user.dir)
		return
	var/list/disallowed_dirs = list(turn(user.dir,180), turn(user.dir,135),turn(user.dir,225))
	if (direction in disallowed_dirs)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 10
			to_chat(user,span_alert("I can't rotate the gun so violently!"))
		return
	if(rapid_turn_cooldown > world.time)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 10
			to_chat(user,span_alert("I need to catch my breath!"))
		return
	if (direction == turn(user.dir,90) || direction == turn(user.dir,-90))
		rapid_turn_cooldown = world.time + 10
	direction_track(user,get_edge_target_turf(src,direction))

/obj/machinery/deployable_turret/mount/buckle_mob(mob/living/M, force, check_loc)
	. = ..()
	playsound(src, 'mod_celadon/_storage_sounds/sound/gun/kord/getting_on.ogg',100, FALSE)

/obj/machinery/deployable_turret/mount/checkfire(atom/targeted_atom, mob/user)
	target = targeted_atom
	if(target == user || target == get_turf(src))
		return
	target_turf = get_turf(target)
	if(fire_helper(user))
		for(var/MN in mapzone.get_client_mobs())
			var/mob/M = MN
			var/turf/T = get_turf(src)
			//playsound(src,'mod_celadon/_storage_sounds/sound/gun/kord/single_close_loud.ogg', 100, FALSE, falloff_exponent = 6, channel = 1)
			if(can_see(M,src,10))
				M.playsound_local(T, 'mod_celadon/_storage_sounds/sound/gun/kord/single_close_loud.ogg', 100, FALSE, falloff_exponent = 6, channel = 1, max_distance = 100)
			if (get_dist(src, get_turf(M)) > 15)
				M.playsound_local(T, 'mod_celadon/_storage_sounds/sound/gun/kord/single_mid_stereo.ogg', 90, FALSE, /*falloff_exponent = 1*/, max_distance = 100)
			if (get_dist(src, get_turf(M)) > 30)
				M.playsound_local(T, 'mod_celadon/_storage_sounds/sound/gun/kord/single_far_stereo.ogg', 60, FALSE, falloff_exponent = 1, max_distance = 100)

/obj/item/gun_control/mount
	name = "TestName"
	desc = "TestDesc"

/obj/item/gun_control/mount/afterattack(atom/targeted_atom, mob/user, flag, params)
	var/list/allowed_dirs = list(user.dir, turn(user.dir, 45), turn(user.dir, -45))
	var/obj/machinery/deployable_turret/E = user.buckled
	var/modifiers = params2list(params)
	if(get_dir(user, targeted_atom) in allowed_dirs)
		E.calculated_projectile_vars = calculate_projectile_angle_and_pixel_offsets(user, targeted_atom, modifiers)
		E.checkfire(targeted_atom, user)

/obj/machinery/deployable_turret/mount/screwdriver_act(mob/living/user, obj/item/I)
	if(gun)
		if(I.use_tool(src, user, 3, volume=50))
			can_be_removed = !can_be_removed
			to_chat(user, span_danger("I [can_be_removed ? "loosen" : "tightening"] the machine gun mount. Now I can [can_be_removed ? "remove" : "fire from"] it."))
			return
	else
		. = ..()
