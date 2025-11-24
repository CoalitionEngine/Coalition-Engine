///@desc Enemy Drawing
if (!surface_exists(__enemy_draw_surface)) __enemy_draw_surface = surface_create(640, 480);
surface_set_target(__enemy_draw_surface);
draw_clear_alpha(c_black, 0);
__EnemyDrawFunction();
surface_reset_target();

draw_surface(__enemy_draw_surface, 0, 0);

//Don't delete, this prevents the enemy to be drawn inside the board
Battle_Masking_Start();
draw_surface_ext(__enemy_draw_surface, 0, 0, 1, 1, 0, c_black, 1);
Battle_Masking_End();