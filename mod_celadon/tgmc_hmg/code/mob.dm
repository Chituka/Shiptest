/mob
	var/atom/movable/interactee

/datum/proc/on_set_interaction(mob/user)
	return


/datum/proc/on_unset_interaction(mob/user)
	return

/mob/proc/set_interaction(atom/movable/AM)
	if(interactee)
		if(interactee == AM) //already set
			return
		else
			unset_interaction()
	interactee = AM
	interactee.on_set_interaction(src)


/mob/proc/unset_interaction()
	if(interactee)
		interactee.on_unset_interaction(src)
		interactee = null
