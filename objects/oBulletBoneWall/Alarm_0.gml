///@desc True creation
active = true;
state = 1;
var board = target_board,
	board_x = board.x,
	board_y = board.y,
	board_u = board_y - board.up,
	board_d = board_y + board.down,
	board_l = board_x - board.left,
	board_r = board_x + board.right;
//Initalize position
if dir == DIR.UP || dir == DIR.DOWN
{
	x = board_x;
	y = (dir == DIR.UP) ? board_u - height : board_d + height;
}
else if dir == DIR.LEFT || dir == DIR.RIGHT
{
	y = board_y;
	x = (dir == DIR.LEFT) ? board_l - height : board_r + height;
}

target_x = x;
target_y = y;