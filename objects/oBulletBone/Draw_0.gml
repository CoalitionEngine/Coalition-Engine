if (depth < oBoard.depth)
{
	var _color = __default_color,
		_angle = image_angle + Axis.angle + Len.angle_extra;
	switch (__type)
	{
		case 1: _color = c_aqua;	break;
		case 2: _color = c_orange;	break;
	}
	var _color_outline = _color;
	//Using image_index in case you are using several indexes for several types of bones
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, _angle, _color, image_alpha);
	draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, 1, _angle, _color_outline, image_alpha);
}

if (global.__CoalitionShowHitbox)
{
	//Add angle from normal angle and special calculations
	var	_angle = image_angle + Axis.angle + Len.angle_extra,
		LengthX = lengthdir_x(Length / 2, _angle),
		LengthY = lengthdir_y(Length / 2, _angle);
	//Draws hitbox manually due to nine slice sprites don't exactly work with CoalitionShowHitbox()
	draw_line_width_color(x + LengthX, y + LengthY, x - LengthX, y - LengthY, 5, c_red, c_red);
}