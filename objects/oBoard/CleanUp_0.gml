//Frees stored surface
if (surface_exists(__surface)) surface_free(__surface);
if (surface_exists(__frame_surf)) surface_free(__frame_surf);
//Removes itself from the global board array
array_delete(BattleBoardList, array_get_index(BattleBoardList, id), 1);