depth = oOWPlayer.depth + 10;
//The collision event
Event = -1;
//Whether the player has collided with this collision
__Collided = false;
enum __COALITION_COLLISION_STATE {
	NOT_COLLIDED,
	COLLIDING,
	COLLIDED
}
//Whether this is an interactable object (Press Confirm)
Interactable = false;
Name = "Unnamed collision";
///Checks for the confirm input
function CheckConfirm() {
	forceinline;
	return oOWController.__menu_state == MENU_MODE.IDLE && !oOWPlayer.__ForceCollideless && PRESS_CONFIRM;
}
///Checks whether the player is colliding
function CheckCollide() {
	forceinline;
	if (!Interactable)
		return place_meeting(x, y, oOWPlayer);
	for (var i = 0; i < 4; i++)
		if (place_meeting(x + cos(i * 90), y - sin(i * 90), oOWPlayer))
			return true;
	return false;
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
	with (oOWPlayer)
	{
		if (place_meeting(__xstart, __ystart, other))
			other.__Collided = true;
	}
}, [], 1);