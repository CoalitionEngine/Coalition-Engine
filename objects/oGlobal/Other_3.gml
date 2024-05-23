/// @description Uninitialization
if surface_exists(CutScreenSurface) surface_free(CutScreenSurface);
if surface_exists(RGBSurf) surface_free(RGBSurf);
if surface_exists(GradientSurf) surface_free(GradientSurf);
instance_destroy(oBulletParents);
global.Settings[? "Volume"] = global.Volume;
delete global.SaveFile;
delete global.TempData;
ds_map_destroy(global.Settings);

part_system_destroy(global.TrailS);
part_type_destroy(global.TrailP);

var i = 0;
while time_source_exists(i) time_source_destroy(i++);

if sprite_exists(Border.Sprite) sprite_delete(Border.Sprite);
if sprite_exists(Border.SpritePrevious) sprite_delete(Border.SpritePrevious);

delete Song;
delete Fade;
delete Naming;
delete Border;
delete global.data;

i = 0;
repeat ds_list_size(global.ItemLibrary) delete global.ItemLibrary[| i++];
i = 0;
repeat ds_list_size(global.CellLibrary) delete global.CellLibrary[| i++];
ds_list_destroy(global.ItemLibrary);
ds_list_destroy(global.CellLibrary);