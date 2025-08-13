///@desc Drawing
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, 1, image_angle, c_white, image_alpha);
draw_sprite_ext(sprite_index, 1, x, y, image_xscale, 1, image_angle, sticky ? c_lime : c_fuchsia, image_alpha);

//Effect drawing (For the one said in Step)
if (__effect)
{
	var _xscale = __effect_xscale,
		_yscale = __effect_yscale,
		_alpha = __effect_alpha;
	draw_sprite_ext(sprite_index, 0, __effect_x, __effect_y, _xscale, _yscale, image_angle, c_white, _alpha);
	draw_sprite_ext(sprite_index, 1, __effect_x, __effect_y, _xscale, _yscale, image_angle, image_blend, _alpha);
}

CoalitionShowHitbox(c_lime);