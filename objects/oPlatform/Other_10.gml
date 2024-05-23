///@desc Drawing
var _color = sticky ? c_lime : c_fuchsia,
	_angle = image_angle,
	_alpha = image_alpha,
	_length = length / 4,
	_image_xscale = image_xscale,
	_x = x, _y = y;

//Drawing
draw_sprite_ext(sprite_index, 0, _x, _y, _image_xscale, 1, _angle, c_white, _alpha);
draw_sprite_ext(sprite_index, 1, _x, _y, _image_xscale, 1, _angle, _color, _alpha);

//Effect drawing (For the one said in Step)
if effect
{
	var _xscale = effect_xscale,
		_yscale = effect_yscale;
		_alpha = effect_alpha;
		 _color = image_blend;
		_x = effect_x;
		_y = effect_y;
	draw_sprite_ext(sprite_index, 0, _x, _y, _xscale, _yscale, _angle, c_white, _alpha);
	draw_sprite_ext(sprite_index, 1, _x, _y, _xscale, _yscale, _angle, _color, _alpha);
}

show_hitbox(c_lime);