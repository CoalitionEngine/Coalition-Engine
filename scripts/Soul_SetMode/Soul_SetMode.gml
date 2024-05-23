///@desc Sets the Mode of the Soul (Macros are given, i.e. SOUL_MODE.RED)
///@param {real} mode	The mode of the soul to set to
///@param {bool} effect	Whether to create the soul effect or not (Default True)
function Soul_SetMode(soul_mode, effect = true)
{
	forceinline
	with BattleSoulList[TargetSoul]
	{
		dir = DIR.DOWN;
		draw_angle = 0;
		image_angle = 0;
		var curBle = Blend;
		switch soul_mode
		{
			case SOUL_MODE.RED:			Blend = c_red;		break;
			case SOUL_MODE.BLUE:		Blend = c_blue;		break;
			case SOUL_MODE.ORANGE:		Blend = c_orange;	break;
			case SOUL_MODE.YELLOW:
				Blend = c_yellow;
				draw_angle = 180;
				break;
			case SOUL_MODE.GREEN:		Blend = c_lime;		break;
			case SOUL_MODE.PURPLE:		Blend = c_purple;	break;
			case SOUL_MODE.CYAN:		Blend = c_aqua;		break;
		}
		TweenEasyBlend(curBle, Blend, 0, 15, "");
		mode = soul_mode;
		alarm[0] = effect;
	}
}

function SoulSetMode(soul_mode, effect = true)
{
	forceinline
	Soul_SetMode(soul_mode, effect);
}