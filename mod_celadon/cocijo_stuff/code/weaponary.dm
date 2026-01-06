/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_108mm
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi'
	ammo_type = /obj/item/ammo_casing/a127_108mm

/obj/item/storage/box/ammo/a127_108mm
	name = "box of 12.7x108mm ammo"
	desc = "A box of standard 12.7x108mm ammo. Deal incredible "
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'
	icon_state = "a127mmbox"

/obj/item/storage/box/ammo/a127_108mm/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_55mm = 4)
	generate_items_inside(items_inside,src)

/obj/item/ammo_casing/a127_108mm
	name = "12.7x108mm bullet casing"
	desc = "A 12.7x108mm bullet casing."
	icon_state = "big-steel"
	caliber = "12.7x108mm"
	projectile_type = /obj/projectile/bullet/a127_108mm

/obj/projectile/bullet/a127_108mm
	name = "12.7x108mm bullet"
	speed = BULLET_SPEED_SNIPER
	damage = 60
	armour_penetration = 60
	var/breakthings = TRUE
	bullet_identifier = "huge bullet"
	color = "red"
	light_system = MOVABLE_LIGHT
	light_color = COLOR_SOFT_RED
	light_range = 2
	var/obj_bonus = 100 // на 10 урона больше по стенкам чем у 50 БМГ

/obj/projectile/bullet/a127_108mm/on_hit(atom/target, blocked = 0)
	if(isobj(target) && (blocked != 100) && breakthings)
		if(ismecha(target))
			return ..()
		var/obj/O = target
		O.take_damage(obj_bonus, BRUTE, "bullet", FALSE)
	return ..()

/obj/item/ammo_box/magazine/internal/cylinder/a127_55mm
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a127_55mm
	caliber = "12.7mm"
	max_ammo = 6

/obj/projectile/bullet/a127_55mm
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	icon_state= "bolter"
	damage = 70
	armour_penetration = 25

/obj/projectile/bullet/a127_55mm/ap
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 50
	armour_penetration = 60

/obj/projectile/bullet/a127_55mm/ap/buffed
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

/obj/projectile/bullet/a127_55mm/ap/buffed/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		new /obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)

/obj/projectile/bullet/a127_55mm/ap/buffed/on_hit(atom/target, blocked = FALSE)
	..()
	var/turf/location = get_turf(target)
	if(location)
		new /obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)
	return BULLET_ACT_HIT

/obj/projectile/bullet/a127_55mm/alum
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 90
	armour_penetration = 0

/obj/item/ammo_casing/a127_55mm
	name = "12.7x55mm bullet casing"
	desc = "AMR stands for Anti-materiel revolver."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi'
	icon_state = "a127-brass"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127_55mm
	stack_size = 6

/obj/item/ammo_casing/a127_55mm/alum
	name = "12.7x55mm aluminium bullet casing"
	desc = "A fine thing for making criminally large holes inside your enemy... If they don't have armour."
	bullet_skin = "alum"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127_55mm/alum
	stack_size = 6

/obj/item/ammo_casing/a127_55mm/ap
	name = "12.7x55mm armor penetrating bullet casing"
	desc = "A exceptionally rare bullet for exceptionally thick armour. For incriminating their personal space and existence, of course."
	bullet_skin = "ap"
	mob_overlay_icon = 'mod_celadon/_storage_icons/icons/items/clothing/mask/overlay/a127mm.dmi'
	mob_overlay_state = null
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127_55mm/ap
	stack_size = 6
	slot_flags = ITEM_SLOT_MASK
	var/lit = FALSE
	var/lit_time = 0
	var/lit_bullet_skin = "apon"
	var/icon_off = "cigaroff"

/obj/item/ammo_casing/a127_55mm/ap/attackby(obj/item/attacking_item, mob/user, params)
	if(!lit)
		var/lighting_text = attacking_item.ignition_effect(src, user)
		if(lighting_text)
			light(lighting_text)
			lit_time = world.time
	. = ..()

/obj/item/ammo_casing/a127_55mm/ap/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, misfire)
	var/time_difference = (world.time - lit_time) / 10 //So we get seconds and not ticks
	if (BB && lit && (time_difference > 600)) // if it was lit for more than 10 mins
		explosion(src, 0, 0, 2, 0, flame_range = 1)
		BB = null
		return
	if (BB && lit && (time_difference > 60)) // if it was lit for more than a minute
		qdel(BB)
		BB = new /obj/projectile/bullet/a127_55mm/ap/buffed
	. = ..()

/obj/item/ammo_casing/a127_55mm/ap/proc/light(flavor_text = null)
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

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_55mm/ap
	ammo_type = /obj/item/ammo_casing/a127_55mm/ap

/obj/item/storage/fancy/cigarettes/cigars/a127_55mm
	name = "12.7x55mm AP ammo case"
	desc = "A case of imported 12,7x55mm AP ammo, renowned for their strong flavor after shot and large holes inside enemies."
	icon_state = "cohibacase"
	w_class = WEIGHT_CLASS_NORMAL
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/ammo_casing/a127_55mm/ap

/obj/item/storage/fancy/cigarettes/cigars/a127_55mm/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/ammo_casing/a127_55mm))

/obj/item/storage/fancy/cigarettes/AltClick(mob/living/carbon/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	var/obj/item/ammo_casing/a127_55mm/W = locate(/obj/item/ammo_casing/a127_55mm) in contents
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		contents -= W
		to_chat(user, span_notice("You take \a [W] out of the pack."))
	else
		to_chat(user, span_notice("There are no [contents_tag]s left in the pack."))

/obj/item/storage/fancy/cigarettes/cigars/a127_55mm/update_overlays()
	. = ..()
	if(!is_open)
		return
	var/bullet_position = 1 //generate sprites for cigars in the box
	for(var/obj/item/ammo_casing/a127_55mm/ap/bullets in contents)
		var/mutable_appearance/bullet_overlay = mutable_appearance('mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi', "[bullets.icon_off]_[bullet_position]")
		. += bullet_overlay
		bullet_position++

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_55mm
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_bullets.dmi'
	//icon_state = "a127-brass"
	ammo_type = /obj/item/ammo_casing/a127_55mm
	max_ammo = 6

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_55mm/alum
	//icon_state = "a127-brass-alum"
	ammo_type = /obj/item/ammo_casing/a127_55mm/alum

/obj/item/storage/box/ammo/a127_55mm
	name = "box of 12.7x55mm ammo"
	desc = "A box of standard 12.7x55mm ammo."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'
	icon_state = "a127mmbox"

/obj/item/storage/box/ammo/a127_55mm/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_55mm = 2)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/ammo/a127_55mm/alum
	name = "box of 12.7x55mm HP ammo"
	desc = "A steel box of 12.7x55mm HP ammo. Box seems to be quite cheeap..."
	icon = 'icons/obj/ammunition/ammo_boxes.dmi'
	icon_state = "generic-ammo"

/obj/item/storage/box/ammo/a127_55mm/alum/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a127_55mm/alum = 4)
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
	default_ammo_type = /obj/item/ammo_box/magazine/internal/cylinder/a127_55mm
	allowed_ammo_types = list(
	/obj/item/ammo_box/magazine/internal/cylinder/a127_55mm,
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

	///does this have a magazine cover?
	var/has_cover = FALSE
	///is the cover opened? Yeah, we reuse it here, but.. why not
	sealed_magazine = TRUE
	var/cover_sound = 'sound/weapons/gun/l6/l6_door.ogg'
	var/cover_sound_volume = 80

	/// does this have a GLOBAAL SOUND?
	var/has_global_sound = FALSE
	var/mid_global_fire_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/single_far.ogg'
	var/far_global_fire_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/single_far.ogg'
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

	has_cover = TRUE

	fire_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/single_close_loud.ogg'
	rack_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_cocked.ogg'
	rack_sound_volume = 80
	load_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_reload.ogg'
	eject_sound = 'mod_celadon/_storage_sounds/sound/gun/kord/temp_kord_unload.ogg'
	has_global_sound = TRUE

	gun_firemodes = list(FIREMODE_FULLAUTO)
	default_firemode = FIREMODE_FULLAUTO

	fire_delay = 0.2 SECONDS

	show_magazine_on_sprite = TRUE
	show_magazine_on_sprite_ammo = TRUE
	mag_display_ammo = TRUE
	unique_mag_sprites_for_variants = TRUE

	slot_flags = ITEM_SLOT_BACK
	bolt_type = BOLT_TYPE_STANDARD
	tac_reloads = FALSE

	wield_slowdown = HMG_SLOWDOWN

	default_ammo_type = /obj/item/ammo_box/magazine/echis
	allowed_ammo_types = list(
		/obj/item/ammo_box/magazine/echis,
		/obj/item/ammo_box/magazine/echis/small
	)

	spread = 12
	spread_unwielded = 35
	recoil = 10
	recoil_unwielded = 60

NO_MAG_GUN_HELPER(automatic/hmg/superheavy/echis)
// Сделать так, что его можно таскать только на спине или на двух руках...
// Посмотреть у гибтонита
// Мб сделать так, что с магазином ты его не можешь таскать на спине.
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
		to_chat(user, span_danger("I [sealed_magazine ? "close" : "open"] the cover."))

/obj/item/gun/ballistic/automatic/hmg/superheavy/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(has_cover)
		if(!sealed_magazine)
			to_chat(user, span_userdanger("The cover is [prob(10) ? "fucking" : ""] open!"))
			return
	. = ..()

/obj/item/gun/ballistic/automatic/hmg/superheavy/secondary_action(mob/living/user)
	if(!user.incapacitated())
		playsound(src, cover_sound, cover_sound_volume, TRUE)
		sealed_magazine = !sealed_magazine
		update_appearance()
		to_chat(user, span_danger("I [sealed_magazine ? "close" : "open"] the cover."))
	. = ..()

/obj/item/gun/ballistic/automatic/hmg/superheavy/shoot_live_shot(mob/living/user, pointblank = FALSE, atom/pbtarget = null, message = TRUE)
	if(!suppressed && has_global_sound)
		playsound(src,far_global_fire_sound,100, TRUE, 100, SOUND_FALLOFF_EXPONENT = 0.5, channel = 1011, ignore_walls = TRUE,falloff_distance = 100)
		playsound(src,mid_global_fire_sound,100, TRUE, 15, SOUND_FALLOFF_EXPONENT = 1, channel = 1011)
	. = ..()

/obj/item/ammo_box/magazine/echis
	name = "SHMG \"Echis\" box magazine (12.7x108mm)"
	desc = "A extremely large and heavy 50-round box magazine designed for the SHMG \"Echis\". These rounds deal absurd damage, and bypass most protective equipment. Yet, compared to .50 BMG, they are less lethal."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/machinegun.dmi'
	base_icon_state = "kord_mag"
	icon_state = "kord_mag-1"
	ammo_type = /obj/item/ammo_casing/a127_108mm
	caliber = "12.7x108mm"
	max_ammo = 50
	w_class = WEIGHT_CLASS_BULKY
	multiple_sprites = AMMO_BOX_FULL_EMPTY


/obj/item/ammo_box/magazine/echis/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[!!ammo_count()]"

/obj/item/ammo_box/magazine/echis/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/echis/small
	name = "SHMG \"Echis\" 10-round magazine (12.7x108mm)"
	desc = "A large 10-round box magazine for the SHMG \"Echis\". These rounds deal absurd damage, and bypass most protective equipment. Yet, compared to .50 BMG, they are less lethal."
	base_icon_state = "kord_small_mag"
	icon_state = "kord_small_mag-1"
	max_ammo = 10
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/ammo_box/magazine/echis/small/empty
	start_empty = TRUE


	//playsound(src,'mod_celadon/_storage_sounds/sound/gun/kord/single_far.ogg',100, TRUE, 100, SOUND_FALLOFF_EXPONENT = 0.5, channel = 1023, ignore_walls = TRUE,falloff_distance = 100)
	//playsound(src,'mod_celadon/_storage_sounds/sound/gun/kord/single_mid.ogg',100, TRUE, 15, SOUND_FALLOFF_EXPONENT = 1, channel = 1023)
	// playsound(src,'mod_celadon/_storage_sounds/sound/gun/kord/single_close_loud.ogg',100, TRUE, SOUND_FALLOFF_EXPONENT = 0.1, channel = 1023)
	/*
	var/turf/T = get_turf(src)
	mapzone = T.get_map_zone()
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
	*/
