///Board data
function __Board() constructor {
	///Gets the x position of the board
	///@param {real} target	The target board to get the data from
	static GetX = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].x;
	}
	///Gets the y position of the board
	///@param {real} target	The target board to get the data from
	static GetY = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].y;
	}
	///Gets the upwards distance of the board
	///@param {real} target	The target board to get the data from
	static GetUp = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].up;
	}
	///Gets the downwards distance of the board
	///@param {real} target	The target board to get the data from
	static GetDown = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].down;
	}
	///Gets the leftwards distance of the board
	///@param {real} target	The target board to get the data from
	static GetLeft = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].left;
	}
	///Gets the rightwards distance of the board
	///@param {real} target	The target board to get the data from
	static GetRight = function(target = TargetBoard) {
		forceinline
		return BattleBoardList[target].right;
	}
	///Gets the upwards position of the board
	///@param {real} target	The target board to get the data from
	static GetUpPos = function(target = TargetBoard) {
		forceinline
		return Board.GetY(target) - Board.GetUp(target);
	}
	///Gets the downwards position of the board
	///@param {real} target	The target board to get the data from
	static GetDownPos = function(target = TargetBoard) {
		forceinline
		return Board.GetY(target) + Board.GetDown(target);
	}
	///Gets the leftwards position of the board
	///@param {real} target	The target board to get the data from
	static GetLeftPos = function(target = TargetBoard) {
		forceinline
		return Board.GetX(target) - Board.GetLeft(target);
	}
	///Gets the rightwards position of the board
	///@param {real} target	The target board to get the data from
	static GetRightPos = function(target = TargetBoard) {
		forceinline
		return Board.GetX(target) + Board.GetRight(target);
	}
	///Gets the height of the board
	///@param {real} target	The target board to get the data from
	static GetHeight = function(target = TargetBoard) {
		forceinline
		return Board.GetUp(target) + Board.GetDown(target);
	}
	///Gets the width of the board
	///@param {real} target	The target board to get the data from
	static GetWidth = function(target = TargetBoard) {
		forceinline
		return Board.GetLeft(target) + Board.GetRight(target);
	}
	/**
		Sets the size of the board with Anim (optional)
		@param {real} up		The Disatance Upwards (Default 65)
		@param {real} down		The Disatance Downards (Default 65)
		@param {real} left		The Disatance Leftwards (Default 283)
		@param {real} right		The Disatance Rightwards (Default 283)
		@param {real,array,struct} time	The duration of the Anim (0 = instant, Default 30)
		@param {function,string} ease	The Tween Ease of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad)
		@param {real} target	The target board to se the size to
	*/
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
	/**
		Sets the angle of the board with Anim (optional)
		@param {real} angle				The target angle (Default 0)
		@param {real,array,struct} time	The duration of the Anim
		@param {function,string} ease	The Tween Ease of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad)
		@param {Asset.GMObject} target	The target board to se the size to
	*/
	static SetAngle = function(angle = 0, time = {dist: 10}, ease = "oQuad", board = undefined)
	{
		forceinline
		board ??= BattleBoardList[TargetBoard];
		if time == 0 board.image_angle = angle;
		else TweenFire(board, ease, 0, false, 0, time, "image_angle>", angle);
	}
	/**
		Sets the x and y position of the board
		@param {real} x					The x position
		@param {real} y					The y position
		@param {real,array,struct} time	The time taken for the anim
		@param {function,string} ease	The easing
		@param {Asset.GMObject} target	The target board to se the size to
	*/
	static SetPos = function(xx = 320, yy = 320, time = {dist: 10}, ease = "oQuad", board = undefined)
	{
		forceinline
		board ??= BattleBoardList[TargetBoard];
		if time == 0
		{
			board.x = xx;
			board.y = yy;
		}
		else TweenFire(board, ease, 0, false, 0, time, "x>", xx, "y>", yy);
	}
	/**
		Gets the ID of the board in the global board list
		@param {Asset.GMObject}	board	THe board to get the ID of
	*/
	static GetID = function(board)
	{
		forceinline
		var i = 0;
		repeat array_length(BattleBoardList) if BattleBoardList[i] != board.id i++; else return i;
	}
	///Automatically masks the board with the default background color
	static Mask = function()
	{
		forceinline
		with other
		{
			Battle_Masking_Start();
			draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, oBoard.bg_color, 1);
			Battle_Masking_End();
		}
	}
}
