//Changes warning box color
if warn_color_swap
{
	WarnTimer++;
	if !(WarnTimer % 5) && time_warn
	{
		var change = (WarnTimer % 10) == 5;
		warn_color = change ? c_yellow : c_red;
		warn_alpha_filled = change ? 0.25 : 0.5;
	}
}

if time_warn
{
	time_warn--;
	width = point_distance(Board.GetLeftPos(), Board.GetUpPos(), Board.GetRightPos(), Board.GetDownPos());
	
	//Since the centre position of the warning box is the x/y position, calculate the corner
	//positions of the warning box
	var TargetX = x, TargetY = y;
	//Apply first displacement
	TargetX -= lengthdir_x(width / 2 + 1, image_angle + 90);
	TargetY -= lengthdir_y(width / 2 + 1, image_angle + 90);
	//Top left corner (With respect to image_angle = 0)
	WarningBoxPos[# 0, 0] = TargetX + lengthdir_x(distance[1] - distance[0] - height / 2, image_angle);
	WarningBoxPos[# 0, 1] = TargetY + lengthdir_y(distance[1] - distance[0] - height / 2, image_angle);
	//Top Right corner
	WarningBoxPos[# 1, 0] = TargetX;
	WarningBoxPos[# 1, 1] = TargetY;
	//Apply second displacement
	TargetX += lengthdir_x(width + 1, image_angle + 90);
	TargetY += lengthdir_y(width + 1, image_angle + 90);
	//Bottom left corner (With respect to image_angle = 0)
	WarningBoxPos[# 3, 0] = TargetX + lengthdir_x(distance[1] - distance[0] - height / 2, image_angle);
	WarningBoxPos[# 3, 1] = TargetY + lengthdir_y(distance[1] - distance[0] - height / 2, image_angle);
	//Bottom Right corner
	WarningBoxPos[# 2, 0] = TargetX;
	WarningBoxPos[# 2, 1] = TargetY;
}
else if state == 1
{
	//Play sound
	if sound_create audio_play(snd_bonewall);
	state = 2;
	for (var i = round(-width / 2),
			sprite = object_get_sprite(object),
			spacing = sprite_get_height(sprite),
			MoveTime = time_move, StayTime = time_stay,
			EaseIn = ease[0], EaseOut = ease[1],
			InitDistance = distance[0], Displace = distance[1]; i < width / 2; i += spacing) {
		var X = x + lengthdir_x(i, image_angle + 90),
			Y = y + lengthdir_y(i, image_angle + 90);
		with Bullet_Bone(X, Y, height, 0, 0, type,,, image_angle,, false, StayTime + MoveTime * 2 + time_warn)
		{
			TweenFire(self, EaseIn, 0, 0, 0, MoveTime,
			"x>", x - lengthdir_x(InitDistance - Displace, image_angle),
			"y>", y - lengthdir_y(InitDistance - Displace, image_angle));
			TweenFire(self, EaseOut, 0, 0, StayTime, MoveTime,
			"x>", x + lengthdir_x(InitDistance, image_angle),
			"y>", y + lengthdir_y(InitDistance, image_angle));
		}
	}
}
if state >= 2
{
	if timer == ceil(time_move * 2 + time_stay + time_move) instance_destroy();
	timer++;
}