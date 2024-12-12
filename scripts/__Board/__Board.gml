///@category Battle
///@title Board Functions
///@text Below are the functions that are related to controlling the board

///@constructor
///@func __Board()
///@desc Board data, to call these functions, simply use `Board.XXX()`
function __Board() constructor {
	///@method GetX([target])
	///@desc Gets the x position of the board
	///@param {real} target The target board to get the data from
	static GetX = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].x;
	}
	///@method GetY([target])
	///@desc Gets the y position of the board
	///@param {real} target The target board to get the data from
	static GetY = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].y;
	}
	///@method GetUp([target])
	///@desc Gets the upwards distance of the board
	///@param {real} target The target board to get the data from
	static GetUp = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].up;
	}
	///@method GetDown([target])
	///@desc Gets the downwards distance of the board
	///@param {real} target The target board to get the data from
	static GetDown = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].down;
	}
	///@method GetLeft([target])
	///@desc Gets the leftwards distance of the board
	///@param {real} target The target board to get the data from
	static GetLeft = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].left;
	}
	///@method GetRight([target])
	///@desc Gets the rightwards distance of the board
	///@param {real} target The target board to get the data from
	static GetRight = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].right;
	}
	///@method GetAngle([target])
	///@desc Gets the angle of the board
	///@param {real} target The target board to get the data from
	static GetAngle = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].image_angle;
	}
	///@method GetUpPos([target])
	///@desc Gets the upwards position of the board
	///@param {real} target The target board to get the data from
	static GetUpPos = function(target = TargetBoard) {
		forceinline
		return GetY(target) - lengthdir_y(GetUp(target), GetAngle(target) - 90);
	}
	///@method GetDownPos(target)
	///@desc Gets the downwards position of the board
	///@param {real} target The target board to get the data from
	static GetDownPos = function(target = TargetBoard) {
		forceinline
		return GetY(target) + lengthdir_y(GetDown(target), GetAngle(target) - 90);
	}
	///@method GetLeftPos([target])
	///@desc Gets the leftwards position of the board
	///@param {real} target The target board to get the data from
	static GetLeftPos = function(target = TargetBoard) {
		forceinline
		return GetX(target) - lengthdir_x(GetLeft(target), GetAngle(target));
	}
	///@method GetRightPos([target])
	///@desc Gets the rightwards position of the board
	///@param {real} target The target board to get the data from
	static GetRightPos = function(target = TargetBoard) {
		forceinline
		return GetX(target) + lengthdir_x(GetRight(target), GetAngle(target));
	}
	///@method GetHeight([target])
	///@desc Gets the height of the board
	///@param {real} target The target board to get the data from
	static GetHeight = function(target = TargetBoard) {
		forceinline
		return GetUp(target) + GetDown(target);
	}
	///@method GetWidth([target])
	///@desc Gets the width of the board
	///@param {real} target The target board to get the data from
	static GetWidth = function(target = TargetBoard) {
		forceinline
		return GetLeft(target) + GetRight(target);
	}
	///@method SetSize([up], [down], [left], [right], [time], [ease], [target])
	///@desc Sets the size of the board with Anim
	///@param {real} up The Disatance Upwards (Default 65)
	///@param {real} down The Disatance Downards (Default 65)
	///@param {real} left The Disatance Leftwards (Default 283)
	///@param {real} right The Disatance Rightwards (Default 283)
	///@param {real,array,struct} time The duration of the Anim (0 = instant, Default 30)
	///@param {function,string} ease The Tween Ease of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad)
	///@param {real} target The target board to se the size to
	static SetSize = function(up = 65, down = 65, left = 283, right = 283, time = {dist: 10}, ease = "oQuad", board = undefined)
	{
		forceinline
		board ??= BattleBoardList[TargetBoard];
		if time == 0
		{
			board.up = up;
			board.down = down;
			board.left = left;
			board.right = right;
		}
		else TweenFire(board, ease, 0, false, 0, time, "up>", up, "down>", down, "left>", left, "right>", right);
	}
	///@method SetAngle([angle], [time], [ease], [target])
	///@desc Sets the angle of the board with Anim
	///@param {real} angle The target angle (Default 0)
	///@param {real,array,struct} time The duration of the Anim
	///@param {function,string} ease The easing of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad)
	///@param {Asset.GMObject} target The target board to se the size to
	static SetAngle = function(angle = 0, time = {dist: 10}, ease = "oQuad", board = undefined)
	{
		forceinline
		board ??= BattleBoardList[TargetBoard];
		if time == 0 board.image_angle = angle;
		else TweenFire(board, ease, 0, false, 0, time, "image_angle>", angle);
	}
	///@method SetPos([x], [y], [time], [ease], [board])
	///@desc Sets the x and y position of the board
	///@param {real} x The x position
	///@param {real} y The y position
	///@param {real,array,struct} time The time taken for the anim
	///@param {function,string} ease The easing
	///@param {Asset.GMObject} target The target board to se the size to
	static SetPos = function(xx = 320, yy = 320, time = {dist: 10}, ease = "oQuad", board = undefined)
	{
		forceinline
		board ??= BattleBoardList[TargetBoard];
		if time == 0
		{
			with board
			{
				x = xx;	
				y = yy;
			}
		}
		else TweenFire(board, ease, 0, false, 0, time, "x>", xx, "y>", yy);
	}
	///@method GetID(target)
	///@desc Gets the ID of the board in the global board list
	///@param {Asset.GMObject} board The board to get the ID of
	static GetID = function(board)
	{
		forceinline
		var i = 0;
		repeat array_length(BattleBoardList) if BattleBoardList[i] != board.id i++; else return i;
	}
	///@method Mask()
	///@desc Automatically masks the board with the default background color
	static Mask = function()
	{
		forceinline
		static PixTex = sprite_get_texture(sprPixel, 0);
		with other
		{
			Battle_Masking_Start();
			draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, oBoard.bg_color, 1);
			Battle_Masking_End();
		}
	}
}
///@function BoardMaskAll()
///@desc Draws a mask for all the boards
function BoardMaskAll()
{
	forceinline
	static pix_tex = sprite_get_texture(sprPixel, 0);
	var i = 0;
	//Masking of normal boards
	repeat instance_number(oBoard) - instance_number(oVertexBoard)
	{
		var curBoard = instance_find(oBoard, i);
		if !curBoard.VertexMode
		{
			draw_set_color(curBoard.bg_color);
			draw_primitive_begin_texture(pr_trianglestrip, pix_tex);
			with Board
			{
				draw_vertex_texture(GetLeftPos(i), GetUpPos(i), 0, 0);
				draw_vertex_texture(GetRightPos(i), GetUpPos(i), 1, 0);
				draw_vertex_texture(GetLeftPos(i), GetDownPos(i), 0, 1);
				draw_vertex_texture(GetRightPos(i), GetDownPos(i), 1, 1);
			}
			draw_primitive_end();
		}
		++i;
	}
	i = 0;
	var k = 0;
	//Masking of vertex boards
	repeat instance_number(oVertexBoard)
	{
		with instance_find(oVertexBoard, k)
		{
			draw_set_color(bg_color);
			draw_primitive_begin(pr_trianglelist);
			repeat triangulationIndicesCount
			{
				for (var j = 0, triangle = triangulationIndices[| i++]; j < 3; j++) {
					var Result = Vertices[| triangle[j]].Rotated(image_angle);
					draw_vertex(Result.x, Result.y);
				}
			}
			draw_primitive_end();
		}
		++k;
	}
}