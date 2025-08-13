//Quit Texts
if (__quit_timer)
	draw_sprite_ext(sprQuitMesssge, __quit_timer / 14, 4, 4, 2, 2, 0, c_white, __quit_timer / 15);

//Fader
if (__fader_alpha > 0)
	draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, __fader_color, __fader_alpha);

//Gradient, pre-baked (will only run once to store the surface)
if (global.timer == 1)
{
	surface_set_target(__GradientSurf);
	shader_set(shdGradient);
	draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_white, 1);
	shader_reset();
	surface_reset_target();
	shader_enable_corner_id(false);
}