//Collision event with bulets
with(oBulletParents)
	if place_meeting(x, y, other)
	{
		instance_destroy();
		instance_destroy(other);
	}
//Draw trail
TrailEffect(10);
//Auto destroy
if check_outside() instance_destroy();