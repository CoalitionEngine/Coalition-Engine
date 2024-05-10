if !surface_exists(ClipSurf) ClipSurf = surface_create(640, 480);
if !surface_exists(MaskSurf) MaskSurf = surface_create(640, 480);
//Saves current GPU state
gpu_push_state();
surface_set_target(MaskSurf);
//This is a replacement for draw_clear(c_black)
draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_black, 1);
//Subtract the board shape from the masking surface
gpu_set_blendmode(bm_subtract);
var i = 0;
//Draws the shape using triangle list primitives
draw_primitive_begin(pr_trianglelist);
repeat triangulationIndicesCount
{
	for (var j = 0, triangle = triangulationIndices[| i++]; j < 3; j++) {
		var Result = Vertices[| triangle[j]].Rotated(image_angle);
		draw_vertex(Result.x, Result.y);
	}
}
draw_primitive_end();
gpu_set_blendmode(bm_normal);
surface_reset_target();

//ClipSurfTex = surface_get_texture(ClipSurf);
//Draws the contents inside board
surface_set_target(ClipSurf);
draw_clear_alpha(c_black, 0);
//Enemy drawing
with oEnemyParent event_user(0);
//Bullet + platform drawing
RenderBullets();
//Apply masking
gpu_set_blendmode(bm_subtract);
draw_surface(MaskSurf, 0, 0);
surface_reset_target();
//Reset GPU state
gpu_pop_state();
//Draws the board surface
draw_surface(ClipSurf, 0, 0);
//Debug code for randomized board shape
if keyboard_check_pressed(vk_space) && DEBUG
{
	Vertex = [];
	var i = 0, n = irandom_range(5, 9);
	repeat n
	{
		Vertex[i * 2] = 320 + lengthdir_x(random_range(10, 150), 360 / n * i);
		Vertex[i * 2 + 1] = 320 + lengthdir_y(random_range(10, 150), 360 / n * i);
		++i;
	}
	UpdateEars();
}
//Draws the board frame
CleanPolyline(Vertex).Join("miter").Cap("closed", "closed").Thickness(thickness_frame + 1).Blend(image_blend, image_alpha).Draw();