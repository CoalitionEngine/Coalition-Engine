//Cut screen
if (global.timer >= 1)
{
	var n = ds_list_size(global.__CoalitionCutscreenSurfaceList), i = 0, _list;
	if (n > 1)
	{
		if (!surface_exists(__CutScreenSurface)) __CutScreenSurface = surface_create(640, 480);
		surface_set_target(__CutScreenSurface);
		draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_black, 1);
		draw_surface(application_surface, 0, 0);
		surface_reset_target();
	}
	repeat (n)
	{
		_list = global.__CoalitionCutscreenSurfaceList[| i];
		if (is_even(i))
			draw_clear_alpha(c_black, 1);
	
		surface_set_target(_list[0]);
		shader_set(shdCutScreen);
		shader_set_uniform_f_array(__CutLineStart, _list[3]);
		shader_set_uniform_f_array(__CutLineEnd, _list[4]);
		shader_set_uniform_f(__CutSide, is_odd(i) ? -1 : 1);
		draw_surface(__CutScreenSurface, 0, 0);
		shader_reset();
		surface_reset_target();
		var dir = is_odd(i) ? 180 : 0,
			_x = lengthdir_x(_list[1], _list[2] + dir),
			_y = lengthdir_y(_list[1], _list[2] + dir);
		draw_surface(_list[0], _x, _y);
		if (is_odd(i))
		{
			surface_set_target(__CutScreenSurface);
			draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_black, 1);
			draw_surface(application_surface, 0, 0);
			surface_reset_target();
		}
		++i;
	}
	//Drawing blasters
	if (room == room_battle && instance_exists(oGB))
	{
		gpu_push_state();
		//Apply GPU depth for blaster sprite drawing
		gpu_set_ztestenable(true);
		gpu_set_depth(-10);
		//Draw the beam first to avoid overlapping
		with (oGB)
		{
			var color = image_blend;
			switch (__type)
			{
				case 1: color = c_aqua;			break;
				case 2: color = c_orange;		break;
				case 3: color = c_red;			break;
			}
			//Firing state
			if (__state == 4)
				draw_sprite_ext(sprite_index, 0, x, y, image_xscale, __beam_scale, image_angle, color, __beam_alpha);
		}
		//Afterwards, draw the blaster to ensure the blaster is always above the beam
		with (oGB)
		{
			var color = image_blend;
			switch (__type)
			{
				case 1: color = c_aqua;			break;
				case 2: color = c_orange;		break;
				case 3: color = c_red;			break;
			}
			draw_sprite_ext(Blaster.sprite_index, Blaster.image_index, Blaster.x, Blaster.y, Blaster.image_xscale, Blaster.image_yscale, image_angle, color, Blaster.image_alpha);
		}
		gpu_pop_state();
	}
}
//Shop
if (room == room_shop)
	Shop.__Draw();