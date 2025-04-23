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
