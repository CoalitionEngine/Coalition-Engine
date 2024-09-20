switch mode
{
	case EFFECT_MODE.SPRITE_TRAIL:
		if duration > 0 && alpha > 0
			alpha -= 1 / duration;
		if alpha <= 0 instance_destroy();
		break;
}