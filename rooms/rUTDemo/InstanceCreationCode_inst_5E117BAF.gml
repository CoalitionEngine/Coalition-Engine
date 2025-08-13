///This is an example of random encounter
minimal_interval = 120;
Event = function() {
	if minimal_interval > 0
	{
		minimal_interval--;
		__Collided = __COALITION_COLLISION_STATE.NOT_COLLIDED;
	}
	else if !irandom(5)
	{
		with oOWPlayer
			Encounter_Begin();
	}
};