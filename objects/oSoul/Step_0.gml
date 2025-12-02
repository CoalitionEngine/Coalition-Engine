// Invincibility
if (global.__CoalitionPlayerInvincibilityFrames > 0)
{
	global.__CoalitionPlayerInvincibilityFrames--;
	if (!global.__CoalitionPlayerKREnabled && image_speed == 0)
	{
		image_speed = 0.5;
		image_index = 1;
	}
}
else
{
	if (image_speed != 0 && sprite_index != sprSoulFlee)
	{
		image_speed = 0;
		image_index = 0;
	}
}

// Mode
if (Battle.State() == BATTLE_STATE.IN_TURN)
{
	var x_offset = sprite_width / 2, y_offset = sprite_height / 2;
	__h_spd = CHECK_HORIZONTAL;
	__v_spd = CHECK_VERTICAL;
	//Soul movement logic
	if (struct_exists(Soul.__defined_modes, __SoulMode) && !Soul.__defined_modes[$ __SoulMode].EndStep)
		Soul.__defined_modes[$ __SoulMode].Step(self);
	//Check if the soul is allowed to go outside the screen
	if (!CanBeOffscreen)
	{
		var camX = oGlobal.__MainCamera.x, camY = oGlobal.__MainCamera.y;
		x = clamp(x, camX + x_offset, camX + 640 - x_offset);
		y = clamp(y, camY + y_offset, camY + 480 - y_offset);
	}
}