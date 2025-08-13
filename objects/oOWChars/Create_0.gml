//Sprites for each direction, Right - Up - Left - DOwn
DirSprites = array_create(4);
//Stores the previous sprite being drawn
__last_sprite = -1;
//Stores the previous direction the player is facing, 1 if right and -1 if left
__last_horizontal_dir = 1;
sprite_index = -1;
//Current direction the char is facing
FacingDirection = DIR.DOWN;
//Which direction will the sprite flip, set this to -1 if you don't want it
SpriteFlipDirection = DIR.RIGHT;
image_speed = 0;
//For preventing infinite loop of room transition
if (!variable_global_exists("SetForceCollideless"))
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
	return (layer_exists("TileCollision") && tile_meeting(x, y, "TileCollision")) || place_meeting(x, y, oOWChars) || (place_meeting(x, y, oOWCollision) && instance_place(x, y, oOWCollision).Interactable);
}
function __SpriteShouldFlip() {
	return abs(angle_difference(FacingDirection, SpriteFlipDirection)) <= 45 && SpriteFlipDirection != -1;
}
function __GetDirectionalSprite(dir) {
	return DirSprites[dir / 90];
}