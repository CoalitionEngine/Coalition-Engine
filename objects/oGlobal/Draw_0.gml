//Cut screen
if global.timer >= 1
{
	var n = ds_list_size(global.sur_list), i = 0, _list;
	if n > 1 surface_copy(CutScreenSurface, 0, 0, application_surface);
	repeat n
	{
		_list = global.sur_list[| i];
		if is_even(i) draw_clear_alpha(c_black, 1);
	
		surface_set_target(_list[0]);
		shader_set(shdCutScreen);
		shader_set_uniform_f_array(CutLineStart, _list[3]);
		shader_set_uniform_f_array(CutLineEnd, _list[4]);
		shader_set_uniform_f(CutSide, is_odd(i) ? -1 : 1);
		draw_surface(CutScreenSurface, 0, 0);
		shader_reset();
		surface_reset_target();
		var dir = is_odd(i) ? 180 : 0,
			_x = lengthdir_x(_list[1], _list[2] + dir),
			_y = lengthdir_y(_list[1], _list[2] + dir);
		draw_surface(_list[0], _x, _y);
		if is_odd(i) surface_copy(CutScreenSurface, 0, 0, application_surface);
		++i;
	}
	//Drawing blasters
	if room == room_battle && instance_exists(oGB)
	{
		//Apply GPU depth for blaster sprite drawing
		var dep = gpu_get_depth();
		gpu_set_ztestenable(true);
		gpu_set_depth(-10);
		with oGB
		{
			var color = image_blend;
			switch type
			{
				case 1: color = c_aqua;			break;
				case 2: color = c_orange;		break;
				case 3: color = c_red;			break;
			}
			//Firing state
			if state == 4
				draw_sprite_ext(beam_sprite, 0, x, y, image_xscale, __beam_scale, image_angle, color, __beam_alpha);
		}
		with oGB
		{
			var color = image_blend;
			switch type
			{
				case 1: color = c_aqua;			break;
				case 2: color = c_orange;		break;
				case 3: color = c_red;			break;
			}
			draw_sprite_ext(gb_sprite, gb_index, gbx, gby, gb_xscale, gb_yscale, image_angle, color, gb_alpha);
		}
		gpu_set_depth(dep);
		gpu_set_ztestenable(false);
	}
}
//Shop
if room == room_shop Shop.__Draw();