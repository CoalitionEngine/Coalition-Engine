live;
var STATE = oBattleController.battle_state,
	MENU = oBattleController.menu_state;
image_angle += draw_angle;
if (STATE = 0 or STATE = 2) and (MENU != 5)
	draw_self();
image_angle -= draw_angle;

//Green soul shield drawing
if mode = SOUL_MODE.GREEN
{
	if STATE == 2
	{
		if GreenCircle
		{
			draw_set_circle_precision(16);
			draw_circle_colour(x - 0.5, y - 0.5, 30, c_green, c_green, 1);
		}
		gpu_set_blendmode(bm_add);
		with oGreenShield draw_sprite_ext(sprite_index, 0, x, y, 1, 1, image_angle, image_blend, image_alpha);
		with oGreenArr draw_self();
		gpu_set_blendmode(bm_normal);
	}
}
//Purple soul line drawing
if mode == SOUL_MODE.PURPLE and STATE == 2
{
	var TopLine =		oBoard.y - oBoard.up + 15,
		BottomLine =	oBoard.y + oBoard.down - 15,
		LeftLine =		oBoard.x - oBoard.left + 15,
		RightLine =		oBoard.x + oBoard.right - 15,
		XDifference = (RightLine - LeftLine) / (Purple.HLineAmount - 1),
		YDifference = (BottomLine - TopLine) / (Purple.VLineAmount - 1);
	draw_set_alpha(Purple.Mode == 0 ? 1 : 0.3);
	for(var i = TopLine; i <= BottomLine; i += YDifference)
	{
		draw_set_color(c_purple);
		draw_line(LeftLine, i, RightLine, i);
		draw_set_color(c_white);
	}
	draw_set_alpha(Purple.Mode == 1 ? 1 : 0.3);
	for(var i = LeftLine; i <= RightLine; i += XDifference)
	{
		draw_set_color(c_purple);
		draw_line(i, TopLine, i, BottomLine);
		draw_set_color(c_white);
	}
	Purple.ForceAlpha = lerp(Purple.ForceAlpha, 0, Purple.BoxLerpSpeed);
	draw_set_alpha(Purple.ForceAlpha);
	draw_set_color(c_purple);
	Battle_Masking_Start();
	draw_rectangle(oBoard.x - oBoard.left, oBoard.y - oBoard.up,
					oBoard.x + oBoard.right, oBoard.y + oBoard.down, 0);
	Battle_Masking_End();
	draw_set_color(c_white);
	draw_set_alpha(1);
}


show_hitbox();