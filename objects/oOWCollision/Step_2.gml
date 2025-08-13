var input_confirm = CheckConfirm(), collide = CheckCollide() && !oOWPlayer.__ForceCollideless && oOWPlayer.Movable;
switch (sprite_index)
{
	default:
		//Check for collision and interactibility
		if (collide && (Interactable && CheckConfirm() || !Interactable) && __Collided == __COALITION_COLLISION_STATE.NOT_COLLIDED)
		{
			__Collided = __COALITION_COLLISION_STATE.COLLIDING;
			if (is_callable(Event))
				Event();
		}
		//Buffers collision
		elif (collide && __Collided == __COALITION_COLLISION_STATE.COLLIDING)
			__Collided = __COALITION_COLLISION_STATE.COLLIDED;
		//Reset collision state
		if (!collide && __Collided == __COALITION_COLLISION_STATE.COLLIDED)
			__Collided = __COALITION_COLLISION_STATE.NOT_COLLIDED;
		break;
}