depth = oOWPlayer.depth + 10;
Event = -1;
Collided = false;
function CheckConfirm() {
	return oOWController.menu_state == MENU_MODE.IDLE && PRESS_CONFIRM;
}
function CheckCollide() {
	return place_meeting(x, y, oOWPlayer);
}