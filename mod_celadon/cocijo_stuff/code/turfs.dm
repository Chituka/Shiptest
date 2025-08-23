/turf/open/floor/plasteel/stairs/stairs_pack/dark/darker
	color = "grey"

/turf/open/floor/plasteel/stairs/stairs_pack/dark/other/darker
	color = "grey"

/turf/open/floor/plasteel/elevatorshaft/darker
	color = "#808080"

/turf/open/floor/plasteel/grimy/darker
	color = "#7f828f"
	floor_tile = /obj/item/stack/tile/plasteel/grimy/darker

/obj/item/stack/tile/plasteel/grimy/darker
	name = "dark grimy floor tile"
	turf_type = /turf/open/floor/plasteel/grimy/darker
	merge_type = /obj/item/stack/tile/plasteel/grimy/darker
	color = "#7f828f"

/turf/open/floor/plasteel/mono/dark/darker
	color = "grey"
	floor_tile = /obj/item/stack/tile/plasteel/dark/darker

/obj/item/stack/tile/plasteel/dark/darker
	name = "dark tile"
	turf_type = /turf/open/floor/plasteel/mono/dark/darker
	merge_type = /obj/item/stack/tile/plasteel/dark/darker

/turf/open/floor/suns/dark/plain/darker
	color = "grey"

/obj/item/stack/tile/suns
	tile_reskin_types = list(
	/obj/item/stack/tile/suns/plain,
	/obj/item/stack/tile/suns/pattern,
	/obj/item/stack/tile/suns/hatch,
	/obj/item/stack/tile/suns/diagonal,
	/obj/item/stack/tile/suns/grid,
	/obj/item/stack/tile/suns/dark,
	/obj/item/stack/tile/suns/dark/plain,
	/obj/item/stack/tile/suns/dark/plain/darker,
	/obj/item/stack/tile/suns/dark/pattern)

/obj/item/stack/tile/suns/dark/plain/darker
	name = "black plain marble tile"
	singular_name = "black plain marble floor tile"
	icon_state = "tile_suns_darkplain"
	color = "grey"
	turf_type = /turf/open/floor/suns/dark/plain/darker

/obj/structure/powerline
	name = "Powerline"
	desc = "A huge bundle of double insulated cabling."
	icon = 'mod_celadon/_storge_icons/icons/powerline.dmi'
	icon_state = "cablerelay"
	plane = FLOOR_PLANE
	layer = WIRE_LAYER

/obj/structure/powerline/broken1
	icon_state = "cablerelay-broken-cable"

/obj/structure/powerline/broken2
	icon_state = "cablerelay-broken"

/obj/structure/powerline/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)
