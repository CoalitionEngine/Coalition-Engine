if active
{	
	var board = target_board,
		board_x = board.x,
		board_y = board.y,
		board_u = board_y - board.up,
		board_d = board_y + board.down,
		board_l = board_x - board.left,
		board_r = board_x + board.right;

	if time_warn
	{
		time_warn--;
		//Set corner locations
		var x1 = 0, y1 = 0, x2 = 0, y2 = 0;
		if dir == DIR.UP || dir == DIR.DOWN
		{
			x1 = board_l + 2;
			x2 = board_r - 3;
			y1 = dir == DIR.UP ? board_u + 2 : board_d - 2;
			y2 = dir == DIR.UP ? board_u + height - 2 - 5 : board_d - height + 5;
		}
		else if dir == DIR.LEFT || dir == DIR.RIGHT
		{
			y1 = board_u + 2;
			y2 = board_d - 3;
			x1 = dir == DIR.LEFT ? board_l + 2 : board_r - 2;
			x2 = dir == DIR.LEFT ? board_l + height - 2 + 5 : board_r - height - 5;
		}
		
		draw_set_color(warn_color);
		//Warning rectangle
		draw_sprite_ext(sprPixel, 0, x1, y1, x2 - x1, y2 - y1, 0, warn_color, warn_alpha_filled);
		//Warning outline
		draw_rectangle(x1, y1, x2, y2, true);
	}
	else //Draw bones
	{
		if !oBoard.VertexMode
		{
			Battle_Masking_Start(true);
			event_user(0);
			Battle_Masking_End();
		}
		if state == 1 state = 2;
	}
}
