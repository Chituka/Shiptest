/obj/structure/powerline
	name = "Powerline"
	desc = "A huge bundle of double insulated cabling."
	icon = 'mod_celadon/_storge_icons/icons/powerline.dmi'
	icon_state = "cablerelay"
	plane = FLOOR_PLANE
	layer = WIRE_LAYER

/obj/structure/powerline/broken1
	icon_state = "cablerelay-broken-cable"

/obj/structure/powerline/broken2
	icon_state = "cablerelay-broken"

/obj/structure/powerline/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/porta_turret/syndicate/no_access/energy/heavy/capital
	name = "Main Laser Subsidiary Turret"
	desc = "Heavy assault turret, that was designed to take down space ships. Yet this one is in disarray and now it is used for anti-infantry."
	icon = 'mod_celadon/_storge_icons/icons/turret_96x96.dmi'
	icon_state = "standard"
	base_icon_state = "standard"
	active_power_usage = 15000
	scan_range = 18
	shot_delay = 0.5
	pixel_y = -32
	pixel_x = -32
	bound_y = -32
	bound_x = -32
	stun_projectile = /obj/projectile/beam/hitscan/kalix
	stun_projectile_sound = 'sound/weapons/gun/laser/heavy_laser.ogg'
	lethal_projectile = /obj/projectile/beam/hitscan/kalix
	lethal_projectile_sound = 'sound/weapons/gun/laser/heavy_laser.ogg'
