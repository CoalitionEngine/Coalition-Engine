event_inherited();

var soul = oSoul,
	dir_e = ((mode == 2 || mode == 3) ? 45 : 0);
image_index = index + mode;
image_angle = dir + dir_e + dir_a;
len -= spd;

//Yellow or Diagonal Yellow
if mode == 1 || mode == 3
{
	switch RotateEasing
	{
		case "": case EaseLinear:
			//Sets the arrow to only rotate if it is 81 pixels away from the soul
			var CalDist = clamp(0, len - 80, 81) / 81;
			dir = target_dir + quick_pow(CalDist, 1.5) * 180 * RotateDirection;
			break;
		//im thinking shut up
	}
}

x = lengthdir_x(len, dir + dir_e + dir_a) + soul.x;
y = lengthdir_y(len, dir + dir_e + dir_a) + soul.y;