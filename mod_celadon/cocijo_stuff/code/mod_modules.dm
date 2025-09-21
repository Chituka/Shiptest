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

///Radiation Protection - Protects the user from radiation, gives them a geiger counter and rad info in the panel.
/obj/item/mod/module/rad_protection
	name = "MOD radiation protection module"
	desc = "A module utilizing polymers and reflective shielding to protect the user against ionizing radiation; \
		a common danger in space. This comes with software to notify the wearer that they're even in a radioactive area, \
		giving a voice to an otherwise silent killer."
	icon_state = "radshield"
	complexity = 2
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/rad_protection)
	tgui_id = "rad_counter"
	/// Radiation threat level being perceived.
	var/perceived_threat_level
	var/list/armor_values = list("rad" = 100) //это я добавил хы
//костыль на время
/obj/item/mod/module/rad_protection/on_suit_activation()
	. = ..()
	if(!.)
		return
	var/list/parts = mod.mod_parts + mod
	for(var/obj/item/part as anything in parts)
		part.armor = part.armor.modifyRating(arglist(armor_values))

/obj/item/mod/module/rad_protection/on_suit_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	var/list/parts = mod.mod_parts + mod
	var/list/removed_armor = armor_values.Copy()
	for(var/armor_type in removed_armor)
		removed_armor[armor_type] = -removed_armor[armor_type]
	for(var/obj/item/part as anything in parts)
		part.armor = part.armor.modifyRating(arglist(removed_armor))

//перепилить позже
/*
/obj/item/mod/module/rad_protection/on_suit_activation()
	AddComponent(/datum/looping_sound/geiger/soundloop)
	ADD_TRAIT(mod.wearer, TRAIT_BYPASS_EARLY_IRRADIATED_CHECK, MOD_TRAIT)
	RegisterSignal(mod.wearer, COMSIG_IN_RANGE_OF_IRRADIATION, PROC_REF(on_pre_potential_irradiation))
	for(var/obj/item/part in mod.mod_parts)
		ADD_TRAIT(part, TRAIT_RADIATION_PROTECTED_CLOTHING, MOD_TRAIT)

/obj/item/mod/module/rad_protection/on_suit_deactivation(deleting = FALSE)
	qdel(GetComponent(/datum/component/geiger_sound))
	REMOVE_TRAIT(mod.wearer, TRAIT_BYPASS_EARLY_IRRADIATED_CHECK, MOD_TRAIT)
	UnregisterSignal(mod.wearer, COMSIG_IN_RANGE_OF_IRRADIATION)
	for(var/obj/item/part in mod.mod_parts)
		REMOVE_TRAIT(part, TRAIT_RADIATION_PROTECTED_CLOTHING, MOD_TRAIT)

/obj/item/mod/module/rad_protection/add_ui_data()
	. = ..()
	.["is_user_irradiated"] = mod.wearer ? HAS_TRAIT(mod.wearer, TRAIT_IRRADIATED) : FALSE
	.["background_radiation_level"] = perceived_threat_level
	.["health_max"] = mod.wearer?.getMaxHealth() || 0
	.["loss_tox"] = mod.wearer?.getToxLoss() || 0

/obj/item/mod/module/rad_protection/proc/on_pre_potential_irradiation(datum/source, datum/radiation_pulse_information/pulse_information, insulation_to_target)
	SIGNAL_HANDLER

	perceived_threat_level = get_perceived_radiation_danger(pulse_information, insulation_to_target)
	addtimer(VARSET_CALLBACK(src, perceived_threat_level, null), TIME_WITHOUT_RADIATION_BEFORE_RESET, TIMER_UNIQUE | TIMER_OVERRIDE)
*/

/obj/item/mod/module/hat_stabilizer/syndicate
	name = "MOD elite hat stabilizer module"
	desc = "A simple set of deployable stands, directly atop one's head; \
		these will deploy under a hat to keep it from falling off, allowing them to be worn atop the sealed helmet. \
		You still need to take the hat off your head while the helmet deploys, though. This is a must-have for \
		Syndicate Operatives and Agents alike, enabling them to continue to style on the opposition even while in their MODsuit."
	complexity = 0
	removable = FALSE
