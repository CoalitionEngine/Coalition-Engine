//Adds the board to the global board list
array_push(BattleBoardList, id);
//Initalize variables
surface = noone;
x = 320;
y = 320;

up = 65;
down = 65;
left = 283;
right = 283;

__frame_x = array_create(4, 0);
__frame_y = array_create(4, 0);

__bg_x = 0;
__bg_y = 0;
__bg_w = 0;
__bg_h = 0;
//The thickness of the board frame
thickness_frame = 5;

point_x = 0;
point_y = 0;
//Rotation speed for the board
rotate = 0;

//Board frame color
image_blend = c_white;
//Board background color
bg_color = c_black;

//Whether polygon board is enabled
VertexMode = false;

///Converts the board to a vertex board, then returns the resultant vertex board
function ConvertToVertex() {
	if VertexMode exit;
	Vertex = [];
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
		array_push(Vertex, arr[0], arr[1]);
	}
	VertexMode = true;
	var board = instance_create_depth(x, y, depth, oVertexBoard);
	array_copy(board.Vertex, 0, Vertex, 0, array_length(Vertex));
	board.UpdateEars();
	return board;
}