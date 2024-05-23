//Quit Texts
if quit_timer
	draw_sprite_ext(sprQuitMesssge, quit_timer / 14, 4, 4, 2, 2, 0, c_white, quit_timer / 15);
if RGBShake
{
	switch RGBShakeMethod
	{
		//Extra surface drawing (has shadow)
		case 0:
			surface_copy(RGBSurf, 0, 0, application_surface);
			draw_clear(c_black);
			gpu_set_blendmode(bm_add);
			draw_surface_ext(RGBSurf, random_range(-RGBShake, RGBShake), random_range(-RGBShake, RGBShake), 1, 1, 0, c_red, 1);
			draw_surface_ext(RGBSurf, random_range(-RGBShake, RGBShake), random_range(-RGBShake, RGBShake), 1, 1, 0, c_blue, 1);
			draw_surface_ext(RGBSurf, random_range(-RGBShake, RGBShake), random_range(-RGBShake, RGBShake), 1, 1, 0, c_dkgreen, 1);
			gpu_set_blendmode(bm_normal);
		break
		//Application surface drawing (No shadow, brighter)
		case 1:
			gpu_set_blendmode(bm_add);
			draw_surface_ext(application_surface, random_range(-RGBShake, RGBShake), random_range(-RGBShake, RGBShake), 1, 1, 0, c_red, 1);
			draw_surface_ext(application_surface, random_range(-RGBShake, RGBShake), random_range(-RGBShake, RGBShake), 1, 1, 0, c_blue, 1);
			draw_surface_ext(application_surface, random_range(-RGBShake, RGBShake), random_range(-RGBShake, RGBShake), 1, 1, 0, c_dkgreen, 1);
			gpu_set_blendmode(bm_normal);
		break
	}
}

//Fader
if fader_alpha > 0
	draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, fader_color, fader_alpha);

//Song Name
with Song
{
	if Activate
	{
		if (room == room_gameover && Time < 180) Time = 180;
		Time++;
		var Text = "Now Playing: " + Name, Length = string_width(Text), Height = string_height(Text), dist = Dist;
		draw_rectangle_color(dist - 10, 10, dist - Length - 20, 30 + Height, c_teal, c_purple,
							c_purple, c_teal, false);
		draw_triangle_color(dist - 11, 10, dist + 20, (35 + Height) / 2, dist - 11, 30 + Height,
							c_purple, c_purple, c_purple, false);
		draw_text_scribble(dist - Length + 10, 10, "[fnt_dt_sans][c_white]" + Text);
		if Time < 60 Dist = lerp(dist, Length, Lerp);
		if Time > 180 Dist = lerp(dist, -20, Lerp);
		if Time > 240
		{
			Activate = false;
			Time = 0;
			Name = "";
		}
	}
}

//Gradient, pre-baked (will only run once to store the surface)
if global.timer == 1
{
	surface_set_target(GradientSurf);
	shader_set(shdGradient);
	draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_white, 1);
	shader_reset();
	surface_reset_target();
	shader_enable_corner_id(false);
}