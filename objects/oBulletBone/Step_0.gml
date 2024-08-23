if !__COALITION_VISUAL_MODE
	var board = target_board;
if timer timer--;
DurationTimer++;


if Axis.activate
	axis_step();

//Sets minimal length due to nine-slices drawing
length = max(14, length);
image_xscale = length / 14;
//Automatiacally sets the angle of the bone as the direction if needed
if angle_to_direction
	image_angle = direction;
//Rotation
image_angle += rotate;

//Auto sticking to board edges if the bone is not in lening
if !Len.activate
{
	var half_len = length / 2;
	switch mode
	{
		case 0: break;
		case 1: y = board.y - board.up + half_len;		break;
		case 2: y = board.y + board.down - half_len;	break;
		case 3: x = board.x - board.left + half_len;	break;
		case 4: x = board.x + board.right - half_len;	break;
	}
}
else len_step();
//Auto destroy when turn ends or duration is met
if (at_turn_end && length < 11) || (duration != -1 && DurationTimer >= duration)
	instance_destroy();

