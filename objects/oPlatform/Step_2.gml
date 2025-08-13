///@desc Auto destroy
if (AutoDestroy && (y < -length || y > (480 + length) || x < -length || x > (640 + length)) || Battle.State() == BATTLE_STATE.MENU)
	instance_destroy();