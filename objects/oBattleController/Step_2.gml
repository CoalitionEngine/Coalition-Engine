/// @description KR Drain & Game Over
if (global.__CoalitionPlayerKREnabled)
{
	global.__CoalitionPlayerAssignInvincibility = 2;
	global.__CoalitionPlayerKR = clamp(global.__CoalitionPlayerKR, 0, global.__CoalitionPlayerMaxKR);
	if (global.__CoalitionPlayerKR >= global.HP)
		global.__CoalitionPlayerKR = global.HP - 1;
	
	if (global.__CoalitionPlayerKR)
	{
		__kr_timer++;
		if (
		(__kr_timer == 2 && global.__CoalitionPlayerKR >= 40) ||
		(__kr_timer == 4 && global.__CoalitionPlayerKR >= 30) || 
		(__kr_timer == 10 && global.__CoalitionPlayerKR >= 20) ||
		(__kr_timer == 30 && global.__CoalitionPlayerKR >= 10) ||
		__kr_timer == 60)
		{
			__kr_timer = 0;
			global.__CoalitionPlayerKR--;
			global.HP--;
		}
		if (global.HP <= 0)
			global.HP = 1;
	}
	else
		__kr_timer = 0;
}
else
{
	__kr_timer = 0;
	global.__CoalitionPlayerKR = 0;
}

if (global.HP <= 0 && PlayerCanDie)
{
	if (!global.__CoalitionDebug)
		__gameover();
	else
	{
		global.HP = global.MaxHP;
		audio_play(snd_item_heal);
	}
}
// Bake masking surface
//Creates a surface for the drawing region for the bullets
if (!surface_exists(__mask_surf)) __mask_surf = surface_create(640, 480, surface_r8unorm);
surface_set_target(__mask_surf);
//Fills the entire view
draw_clear(c_white);
//Cuts out the board
gpu_push_state();
gpu_set_blendmode(bm_subtract);
with (oBoard)
	__DrawBackground(c_black);
with (oVertexBoard)
	__DrawBackground(c_black);
gpu_pop_state();
//Draw cover board masks
with (oBoardCover)
	draw_sprite_ext(sprPixelBig, 0, __true_x, __true_y, (right + left) / 2, (down +  up) / 2, image_angle, c_black, 1);
//End masking creation
surface_reset_target();

// Bake board background surf
if (!surface_exists(__board_bg_surf)) __board_bg_surf = surface_create(640, 480);
surface_set_target(__board_bg_surf);
draw_clear_alpha(c_black, 0);
with (oVertexBoard)
	__DrawBackground(c_white);
with (oBoard)
{
	if (!VertexMode && surface_exists(__surface))
		draw_surface(__surface, 0, 0);
}
surface_reset_target();