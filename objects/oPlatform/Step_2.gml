///@desc Auto destroy
if destroyable
{
	var destroy = false
	
	if (destroydir == DIR.UP && y < 0)
	or (destroydir == DIR.DOWN && y > 480)
	or (destroydir == DIR.LEFT && x < 0)
	or (destroydir == DIR.RIGHT && y > 640)
		destroy = true;
	else if y < -length || y > (480 + length) || x < -length || x > (640 + length)
		destroy = true;
	
	if destroy
		instance_destroy();
}
if (BattleData.State() == 0) instance_destroy();

