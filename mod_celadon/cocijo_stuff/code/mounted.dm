/obj/machinery/deployable_turret/mount
	name = "machine gun turret mount"
	desc = ""
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mounted_machinegun.dmi'
	icon_state = "mount"
	can_buckle = TRUE
	anchored = TRUE
	max_integrity = 200
	layer = ABOVE_MOB_LAYER
	view_range = 0
	control_type = /obj/item/gun_control/mount
	/// Delay between shots in a burst
	//rate_of_fire = null
	cooldown = 0
	cooldown_duration = 0 SECONDS
	rate_of_fire = 0
	number_of_shots = 0
	/// If using a wrench on the turret will start undeploying it
	can_be_undeployed = TRUE
	/// What gets spawned if the object is undeployed
	spawned_on_undeploy = /obj/item/deployable_turret_folded/mount
	/// How long it takes for a wrench user to undeploy the object
	undeploy_time = 3 SECONDS
	/// The GUN itself for managing stuff
	//WEAKREF
	var/obj/item/gun/ballistic/gun
	/// can we remove da gun?
	var/can_be_removed = TRUE
	/// Old recoil for gun before mounting
	var/old_recoil
	/// Old spread for gun before mounting
	var/old_spread

	/// Doesn't let you spam messages
	var/message_cooldown = 10
	/// How fast can we turn around?
	var/rapid_turn_cooldown = 5
	control_type = /obj/item/gun_control/mount

	/// used for far_sound, so we don't search in GLOB every single shot
	var/datum/map_zone/mapzone

	/// Allowed base types of magazines with the gun
	var/allowed_gun_types = list(
		/obj/item/gun/ballistic/automatic/hmg/superheavy,
		)
	/// Incompatible magazines with the gun
	var/blacklisted_gun_types

/obj/machinery/deployable_turret/mount/Initialize(mapload)
	. = ..()
	allowed_gun_types = typecacheof(allowed_gun_types) - blacklisted_gun_types

/obj/machinery/deployable_turret/mount/update_icon_state() // Меняем именно иконку, чтобы была свобода сошки как угодно ставить
	if(gun)
	// сделать проверку на тип
		if(istype(gun, /obj/item/gun/ballistic/automatic/hmg/superheavy))
			var/obj/item/gun/ballistic/automatic/hmg/superheavy/shmg = gun
			if(shmg.has_cover)
				icon_state = "mount_[gun.icon_state]_[gun.sealed_magazine ? "closed" : "open"]"
		else
			icon_state = "mount_[gun.icon_state]"
	else
		icon_state = "[initial(icon_state)]"
	return ..()

/obj/machinery/deployable_turret/mount/update_overlays()
	. = ..()
	if(gun)
		// if (gun.has_cover)
				//. += "[initial(icon_state)]_[gun.icon_state]_[sealed_magazine ? "closed" : "open"]"
				//. += "[initial(icon_state)]_[gun.icon_state]_[sealed_magazine ? "closed" : "open"]"
		if (gun.bolt_type == BOLT_TYPE_LOCKING)
			. += "mount_[gun.icon_state]_bolt[gun.bolt_locked ? "_locked" : ""]"

		if (gun.bolt_type == BOLT_TYPE_OPEN && gun.bolt_locked)
			. += "mount_[gun.icon_state]_bolt"
		if (gun.show_magazine_on_sprite && gun.magazine) // если нет видимого магазина, то тупо поставьте в dmi файлу пустоту С необходимым названием
			if (gun.unique_mag_sprites_for_variants)
				. += "mount_[gun.icon_state]_mag_[gun.magazine.base_icon_state]"
				if (!gun.magazine.ammo_count())
					. += "mount_[gun.icon_state]_mag_[gun.magazine.base_icon_state]_empty"
			else
				. += "mount_[gun.icon_state]_mag"
		/*
		if(!chambered && empty_indicator)
			. += "[icon_state]_empty"
		if(chambered && mag_display_ammo)
			. += "[icon_state]_chambered"
		*/

/obj/machinery/deployable_turret/mount/proc/integrate(obj/item/gun/ballistic/B, mob/user)
	if(!(B.type in allowed_gun_types))
		to_chat(user, span_warning("\The [B] doesn't seem to fit onto \the [src]..."))
		return FALSE
	// if(istype(B, /obj/item/gun/ballistic))
	// if(istype(B, /obj/item/gun/energy))
	// to-do add energy gun support...
	to_chat(user, span_warning("I'm trying to mount [B] onto \the [src]..."))
	if(do_after(user, 3 SECONDS, src))
		if(!user.transferItemToLoc(B, src))
			to_chat(user, span_warning("Something went wrong..."))
			return FALSE
		can_be_undeployed = FALSE
		gun = B
		old_recoil = gun.recoil
		old_spread = gun.spread
		gun.recoil = gun.recoil_mounted
		gun.spread = gun.spread_mounted // it sucks
		gun.wielded = TRUE
		gun.wielded_fully = TRUE
		gun.safety = FALSE
		update_appearance()
		return TRUE
	else
		return FALSE

/obj/machinery/deployable_turret/mount/proc/remove_gun(mob/user)
	if(!gun)
		return
	can_be_undeployed = FALSE
	gun.recoil = old_recoil
	gun.spread = old_spread
	gun.wielded = FALSE
	gun.wielded_fully = FALSE
	user.put_in_hands(gun)
	gun = null
	update_appearance()
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
		update_appearance()

/obj/machinery/deployable_turret/mount/interact(mob/user, special_state)
	. = ..()
	unique_action(user)

/obj/machinery/deployable_turret/mount/Del()
	if(gun)
		gun.recoil_unwielded = old_recoil
		gun.spread_unwielded = old_spread
	. = ..()

/obj/machinery/deployable_turret/mount/Destroy()
	if(gun)
		gun.recoil_unwielded = old_recoil
		gun.spread_unwielded = old_spread
	new spawned_on_undeploy(loc)
	. = ..()


/// Открывает крышку пулемету / Ещё что-то.
/obj/machinery/deployable_turret/mount/AltClick(mob/user)
	. = ..()
	if(!user?.incapacitated() && gun)
		gun.AltClick(user)
		update_appearance()

/// Вытаскивание магазина
/obj/machinery/deployable_turret/mount/MouseDrop(mob/over_user)
	. = ..()
	if((!over_user?.incapacitated() || !istype(over_user)) && gun) // Есть баг с этим, который хз как фиксить. На работу не влияет
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
	update_appearance()

/obj/machinery/deployable_turret/mount/attack_hand(mob/living/user)
	if(LAZYLEN(buckled_mobs) != 0)
		to_chat(user, span_notice("I can't place the gun when it is manned... Somehow."))
		return FALSE
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
		if(LAZYLEN(buckled_mobs) != 0)
			to_chat(user, span_notice("I can't place the gun when [src] is manned."))
			return

		if(integrate(A,user))
			to_chat(user, span_notice("I placed \the [gun] on \the [src]."))
			return
		else
			to_chat(user, span_notice("You can't do that!"))
			return
	if(gun)
		// Пофиксить, сломано
		if(istype(A,/obj/item/ammo_casing))
			to_chat(user, span_danger("Like a pro, I try to load the bullet directly into the [src]'s chamber."))
			gun.attackby(A,user,params)
			return

		if(istype(A, /obj/item/gun_control))
			unique_action(user)
			return
		//if(istype(A, /obj/item/stock_parts/cell/gun))

		if(istype(A, /obj/item/ammo_box/magazine))
			gun.attackby(A, user, params)
			update_appearance()
	return FALSE
/*
/obj/machinery/deployable_turret/mount/fire_helper(mob/user, flag, click_parameters)
	if((user.incapacitated() || !(user in buckled_mobs)) || !gun)
		return FALSE
	if(can_be_removed) // hey it would break itself
		to_chat(user, span_danger("I can't fire when the gun is not installed securely!"))
		return FALSE
	if(QDELETED(target))
		target = target_turf
	if(!gun.afterattack(target, user, flag, click_parameters)) //!gun.process_fire(target,user)
		return FALSE
	return TRUE
*/
/obj/machinery/deployable_turret/mount/buckle_mob(mob/living/M, force, check_loc)
	. = ..()
	playsound(src, 'mod_celadon/_storage_sounds/sound/gun/kord/getting_on.ogg',100, FALSE)

/obj/machinery/deployable_turret/mount/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	. = ..()
	if(gun)
		gun?.azoom.Grant(user)
		for(var/datum/action/action as anything in gun.actions)
			action.Grant(M)

/obj/machinery/deployable_turret/mount/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	. = ..()
	if(gun)
		gun?.azoom.Remove(buckled_mob)
		for(var/datum/action/action as anything in gun.actions)
			action.Remove(buckled_mob)

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
/*
/obj/machinery/deployable_turret/mount/checkfire(atom/targeted_atom, mob/user, flag = FALSE, click_parameters)
	target = targeted_atom
	if(target == user || target == get_turf(src))
		return
	target_turf = get_turf(target)
	fire_helper(user, flag, click_parameters)
*/
/// Shitcode... welp
/obj/item/gun_control/mount

/obj/item/gun_control/mount/unique_action(mob/living/user)
	var/obj/machinery/deployable_turret/mount/mount = turret
	mount.unique_action(user)
	. = ..()

/obj/item/gun_control/mount/afterattack(atom/targeted_atom, mob/user, flag = FALSE, params)
	var/list/allowed_dirs = list(user.dir, turn(user.dir, 45), turn(user.dir, -45))
	var/obj/machinery/deployable_turret/mount/E = user.buckled
	if(get_dir(user, targeted_atom) in allowed_dirs)
		E.gun.afterattack(targeted_atom, user, flag, params)

// /// God I hate it. EAST = 0, flag = TRUE -> counter clockwise, flag = FALSE -> clockwise
// /proc/get_absolute_angle(atom/movable/start, atom/movable/end, flag = TRUE)
// 	if(!start || !end)
// 		return 0
// 	var/dy =(32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
// 	var/dx =(32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
// 	if(!dx)
// 		return (dy >= 0) ? 0 : 180
// 	if(flag)
// 		. = arctan(dy/dx)
// 	. = arctan(-dy/dx)

// /obj/item/gun_control/mount/afterattack(atom/targeted_atom, mob/user, flag = FALSE, params)

// 	var/obj/machinery/deployable_turret/mount/E = user.buckled
// 	//var/modifiers = params2list(params)
// 	var/allowed_cone = 60
// 	var/ang = get_absolute_angle(src, targeted_atom, FALSE)-90
// 	var/fire_cone = abs(dir2angle(dir)-ang)
// 	if(fire_cone <= allowed_cone)
// 		// E.calculated_projectile_vars = calculate_projectile_angle_and_pixel_offsets(user, targeted_atom, modifiers)
// 		E.checkfire(targeted_atom, user, flag, params)

/obj/machinery/deployable_turret/mount/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(!. && gun)
		to_chat(user, span_danger("I'm [can_be_removed ? "loosening" : "tightening"] the machine gun mount."))
		if(I.use_tool(src, user, 3 SECONDS, volume=50))
			can_be_removed = !can_be_removed
			to_chat(user, span_danger("Now I can [can_be_removed ? "remove" : "fire from"] it."))
			return TRUE

/obj/machinery/deployable_turret
	var/buckle_mob_sound = 'sound/mecha/mechmove01.ogg'
	var/unbuckle_mob_sound = 'sound/mecha/mechmove01.ogg'

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
	// M.pixel_y = 14
	M.setDir(dir)
	direction_track(M)
	layer = ABOVE_MOB_LAYER
	//setDir(SOUTH)
	playsound(src,buckle_mob_sound, 50, TRUE)
	if(M.client)
		M.client.view_size.setTo(view_range)
	START_PROCESSING(SSfastprocess, src)

/obj/machinery/deployable_turret/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	playsound(src,unbuckle_mob_sound, 50, TRUE)
	for(var/obj/item/I in buckled_mob.held_items)
		if(istype(I, /obj/item/gun_control))
			qdel(I)
	if(istype(buckled_mob))
		buckled_mob.pixel_x = buckled_mob.base_pixel_x
		buckled_mob.pixel_y = buckled_mob.base_pixel_y
		if(buckled_mob.client)
			buckled_mob.client.view_size.resetToDefault()
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)

/obj/machinery/deployable_turret/mount/direction_track(mob/user, atom/targeted)
	if(user.incapacitated())
		return
	setDir(get_dir(src,targeted))
	user.setDir(dir)
	switch(dir)
		if(NORTH)
			layer = BELOW_MOB_LAYER
			user.pixel_x = 0
			user.pixel_y = -12
		if(NORTHEAST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = -8
			user.pixel_y = -4
		if(EAST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = -16
			user.pixel_y = 0
		if(SOUTHEAST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = -8
			user.pixel_y = 4
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 0
			user.pixel_y = 12
		if(SOUTHWEST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = 8
			user.pixel_y = 4
		if(WEST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 16
			user.pixel_y = 0
		if(NORTHWEST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = 8
			user.pixel_y = -4
