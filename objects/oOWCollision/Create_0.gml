depth = oOWPlayer.depth + 10;
Event = -1;
Collided = false;
Interactable = false;
function CheckConfirm() {
	return oOWController.menu_state == MENU_MODE.IDLE && !oOWPlayer.ForceCollideless && PRESS_CONFIRM;
}
function CheckCollide() {
	return place_meeting(x, y, oOWPlayer);
}
///Sets whether the object is an interactable object
///@param {bool} is_interactable Whether the object is an interactable object
///@param {function} event The event to execute when the confirm button is pressed while interacting
function SetInteractable(is_interactable, event) {
	forceinline
	Interactable = is_interactable;
	Event = event;
}

//Preventing infinite loop of collision
invoke(function() {
	with oOWPlayer
	{
		if place_meeting(__xstart, __ystart, other)
			other.Collided = true;
	}
}, [], 1);