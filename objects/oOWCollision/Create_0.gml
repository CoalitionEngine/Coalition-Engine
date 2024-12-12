depth = oOWPlayer.depth + 10;
//The collision event
Event = -1;
//Whether the player has collided with this collision
Collided = false;
//Whether this is an interactable object (Press Confirm)
Interactable = false;
Name = "Unnamed collision";
///Checks for the confirm input
function CheckConfirm() {
	forceinline;
	return oOWController.menu_state == MENU_MODE.IDLE && !oOWPlayer.__ForceCollideless && PRESS_CONFIRM;
}
///Checks whether the player is colliding
function CheckCollide() {
	forceinline;
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