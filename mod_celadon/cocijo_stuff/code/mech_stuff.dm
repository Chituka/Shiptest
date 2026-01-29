#define COMSIG_MECHA_PHYS_DEF_ACTIVATE "mecha_phys_def_activate"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower
	name = "GEC \"Ballista\" Exosuit Slug Thrower"
	desc = "A weapon for combat exosuits. It is a hybrid electromagnetic weapon that shoots heavy slugs at high-speed. \n\
		Being a combination of powder and gauss, it uses magnetic cumulation generator, that charges capacitors for this gun from each detonation of combustible component inside the 'semi-regular' casing. \n\
		Basically, a down-sized version Trebuchet."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mecha_equipment.dmi'
	icon_state = "mecha_slugthrower"
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
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/mecha_ammo.dmi'
	icon_state = "heavy_slug"
	rounds = 12
	ammo_type = "heavy_slug"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder
	name = "GEC \"Trebuchet\" ESMSSSHSL"
	desc = "Exosuit Shoulder-Mounted Single-Shot Super-Heavy Slug Launcher... That's way too many words for you to proccess, but it is certainly a weapon for combat exosuits. \n\
		It is a hybrid of hybrid electromagnetic weapon that shoots super-heavy slugs at extremely low speed. \n\
		Being a combination of powder, railgun and gauss, it uses magnetic cumulation generator, that charges capacitors for this gauss-rail monstriocity from each detonation of combustible component inside the canister."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/mecha_equipment.dmi'
	icon_state = "mecha_slugthrower_shoulder"
	energy_drain = 500
	equip_cooldown = 20
	projectile = /obj/projectile/bullet/heavy_slug/super
	fire_sound = 'mod_celadon/_storage_sounds/sound/gun/trebuchet_shot.ogg'
	projectiles = 1
	projectiles_cache = 0
	projectiles_cache_max = 0
	disabledreload = TRUE
	harmful = TRUE
	ammo_type = "super_heavy_slug"
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
	if(chassis)
		chassis.cut_overlay(slughthrower_shoulder_overlay)
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder/attach(obj/mecha/M as obj)
	..()
	slughthrower_shoulder_overlay = new(src.icon, icon_state = "mecha_slugthrower_shoulder")
	M.add_overlay(slughthrower_shoulder_overlay)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/slugthrower_shoulder/detach()
	chassis.cut_overlay(slughthrower_shoulder_overlay)
	..()

/obj/item/mecha_ammo/super_heavy_slug
	name = "Super-Heavy Slug container"
	desc = "This is a container for a super-heavy slug, designed for magnetic cumulation generator, retaining high durability for protecting externals from explosive compound inside even if it explodes... Always when it explodes. This one feels really heavy."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/mecha_ammo.dmi'
	icon_state = "super_heavy_slug"
	rounds = 1
	direct_load = TRUE
	load_audio = 'sound/weapons/gun/general/load_shell.ogg'
	ammo_type = "super_heavy_slug"

/obj/item/mecha_ammo/super_heavy_slug/update_ammo_name()
	if(rounds == 0)
		qdel(src)

/datum/action/innate/mecha/mech_phys_defence
	name = "Toggle an energy shield that blocks all attacks from the faced direction at a heavy power cost."
	button_icon_state = "mech_defense_mode_off"

/datum/action/innate/mecha/mech_phys_defence/Activate(forced_state = FALSE)
	SEND_SIGNAL(chassis.p_shield, COMSIG_MECHA_PHYS_DEF_ACTIVATE, src)

/obj/mecha
	var/obj/item/mecha_parts/mecha_equipment/phys_shield/p_shield // P stands for Physical GOD I HATE DURAND
	var/shield_hit_sound
	var/datum/action/innate/mecha/mech_phys_defence/phys_defence = new

/obj/mecha/GrantActions(mob/living/user, human_occupant)
	if(human_occupant)
		eject_action.Grant(user, src)
	if(enclosed)
		internals_action.Grant(user, src)
	cycle_action.Grant(user, src)
	lights_action.Grant(user, src)
	stats_action.Grant(user, src)
	strafing_action.Grant(user, src)
	if(p_shield)
		phys_defence.Grant(user, src)

/obj/mecha/RemoveActions(mob/living/user, human_occupant)
	if(human_occupant)
		eject_action.Remove(user)
	internals_action.Remove(user)
	cycle_action.Remove(user)
	lights_action.Remove(user)
	stats_action.Remove(user)
	strafing_action.Remove(user)
	if(zoom_action)
		zoom_action.Remove(user)
		user.client.view_size.zoomIn()
	if(p_shield)
		phys_defence.Remove(user)

/obj/mecha/bullet_act(obj/projectile/Proj)
	if(p_shield && p_shield.is_deployed && dir_check(Proj))
		p_shield.bullet_act(Proj)
		return
	else
		if(!enclosed && occupant && !silicon_pilot && !Proj.force_hit && (Proj.def_zone == BODY_ZONE_HEAD || Proj.def_zone == BODY_ZONE_CHEST)) //allows bullets to hit the pilot of open-canopy mechs
			occupant.bullet_act(Proj) //If the sides are open, the occupant can be hit
			return BULLET_ACT_HIT
		log_message("Hit by projectile. Type: [Proj.name]([Proj.flag]).", LOG_MECHA, color="red")
		. = ..()

/obj/mecha/welder_act(mob/living/user, obj/item/W)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		return
	. = TRUE
	if(internal_damage & MECHA_INT_TANK_BREACH)
		if(!W.use_tool(src, user, 0, volume=50, amount=1))
			return
		clearInternalDamage(MECHA_INT_TANK_BREACH)
		to_chat(user, span_notice("You repair the damaged gas tank."))
		return

	if(p_shield)
		if(p_shield.is_deployed)
			if(p_shield.atom_integrity < p_shield.max_integrity)
				if(do_after(user, 20, target= src))
					W.use_tool(src, user, 0, 1, 50)
					user.visible_message(span_notice("[user] repairs some damage to [p_shield.name]."), span_notice("You repair some damage to [p_shield.name]."))
					p_shield.atom_integrity += min(p_shield.repair_amount, p_shield.max_integrity-p_shield.atom_integrity)
					return
			else
				to_chat(user,span_danger("Shield's fully repaired. If I want to repait the mecha itself, I need to collapse it's giant shield!"))
		else
			to_chat(user,span_danger("If I want to repair the shield, I need to deploy it first!"))

	while(atom_integrity < max_integrity)
		if(!do_after(user, 20, target= src))
			return
		if(!W.use_tool(src, user, 0, volume=50, amount=1))
			return
		user.visible_message(span_notice("[user] repairs some damage to [name]."), span_notice("You repair some damage to [src]."))
		atom_integrity += min(10 * repair_multiplier, max_integrity-atom_integrity)
		if(atom_integrity == max_integrity)
			to_chat(user, span_notice("It looks to be fully repaired now."))
			return
	to_chat(user, span_warning("The [name] is at full integrity!"))



/obj/mecha/proc/dir_check(turf/aloc, skip_defence = FALSE)
	if (!p_shield)
		return FALSE
	. = FALSE
	switch(dir)
		if (1)
			if(abs(x - aloc.x) <= (y - aloc.y) * -2)
				. = TRUE
		if (2)
			if(abs(x - aloc.x) <= (y - aloc.y) * 2)
				. = TRUE
		if (4)
			if(abs(y - aloc.y) <= (x - aloc.x) * -2)
				. = TRUE
		if (8)
			if(abs(y - aloc.y) <= (x - aloc.x) * 2)
				. = TRUE
	return

/obj/item/mecha_parts/mecha_equipment/phys_shield
	name = "Mecha Shield Module"
	desc = "0512"
	icon_state = "mecha_abooster_proj"
	equip_cooldown = 10
	selectable = 0
	atom_integrity = 100
	var/is_deployed = FALSE
	var/icon/shield_overlay
	var/repair_amount = 20 //How much integrity we restore with each repair

/obj/item/mecha_parts/mecha_equipment/phys_shield/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MECHA_PHYS_DEF_ACTIVATE, PROC_REF(relay))

/obj/item/mecha_parts/mecha_equipment/phys_shield/Destroy()
	if(chassis)
		chassis.cut_overlay(shield_overlay)
	UnregisterSignal(src, COMSIG_MECHA_PHYS_DEF_ACTIVATE)
	return ..()

/obj/item/mecha_parts/mecha_equipment/phys_shield/atom_destruction(damage_flag)
	SHOULD_CALL_PARENT(FALSE)
	playsound(loc, 'sound/effects/sparks1.ogg', 35)
	if(isliving(loc))
		loc.balloon_alert(loc, "Shield's down!")
	atom_integrity = 1
	is_deployed = TRUE
	relay(chassis)

/obj/item/mecha_parts/mecha_equipment/phys_shield/proc/relay(obj/mecha/M)
	SIGNAL_HANDLER

	if(atom_integrity <= 1)
		chassis.occupant_message(span_danger("Shield module has suffered critical damage. Manual repairs are required."))
		is_deployed = FALSE //Just to be absolutely sure
		return
	if(is_deployed)
		chassis.cut_overlay(shield_overlay)
		chassis.occupant_message(span_notice("Shield's collapsed. Defensive capabilites lowered."))
	else
		shield_overlay = new(src.icon, icon_state = "repair_droid")
		chassis.add_overlay(shield_overlay)
		chassis.occupant_message(span_notice("Shield's deployed. Now blocking incoming attacks."))
	is_deployed = !is_deployed
	chassis.update_appearance(shield_overlay)

/obj/item/mecha_parts/mecha_equipment/phys_shield/welder_act(mob/living/user, obj/item/W)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		return
	. = TRUE
	if(atom_integrity < max_integrity)
		if(do_after(user, 20, target= src))
			W.use_tool(src, user, 0, 1, 50)
			atom_integrity += min(repair_amount*2, max_integrity-atom_integrity)
			to_chat(user,span_italics("I repair ins and outs of the shield."))
			return
	else
		to_chat(user,span_danger("It's fully repaired!"))

/obj/item/mecha_parts/mecha_equipment/phys_shield/try_attach_part(mob/user, obj/mecha/M)
	if(..())
		M.p_shield = src
	else
		. = ..()

/obj/item/mecha_parts/mecha_equipment/phys_shield/detach(atom/moveto=null, mob/user)
	if(chassis.occupant)
		chassis.phys_defence.Remove(chassis.occupant)
	chassis.phys_defence.Remove(user)
	chassis.cut_overlay(shield_overlay)
	chassis.p_shield = null
	. = ..()

/obj/item/mecha_parts/mecha_equipment/phys_shield/action(atom/target)
	if(!atom_integrity <= 1)
		is_deployed = !is_deployed
