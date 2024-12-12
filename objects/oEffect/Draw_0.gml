switch mode
{
	case EFFECT_MODE.SPRITE_TRAIL:
		if sprite_exists(sprite)
			draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, alpha);
		break;
}