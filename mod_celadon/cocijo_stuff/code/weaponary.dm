/obj/projectile/bullet/a12mm
	name ="12.5mm bullet"
	desc = "USE A WEEL GUN"
	icon_state= "bolter"
	damage = 70
	armour_penetration = 25

/obj/item/ammo_casing/a12mm
	name = "12.5mm bullet shell"
	icon_state = "40mmHE"
	caliber = "12.5mm"
	projectile_type = /obj/projectile/bullet/a12mm
	stack_size = 6

/obj/item/ammo_box/magazine/internal/cylinder/a12mm
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a12mm
	caliber = "12.5mm"
	max_ammo = 6

/obj/item/gun/ballistic/revolver/fdl
	name = "\improper FDL-12 revolver"
	desc = "Also known as Fer-de-Lance, this revolver is a highly experimental technology, firing unimaginable 12.5mm rounds."
	icon = 'mod_celadon/_storge_icons/icons/guns/horizonx.dmi'
	icon_state = "horizonx"
	fire_sound = 'mod_celadon/_storge_sounds/sound/gun/shot_hozizonx.ogg'
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
