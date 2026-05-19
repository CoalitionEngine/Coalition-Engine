var _time_warn = __time_warn, _angle = image_angle, _distances = __distances;
//Changes warning box color
if (WarnSwapColor && _time_warn)
	__WarnTimer++;

if (_time_warn)
{
	_time_warn--;
	__time_warn = _time_warn;
	var _width = point_distance(0, 0, Board.GetWidth(), Board.GetHeight());
	
	//Since the centre position of the warning box is the x/y position, calculate the corner
	//positions of the warning box
	var TargetX = x, TargetY = y, _half_height = __height / 2, _dist = _distances[1] - _distances[0] - _half_height;
	//Apply first displacement
	TargetX -= lengthdir_x(_width / 2 + 1, _angle + 90);
	TargetY -= lengthdir_y(_width / 2 + 1, _angle + 90);
	//Top left corner (With respect to image_angle = 0)
	__warning_box_positions[# 0, 0] = TargetX + lengthdir_x(_dist, _angle);
	__warning_box_positions[# 0, 1] = TargetY + lengthdir_y(_dist, _angle);
	//Top Right corner
	__warning_box_positions[# 1, 0] = TargetX;
	__warning_box_positions[# 1, 1] = TargetY;
	//Apply second displacement
	TargetX += lengthdir_x(_width + 1, _angle + 90);
	TargetY += lengthdir_y(_width + 1, _angle + 90);
	//Bottom left corner (With respect to image_angle = 0)
	__warning_box_positions[# 3, 0] = TargetX + lengthdir_x(_dist, _angle);
	__warning_box_positions[# 3, 1] = TargetY + lengthdir_y(_dist, _angle);
	//Bottom Right corner
	__warning_box_positions[# 2, 0] = TargetX;
	__warning_box_positions[# 2, 1] = TargetY;
	
	__width = _width;
}
else if (__state == 1)
{
	//Play sound
	if (__play_sound_at_create)
		audio_play(snd_bonewall);
	__state = 2;
	//Creates each individual bone and sets its easing
	//The initialization is pure chaos
	for (var i = round(-__width / 2),
			sprite = object_get_sprite(__object),
			spacing = sprite_get_height(sprite),
			_ease = __animation_ease,
			EaseIn = _ease[0], EaseOut = _ease[1],
			InitDistance = _distances[0], Displace = _distances[1],
			_height = __height, _move = __time_move, _stay = __time_stay, _type = type,
			_in_displace_x = lengthdir_x(InitDistance - Displace, _angle),
			_in_displace_y = lengthdir_y(InitDistance - Displace, _angle),
			_out_displace_x = lengthdir_x(Displace, _angle),
			_out_displace_y = lengthdir_y(Displace, _angle);
			i < __width / 2; i += spacing)
	{
		var X = x + lengthdir_x(i, _angle + 90),
			Y = y + lengthdir_y(i, _angle + 90);
		with (Bullet_Bone(X, Y, _height, 0, 0, _type,,, _angle,, false, _stay + _move * 2 + _time_warn, c_white))
		{
			TweenFire(self, EaseIn, 0, 0, 0, _move, "x>", x - _in_displace_x, "y>", y - _in_displace_y);
			TweenFire(self, EaseOut, 0, 0, _stay, _move, "x>", x + _out_displace_x, "y>", y + _out_displace_y);
		}
	}
}
if (__state >= 2 && __timer++ == ceil(__time_move * 2 + __time_stay + __time_move))
	instance_destroy();