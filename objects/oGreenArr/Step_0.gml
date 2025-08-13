event_inherited();

var soul = COALITION_CURRENT_SOUL,
	dir_e = ((__ArrowMode == 2 || __ArrowMode == 3) ? 45 : 0);
image_index = __base_index + __ArrowMode;
image_angle = Direction + dir_e + DirectionDisplace;
__DistanceToTarget -= Speed;

//Yellow or Diagonal Yellow
if (__ArrowMode == 1 || __ArrowMode == 3)
{
	switch RotateEasing
	{
		case "": case EaseLinear:
			//Sets the arrow to only rotate if it is 81 pixels away from the soul
			var CalDist = clamp(0, __DistanceToTarget - 80, 81) / 81;
			Direction = __TargetDirection + quick_pow(CalDist, 1.5) * 180 * RotateDirection;
			break;
		//im thinking shut up
	}
}

x = lengthdir_x(__DistanceToTarget, Direction + dir_e + DirectionDisplace) + soul.x;
y = lengthdir_y(__DistanceToTarget, Direction + dir_e + DirectionDisplace) + soul.y;