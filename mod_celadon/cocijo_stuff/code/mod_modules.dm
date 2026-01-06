///Medbeam - Medbeam but built into a modsuit
/obj/item/mod/module/medbeam
	name = "MOD Medbeam Module"
	desc = "A wrist mounted variant of the medbeam gun, allowing the user to heal their allies without the risk of dropping it."
	icon_state = "chronogun"
	module_type = MODULE_ACTIVE
	complexity = 1
	active_power_cost = DEFAULT_CHARGE_DRAIN
	device = /obj/item/gun/medbeam/mod
	incompatible_modules = list(/obj/item/mod/module/medbeam)
	removable = TRUE
	cooldown_time = 0.5

/obj/item/gun/medbeam/mod
	name = "MOD medbeam"

/obj/item/mod/module/hat_stabilizer/syndicate
	name = "MOD elite hat stabilizer module"
	desc = "A simple set of deployable stands, directly atop one's head; \
		these will deploy under a hat to keep it from falling off, allowing them to be worn atop the sealed helmet. \
		You still need to take the hat off your head while the helmet deploys, though. This is a must-have for \
		Syndicate Operatives and Agents alike, enabling them to continue to style on the opposition even while in their MODsuit."
	complexity = 0
	removable = FALSE

/obj/item/mod/module/flamethrower/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	var/obj/projectile/flame = new /obj/projectile/flamethrower(mod.wearer.loc)
	flame.preparePixelProjectile(target, mod.wearer)
	flame.firer = mod.wearer
	playsound(src, 'sound/items/modsuit/flamethrower.ogg', 75, TRUE)
	INVOKE_ASYNC(flame, TYPE_PROC_REF(/obj/projectile, fire))
	drain_power(use_power_cost)
