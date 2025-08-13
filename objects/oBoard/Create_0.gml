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

__frame_x = array_create(4, 0);
__frame_y = array_create(4, 0);
__frame_surf = -1;

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
	array_copy(board.__vertices, 0, __vertices, 0, array_length(__vertices));
	board.__UpdateEars();
	return board;
}

//Drawing of the Cover Board
function __DrawCoverBoard()
{
	forceinline
	if (instance_exists(oBoardCover))
	{
		gpu_push_state();
		var i = 0;
		repeat (instance_number(oBoardCover))
		{
			var BoardCoverID = instance_find(oBoardCover, i);
			if (surface_exists(BoardCoverID.__surface))
				draw_surface_part(BoardCoverID.__surface, __bg_x, __bg_y, __bg_w + 10, __bg_h,
									x - lengthdir_x(__bg_w / 2, image_angle) - abs(lengthdir_x(BoardCoverID.FrameThickness, BoardCoverID.image_angle) - lengthdir_y(BoardCoverID.FrameThickness, BoardCoverID.image_angle)),
									y - lengthdir_x(__bg_h / 2, image_angle));
			++i;
		}
		gpu_set_blendmode(bm_subtract);
		with (oBoardCover)
			draw_sprite_ext(sprPixelBig, 0, x + lengthdir_x((right - left) / 2, image_angle), y + lengthdir_x((down - up) / 2, image_angle), (right + left) / 2, (down +  up) / 2, image_angle, c_white, 1);
		gpu_pop_state();
	}
}
function __DrawBackground(bg_color = BackgroundColor) {
	forceinline
	if (VertexMode) return;
	draw_sprite_ext(sprPixel, 0, __bg_x, __bg_y, __bg_w, __bg_h, image_angle, bg_color, image_alpha);
}