//UDLR
dir_sprite = array_create(4);
last_sprite = -1
last_dir = 1;
sprite_index = -1;
dir = DIR.DOWN;
image_flip = DIR.RIGHT;
image_speed = 0;
collidable = true;
//For preventing infinite loop of room transition
ForceCollideless = false;

/**
	Checks if the player is colliding with any collidable objects in the overworld.
	You may add your own collision events
*/
function CollideWithAnything(x, y)
{
	return tile_meeting(x, y, "TileCollision") || place_meeting(x, y, oOWChars) || place_meeting(x, y, oSavePoint) || (place_meeting(x, y, oOWCollision) && instance_place(x, y, oOWCollision).Interactable);
}