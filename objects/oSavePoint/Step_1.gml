//Check for collision and confirmation input
if (collision_rectangle(x - 7, y - 7, x + 7, y + 7, oOWPlayer, 1, 1) && oOWController.__save_state == SAVE_STATE.NOT_SAVING && CheckConfirm())
{
	__Collided = __COALITION_COLLISION_STATE.COLLIDING;
	Overworld_CreateDialog("* You are filled with...\n[fdelay,20]  DETERMINATION[pause][to_save]");
	oOWController.__save_state = SAVE_STATE.DISPLAY_DIALOG;
	oOWController.__menu_disabled = true;
}