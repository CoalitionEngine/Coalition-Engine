len_step();
axis_step();
image_xscale = length / 4;
//Set angle
var angle = round(image_angle % 360 / 90);
//Set direction of auto destroy
switch angle
{
	case 0: destroydir = DIR.DOWN;	break
	case 1: destroydir = DIR.RIGHT; break
	case 2: destroydir = DIR.UP;	break
	case 3: destroydir = DIR.LEFT;	break
}
//Fade out + increase size effect
if effect
{
	if effect == 1 effect = 2;
	if effect == 2
	{
		audio_play(snd_ding);
		effect_xscale = image_xscale;
		effect_yscale = image_yscale;
		effect_alpha = 1;
		effect_x = x;
		effect_y = y;
		effect = 3;
	}
	if effect == 3
	{
		effect_xscale += 0.6;
		effect_yscale += 0.15;
		if effect_alpha > 0 effect_alpha -= 0.035;
		else effect = false;
	}
}