depth = oOWPlayer.depth + 10;
Event = -1;
Collided = false;
Interactable = false;
function CheckConfirm() {
	return oOWController.menu_state == MENU_MODE.IDLE && !oOWPlayer.ForceCollideless && PRESS_CONFIRM;
}
function CheckCollide() {
	for (var i = 0; i < 4; ++i) {
		if place_meeting(x + lengthdir_x(1, i * 90), y + lengthdir_y(1, i * 90), oOWPlayer)
			return true;
	}
}
///Sets whether the object is an interactable object
///@param {bool} is_interactable Whether the object is an interactable object
///@param {function} event The event to execute when the confirm button is pressed while interacting
function SetInteractable(is_interactable, event) {
	forceinline
	Interactable = is_interactable;
	Event = event;
}