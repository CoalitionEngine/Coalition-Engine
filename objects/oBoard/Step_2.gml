if (VertexMode)
	exit;
// Frames
var _frame_x = __frame_x,
	_frame_y = __frame_y,
	_frame_thickness = FrameThickness,
	side_h = (up + down) + _frame_thickness * 2,
	side_v = (left + right) + _frame_thickness * 2,
	_left = left, _right = right, _up = up, _down = down;
// Top
point_xy(x - _left - _frame_thickness, y - _up - _frame_thickness);
_frame_x[0] = point_x;
_frame_y[0] = point_y;

// Left
_frame_x[2] = point_x;
_frame_y[2] = point_y;

// Bottom
point_xy(x - _left - _frame_thickness, y + _down);
_frame_x[1] = point_x;
_frame_y[1] = point_y;

// Right
point_xy(x + _right, y - _up - _frame_thickness);
_frame_x[3] = point_x;
_frame_y[3] = point_y;

// Background/Surface
__bg_w = _left + _right;
__bg_h = _up + _down;

//Ensure coordinate calculation is frame perfect
if (!surface_exists(__frame_surf))
{
	__frame_surf = surface_create(side_v, side_h);
	__cur_surf_width = side_v;
	__cur_surf_height = side_h;
}
//Resize board frame surface if needed
if (__cur_surf_width != side_v || __cur_surf_height != side_h)
{
	surface_resize(__frame_surf, side_v, side_h);
	__cur_surf_width = side_v;
	__cur_surf_height = side_h;
}
//Draws the board frame
surface_set_target(__frame_surf);
draw_clear_alpha(c_black, 0);
if (!sprite_exists(sprite_index))
{
	draw_sprite_ext(sprPixel, 0, 0, 0, side_v, side_h, 0, c_white, 1);
	gpu_push_state();
	gpu_set_blendmode(bm_subtract);
	draw_sprite_ext(sprPixel, 0, _frame_thickness, _frame_thickness, side_v - _frame_thickness * 2, side_h - _frame_thickness * 2, 0, c_white, 1);
	gpu_pop_state();
}
else //If the board is a sprite
	draw_sprite_stretched(sprite_index, image_index, 0, 0, side_v, side_h);
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

__frame_x = _frame_x;
__frame_y = _frame_y;