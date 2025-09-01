// Убирает возможность телепортироваться между З-левелами по маякам
/obj/machinery/computer/teleporter/is_eligible(atom/movable/AM, is_gate_mode = FALSE)
	if(!is_gate_mode && (AM.get_virtual_level() != src.get_virtual_level()))
		return FALSE
	. = ..()
