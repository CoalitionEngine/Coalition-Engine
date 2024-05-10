var sprite = object_get_sprite(object),
	index = 2,
	spacing = sprite_get_height(sprite),
	head = cone;
if head == 2
{
	index = 4;
	spacing -= 2;
}
//Color
var color, color_outline;
switch type
{
	case 0: color = c_white;	break;
	case 1: color = c_aqua;		break;
	case 2: color = c_orange;	break;
}
color_outline = color;
//Warn line
for (var i = 0; i < 4; ++i) {
	draw_line_color(
		WarningBoxPos[# i, 0], WarningBoxPos[# i, 1],
		WarningBoxPos[# (i + 1) % 4, 0], WarningBoxPos[# (i + 1) % 4, 1],
		warn_color, warn_color);
}
//Fill area, triangle is ever so slightly faster than primitives on average, thus higher quality
draw_set_alpha(warn_alpha_filled);
draw_triangle_color(
	WarningBoxPos[# 0, 0], WarningBoxPos[# 0, 1],
	WarningBoxPos[# 1, 0], WarningBoxPos[# 1, 1],
	WarningBoxPos[# 2, 0], WarningBoxPos[# 2, 1],
	warn_color, warn_color, warn_color, false);
draw_triangle_color(
	WarningBoxPos[# 2, 0], WarningBoxPos[# 2, 1],
	WarningBoxPos[# 3, 0], WarningBoxPos[# 3, 1],
	WarningBoxPos[# 0, 0], WarningBoxPos[# 0, 1],
	warn_color, warn_color, warn_color, false);
draw_set_alpha(1);