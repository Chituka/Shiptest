/obj/item/ammo_box/magazine/internal/cylinder/a127mm
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a127mm
	caliber = "12.7mm"
	max_ammo = 6

/obj/projectile/bullet/a127mm
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	icon_state= "bolter"
	damage = 70
	armour_penetration = 25

/obj/projectile/bullet/a127mm/ap
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 50
	armour_penetration = 60

/obj/projectile/bullet/a127mm/ap/buffed
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 50
	armour_penetration = 60
	range = 50
	hitscan = TRUE
	light_system = 0
	light_range = 0
	muzzle_type = /obj/effect/projectile/muzzle/stun
	//tracer_type = /obj/effect/projectile/tracer/legion
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/projectile/bullet/a127mm/ap/buffed/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		new /obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)

/obj/projectile/bullet/a127mm/ap/buffed/on_hit(atom/target, blocked = FALSE)
	..()
	var/turf/location = get_turf(target)
	if(location)
		new /obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)
	return BULLET_ACT_HIT

/obj/projectile/bullet/a127mm/alum
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 90
	armour_penetration = 0

/obj/item/ammo_casing/a127mm
	name = "12.7x55mm bullet casing"
	desc = "AMR stands for Anti-materiel revolver."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi'
	icon_state = "a127-brass"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127mm
	stack_size = 6

/obj/item/ammo_casing/a127mm/alum
	name = "12.7x55mm aluminium bullet casing"
	desc = "A fine thing for making criminally large holes inside your enemy... If they don't have armour."
	bullet_skin = "alum"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127mm/alum
	stack_size = 6

/obj/item/ammo_casing/a127mm/ap
	name = "12.7x55mm armor penetrating bullet casing"
	desc = "A exceptionally rare bullet for exceptionally thick armour. For incriminating their personal space and existence, of course."
	bullet_skin = "ap"
	mob_overlay_icon = 'mod_celadon/_storage_icons/icons/items/clothing/mask/overlay/a127mm.dmi'
	mob_overlay_state = null
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127mm/ap
	stack_size = 6
	slot_flags = ITEM_SLOT_MASK
	var/lit = FALSE
	var/lit_time = 0
	var/lit_bullet_skin = "apon"
	var/icon_off = "cigaroff"

/obj/item/ammo_casing/a127mm/ap/attackby(obj/item/attacking_item, mob/user, params)
	if(!lit)
		var/lighting_text = attacking_item.ignition_effect(src, user)
		if(lighting_text)
			light(lighting_text)
			lit_time = world.time
	. = ..()

/obj/item/ammo_casing/a127mm/ap/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, misfire)
	var/time_difference = (world.time - lit_time) / 10 //So we get seconds and not ticks
	if (BB && lit && (time_difference > 600)) // if it was lit for more than 10 mins
		explosion(src, 0, 0, 2, 0, flame_range = 1)
		BB = null
		return
	if (BB && lit && (time_difference > 60)) // if it was lit for more than a minute
		qdel(BB)
		BB = new /obj/projectile/bullet/a127mm/ap/buffed
	. = ..()

/obj/item/ammo_casing/a127mm/ap/proc/light(flavor_text = null)
	if(lit)
		return
	bullet_skin = lit_bullet_skin
	update_icon_state()
	lit = TRUE
	name = "lit [name]"
	attack_verb = list("burnt", "singed")
	hitsound = 'sound/items/welder.ogg'
	damtype = "fire"
	force = 4

	if(flavor_text)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127mm/ap
	ammo_type = /obj/item/ammo_casing/a127mm/ap

/obj/item/storage/fancy/cigarettes/cigars/a127mm
	name = "12.7x55mm AP ammo case"
	desc = "A case of imported 12,7x55mm AP ammo, renowned for their strong flavor after shot and large holes inside enemies."
	icon_state = "cohibacase"
	w_class = WEIGHT_CLASS_NORMAL
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/ammo_casing/a127mm/ap

/obj/item/storage/fancy/cigarettes/cigars/a127mm/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/ammo_casing/a127mm))

/obj/item/storage/fancy/cigarettes/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	var/obj/item/ammo_casing/a127mm/W = locate(/obj/item/ammo_casing/a127mm) in contents
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		contents -= W
		to_chat(user, span_notice("You take \a [W] out of the pack."))
	else
		to_chat(user, span_notice("There are no [contents_tag]s left in the pack."))

/obj/item/storage/fancy/cigarettes/cigars/a127mm/update_overlays()
	. = ..()
	if(!is_open)
		return
	var/bullet_position = 1 //generate sprites for cigars in the box
	for(var/obj/item/ammo_casing/a127mm/ap/bullets in contents)
		var/mutable_appearance/bullet_overlay = mutable_appearance('mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi', "[bullets.icon_off]_[bullet_position]")
		. += bullet_overlay
		bullet_position++

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127mm
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi'
	//icon_state = "a127-brass"
	ammo_type = /obj/item/ammo_casing/a127mm
	max_ammo = 6

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127mm/alum
	//icon_state = "a127-brass-alum"
	ammo_type = /obj/item/ammo_casing/a127mm/alum

/obj/item/storage/box/ammo/a127mm
	name = "box of 12.7x55mm ammo"
	desc = "A box of standard 12.7x55mm ammo."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'
	icon_state = "a127mmbox"

/obj/item/storage/box/ammo/a127mm/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127mm = 2)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/ammo/a127mm/alum
	name = "box of 12.7x55mm HP ammo"
	desc = "A steel box of 12.7x55mm HP ammo. Box seems to be quite cheeap..."
	icon = 'icons/obj/ammunition/ammo_boxes.dmi'
	icon_state = "generic-ammo"

/obj/item/storage/box/ammo/a127mm/alum/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127mm/alum = 4)
	generate_items_inside(items_inside,src)


/obj/item/gun/ballistic/revolver/fdl
	name = "\improper FDL-12 revolver"
	desc = "Also known as Fer-de-Lance, this revolver is a highly experimental technology made by combined efforts of the GEC and Scarborough Arms, firing 12.7x55mm rounds at unimaginable velocity."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/cocijo_guns.dmi'
	lefthand_file = 'mod_celadon/_storage_icons/icons/items/weapons/in_hands/fdl_lefthand.dmi'
	righthand_file = 'mod_celadon/_storage_icons/icons/items/weapons/in_hands/fdl_righthand.dmi'
	icon_state = "fdl12"
	item_state = "fdl"
	fire_sound = 'mod_celadon/_storage_sounds/sound/gun/fdl12_shot.ogg'
	manufacturer = MANUFACTURER_SCARBOROUGH
	safety_wording = "safety"
	spread = 0
	spread_unwielded = 10
	recoil = 10
	recoil_unwielded = 20
	gate_loaded = TRUE
	semi_auto = FALSE
	default_ammo_type = /obj/item/ammo_box/magazine/internal/cylinder/a127mm
	allowed_ammo_types = list(
	/obj/item/ammo_box/magazine/internal/cylinder/a127mm,
	)

/obj/item/gun/ballistic/revolver/fdl/examine_more(mob/user)
	. = ..()
	. += span_warning("This piece of techonology is a culmination of GEC ingenuity and perseverance, being a combination of regular chemical weapon, gauss and railgun technologies and, especially, magnetic cumulation generator. \n\
						This majesty of innovation is a complex weaponry, miniaturized after several attempts which are mech weapons. \n\
						The first stage: the chemical component is activated and explodes, initiating movement and, crucially, generating a powerful current pulse by magnetic cumulation generator in chamber REQUIRED for railgun component of gun for the next stage. \n\
						The second stage: the magnetic current generated from previous stage is used for charging rails, which imparts colossal acceleration to projectile. \n\
						The third stage: coil component stabilizes the shot and increases the accuracy, spinning the projectile and correcting the trajectory. \n\
						All these stages lead to incredible velocity and power for gradual disassembly of even mechs. Yet the complexity and requirement for this fascination lead to incredible pricey bullets and recoil.")

/obj/item/gun/ballistic/revolver/fdl/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ammo_hud/revolver)

/obj/item/gun/ballistic/revolver/fdl/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	playsound(loc, 'mod_celadon/_storage_sounds/sound/gun/fdl12_charge.ogg', 100)
	if(do_after(user, 1 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE))
		. = ..()

/obj/effect/projectile/tracer/laser/capital
	icon_state = "hcult"

/obj/effect/projectile/tracer/laser/capital/Initialize(mapload)
	. = ..()
	scale_to(2.3,1.05)

/obj/projectile/beam/hitscan/laser/capital/Range()
	..()
	transform *= 2

/obj/projectile/beam/hitscan/laser/capital/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, -1, 1, 2, adminlog = FALSE)
	return BULLET_ACT_HIT


///////////////
/// ПУЛЕМЕТ ///
///////////////
/obj/item/gun
	var/recoil_mounted = 1 // I'M SORRY
	var/spread_mounted = 1

/obj/item/gun/ballistic/automatic/hmg/superheavy
	name = "Super-Heavy Machinegun"
	desc = "Sexy."
	bad_type = /obj/item/gun/ballistic/automatic/hmg
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = 0
	weapon_weight = WEAPON_VERY_HEAVY
	burst_size = 1
	actions_types = list(/datum/action/item_action/deploy_bipod)
	drag_slowdown = 3 // CARRY THIS, YOU B-
	fire_delay = 0.2 SECONDS

	gun_firemodes = list(FIREMODE_FULLAUTO)
	default_firemode = FIREMODE_FULLAUTO

	wield_slowdown = HMG_SLOWDOWN

	spread = 12
	spread_unwielded = 35
	recoil = 10 //it's firing 12X XXX XXXXXXXxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	recoil_unwielded = 60 // spine-breaking feature next
	recoil_mounted = 2
	spread_mounted = 2

	gunslinger_recoil_bonus = 2
	gunslinger_spread_bonus = 20

	///does this have a bipod?
	has_bipod = FALSE
	///is the bipod deployed?
	bipod_deployed = FALSE
	///how long do we need to deploy the bipod?
	deploy_time = 0.5 SECONDS

	///does this have a cover?
	var/has_cover = FALSE
	///is the cover opened? Yeah, we reuse it here, but.. why not
	sealed_magazine = TRUE
	var/cover_sound = 'sound/weapons/gun/l6/l6_door.ogg'
	var/cover_sound_volume = 80

	///we add these two values to recoi/spread when we have the bipod deployed
	deploy_recoil_bonus = -1
	deploy_spread_bonus = -5

	deployable_on_structures = list(
	/obj/structure/table,
	/obj/structure/barricade,
	/obj/structure/bed,
	/obj/structure/chair,
	/obj/structure/railing,
	/obj/structure/flippedtable
	)
	wear_minor_threshold = 300
	wear_major_threshold = 900
	wear_maximum = 1500

/obj/item/gun/ballistic/automatic/hmg/superheavy/update_overlays()
	. = ..()
	if(has_cover)
		. += "[icon_state]_[sealed_magazine ? "closed" : "open"]"

/obj/item/gun/ballistic/automatic/hmg/superheavy/echis
	name = "SHMG \"Echis\""
	desc = "Super-Heavy Machinegun \"Echis\". The beast of the beast"
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mounted_machinegun.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/inteq/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/inteq/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/inteq/onmob.dmi'

	icon_state = "kord"
	item_state = "kord"

	manufacturer = MANUFACTURER_SCARBOROUGH

	show_magazine_on_sprite = TRUE
	show_magazine_on_sprite_ammo = TRUE
	mag_display_ammo = TRUE
	has_cover = TRUE

	fire_sound = 'sound/weapons/gun/hmg/hmg.ogg'
	rack_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_cocked.ogg'
	rack_sound_volume = 80
	load_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_reload.ogg'
	eject_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_unload.ogg'

	gun_firemodes = list(FIREMODE_FULLAUTO)
	default_firemode = FIREMODE_FULLAUTO

	fire_delay = 0.2 SECONDS

	unique_mag_sprites_for_variants = TRUE

	slot_flags = ITEM_SLOT_BACK
	bolt_type = BOLT_TYPE_STANDARD
	tac_reloads = FALSE

	wield_slowdown = HMG_SLOWDOWN

	default_ammo_type = /obj/item/ammo_box/magazine/turret
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/turret,
		/obj/item/ammo_box/magazine/turret/small
	)

	spread = 12
	spread_unwielded = 35
	recoil = 10
	recoil_unwielded = 60

/obj/item/gun/ballistic/automatic/hmg/superheavy/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box/magazine))
		if(has_cover && sealed_magazine)
			to_chat(user, span_notice("Cover is closed! Open it to change the magazine!"))
			return
	. = ..()

/obj/item/gun/ballistic/automatic/hmg/superheavy/AltClick(mob/user)
	. = ..()
	if(!user.incapacitated())
		playsound(src, cover_sound, cover_sound_volume, TRUE)
		sealed_magazine = !sealed_magazine
		update_appearance()
		// icon_state = "[initial(icon_state)]_[sealed_magazine ? "closed" : "open"]"
		to_chat(user, span_danger("I [sealed_magazine ? "close" : "open"] the cover."))

/obj/item/gun/ballistic/automatic/hmg/superheavy/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(has_cover)
		if(!sealed_magazine)
			to_chat(user, span_userdanger("The cover is [prob(10) ? "fucking" : ""] open!"))
			return
	. = ..()

///Used to chamber a new round and eject the old one. Also returns True of False
/obj/machinery/deployable_turret/cocijo/proc/chamber_round(keep_bullet = FALSE)
	if (chambered || !magazine)
		return
	if (magazine.ammo_count())
		if(doesnt_keep_bullet)
			chambered = magazine.get_round(FALSE)
		else
			chambered = magazine.get_round(keep_bullet || bolt_type == BOLT_TYPE_NO_BOLT)
		if (bolt_type != BOLT_TYPE_OPEN)
			chambered.forceMove(src)
/*
	if (chambered || !magazine)
		if (bolt_type == BOLT_TYPE_OPEN)
			chambered = null
		return FALSE
	if (magazine.ammo_count())
		chambered = magazine.get_round(keep_bullet || bolt_type == BOLT_TYPE_NO_BOLT)
		if (bolt_type != BOLT_TYPE_OPEN)
			chambered.forceMove(src)
	return TRUE
*/
/obj/item/ammo_box/magazine/turret
	name = "'Писятник'"
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/machinegun.dmi'
	base_icon_state = "kord_mag"
	icon_state = "kord_mag-1"
	max_ammo = 50
	ammo_type = /obj/item/ammo_casing/p50
	caliber = ".50 BMG"
	w_class = WEIGHT_CLASS_BULKY
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/turret/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[!!ammo_count()]"

/obj/item/ammo_box/magazine/turret/small
	name = "'Десятник'"
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/machinegun.dmi'
	icon_state = "kord"
	max_ammo = 10
	w_class = WEIGHT_CLASS_NORMAL

/obj/machinery/deployable_turret/cocijo
	name = "HMG \"Echis\""
	desc = "Testdesc"
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mounted_machinegun.dmi'
	icon_state = "kord_deployed"
	var/message_cooldown = 10
	var/rapid_turn_cooldown = 5
	control_type = /obj/item/gun_control/cocijo
	firesound = 'sound/weapons/gun/hmg/hmg.ogg'
// переделать спрайтики так, чтобы у нас было стейт с открытой крышкой и с закрытой. Магазин это единственное, что будет модульно.
// таким образом нам нужно реализовать добавление спрайта магазина (с пулями и без)
// что я хочу. Это сначала сделать механ того, что пулемет полностью отдельно, вытаскивание пушки тоже полностью отдельно.
// Т.е. сейчас. Есть пулемет как структура.
	var/rack_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_cocked.ogg'
	var/rack_sound_volume = 60
	var/rack_sound_vary = TRUE
	var/reload_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_reload.ogg'
	var/unload_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_unload.ogg'
	var/cover_sound = 'sound/weapons/gun/l6/l6_door.ogg'

	var/datum/map_zone/mapzone // used for far_sound, so we don't search in GLOB every single shot
	var/obj/item/ammo_box/magazine/magazine
	var/list/allowed_magazines = list(/obj/item/ammo_box/magazine/turret, /obj/item/ammo_box/magazine/turret/small)
	var/obj/item/ammo_casing/chambered
	var/magazine_wording = "Magazine"
	var/bolt_type = BOLT_TYPE_STANDARD
	var/cover_open = FALSE
	/// Doesn't ever keep ammo when loading a new round into the chamber. Mainly for BOLT_TYPE_NO_BOLT guns.
	var/doesnt_keep_bullet = FALSE

/obj/machinery/deployable_turret/cocijo/interact(mob/user, special_state)
	. = ..()
	if(chamber_round())
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		to_chat(user, span_notice("I rack the gun."))
		chambered.on_eject(src)
	else
		to_chat(user, span_notice("I try to rack the gun, but it's already racked."))

/obj/machinery/deployable_turret/cocijo/AltClick(mob/user)
	. = ..()
	if(!user.incapacitated())
		playsound(src, cover_sound, rack_sound_volume, TRUE) // сделать какой-нибудь звук
		cover_open = !cover_open
		to_chat(user, span_danger("I [cover_open ? "open" : "close"] the cover."))

/obj/machinery/deployable_turret/cocijo/MouseDrop(mob/over_user)
	. = ..()
	if(!over_user.incapacitated())
		if(!cover_open)
			to_chat(over_user, span_danger("I need to open cover first!"))
			return
		playsound(src, unload_sound, rack_sound_volume, TRUE)
		magazine.update_ammo_count()
		over_user.put_in_hands(magazine)
		magazine = null
		if(bolt_type == BOLT_TYPE_OPEN)
			chambered = null

/obj/machinery/deployable_turret/cocijo/attackby(obj/item/A, mob/user, params)
	if(..())
		return FALSE

	if(istype(A, /obj/item/ammo_casing/p50) && cover_open && bolt_type == BOLT_TYPE_STANDARD  && !chambered)
		chambered = A
		A.forceMove(src)
		to_chat(user, span_danger("Like a pro, I load the bullet directly into the [src]'s chamber."))

	if(istype(A, /obj/item/gun_control))
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		to_chat(user, span_notice("I rack the gun."))
		chamber_round()

	if(istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine)
			insert_magazine(user, AM)
		else
			to_chat(user, span_notice("There's already a [magazine_wording] in \the [src]."))
			return

/obj/machinery/deployable_turret/cocijo/proc/insert_magazine(mob/user, obj/item/ammo_box/magazine/inserted_mag, display_message = TRUE)
	if(!(inserted_mag.type in allowed_magazines))
		to_chat(user, span_warning("\The [inserted_mag] doesn't seem to fit into \the [src]..."))
		return FALSE
	if(!cover_open)
		to_chat(user, span_warning("I need to open it's cover first!"))
		return FALSE
	if(user.transferItemToLoc(inserted_mag, src))
		playsound(src, reload_sound, rack_sound_volume, TRUE)
		magazine = inserted_mag
		if (display_message)
			to_chat(user, span_notice("You load a new [magazine_wording] into \the [src]."))
		// if (magazine.ammo_count())
		// 	playsound(src, load_sound, load_sound_volume, load_sound_vary)
		// else
		// 	playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
		if (bolt_type == BOLT_TYPE_OPEN /*&& !bolt_locked*/)
			chamber_round(TRUE)
		update_appearance()
		SEND_SIGNAL(src, COMSIG_UPDATE_AMMO_HUD)
		return TRUE
	else
		to_chat(user, span_warning("You cannot seem to get \the [src] out of your hands!"))
		return FALSE


/obj/machinery/deployable_turret/cocijo/Initialize(mapload, apply_default_parts)
	var/turf/T = get_turf(src)
	mapzone = T.get_map_zone()
	. = ..()
/*
/obj/machinery/deployable_turret/cocijo/checkfire(atom/targeted_atom, mob/user)
	target = targeted_atom
	if(target == user || target == get_turf(src))
		return
	target_turf = get_turf(target)
	fire_helper(user)
*/
/obj/machinery/deployable_turret/cocijo/fire_helper(mob/user)
	if(user.incapacitated() || !(user in buckled_mobs))
		return FALSE
	//update_positioning() //REFRESH MOUSE TRACKING!!
	var/turf/targets_from = get_turf(src)
	if(QDELETED(target))
		target = target_turf
	if(!chambered)
		playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		balloon_alert(user,"Click!")
		return FALSE
	if(cover_open)
		to_chat(user, span_userdanger("The cover is [prob(10) ? "fucking" : ""] open!"))
		return FALSE
	if(!chambered.fire_casing(target, user, fired_from = targets_from)) //Тут же и стреляем
		return FALSE
	chambered.on_eject(user)
	chambered = null
	chamber_round()
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
	// M.pixel_y = 14
	M.setDir(dir)
	update_pixels(M)
	//direction_track(M)
	layer = ABOVE_MOB_LAYER
	//setDir(SOUTH)
	playsound(src,'sound/mecha/mechmove01.ogg', 50, TRUE)
	if(M.client)
		M.client.view_size.setTo(view_range)
	START_PROCESSING(SSfastprocess, src)

/obj/machinery/deployable_turret/cocijo/relaymove(mob/living/user, direction)
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

/obj/machinery/deployable_turret/cocijo/buckle_mob(mob/living/M, force, check_loc)
	. = ..()
	playsound(src, 'mod_celadon/_storage_sounds/sound/gun/kord/getting_on.ogg',100, FALSE)

/obj/machinery/deployable_turret/cocijo/checkfire(atom/targeted_atom, mob/user)
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

/obj/item/gun_control/cocijo
	name = "TestName"
	desc = "TestDesc"

/obj/item/gun_control/cocijo/afterattack(atom/targeted_atom, mob/user, flag, params)
	var/list/allowed_dirs = list(user.dir, turn(user.dir, 45), turn(user.dir, -45))
	var/obj/machinery/deployable_turret/E = user.buckled
	var/modifiers = params2list(params)
	if(get_dir(user, targeted_atom) in allowed_dirs)
		E.calculated_projectile_vars = calculate_projectile_angle_and_pixel_offsets(user, modifiers)
		E.checkfire(targeted_atom, user)

///Updates the pixel offset of user so it looks like their manning the gun from behind
/obj/machinery/deployable_turret/proc/update_pixels(mob/user, mounting = TRUE) // mounting = TRUE пока на время
	if(!mounting)
		//animate(user, pixel_x=user_old_x, pixel_y=user_old_y, 4, 1)
		return
	var/diff_x = 0
	var/diff_y = 0
	// на время
	var/user_old_x = 0
	var/user_old_y = 0
	switch(dir)
		if(NORTH)
			diff_y = -16 + user_old_y
			diff_x = 0
		if(SOUTH)
			diff_y = 16 + user_old_y
			diff_x = 0
		if(EAST)
			diff_x = -16 + user_old_x
			diff_y = 0
		if(WEST)
			diff_x = 16 + user_old_x
			diff_y = 0
	//animate(user, pixel_x=diff_x, pixel_y=diff_y, 0.4 SECONDS)
