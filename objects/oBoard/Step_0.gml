live
if VertexMode exit;
//Rotation
image_angle += rotate;
//Board surface check
if !surface_exists(surface) surface = surface_create(640, 480);

// Frames
var _frame_x = __frame_x,
	_frame_y = __frame_y;

var side_h = (up + down) + thickness_frame * 2,
	side_v = (left + right) + thickness_frame * 2;

// Top
point_xy(x - left - thickness_frame, y - up - thickness_frame);
_frame_x[0] = point_x;
_frame_y[0] = point_y;

// Left
_frame_x[2] = point_x;
_frame_y[2] = point_y;

// Bottom
point_xy(x - left - thickness_frame, y + down);
_frame_x[1] = point_x;
_frame_y[1] = point_y;

// Right
point_xy(x + right, y - up - thickness_frame);
_frame_x[3] = point_x;
_frame_y[3] = point_y;

__frame_x = _frame_x;
__frame_y = _frame_y;

// Background/Surface
point_xy(x - left, y - up);
__bg_x = point_x;
__bg_y = point_y;
__bg_w = left + right;
__bg_h = up + down;

//Draws the background of the board
surface_set_target(surface);
draw_clear_alpha(c_white, 0);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(sprPixel, 0, __bg_x, __bg_y, __bg_w, __bg_h, image_angle, c_white, image_alpha);
surface_reset_target();