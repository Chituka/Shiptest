#define SUNS_GENERAL_ACCESS 511
#define SUNS_BLACK_ACCESS 513
#define SUNS_WHITE_ACCESS 512

/obj/machinery/door/airlock/suns
	name = "SUNS airlock"
	desc = "An airlock with a remarkably esoteric color scheme. What's behind it..?"
	icon = 'icons/obj/doors/airlocks/station/atmos.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_research

/obj/machinery/door/airlock/suns/locked
	req_access_txt = "511"
	req_ship_access = FALSE
	autoclose = FALSE

/obj/machinery/door/airlock/suns/locked/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/card/id/suns/secret))
		if(check_access(I))
			playsound(src,'mod_celadon/_storage_sounds/sound/effects/right_short.ogg',100)
			if(do_after(user,20,src))
				try_to_activate_door(user)
		else
			playsound(src,'mod_celadon/_storage_sounds/sound/effects/wrong_short.ogg',100)
			do_after(user,20,src)

//Специально удаляю любое взаимодействие, чтобы дверь реагировала только на ключ-карты
/obj/machinery/door/airlock/suns/locked/Bumped(atom/movable/AM)

/obj/machinery/door/airlock/suns/locked/attack_hand(mob/user)
	add_fingerprint(user)

/obj/machinery/door/airlock/suns/locked/bumpopen(mob/living/user)
	add_fingerprint(user)

/obj/machinery/door/airlock/suns/locked/white
	icon = 'mod_celadon/_storage_icons/icons/obj/cocijo_stuff/suns_airlock_white.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_sec
	req_access_txt = "512"

/obj/machinery/door/airlock/suns/locked/black
	icon = 'mod_celadon/_storage_icons/icons/obj/cocijo_stuff/suns_airlock_black.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_com
	req_access_txt = "513"

/obj/item/card/id/suns/secret
	name = "SUNS access card"
	desc = "A keycard to open some of SUNS' mysterious doors."
	access = list(SUNS_GENERAL_ACCESS)
	icon = 'mod_celadon/_storage_icons/icons/obj/cocijo_stuff/keycards.dmi'
	registered_age = "512"

/obj/item/card/id/suns/secret/update_label()
	//Оставляем пустым, потому что название не должно обновляться

/obj/item/card/id/suns/secret/white
	name = "White SUNS access card"
	desc = "A white keycard with SUNS initials on it. Probably opens their doors."
	icon_state = "white"
	access = list(SUNS_WHITE_ACCESS)

/obj/item/card/id/suns/secret/black
	name = "Black SUNS access card"
	desc = "They're black now?! Anyway, it's an extremely stylish and expensive-looking keycard, which may or may not cost your life, if you lose it."
	icon_state = "black"
	access = list(SUNS_BLACK_ACCESS)

/obj/item/storage/box/suns/white
	name = "white SUNS access card box"
	desc = "A box of standard 12.7x55mm ammo."
	icon = 'mod_celadon/_storage_icons/icons/guns/ammo_boxes.dmi'
	icon_state = "a127mmbox"

/obj/item/storage/box/suns/white/PopulateContents()
	var/static/items_inside = list(
		/obj/item/card/id/suns/secret/white = 2)
	generate_items_inside(items_inside,src)
