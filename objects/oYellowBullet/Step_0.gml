//Collision event with bulets
with(oBulletParents)
	if YellowCollidable && place_meeting(x, y, other)
	{
		if YellowDestroyable instance_destroy();
		instance_destroy(other);
	}
//Draw trail
TrailEffect(10);
//Auto destroy
if check_outside() instance_destroy();