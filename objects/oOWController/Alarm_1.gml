///@desc End room transition
oOWPlayer.moveable = true;
with oOWCollision
	//Note: Collided is not strictly a boolean
	if Collided != false
		Collided = false;