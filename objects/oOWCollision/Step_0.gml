var input_confirm = CheckConfirm(), collide = CheckCollide();
switch sprite_index
{
	case sprPixel:
		if collide && !Collided
		{
			if Event != -1
			{
				Collided = true;
				Event();
			}
		}
		elif collide && Collided
		{
			Collided = 2;
		}
		if !collide && Collided == 2 Collided = false;
	break
}