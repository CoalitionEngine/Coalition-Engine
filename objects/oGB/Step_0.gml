var _blaster = Blaster;
//Moving state
if (__state == 0)
{
	var _x = _blaster.x, _y = _blaster.y, _angle = image_angle;
	//Play charge sound
	if (__charge_sound)
	{
		audio_play(snd_gb_charge, true, false, 1, 1.2);
		__charge_sound = false;
	}
	//Move blaster to target location
	if (__timer_move <= __time_move)
	{
		_x += (__target_x - _x) * (5 / __time_move);
		_y += (__target_y - _y) * (5 / __time_move);
		_angle += (__target_angle - _angle) * (5 / __time_move);
		
		_x += sign(__target_x - _x) / 2;
		_y += sign(__target_y - _y) / 2;
		_angle += sign(__target_angle - _angle) / 2;
		
		if (abs(_x - __target_x) < 1.5)
			_x = __target_x;
		if (abs(_y - __target_y) < 1.5)
			_y = __target_y;
		if (abs(_angle - __target_angle) < 1.5)
			_angle = __target_angle;
	}
	if (!__time_move || ++__timer_move == __time_move)
	{
		//Wait for shoot
		__state = 1;
		__timer_move = 0;
		_x = __target_x;
		_y = __target_y;
		_angle = __target_angle;
		alarm[0] = max(1, __time_pause);
	}
	_blaster.x = _x; _blaster.y = _y; image_angle = _angle;
}
//Just fire
if (__state == 2)
{
	__state = 3;
	alarm[0] = 8;
}
//Increase index for expansion
if (__state == 3)
	Blaster.image_index += 0.5;
//Firing
if (__state == 4)
{
	var _angle = image_angle, _yscale = _blaster.image_yscale;
	//Auto index
	if (_blaster.image_index == sprite_get_number(_blaster.sprite_index) - 1)
		_blaster.image_index--;
	_blaster.image_index += 0.5;
	direction = _angle - 180;
	//Movement
	x = _blaster.x + lengthdir_x(50, image_angle);
	y = _blaster.y + lengthdir_y(50, image_angle);
	
	//Fire events
	if (__timer_blast++ == 0)
	{
		if (_yscale > 1)
		{
			//Camera shaking
			Camera.Shake(5 * _yscale);
		}
		__blast_func();
		if (__release_sound)
		{
			audio_play(snd_gb_release, true, 0, 1, 1.2);
			audio_play(snd_gb_release2, true, 0, 0.8, 1.2);
			__release_sound = false;
		}
	}
	//Speed changing of blaster according to time after blasted
	if (__timer_exit++ >= __time_stay && __timer_exit < __time_stay + 10)
		speed += 0.5;
	else if (__timer_exit >= __time_stay + 10 && !check_outside())
		speed *= 1.1;
	_blaster.x += lengthdir_x(speed, direction);
	_blaster.y += lengthdir_y(speed, direction);
	//Blaster scale
	if (__timer_blast < 10)
		__beam_scale += (_blaster.image_yscale / 16);
	else if (__timer_blast >= 10 + __time_blast)
	{
		//Beam settings
		__beam_scale *= sqrt(0.8);
		__beam_alpha -= 0.05;
		if (__beam_scale <= .5 && __beam_alpha <= 0 && __timer_exit >= __time_stay)
			_blaster.__auto_destroy();
	}
	else
		__beam_scale = (_blaster.image_yscale + sin(__timer_blast / pi) * _blaster.image_yscale / 4) / 2;
	image_angle = _angle;
	image_xscale += speed;
	image_yscale = __beam_scale * 2;
}
Blaster = _blaster;