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
	speed = 0.8

/obj/projectile/bullet/a127mm/ap/buffed/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	var/turf/location = get_turf(src)
	if(location)
		new /obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)

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
	icon_state = "a127-brass"
	bullet_skin = "ap"
	mob_overlay_icon = 'mod_celadon/_storage_icons/icons/items/clothing/mask/overlay/a127mm.dmi'
	mob_overlay_state = null
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a127mm/ap
	stack_size = 6
	slot_flags = ITEM_SLOT_MASK
	var/lit = FALSE
	var/lit_time = 0
	var/icon_on = "a127-brass-apon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"

/obj/item/ammo_casing/a127mm/ap/attackby(obj/item/attacking_item, mob/living/user)
	if(!lit)
		var/lighting_text = attacking_item.ignition_effect(src, user)
		if(lighting_text)
			light(lighting_text)
			lit_time = world.time
			//mob_overlay_state = "pelvis"
	else
		return ..()

/obj/item/ammo_casing/a127mm/ap/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, misfire)
	var/time_difference = (world.time - lit_time) / 10 //So we get seconds and not ticks
	if (BB && time_difference > 600) // if it was lit for more than 10 mins
		explosion(src, 0, 0, 2, 0, flame_range = 1)
		BB = null
		return
	if (BB && time_difference > 60) // if it was lit for more than a minute
		BB = new /obj/projectile/bullet/a127mm/ap/buffed
	. = ..()

/obj/item/ammo_casing/a127mm/ap/proc/light(flavor_text = null)
	if(lit)
		return
	if(!(flags_1 & INITIALIZED_1))
		icon_state = icon_on
		return

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
	//icon_state = "a127-brass-ap"
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
	desc = "Also known as Fer-de-Lance, this revolver is a highly experimental technology, firing 12.5mm rounds at unimaginable velocity."
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
