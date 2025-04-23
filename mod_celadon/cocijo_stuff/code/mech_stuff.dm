/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower
	name = "\improper GEC \"Ballista\" Exosuit Slug Thrower"
	desc = "A weapon for combat exosuits. Shoots heavy slugs at high-speed."
	icon_state = "mecha_carbine"
	energy_drain = 500
	equip_cooldown = 20
	projectile = /obj/projectile/bullet/heavy_slug
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	projectiles = 12
	projectiles_cache = 12
	projectiles_cache_max = 24
	harmful = TRUE
	ammo_type = "heavy_slug"
	eject_casings = FALSE

/obj/projectile/bullet/heavy_slug
	name = "Accelerated Heavy Slug"
	icon_state = "gauss-slug"
	damage = 80
	armour_penetration = 20
	speed_mod = BULLET_SPEED_SHOTGUN
	range = 50
	light_system = 5
	light_color = MOVABLE_LIGHT
	light_range = 5
	muzzle_type = /obj/effect/projectile/muzzle/gauss
	tracer_type = /obj/effect/projectile/tracer/gauss
	impact_type = /obj/effect/projectile/impact/gauss

/obj/item/mecha_ammo/heavy_slug
	name = "Heavy Slug ammo"
	desc = "A box of ferromagnetic heavy slugs for use with exosuit weapons. They are really heavy."
	icon_state = "incendiary"
	rounds = 12
	ammo_type = "heavy_slug"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder
	name = "\improper GEC \"Trebuchet\" ESMSSSHSL"
	desc = "Exosuit Shoulder-Mounted Single-Shot Super-Heavy Slug Launcher... You have no idea what that means, but it is certainly a weapon for combat exosuits and it shoots super-heavy slugs at extremely low speed."
	icon = 'mod_celadon/_storge_icons/icons/mob/test.dmi'
	icon_state = "test"
	energy_drain = 500
	equip_cooldown = 20
	projectile = /obj/projectile/bullet/heavy_slug/super
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	projectiles = 1
	projectiles_cache = 6
	projectiles_cache_max = 12
	disabledreload = TRUE
	harmful = TRUE
	ammo_type = "heavy_slug"
	eject_casings = FALSE
	var/icon/slughthrower_shoulder_overlay

/obj/projectile/bullet/heavy_slug/super
	name = "COMICALLY LARGE AND SLOW SLUG"
	icon_state = "gauss-slug" //Поменять иконку и трансформ
	damage = 150
	armour_penetration = 15
	speed_mod = 3
	range = 50
	light_system = 20
	light_color = MOVABLE_LIGHT
	light_range = 20
	muzzle_type = /obj/effect/projectile/muzzle/gauss
	tracer_type = /obj/effect/projectile/tracer/gauss
	impact_type = /obj/effect/projectile/impact/gauss

/obj/projectile/bullet/heavy_slug/super/Range()
	..()
	transform *= 2

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(chassis)
		chassis.cut_overlay(slughthrower_shoulder_overlay)
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder/attach(obj/mecha/M as obj)
	..()
	slughthrower_shoulder_overlay = new(src.icon, icon_state = "test")
	M.add_overlay(slughthrower_shoulder_overlay)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder/detach()
	chassis.cut_overlay(slughthrower_shoulder_overlay)
	STOP_PROCESSING(SSobj, src)
	..()
