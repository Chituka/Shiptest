/obj/structure/powerline
	name = "Powerline"
	desc = "A huge bundle of double insulated cabling."
	icon = 'mod_celadon/_storage_icons/icons/powerline.dmi'
	icon_state = "cablerelay"
	plane = FLOOR_PLANE
	layer = WIRE_LAYER
	anchored = 1

/obj/structure/powerline/broken1
	icon_state = "cablerelay-broken-cable"

/obj/structure/powerline/broken2
	icon_state = "cablerelay-broken"

/obj/structure/powerline/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/porta_turret/ship/syndicate/capital
	name = "Coherator-class Super-Heavy Laser Turret"
	desc = "Heavy assault turret, that was designed to take down spaceships. Yet this one is in disarray and now it is used for anti-infantry purposes."
	icon = 'mod_celadon/_storage_icons/icons/turret_96x96.dmi'
	icon_state = "standard"
	base_icon_state = "standard"
	reqpower = 10000 // за каждый выстрел, коих у турели 4, т.е. за залп сеть нагружается на 40 киловатт в нелетале и 80 кВатт в летале
	active_power_usage = 15000 // не работает бтв
	stun_projectile = /obj/projectile/beam/hitscan/disabler/heavy
	stun_projectile_sound = 'sound/weapons/gun/laser/heavy_laser.ogg'
	lethal_projectile = /obj/projectile/beam/hitscan/laser/capital
	lethal_projectile_sound = 'sound/weapons/gun/laser/e40_las.ogg'
	scan_range = 18
	shot_delay = 10
	burst_delay = 0.5
	burst_size = 4
	spread = 20
	reaction_time = 30 // 3 секунды перед выстрелом, есть время убежать или попытаться нанести 140 урона турели, что спокойно возможно

	max_integrity = 350
	integrity_failure = 0.6
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 50, "bomb" = 70, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 90)

	pixel_y = -32
	pixel_x = -32

/obj/projectile/beam/hitscan/laser/capital
	name = "beam"
	damage = 40
	armour_penetration = 100 // you are fighting against anti-ship weapon, what did you expect
	range = 30
	tracer_type = /obj/effect/projectile/tracer/laser/capital
	hitscan_light_intensity = 5
	hitscan_light_range = 1
	hitscan_light_color_override = LIGHT_COLOR_LAVENDER
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	muzzle_flash_intensity = 4
	muzzle_flash_range = 1
	muzzle_flash_color_override = LIGHT_COLOR_LAVENDER
	impact_type = /obj/effect/temp_visual/explosion/fast
	impact_light_intensity = 10
	impact_light_range = 3
	light_color = LIGHT_COLOR_LAVENDER

/obj/machinery/power/grounding_rod/wall
	name = "wall-mounted grounding rod"
	desc = "Keep an area from being fried from Edison's Bane. This one is walled and it looks pitful."
	icon = 'mod_celadon/_storage_icons/icons/obj/cocijo_stuff/tesla_coil.dmi'
	density = 0

/obj/machinery/power/grounding_rod/wall/directional

/obj/machinery/power/grounding_rod/wall/directional/north
	dir = 2
	pixel_y = 32

/obj/machinery/power/grounding_rod/wall/directional/south
	dir = 1
	pixel_y = -32

/obj/machinery/power/grounding_rod/wall/directional/east
	dir = 8
	pixel_x = -32

/obj/machinery/power/grounding_rod/wall/directional/west
	dir = 4
	pixel_x = 32
