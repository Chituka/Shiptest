/obj/item/circuitboard/machine/shuttle/engine/electric/tech1
	name = "1st gen Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric/tech1
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/shuttle/engine/electric/tech2
	name = "2nd gen Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric/tech2
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/shuttle/engine/electric/tech3
	name = "3rd gen Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric/tech3
	req_components = list(/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 2)

/obj/item/circuitboard/machine/shuttle/engine/electric/huge
	name = "Huge Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric/huge
	req_components = list(/obj/item/stock_parts/capacitor = 8,
		/obj/item/stock_parts/micro_laser = 8)

/obj/item/circuitboard/machine/shuttle/smes/massive
	name = "Massive Electric Precharger (Machine Board)"
	build_path = /obj/machinery/power/smes/shuttle/massive
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/cell = 2,
		/obj/item/stock_parts/capacitor = 2
	)
	def_components = list(/obj/item/stock_parts/cell = /obj/item/stock_parts/cell/high/empty)

/obj/item/circuitboard/machine/shuttle/engine/electric/premium
	name = "High Performance Ion Thruster (Machine Board)"
	build_path = /obj/machinery/power/shuttle/engine/electric/premium
	req_components = list(/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/micro_laser = 3)
