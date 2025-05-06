// *********************
// ***  ДИПЛОМАТИК  ***
// *********************



/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/diplomatic
	name = "Capital Admiral's carapace"
	desc = "Experimental carapace given to the highest status syndicate members. This model features better protection compared to it's predecessor. \n\
		The main difference, however, lies in GEC's latest technology: atmospheric field. This system is supplemented by small power repeaters that drain energy from nearby devices. \n\
		Moreover, it takes absolute nothing to start even if all charge has been drained: Small microfiber vibration generators placed in elbows generate energy with each user's movement by bending the fibers.\n\
		As a little tip for all the captains, GEC has included limited chameleon capabilities into the suit, increasing its 'diplomatic powers'"
	armor = list("melee" = 55, "bullet" = 35, "laser" = 50,"energy" = 40, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	icon = 'mod_celadon/_storge_icons/icons/mob/diplomatic_suit.dmi'
	mob_overlay_icon = 'mod_celadon/_storge_icons/icons/mob/diplomatic_suit.dmi'
	icon_state = "Carapace"
	item_state = "Carapace"
	clothing_flags = STOPSPRESSUREDAMAGE
	resistance_flags = FIRE_PROOF | ACID_PROOF

	unique_reskin = list(\
		"2nd Battlegroup" = "2nd_Battlegroup", // /obj/item/clothing/suit/armor/ngr/captain
		"Carapace" = "Carapace", // /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
		"SUNS" = "SUNS_academic_coat" // obj/item/clothing/suit/armor/vest/suns/captain
		)

	unique_reskin_changes_inhand = TRUE

/obj/item/clothing/head/helmet/space/beret/syndicate
	name = "Admiral's special"
	desc = "asdasd"
	armor = list("melee" = 50, "bullet" = 30, "laser" = 45,"energy" = 40, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100) //Небольшой бонус тем, кто стреляет в голову
	icon = 'mod_celadon/_storge_icons/icons/obj/diplomatic_head.dmi' //переделать путь всем этим иконкам потом
	mob_overlay_icon = 'mod_celadon/_storge_icons/icons/mob/diplomatic_head.dmi'
	icon_state = "syndie_beret"
	item_state = "hosformal"
	clothing_flags = STOPSPRESSUREDAMAGE
	strip_delay = 0

	unique_reskin = list(\
		"2nd Battlegroup" = "ngr_cap",
		"Classic" = "syndie_beret",
		"SUNS" = "SUNS_hat"
		)

	unique_reskin_changes_inhand = TRUE



// *********************
// ***    МОДСЬЮТЫ   ***
// *********************



/datum/mod_theme/atmospheric/gec
	name = "Modified Atmospheric"
	desc = "Heavily-modified Atmospheric Modsuit made by Nakamura Engineering and changed by GEC. This modification DOES NOT require a tremendous amount of energy to operate." //Заменить
	default_skin = "gec"
	armor = list("melee" = 40, "bullet" = 20, "laser" = 30, "energy" = 25, "bomb" = 90, "bio" = 100, "rad" = 90,"fire" = 100, "acid" = 100)
	atom_flags = PREVENT_CONTENTS_EXPLOSION_1
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	complexity_max = DEFAULT_MAX_COMPLEXITY + 5
	charge_drain = DEFAULT_CHARGE_DRAIN * 4
	siemens_coefficient = 0
	slowdown_inactive = 1.5
	slowdown_active = 0.8
	ui_theme = "syndicate"
	allowed_suit_storage = list(
		/obj/item/flashlight,
		/obj/item/tank/internals,
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/construction/rcd,
		/obj/item/storage/bag/construction,
		/obj/item/analyzer,
		/obj/item/t_scanner,
		/obj/item/pipe_dispenser,
	)
	skins = list(
		"gec" = list(
			HELMET_FLAGS = list(
				UNSEALED_LAYER = null,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE,
				UNSEALED_INVISIBILITY = HIDEFACIALHAIR|HIDEEARS|HIDEHAIR|HIDEHORNS,
				SEALED_INVISIBILITY = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
			),
			CHESTPLATE_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT|HIDETAIL,
			),
			GAUNTLETS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
			),
			BOOTS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
			),
		),
	)

/obj/item/mod/control/pre_equipped/atmospheric/gec
	theme = /datum/mod_theme/atmospheric/gec
	initial_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/magnetic_harness,
	)
