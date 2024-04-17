///@desc Sets the Mode of the Soul (Macros are given, i.e. SOUL_MODE.RED)
///@param {real} mode	The mode of the soul to set to
///@param {bool} effect	Whether to create the soul effect or not (Default True)
function SoulSetMode(soul_mode, effect = true)
{
	gml_pragma("forceinline");
	with BattleSoulList[TargetSoul]
	{
		dir = DIR.DOWN;
		draw_angle = 0;
		image_angle = 0;
		var curBle = Blend;
		switch soul_mode
		{
			case SOUL_MODE.RED:			Blend = c_red;		break
			case SOUL_MODE.BLUE:		Blend = c_blue;		break
			case SOUL_MODE.ORANGE:		Blend = c_orange;	break
			case SOUL_MODE.YELLOW:
				Blend = c_yellow;
				draw_angle = 180;
			break
			case SOUL_MODE.GREEN:		Blend = c_lime;		break
			case SOUL_MODE.PURPLE:		Blend = c_purple;	break
			case SOUL_MODE.CYAN:		Blend = c_aqua;		break
		}
		TweenEasyBlend(curBle, Blend, 0, 15, "");
		mode = soul_mode;
		alarm[0] = effect;
	}
}

/**
	Sets the position of the soul, can choose to animate the position
	@param {real} target_x			The target X position
	@param {real} target_y			The target Y position
	@param {real} duration			The duration of the Anim (Default 0, which is instant movement)
	@param {function,string} Easing	The Tween Ease of the Animation (Use TweenGMS structs, i.e. EaseOutQuad, Default EaseLinear)
	@param {real} delay				The delay of executing the Anim (Default 0)
*/
function SetSoulPos(target_x, target_y, duration = 0, Easing = "", delay = 0)
{
	gml_pragma("forceinline");
	with BattleSoulList[TargetSoul]
		TweenEasyMove(x, y, target_x, target_y, delay, duration, Easing);
}

///@desc Return whether is soul moving or not
///@param {bool} mode	Whether the check is position based or input based
function IsSoulMoving(input_based = false) {
	gml_pragma("forceinline");
	var target_soul = BattleSoulList[TargetSoul];
	return (input_based ?
	(CHECK_HORIZONTAL != 0 || CHECK_VERTICAL != 0) :
	floor(target_soul.x) != floor(target_soul.xprevious) or floor(target_soul.y) != floor(target_soul.yprevious));
}

function LimitSoulInVertexBoard()
{
	
}