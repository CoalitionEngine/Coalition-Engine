if (!surface_exists(__clip_surf)) __clip_surf = surface_create(640, 480);
if (!surface_exists(__mask_surf)) __mask_surf = surface_create(640, 480);
//Saves current GPU state
gpu_push_state();
surface_set_target(__mask_surf);
//This is a replacement for draw_clear(c_black)
draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_black, 1);
//Subtract the board shape from the masking surface
gpu_set_blendmode(bm_subtract);
var i = 0;
//Draws the shape using triangle list primitives
draw_primitive_begin(pr_trianglelist);
repeat (__triangulated_indice_count)
{
	for (var j = 0, triangle = __triangulated_indices[| i++]; j < 3; j++) {
		var Result = __poly_vertices[| triangle[j]].Rotated(image_angle);
		draw_vertex(Result.x, Result.y);
	}
}
draw_primitive_end();
gpu_set_blendmode(bm_normal);
surface_reset_target();

//__clip_surf_texture = surface_get_texture(__clip_surf);
//Draws the contents inside board
surface_set_target(__clip_surf);
draw_clear_alpha(c_black, 0);
//Enemy drawing
with (oEnemyParent) event_user(0);
//Bullet + platform drawing
__RenderBullets();
//Apply masking
gpu_set_blendmode(bm_subtract);
draw_surface(__mask_surf, 0, 0);
surface_reset_target();
//Reset GPU state
gpu_pop_state();
//Draws the board surface
draw_surface(__clip_surf, 0, 0);
//Debug code for randomized board shape
if (keyboard_check_pressed(vk_space) && DEBUG)
{
	__vertices = [];
	var i = 0, n = irandom_range(5, 9);
	repeat (n)
	{
		__vertices[i * 2] = 320 + lengthdir_x(random_range(10, 150), 360 / n * i);
		__vertices[i * 2 + 1] = 320 + lengthdir_y(random_range(10, 150), 360 / n * i);
		++i;
	}
	__UpdateEars();
}
//Draws the board frame
CleanPolyline(__vertices).Join("miter").Cap("closed", "closed").Thickness(FrameThickness + 1).Blend(image_blend, image_alpha).Draw();