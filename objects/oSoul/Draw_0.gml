var STATE = oBattleController.battle_state, MENU = oBattleController.menu_state;
if (STATE = BATTLE_STATE.MENU || STATE = BATTLE_STATE.IN_TURN) && (MENU != MENU_STATE.FIGHT_AIM)
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle + draw_angle, image_blend, image_alpha);

if STATE == BATTLE_STATE.IN_TURN
{
	//Green soul shield drawing
	if mode = SOUL_MODE.GREEN
	{
		//The green circle of green soul
		if GreenCircle
		{
			draw_set_circle_precision(16);
			draw_circle_colour(x - 0.5, y - 0.5, 30, c_green, c_green, 1);
		}
		//Draws the shield and arrows with addictive blending
		gpu_set_blendmode(bm_max);
		with oGreenArr draw_self();
		with oGreenShield draw_sprite_ext(sprite_index, 0, x, y, 1, 1, image_angle, image_blend, image_alpha);
		gpu_set_blendmode(bm_normal);
	}
	//Purple soul line drawing
	else if mode == SOUL_MODE.PURPLE
	{
		var board =			BattleBoardList[min(SoulListID, array_length(BattleBoardList) - 1)],
			board_x	=		board.x,
			board_y	=		board.y,
			b_up =			board.up,
			b_down =		board.down,
			b_left =		board.left,
			b_right =		board.right,
			TopLine =		board_y - b_up + 15,
			BottomLine =	board_y + b_down - 15,
			LeftLine =		board_x - b_left + 15,
			RightLine =		board_x + b_right - 15,
			XDifference = (RightLine - LeftLine) / (Purple.HLineAmount - 1),
			YDifference = (BottomLine - TopLine) / (Purple.VLineAmount - 1);
		//Horizontal lines
		draw_set_alpha(Purple.Mode == 0 ? 1 : 0.3);
		draw_set_color(c_purple);
		for (var i = TopLine; i <= BottomLine; i += YDifference)
			draw_line(LeftLine, i, RightLine, i);
		if Purple.AllowVertical
		{
			//Vertical lines
			draw_set_alpha(Purple.Mode == 1 ? 1 : 0.3);
			for(var i = LeftLine; i <= RightLine; i += XDifference)
				draw_line(i, TopLine, i, BottomLine);
			//Fading effect when line changes
			Purple.ForceAlpha = lerp(Purple.ForceAlpha, 0, Purple.BoxLerpSpeed);
			Battle_Masking_Start();
			draw_sprite_ext(sprPixel, 0, board_x - b_left, board_y - b_up, b_left + b_right, b_up + b_down, 0, c_purple, Purple.ForceAlpha);
			Battle_Masking_End();
		}
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
}
show_hitbox();