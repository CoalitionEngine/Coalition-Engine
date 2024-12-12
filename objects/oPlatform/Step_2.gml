///@desc Auto destroy
if (destroyable && (((destroydir == DIR.UP && y < 0)
	|| (destroydir == DIR.DOWN && y > 480)
	|| (destroydir == DIR.LEFT && x < 0)
	|| (destroydir == DIR.RIGHT && y > 640))
	|| (y < -length || y > (480 + length) || x < -length || x > (640 + length))))
	|| Battle.State() == 0
		instance_destroy();