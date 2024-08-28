//Moving state
if state = 0
{
	var _x = gbx, _y = gby, _angle = image_angle;
	//Play charge sound
	if charge_sound
	{
		audio_play(snd_gb_charge, true, false, 1, 1.2);
		charge_sound = false;
	}
	//Move blaster to destined location
	if timer_move <= time_move
	{
		_x += (target_x - _x) * (5 / time_move);
		_y += (target_y - _y) * (5 / time_move);
		_angle += (target_angle - _angle) * (5 / time_move);
		
		_x += sign(target_x - _x) / 2;
		_y += sign(target_y - _y) / 2;
		_angle += sign(target_angle - _angle) / 2;
		
		if abs(_x - target_x) < 1.5  _x = target_x;
		if abs(_y - target_y) < 1.5  _y = target_y;
		if abs(_angle - target_angle) < 1.5  _angle = target_angle;
	}
	if !time_move || ++timer_move == time_move 
	{
		//Wait for shoot
		state = 1;
		timer_move = 0;
		_x = target_x;
		_y = target_y;
		_angle = target_angle;
		alarm[0] = max(1, time_pause);
	}
	gbx = _x; gby = _y; image_angle = _angle;
}
//Just fire
if state = 2 
{
	state = 3;
	alarm[0] = 8;
}
//Increase index for expansion
if state == 3 gb_index += 0.5;
//Firing
if state == 4
{
	var _angle = image_angle, _yscale = gb_yscale;
	//Auto index
	if gb_index == sprite_get_number(gb_sprite) - 1 gb_index--;
	gb_index += 0.5;
	direction = _angle - 180;
	//Movement
	x = gbx + lengthdir_x(50, image_angle);
	y = gby + lengthdir_y(50, image_angle);
	
	//Fire events
	if timer_blast++ == 0
	{
		if _yscale > 1
		{
			//Camera shaking
			Camera.Shake(5 * _yscale);
			//Screen blurring if needed
			if blurring	Blur_Screen(time_blast, _yscale);
		}
		//RGB shaking
		if global.blaster_enable_rgb oGlobal.RGBShake = 5 * _yscale;
		if release_sound
		{
			audio_play(snd_gb_release, true, 0, 1, 1.2);
			audio_play(snd_gb_release2, true, 0, 0.8, 1.2);
			release_sound = false;
		}
	}
	//Speed changing of blaster according to time after blasted
	if timer_exit++ >= time_stay && timer_exit < time_stay + 10 speed += 0.5;
	else if (timer_exit >= time_stay + 10 && !check_outside()) speed *= 1.1;
	gbx += lengthdir_x(speed, direction); gby += lengthdir_y(speed, direction);
	//Blaster scale
	if timer_blast < 10 beam_scale += (gb_yscale / 16);
	else if timer_blast >= 10 + time_blast
	{
		//Beam settings
		beam_scale *= sqrt(0.8);
		beam_alpha -= 0.05;
		if beam_scale <= .5 && beam_alpha <= 0 destroy = true;
		auto_destroy();
	}
	else beam_scale = (gb_yscale + sin(timer_blast / pi) * gb_yscale / 4) / 2;
	image_angle = _angle;
	image_xscale += speed;
	image_yscale = beam_scale;
}