// Transfer <= code\modules\clothing\outfits\factions\inteq.dm

/* List:
1. Independent (Нейтральные)
2. Syndicate (Синдикат, больше предназначено для косихо)
*/

//								///
//	1.Independent (Нейтральные)	///
//								///


// DEBUG OUTFIT
/datum/outfit/debug //Даем изолиррованность перчаткам
	name = "A debug outfit"
	uniform = /obj/item/clothing/under/misc/adminsuit
	gloves = /obj/item/clothing/gloves/combat{siemens_coefficient = 0}

//								///
//	2. Syndicate (Синдикат)		///
//								///

//	Cocijo for Syndicate

/datum/outfit/job/syndicate/captain/cocijo
	name = "Flotilla Admiral (Cocijo)"
	id_assignment = "Flotilla Admiral"

	uniform = /obj/item/clothing/under/syndicate/coldres
	head = null
	gloves = /obj/item/clothing/gloves/combat/insul
	shoes = /obj/item/clothing/shoes/combat/swat
	ears = /obj/item/radio/headset/syndicate/alt/captain
	mask = /obj/item/clothing/mask/gas/syndicate/voicechanger
	suit = null
	belt = null
	backpack_contents = list(/obj/item/card/id/suns/secret/white)
	implants = list(/obj/item/implant/krav_maga)

/datum/outfit/job/syndicate/captain/cocijo/post_equip(mob/living/carbon/human/H)
	. = ..()
	assign_codename(H)

/datum/outfit/job/syndicate/head_of_personnel/suns/cocijo
	name = "Syndicate - Academic Staff (SUNS, Cocijo)"
	backpack_contents = list(/obj/item/card/id/suns/secret/white, /obj/item/card/id/suns/secret/black)

/datum/outfit/job/syndicate/head_of_personnel/suns/cocijo/post_equip(mob/living/carbon/human/H)
	. = ..()
	assign_general_access(H)
	assign_medical_access(H) // LET THE WAR BEGIN! :3

/datum/outfit/job/syndicate/assistant/suns/complete/cocijo
	name = "Syndicate - Graduate (SUNS, Cocijo)"

/datum/outfit/job/syndicate/assistant/suns/complete/cocijo/post_equip(mob/living/carbon/human/H)
	. = ..()
	assign_general_access(H)

/datum/outfit/job/syndicate/proc/assign_medical_access(mob/living/carbon/human/H)
	var/obj/item/card/id/I = H.get_idcard()
	if(I)
		I.access |= list(ACCESS_CHEMISTRY,ACCESS_MEDICAL,ACCESS_SURGERY)

/datum/outfit/job/syndicate/proc/assign_general_access(mob/living/carbon/human/H)
	var/obj/item/card/id/I = H.get_idcard()
	if(I)
		I.access |= list(ACCESS_RESEARCH,ACCESS_HYDROPONICS,ACCESS_KITCHEN)

