//Basic sprite animating
if sprite_exists(dir_sprite[dir / 90])
{
	if dir == image_flip
	{
		sprite_index = dir_sprite[2];
		image_xscale = -1;
	}
	else sprite_index = dir_sprite[dir / 90];
}