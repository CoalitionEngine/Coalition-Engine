var //Add angle from normal angle and special calculations
	_angle = image_angle + Axis.angle + Len.angle_extra,
	LengthX = lengthdir_x(length / 2, _angle),
	LengthY = lengthdir_y(length / 2, _angle);

if depth < oBoard.depth event_user(0);

if global.show_hitbox
{
	//Draws hitbox manually due to nine slice sprites don't exactly work with show_hitbox()
	draw_set_color(c_red);
	draw_line_width(x + LengthX, y + LengthY, x - LengthX, y - LengthY, 5);
	draw_set_color(c_white);
}