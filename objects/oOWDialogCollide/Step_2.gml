//Check for collision and confirm input
if (CheckCollide() && CheckConfirm() && !Overworld_DialogExists() && !oOWPlayer.__ForceCollideless)
{
	__Collided = __COALITION_COLLISION_STATE.COLLIDING;
	Overworld_CreateDialog(__text);
	oOWController.__menu_disabled = true;
}