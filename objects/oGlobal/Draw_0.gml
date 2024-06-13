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
}
//Shop
if room == room_shop Shop.__Draw();