///Board data
function __Board() constructor {
	/**
		Gets the x position of the board
		@param {real} target	The target board to get the data from
	*/
	static GetX = function(target = TargetBoard) {
		return BattleBoardList[target].x;
	}
	/**
		Gets the y position of the board
		@param {real} target	The target board to get the data from
	*/
	static GetY = function(target = TargetBoard) {
		return BattleBoardList[target].y;
	}
	/**
		Gets the upwards distance of the board
		@param {real} target	The target board to get the data from
	*/
	static GetUp = function(target = TargetBoard) {
		return BattleBoardList[target].up;
	}
	/**
		Gets the downwards distance of the board
		@param {real} target	The target board to get the data from
	*/
	static GetDown = function(target = TargetBoard) {
		return BattleBoardList[target].down;
	}
	/**
		Gets the leftwards distance of the board
		@param {real} target	The target board to get the data from
	*/
	static GetLeft = function(target = TargetBoard) {
		return BattleBoardList[target].left;
	}
	/**
		Gets the rightwards distance of the board
		@param {real} target	The target board to get the data from
	*/
	static GetRight = function(target = TargetBoard) {
		return BattleBoardList[target].right;
	}
	/**
		Gets the upwards position of the board
		@param {real} target	The target board to get the data from
	*/
	static GetUpPos = function(target = TargetBoard) {
		return Board.GetY(target) - Board.GetUp(target);
	}
	/**
		Gets the downwards position of the board
		@param {real} target	The target board to get the data from
	*/
	static GetDownPos = function(target = TargetBoard) {
		return Board.GetY(target) + Board.GetDown(target);
	}
	/**
		Gets the leftwards position of the board
		@param {real} target	The target board to get the data from
	*/
	static GetLeftPos = function(target = TargetBoard) {
		return Board.GetX(target) - Board.GetLeft(target);
	}
	/**
		Gets the rightwards position of the board
		@param {real} target	The target board to get the data from
	*/
	static GetRightPos = function(target = TargetBoard) {
		return Board.GetX(target) + Board.GetRight(target);
	}
	/**
		Gets the height of the board
		@param {real} target	The target board to get the data from
	*/
	static GetHeight = function(target = TargetBoard) {
		return Board.GetUp(target) + Board.GetDown(target);
	}
	/**
		Gets the width of the board
		@param {real} target	The target board to get the data from
	*/
	static GetWidth = function(target = TargetBoard) {
		return Board.GetLeft(target) + Board.GetRight(target);
	}
	/**
		Sets the size of the board with Anim (optional)
		@param {real} up		The Disatance Upwards (Default 65)
		@param {real} down		The Disatance Downards (Default 65)
		@param {real} left		The Disatance Leftwards (Default 283)
		@param {real} right		The Disatance Rightwards (Default 283)
		@param {real} time		The duration of the Anim (0 = instant, Default 30)
		@param {function,string} ease	The Tween Ease of the Anim, use TweenGMS Easing (i.e. EaseLinear, Default EaseOutQuad)
		@param {real} target	The target board to se the size to
	*/
	static SetSize = function(up = 65, down = 65, left = 283, right = 283, time = 30, ease = "oQuad", board = undefined)
	{
		board ??= BattleBoardList[TargetBoard];
		TweenFire(board, ease, 0, false, 0, time, "up>", up, "down>", down, "left>", left, "right>", right);
	}
	/**
		Sets the angle of the board with Anim (optional)
		@param {real} angle				The target angle (Default 0)
		@param {real} time				The duration of the Anim (0 = instant, Default 30)
		@param {function,string} ease	The Tween Ease of the Anim, use TweenGMS Easing (i.e. EaseLinear, Default EaseOutQuad)
		@param {Asset.GMObject} target	The target board to se the size to
	*/
	static SetAngle = function(angle = 0, time = 30, ease = "oQuad", board = undefined)
	{
		board ??= BattleBoardList[TargetBoard];
		with board
			TweenEasyRotate(image_angle, angle, 0, time, ease);
	}
	/**
		Sets the x and y position of the board
		@param {real} x					The x position
		@param {real} y					The y position
		@param {real} time				The time taken for the anim
		@param {function,string} ease	The easing
		@param {Asset.GMObject} target	The target board to se the size to
	*/
	static SetPos = function(xx = 320, yy = 320, time = 30, ease = "oQuad", board = undefined)
	{
		board ??= BattleBoardList[TargetBoard];
		with board
			TweenEasyMove(Board.GetX(), Board.GetY(), xx, yy, 0, time, ease);
	}
	/**
		Gets the ID of the board in the global board list
		@param {Asset.GMObject}	board	THe board to get the ID of
	*/
	static GetID = function(board)
	{
		var i = 0, n = array_length(BattleBoardList);
		repeat n if BattleBoardList[i] != board.id i++; else return i;
	}
	///Automatically masks the board with the default background color
	static Mask = function(obj = oEnemyParent)
	{
		with obj
		{
			Battle_Masking_Start();
			draw_set_color(oBoard.bg_color);
			draw_rectangle(0, 0, 640, 480, false);
			draw_set_color(c_white);
			Battle_Masking_End();
		}
	}
}