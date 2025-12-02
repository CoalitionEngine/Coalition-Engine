if !__COALITION_VISUAL_MODE var board = target_board;

if (Axis.activate)
	axis_step();

//Sets minimal length due to nine-slices drawing
var _length = Length;
if (_length < 14)
	_length = 14;
image_xscale = _length / 14;

//Auto sticking to board edges if the bone is not in lening
if (!Len.activate)
{
	if (__stick_direction > 0)
	{
		var half_len = _length / 2;
		switch (__stick_direction)
		{
			case 1: case "up": y = board.y - board.up + half_len;		break;
			case 2: case "down":  y = board.y + board.down - half_len;	break;
			case 3: case "left":  x = board.x - board.left + half_len;	break;
			case 4: case "right":  x = board.x + board.right - half_len;break;
		}
	}
}
else
	len_step();

//Automatiacally sets the angle of the bone as the direction if needed
if (AngleAsDirection)
	image_angle = direction;
//Rotation
image_angle += RotateSpeed + Axis.angle + Len.angle_extra;

Length = _length;
//Auto destroy when turn ends or duration is met
if ((__at_turn_end && Length < 11) || (Duration != -1 && __DurationTimer++ >= Duration))
	instance_destroy();