// Убирает возможность телепортироваться между З-левелами по маякам
/obj/machinery/computer/teleporter/is_eligible(atom/movable/AM, is_gate_mode = FALSE)
	if(!is_gate_mode && (AM.get_virtual_level() != src.get_virtual_level()))
		power_station.engaged = FALSE
		return FALSE
	var/turf/T = get_turf(AM)
	if(!T)
		power_station.engaged = FALSE
		return FALSE
	if(is_centcom_level(T) || is_away_level(T))
		power_station.engaged = FALSE
		return FALSE
	var/area/A = get_area(T)
	if(!A ||(A.area_flags & NOTELEPORT))
		power_station.engaged = FALSE
		return FALSE
	return TRUE
