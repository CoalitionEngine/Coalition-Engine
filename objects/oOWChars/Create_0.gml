//Sprites for each direction, Up-Down-Left-Right
dir_sprite = array_create(4);
//Stores the previous sprite being drawn
__last_sprite = -1;
//Stores the previous direction the player is facing, 1 if right and -1 if left
__last_dir = 1;
sprite_index = -1;
//Current direction the char is facing
dir = DIR.DOWN;
//Which direction will the sprite flip, set this to -1 if you don't want it
image_flip = DIR.RIGHT;
image_speed = 0;
//For preventing infinite loop of room transition
if !variable_global_exists("SetForceCollideles")
	global.__SetForceCollideless = false;
__ForceCollideless = false;
//The name of the char shown in the debug view
Name = "Unnamed Overworld Char";

/**
	Checks if the player is colliding with any collidable objects in the overworld.
	You may add your own collision events
*/
function CollideWithAnything(x, y)
{
	return tile_meeting(x, y, "TileCollision") || place_meeting(x, y, oOWChars) || (place_meeting(x, y, oOWCollision) && instance_place(x, y, oOWCollision).Interactable);
}