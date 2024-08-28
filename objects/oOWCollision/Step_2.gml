var input_confirm = CheckConfirm(), collide = CheckCollide() && !oOWPlayer.ForceCollideless && oOWPlayer.moveable;
switch sprite_index
{
	case sprPixel:
		if collide && !Collided
		{
			if is_callable(Event)
			{
				Collided = true;
				Event();
			}
		}
		elif collide && Collided
		{
			Collided = 2;
		}
		elif !collide && Collided == 2 Collided = false;
		break;
	default:
		if collide && CheckConfirm() && !Collided
		{
			Collided = true;
			if is_callable(Event)
				Event();
		}
		elif collide && Collided
		{
			Collided = 2;
		}
		if !collide && Collided == 2 Collided = false;
		break;
}