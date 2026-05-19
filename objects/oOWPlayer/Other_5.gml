//Checks that whether the player is now colliding with a collision, if so disable collision checking
if (place_meeting(x, y, oOWCollision))
	global.__SetForceCollideless = true;
	
//Reset encounter animation data
with (Encounter)
{
	__AnimationActivated = false;
	__Time = 0;
	__State = undefined;
}