//Frees stored surface
if surface_exists(surface) surface_free(surface);
//Removes itself form the global board array
array_delete(BattleBoardList, array_get_index(BattleBoardList, id), 1);