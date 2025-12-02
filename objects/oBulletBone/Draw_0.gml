if (depth < oBoard.depth)
	__Draw();

image_angle -= Axis.angle + Len.angle_extra;

if (global.__CoalitionShowHitbox)
{
	//Add angle from normal angle and special calculations
	var	_angle = image_angle + Axis.angle + Len.angle_extra,
		LengthX = lengthdir_x(Length / 2, _angle),
		LengthY = lengthdir_y(Length / 2, _angle);
	//Draws hitbox manually due to nine slice sprites don't exactly work with CoalitionShowHitbox()
	draw_line_width_color(x + LengthX, y + LengthY, x - LengthX, y - LengthY, 5, c_red, c_red);
}