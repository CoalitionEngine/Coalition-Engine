if (VertexMode)
	exit;
// Frames
var _frame_x = __frame_x,
	_frame_y = __frame_y,
	side_h = (up + down) + FrameThickness * 2,
	side_v = (left + right) + FrameThickness * 2;

// Top
point_xy(x - left - FrameThickness, y - up - FrameThickness);
_frame_x[0] = point_x;
_frame_y[0] = point_y;

// Left
_frame_x[2] = point_x;
_frame_y[2] = point_y;

// Bottom
point_xy(x - left - FrameThickness, y + down);
_frame_x[1] = point_x;
_frame_y[1] = point_y;

// Right
point_xy(x + right, y - up - FrameThickness);
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

//Ensure coordinate calculation is frame perfect
if (!surface_exists(__frame_surf)) __frame_surf = surface_create(640, 480);
//Draws the board frame
surface_set_target(__frame_surf);
draw_clear_alpha(c_black, 0);
for (var i = 0; i < 4; ++i)
	draw_sprite_ext(sprPixel, 0, __frame_x[i], __frame_y[i], i < 2 ? left + right + FrameThickness * 2 : FrameThickness, i >= 2 ? up + down + FrameThickness * 2 : FrameThickness, image_angle, image_blend, image_alpha);
//Drawing of the Cover Board
__DrawCoverBoard();
surface_reset_target();
	
//Draws the background of the board
if (!surface_exists(__surface)) __surface = surface_create(640, 480);
surface_set_target(__surface);
draw_clear_alpha(c_black, 0);
__DrawBackground(c_white);
__DrawCoverBoard();
surface_reset_target();