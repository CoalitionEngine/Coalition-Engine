/// @description Uninitialization
if surface_exists(CutScreenSurface) surface_free(CutScreenSurface);
if surface_exists(RGBSurf) surface_free(RGBSurf);
if surface_exists(GradientSurf) surface_free(GradientSurf);
instance_destroy(oBulletParents);
delete COALITION_SAVE_FILE;
delete global.__CoalitionTempData;

part_system_destroy(global.TrailS);
part_type_destroy(global.TrailP);

clear_timesources

with Border
{
	if sprite_exists(Sprite) sprite_delete(Sprite);
	if sprite_exists(SpritePrevious) sprite_delete(SpritePrevious);
}

delete Song;
delete Fade;
delete Naming;
delete Border;
delete COALITION_DATA;

i = 0;
repeat ds_list_size(global.ItemLibrary) delete global.ItemLibrary[| i++];
i = 0;
repeat ds_list_size(global.CellLibrary) delete global.CellLibrary[| i++];
ds_list_destroy(global.ItemLibrary);
ds_list_destroy(global.CellLibrary);