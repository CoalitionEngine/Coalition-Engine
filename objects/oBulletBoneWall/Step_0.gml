//Changes warning box color
if warn_color_swap
{
	WarnTimer++;
	if !(WarnTimer % 5) && time_warn
	{
		var change = (WarnTimer % 10) == 5
		warn_color = change ? c_yellow : c_red;
		warn_alpha_filled = change ? 0.25 : 0.5;
	}
}

if state == 2
{
	var dir_ang_x = -dsin(dir), dir_ang_y = dcos(dir);
	//Plays the sound
	if !timer && sound_create
	{
		audio_play(snd_bonewall);
	}
	else	//Moves the bonewall to destined length
	{
		if timer < time_move
		{
			var spd = floor((height) / time_move);
			
			x -= lengthdir_x(spd, dir);
			y -= lengthdir_y(spd, dir);
		}
		if (timer >= time_move && timer <= time_move + time_stay)
		{
			x = target_x - lengthdir_x(height, dir);
			y = target_y - lengthdir_y(height, dir);
		}
		if timer > time_move + time_stay
		{
			var spd = floor(height / time_move),
				kill_check = false;
			
			x += lengthdir_x(spd, dir);
			y += lengthdir_y(spd, dir);
			switch dir
			{
				case DIR.UP:
					kill_check = y < target_y;
				break
				case DIR.DOWN:
					kill_check = y > target_y;
				break
				case DIR.LEFT:
					kill_check = x < target_x;
				break
				case DIR.RIGHT:
					kill_check = x > target_x;
				break
			}
			if kill_check instance_destroy();
		}
	}
	timer++;
}