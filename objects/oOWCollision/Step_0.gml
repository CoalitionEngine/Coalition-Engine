var input_confirm = CheckConfirm(), collide = CheckCollide();
switch sprite_index
{
	case sprPixel:
		if collide and !Collided
		{
			if Event != -1
			{
				Collided = true;
				Event();
			}
		}
		elif collide and Collided
		{
			Collided = 2;
		}
		if !collide and Collided == 2 Collided = false;
	break
}