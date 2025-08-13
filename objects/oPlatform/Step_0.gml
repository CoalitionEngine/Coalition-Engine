if (Len.activate)
	len_step();
if (Axis.activate)	
	axis_step();
image_xscale = length / 4;
//Set angle
var angle = round(image_angle % 360 / 90);
//Set direction of auto destroy
switch (angle)
{
	case 0: DestroyDirection = DIR.DOWN;	break;
	case 1: DestroyDirection = DIR.RIGHT; break;
	case 2: DestroyDirection = DIR.UP;	break;
	case 3: DestroyDirection = DIR.LEFT;	break;
}
//Fade out + increase size effect
if (__effect)
{
	if (__effect == 1)
		__effect = 2;
	if (__effect == 2)
	{
		audio_play(snd_ding);
		__effect_xscale = image_xscale;
		__effect_yscale = image_yscale;
		__effect_alpha = 1;
		__effect_x = x;
		__effect_y = y;
		__effect = 3;
	}
	if (__effect == 3)
	{
		__effect_xscale += 0.6;
		__effect_yscale += 0.15;
		if (__effect_alpha > 0)
			__effect_alpha -= 0.035;
		else
			__effect = 0;
	}
}