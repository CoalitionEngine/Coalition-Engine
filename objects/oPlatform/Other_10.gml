///@desc Drawing
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, 1, image_angle, c_white, image_alpha);
draw_sprite_ext(sprite_index, 1, x, y, image_xscale, 1, image_angle, sticky ? c_lime : c_fuchsia, image_alpha);

//Effect drawing (For the one said in Step)
if effect
{
	var _xscale = effect_xscale,
		_yscale = effect_yscale,
		_alpha = effect_alpha;
	draw_sprite_ext(sprite_index, 0, effect_x, effect_y, _xscale, _yscale, _angle, c_white, _alpha);
	draw_sprite_ext(sprite_index, 1, effect_x, effect_y, _xscale, _yscale, _angle, image_blend, _alpha);
}

show_hitbox(c_lime);