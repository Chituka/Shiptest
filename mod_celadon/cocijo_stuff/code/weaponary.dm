/obj/projectile/bullet/a12mm
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	icon_state= "bolter"
	damage = 70
	armour_penetration = 25

/obj/projectile/bullet/a12mm/ap
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 50
	armour_penetration = 60

/obj/projectile/bullet/a12mm/alum
	name ="12.7x55mm bullet"
	desc = "USE A WEEL GUN"
	damage = 90
	armour_penetration = 0

/obj/item/ammo_casing/a12mm
	name = "12.7x55mm bullet casing"
	desc = ""
	icon = 'mod_celadon/_storge_icons/icons/guns/ammo_bullets.dmi'
	icon_state = "a127-brass"
	var/icon_off = "cigoff"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a12mm
	stack_size = 6

/obj/item/ammo_casing/a12mm/ap
	name = "12.7x55mm bullet casing"
	desc = ""
	icon_state = "a127-brass-ap"
	mob_overlay_icon = "a127-brass-ap"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a12mm/ap
	stack_size = 6
	slot_flags = ITEM_SLOT_MASK

/obj/item/ammo_casing/a12mm/alum
	name = "12.7x55mm aluminium bullet casing"
	desc = ""
	icon_state = "a127-brass-alum"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/a12mm/alum
	stack_size = 6

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a12mm
	icon = 'mod_celadon/_storge_icons/icons/guns/ammo_bullets.dmi'
	icon_state = "a127-brass"
	ammo_type = /obj/item/ammo_casing/a12mm
	max_ammo = 6

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a12mm/ap
	icon_state = "a127-brass-ap"
	ammo_type = /obj/item/ammo_casing/a12mm/ap

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a12mm/alum
	icon_state = "a127-brass-alum"
	ammo_type = /obj/item/ammo_casing/a12mm/alum

/obj/item/ammo_box/magazine/internal/cylinder/a12mm
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a12mm
	caliber = "12.7mm"
	max_ammo = 6

/obj/item/storage/box/ammo/a12mm
	name = "box of 12.7x55mm ammo"
	desc = "A box of standard 12.7x55mm ammo."
	icon = 'mod_celadon/_storge_icons/icons/guns/ammo_boxes.dmi'
	icon_state = "a127mmbox"

/obj/item/storage/box/ammo/a12mm/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a12mm = 2)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/ammo/a12mm/alum
	name = "box of 12.7x55mm HP ammo"
	desc = "A steel box of 12.7x55mm HP ammo. Box seems to be quite cheeap..."
	icon = 'icons/obj/ammunition/ammo_boxes.dmi'
	icon_state = "generic-ammo"

/obj/item/storage/box/ammo/a12mm/alum/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a12mm/alum = 4)
	generate_items_inside(items_inside,src)

/obj/item/storage/fancy/cigarettes/cigars/a12mm
	name = "12.7x55mm AP ammo case"
	desc = "A case of imported 12,7x55mm AP ammo, renowned for their strong flavor after shot and large holes inside enemies."
	icon_state = "cohibacase"
	w_class = WEIGHT_CLASS_NORMAL
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/ammo_casing/a12mm/ap

/obj/item/storage/fancy/cigarettes/cigars/a12mm/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/ammo_casing/a12mm))

/obj/item/storage/fancy/cigarettes/cigars/a12mm/update_overlays()
	. = ..()
	if(!is_open)
		return
	var/bullet_position = 1 //generate sprites for cigars in the box
	for(var/obj/item/ammo_casing/a12mm/bullets in contents)
		var/mutable_appearance/bullet_overlay = mutable_appearance('mod_celadon/_storge_icons/icons/guns/ammo_bullets.dmi', "[bullets.icon_off]_[bullet_position]")
		. += bullet_overlay
		bullet_position++

/obj/item/gun/ballistic/revolver/fdl
	name = "\improper FDL-12 revolver"
	desc = "Also known as Fer-de-Lance, this revolver is a highly experimental technology, firing 12.5mm rounds at unimaginable velocity."
	icon = 'mod_celadon/_storge_icons/icons/items/weapons/cocijo_guns.dmi'
	icon_state = "fdl12"
	fire_sound = 'mod_celadon/_storge_sounds/sound/gun/fdl12_shot.ogg'
	manufacturer = MANUFACTURER_INTEQ
	safety_wording = "safety"
	spread = 0
	spread_unwielded = 10
	recoil = 10
	recoil_unwielded = 20
	gate_loaded = TRUE
	semi_auto = FALSE
	default_ammo_type = /obj/item/ammo_box/magazine/internal/cylinder/a12mm
	allowed_ammo_types = list(
	/obj/item/ammo_box/magazine/internal/cylinder/a12mm,
	)

/obj/item/gun/ballistic/revolver/fdl/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ammo_hud/revolver)

/obj/item/gun/ballistic/revolver/fdl/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	playsound(loc, 'mod_celadon/_storge_sounds/sound/gun/fdl12_charge.ogg', 100)
	if(do_after(user, 1 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE))
		. = ..()
