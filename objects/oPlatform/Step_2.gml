///@desc Auto destroy
if ((y < -length || y > (480 + length) || x < -length || x > (640 + length)) && AutoDestroy || oBattleController.__battle_state == BATTLE_STATE.MENU)
	instance_destroy();