var _color = image_blend,
	_angle = image_angle,
	_alpha = image_alpha;

var _frame_x = frame_x,
	_frame_y = frame_y,
	_frame_w = frame_w,
	_frame_h = frame_h;

var soul = oSoul;

//Draws the board
surface_set_target(surface);
draw_clear_alpha(c_white, 0);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(sprPixel, 0, bg_x - lengthdir_x(5, image_angle), bg_y - lengthdir_y(5, image_angle - 90), bg_w + 10, bg_h + 10, _angle, c_black, _alpha);
for (var i = 0; i < 4; ++i)
	draw_sprite_ext(sprPixel, 0, _frame_x[i], _frame_y[i], _frame_w[i], _frame_h[i], _angle, _color, _alpha);
surface_reset_target();

//Shows hitbox
if global.show_hitbox {
	
	//Distances from center of board
	//var UR = point_distance(0, 0, right, up), 
	//	LR = point_distance(0, 0, left, up),
	//	LD = point_distance(0, 0, left, down),
	//	RD = point_distance(0, 0, right, down),
	//	//Corner locations
	//	corners = [
	//		[x + (UR - 2)  * dcos(_angle - 45),  y + (UR + 10) * -dsin(_angle - 45)],
	//		[x + (LR - 2)  * dcos(_angle + 45),  y + (LR + 10) * -dsin(_angle + 45)],
	//		[x + (LD + 15) * dcos(_angle + 135), y + (LD + 10) * -dsin(_angle + 135)],
	//		[x + (RD + 15) * dcos(_angle + 225), y + (RD + 10) * -dsin(_angle + 225)],
	//	];
	//draw_set_alpha(0.3);
	//draw_set_color(c_red);
	//draw_triangle(
	//	corners[0, 0], corners[0, 1],
	//	corners[1, 0], corners[1, 1],
	//	corners[2, 0], corners[2, 1],
	//	0);
	//draw_set_color(c_green);
	//draw_triangle(
	//	corners[1, 0], corners[1, 1],
	//	corners[2, 0], corners[2, 1],
	//	corners[3, 0], corners[3, 1], 0);
	//draw_set_color(c_blue);
	//draw_triangle(
	//	corners[2, 0], corners[2, 1],
	//	corners[3, 0], corners[3, 1],
	//	corners[0, 0], corners[0, 1], 0);
	//draw_set_color(c_yellow);
	//draw_triangle(
	//	corners[3, 0], corners[3, 1],
	//	corners[0, 0], corners[0, 1],
	//	corners[1, 0], corners[1, 1], 0);
	//draw_set_color(c_white);
	show_hitbox(c_fuchsia)
}

image_blend = _color;
image_angle = _angle;
image_alpha = _alpha;

frame_x = _frame_x;
frame_y = _frame_y;
frame_w = _frame_w;
frame_h = _frame_h;


//Reposition for move_and_collide() to work, which it doesn't
x = InitX + (right - left) / 2 - 5;
y = InitY + (down - up) / 2 - 5;
image_xscale = (right + left) / 2 + 5;
image_yscale = (up + down) / 2 + 5;
