//Adds the board to the global board list
array_push(BattleBoardList, id);
image_alpha = 1;
surface = noone;

x = 320;
y = 320;

up = 65;
down = 65;
left = 283;
right = 283;

frame_x = array_create(4, 0);
frame_y = array_create(4, 0);
frame_w = array_create(4, 0);
frame_h = array_create(4, 0);

bg_x = 0;
bg_y = 0;
bg_w = 0;
bg_h = 0;

thickness_frame = 5;

point_x = 0;
point_y = 0;

rotate = 0;

//Board frame color
image_blend = c_white;
//Board background color
bg_color = c_black;

//Polygon board (WIP)
VertexMode = false;
Vertex = [];
VertexList = [];

function ConvertToVertex() {
	if VertexMode exit;
	Vertex = [];
	VertexList = [];
	var PointList =
	[
		[x + right + 2.5, y - up - 2.5],
		[x + right + 2.5, y + down + 2.5],
		[x - left - 2.5, y + down + 2.5],
		[x - left - 2.5, y - up - 2.5]
	], displace = thickness_frame * dcos(image_angle) / 2;
	for (var i = 0; i < 4; ++i) {
		var arr = point_xy_array(PointList[i][0], PointList[i][1]);
		array_push(Vertex, arr[0], arr[1]);
	}
	VertexMode = true;
}
function ConvertToBox(X = x, Y = y, Left = left, Right = right, Up = up, Down = down, angle = image_angle) {
	if !VertexMode exit;
	if array_length(Vertex) == 4
	{
		if is_rectangle(Vertex[0], Vertex[1], Vertex[2], Vertex[3])
		{
			x = X;
			y = Y;
			left = Left;
			right = Right;
			up = Up;
			down = Down;
			image_angle = angle;
		}
	}
	VertexMode = false;
}
/**
	Inserts a point into the polygon board
	The first point is 0, then 1, then 2 etc.
	You must insert the points in anti-clockwise order or else visual bugs may occur.
	Returns the index of the vertex array
	@param {real} Number	The number of the point (Not index of the vertex array)
	@param {real} x			The x position of the point
	@param {real} y			The y position of the point
*/
function InsertPolygonPoint(no, x, y) {
	array_insert(Vertex, no * 2, x, y);
	return no * 2;
}