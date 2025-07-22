// *******************
// ** Старая турель **
// *******************

//Делаю необходимые новые проки и малость меняю текущие
/obj/machinery/deployable_turret/proc/LeftAndRightOfDir(direction, diagonal_check = FALSE)
	if(diagonal_check)
		if(ISDIAGONALDIR(direction))
			return list(turn(direction, 45), turn(direction, -45))
	return list(turn(direction, 90), turn(direction, -90))

/obj/machinery/deployable_turret/proc/check_dir(atom/targeted_atom)
	target = targeted_atom
	var/list/leftright = LeftAndRightOfDir(src.dir)
	var/left = leftright[1] - 1
	var/right = leftright[2] + 1
	var/angle = get_dir(src, target)
	if(!(left == (angle-1)) && !(right == (angle+1)))
		return TRUE
	return FALSE

/obj/machinery/deployable_turret/direction_track(mob/user, atom/targeted)
	if(user.incapacitated())
		return
	if(check_dir(targeted))
		to_chat(user, span_warning("[src] cannot be rotated so violently."))
		return
	setDir(get_dir(src,targeted))
	user.setDir(dir)
	switch(dir)
		if(NORTH)
			layer = BELOW_MOB_LAYER
			user.pixel_x = 0
			user.pixel_y = -14
		if(NORTHEAST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = -8
			user.pixel_y = -4
		if(EAST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = -14
			user.pixel_y = 0
		if(SOUTHEAST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = -8
			user.pixel_y = 4
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 0
			user.pixel_y = 14
		if(SOUTHWEST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = 8
			user.pixel_y = 4
		if(WEST)
			layer = ABOVE_MOB_LAYER
			user.pixel_x = 14
			user.pixel_y = 0
		if(NORTHWEST)
			layer = BELOW_MOB_LAYER
			user.pixel_x = 8
			user.pixel_y = -4
	return


// *******************
// ** Новая  турель **
// *******************

/obj/item/deployable_turret_folded/mounted
	name = "folded heavy machine gun"
	desc = "A folded and unloaded heavy machine gun, ready to be deployed and used."
	icon = 'icons/obj/turrets.dmi'
	icon_state = "folded_hmg"
	max_integrity = 250
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK


/obj/item/deployable_turret_folded/mounted/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable, 3 SECONDS, /obj/machinery/deployable_turret/mounted, delete_on_use = TRUE)


/obj/machinery/deployable_turret/mounted
	name = "Test Turret"
	desc = "A test turret for compatibility with TGMC mounted turrets system."
	icon = 'icons/obj/turrets.dmi'
	icon_state = "machinegun"
	can_buckle = TRUE
	anchored = FALSE
	density = FALSE
	max_integrity = 150
	buckle_lying = 0
	layer = ABOVE_MOB_LAYER
	view_range = 1
	projectile_type = /obj/projectile/bullet/manned_turret
	number_of_shots = 1
	cooldown_duration = 1
	can_be_undeployed = TRUE
	var/mob/living/carbon/human/operator

	//Здесь и дальше - вары для подключения магазина
	///Compatible magazines with the gun
	var/default_ammo_type
	///Allowed base types of magazines with the gun
	var/allowed_ammo_types
	///Incompatible magazines with the gun
	var/blacklisted_ammo_types
	///Whether the gun alarms when empty or not.
	var/empty_alarm = FALSE
	///Do we eject the magazine upon runing out of ammo?
	var/empty_autoeject = FALSE
	///Whether the gun supports multiple special mag types
	var/special_mags = FALSE

	///Actual magazine currently contained within the gun
	var/obj/item/ammo_box/magazine/magazine
	///whether the gun ejects the chambered casing
	var/casing_ejector = TRUE
	///Whether the gun has an internal magazine or a detatchable one. Overridden by BOLT_TYPE_NO_BOLT.
	var/internal_magazine = FALSE
	///Whether the gun *can* be reloaded
	var/sealed_magazine = FALSE


	///Phrasing of the magazine in examine and notification messages; ex: magazine, box, etx
	var/magazine_wording = "magazine"
	///Phrasing of the cartridge in examine and notification messages; ex: bullet, shell, dart, etc.
	var/cartridge_wording = "bullet"

	///sound when inserting magazine
	var/load_sound = 'sound/weapons/gun/general/magazine_insert_full.ogg'
	///sound when inserting an empty magazine
	var/load_empty_sound = 'sound/weapons/gun/general/magazine_insert_empty.ogg'
	///volume of loading sound
	var/load_sound_volume = 40
	///whether loading sound should vary
	var/load_sound_vary = TRUE
	///Sound of ejecting a magazine
	var/eject_sound = 'sound/weapons/gun/general/magazine_remove_full.ogg'
	///sound of ejecting an empty magazine
	var/eject_empty_sound = 'sound/weapons/gun/general/magazine_remove_empty.ogg'
	///volume of ejecting a magazine
	var/eject_sound_volume = 40
	///whether eject sound should vary
	var/eject_sound_vary = TRUE


/obj/machinery/deployable_turret/mounted/interact(mob/user)

	if(!ishuman(user))
		return TRUE
	var/mob/living/carbon/human/human_user = user
	if(get_step(src, REVERSE_DIR(dir)) != human_user.loc) //cant man the gun from the barrels side
		to_chat(human_user, span_warning("You should be behind [src] to man it!"))
		return TRUE
	if(operator) //If there is already a operator then they're manning it.
		/*
		if(!operator.interactee)
			stack_trace("/obj/machinery/deployable/mounted/interact(mob/user) called by user [human_user] with an operator with a null interactee: [operator].")
			operator = null //this shouldn't happen, but just in case
			*/
		to_chat(human_user, span_warning("Someone's already controlling it."))
		return TRUE
	if(human_user.interactee) //Make sure we're not manning two guns at once, tentacle arms.
		human_user.unset_interaction()

	density = FALSE
	if(!user.Move(loc)) //Move instead of forcemove to ensure we can actually get to the object's turf
		density = initial(density)
		return
	density = initial(density)

	var/V
	for(V in user.held_items)
	var/obj/item/I = V
	if(istype(I))
		if(user.dropItemToGround(I))
			var/obj/item/gun_control/mounted/TC = new(src)
			user.put_in_hands(TC)
	else //Entries in the list should only ever be items or null, so if it's not an item, we can assume it's an empty hand
		var/obj/item/gun_control/mounted/TC = new(src)
		user.put_in_hands(TC)

	//RegisterSignal(operator, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(afterattack))
	//RegisterSignal(operator, COMSIG_CLIENT_MOUSEDRAG, PROC_REF(change_target))

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, TRUE, 7)
	do_attack_animation(src, "grab")
	visible_message("[icon2html(src, viewers(src))] [span_notice("[human_user] mans the [src]!")]",
		span_notice("You man the gun!"))

	return ..()

/obj/machinery/deployable_turret/mounted/checkfire(atom/targeted_atom, mob/user)
	target = targeted_atom
	if(target == user || target == get_turf(src))
		return
	target_turf = get_turf(target)
	fire_helper(user, target)

/obj/item/gun_control/mounted
	name = "mounted turret controls"
	icon = 'icons/obj/items.dmi'
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT | NOBLUDGEON | DROPDEL
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/gun_control/mounted/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	turret = loc
	if(!istype(turret))
		return INITIALIZE_HINT_QDEL

/obj/item/gun_control/mounted/Destroy()
	turret = null
	return ..()

/obj/item/gun_control/mounted/CanItemAutoclick()
	return TRUE

/obj/item/gun_control/mounted/attack_obj(obj/O, mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	O.attacked_by(src, user)

/obj/item/gun_control/mounted/attack(mob/living/M, mob/living/user)
	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey
	M.attacked_by(src, user)
	add_fingerprint(user)

/obj/item/gun_control/mounted/afterattack(atom/targeted_atom, mob/user, flag, params)
	var/modifiers = params2list(params)
	var/obj/machinery/deployable_turret/mounted/E = user
	E.calculated_projectile_vars = calculate_projectile_angle_and_pixel_offsets(user, modifiers)
	E.direction_track(user, targeted_atom)
	E.checkfire(targeted_atom, user)
