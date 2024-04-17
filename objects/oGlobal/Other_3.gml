/// @description Uninitialization
if surface_exists(CutScreenSurface) surface_free(CutScreenSurface);
if surface_exists(RGBSurf) surface_free(RGBSurf);
if surface_exists(GradientSurf) surface_free(GradientSurf);
instance_destroy(oBulletParents);
global.Settings[? "Volume"] = global.Volume;
ds_map_destroy(global.SaveFile);
ds_map_destroy(global.Settings);
ds_map_destroy(global.TempData);

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