var input_confirm = CheckConfirm(), collide = CheckCollide() && !oOWPlayer.__ForceCollideless && oOWPlayer.moveable;
switch sprite_index
{
	default:
		//Check for collision and interactibility
		if collide && (Interactable && CheckConfirm() || !Interactable) && !Collided
		{
			Collided = true;
			if is_callable(Event)
				Event();
		}
		//Buffers collision
		elif collide && Collided
			Collided = 2;
		//Reset collision state
		if !collide && Collided == 2 Collided = false;
		break;
}