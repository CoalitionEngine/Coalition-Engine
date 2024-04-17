//UDLR
dir_sprite = array_create(4);
last_sprite = -1
last_dir = 1;
sprite_index = -1;
dir = DIR.DOWN;
image_flip = DIR.RIGHT;
image_speed = 0;
collidable = true;


/**
	Checks if the player is colliding with any collidable objects in the overworld.
	You may add your own collision events
*/
function CollideWithAnything(x, y)
{
	return place_meeting(x, y, oSavePoint) || tile_meeting(x, y, "TileCollision");
}