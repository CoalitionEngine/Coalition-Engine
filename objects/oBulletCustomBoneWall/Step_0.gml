//Changes warning box color
if (WarnSwapColor && __time_warn)
	__WarnTimer++;

if (__time_warn)
{
	__time_warn--;
	__width = sqrt(sqr(Board.GetWidth()) * Board.GetHeight());
	
	//Since the centre position of the warning box is the x/y position, calculate the corner
	//positions of the warning box
	var TargetX = x, TargetY = y;
	//Apply first displacement
	TargetX -= lengthdir_x(__width / 2 + 1, image_angle + 90);
	TargetY -= lengthdir_y(__width / 2 + 1, image_angle + 90);
	//Top left corner (With respect to image_angle = 0)
	__warning_box_positions[# 0, 0] = TargetX + lengthdir_x(__distances[1] - __distances[0] - __height / 2, image_angle);
	__warning_box_positions[# 0, 1] = TargetY + lengthdir_y(__distances[1] - __distances[0] - __height / 2, image_angle);
	//Top Right corner
	__warning_box_positions[# 1, 0] = TargetX;
	__warning_box_positions[# 1, 1] = TargetY;
	//Apply second displacement
	TargetX += lengthdir_x(__width + 1, image_angle + 90);
	TargetY += lengthdir_y(__width + 1, image_angle + 90);
	//Bottom left corner (With respect to image_angle = 0)
	__warning_box_positions[# 3, 0] = TargetX + lengthdir_x(__distances[1] - __distances[0] - __height / 2, image_angle);
	__warning_box_positions[# 3, 1] = TargetY + lengthdir_y(__distances[1] - __distances[0] - __height / 2, image_angle);
	//Bottom Right corner
	__warning_box_positions[# 2, 0] = TargetX;
	__warning_box_positions[# 2, 1] = TargetY;
}
else if (__state == 1)
{
	//Play sound
	if (__play_sound_at_create)
		audio_play(snd_bonewall);
	__state = 2;
	//Creates each individual bone and sets its easing
	for (var i = round(-__width / 2),
			sprite = object_get_sprite(__object),
			spacing = sprite_get_height(sprite),
			EaseIn = __animation_ease[0], EaseOut = __animation_ease[1],
			InitDistance = __distances[0], Displace = __distances[1]; i < __width / 2; i += spacing)
	{
		var X = x + lengthdir_x(i, image_angle + 90),
			Y = y + lengthdir_y(i, image_angle + 90);
		with (Bullet_Bone(X, Y, __height, 0, 0, __type,,, image_angle,, false, __time_stay + __time_move * 2 + __time_warn, c_white))
		{
			TweenFire(self, EaseIn, 0, 0, 0, other.__time_move,
			"x>", x - lengthdir_x(InitDistance - Displace, image_angle),
			"y>", y - lengthdir_y(InitDistance - Displace, image_angle));
			TweenFire(self, EaseOut, 0, 0, other.__time_stay, other.__time_move,
			"x>", x + lengthdir_x(Displace, image_angle),
			"y>", y + lengthdir_y(Displace, image_angle));
		}
	}
}
if (__state >= 2 && __timer++ == ceil(__time_move * 2 + __time_stay + __time_move))
	instance_destroy();