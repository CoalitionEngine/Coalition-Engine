//Adds the board to the global board list
array_push(BattleBoardList, id);
//Initalize variables
__surface = noone;
x = 320;
y = 320;

up = 65;
down = 65;
left = 283;
right = 283;

__diagonal = 0;
__true_x = x;
__true_y = y;

__frame_x = array_create(4, 0);
__frame_y = array_create(4, 0);
__frame_surf = -1;
__cur_surf_width = 0;
__cur_surf_height = 0;

__bg_x = 0;
__bg_y = 0;
__bg_w = 0;
__bg_h = 0;
//The thickness of the board frame
FrameThickness = 5;

point_x = 0;
point_y = 0;
//Rotation speed for the board
rotate = 0;

//Board frame color
image_blend = c_white;
//Board background color
BackgroundColor = c_black;

//Whether polygon board is enabled
VertexMode = false;

///Converts the board to a vertex board, then returns the resultant vertex board
function ConvertToVertex() {
	aggressive_forceinline
	if (VertexMode) exit;
	__vertices = [];
	left += 2.5;
	right += 2.5;
	up += 2.5;
	down += 2.5;
	var PointList =
	[
		x + right, y - up,
		x + right, y + down,
		x - left, y + down,
		x - left, y - up
	];
	left -= 2.5;
	right -= 2.5;
	up -= 2.5;
	down -= 2.5;
	for (var i = 0; i < 4; ++i) {
		var arr = point_xy_array(PointList[i * 2], PointList[i * 2 + 1]);
		array_push(__vertices, arr[0], arr[1]);
	}
	VertexMode = true;
	var board = instance_create_depth(x, y, depth, oVertexBoard);
	array_copy(board.__vertices, 0, __vertices, 0, 8);
	board.__UpdateEars();
	return board;
}

//Drawing of the Cover Board
function __DrawCoverBoard()
{
	forceinline
	if (instance_exists(oBoardCover))
	{
		var bg_x = __bg_x, bg_y = __bg_y, bg_w = __bg_w, bg_h = __bg_h;
		gpu_push_state();
		with (oBoardCover)
		{
			var _surf = __surface, _frame = FrameThickness, _angle = image_angle;
			if (surface_exists(_surf))
				draw_surface_part(_surf, bg_x, bg_y, bg_w + _frame * 2, bg_h,
									x - lengthdir_x(bg_w / 2, _angle) - abs(lengthdir_x(_frame, _angle) - lengthdir_y(_frame, _angle)),
									y - lengthdir_x(bg_h / 2, _angle));
		}
		//Pull out to prevent multiple calls
		gpu_set_blendmode(bm_subtract);
		with (oBoardCover)
		{
			var _left = left, _right = right, _up = up, _down = down;
			_angle = image_angle;
			draw_sprite_ext(sprPixelBig, 0, x + lengthdir_x((_right - _left) / 2, _angle), y + lengthdir_x((_down - _up) / 2, _angle), (_right + _left) / 2, (_down + _up) / 2, _angle, c_white, 1);
		}
		gpu_pop_state();
	}
}
function __DrawBackground(bg_color = BackgroundColor) {
	forceinline
	if (!VertexMode)
		draw_sprite_ext(sprPixel, 0, __bg_x, __bg_y, __bg_w, __bg_h, image_angle, bg_color, image_alpha);
}