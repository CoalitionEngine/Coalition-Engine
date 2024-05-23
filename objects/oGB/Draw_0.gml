var color = image_blend;
switch type
{
	case 1: color = c_aqua;			break;
	case 2: color = c_orange;		break;
	case 3: color = c_red;			break;
}
//Firing state
if state == 4
	draw_sprite_ext(beam_sprite, 0, x, y, image_xscale, beam_scale, image_angle, color, beam_alpha);
draw_sprite_ext(gb_sprite, gb_index, gbx, gby, gb_xscale, gb_yscale, image_angle, color, gb_alpha);