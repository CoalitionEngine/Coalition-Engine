/// @description Uninitialization
if (surface_exists(__CutScreenSurface)) surface_free(__CutScreenSurface);
if (surface_exists(__GradientSurf)) surface_free(__GradientSurf);
instance_destroy(oBulletParents);
delete COALITION_SAVE_FILE;
delete global.__CoalitionTempData;

clear_timesources

with (__Border)
{
	if (sprite_exists(Sprite)) sprite_delete(Sprite);
	if (sprite_exists(SpritePrevious)) sprite_delete(SpritePrevious);
}

delete __Border;
delete COALITION_DATA;

var i = 0;
repeat (ds_list_size(global.__CoalitionItemLibrary)) delete global.__CoalitionItemLibrary[| i++];
i = 0;
repeat (ds_list_size(global.__CoalitionCellLibrary)) delete global.__CoalitionCellLibrary[| i++];
ds_list_destroy(global.__CoalitionItemLibrary);
ds_list_destroy(global.__CoalitionCellLibrary);