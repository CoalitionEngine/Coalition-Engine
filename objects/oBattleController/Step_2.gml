/// @description KR Drain & Game Over
if global.kr_activation
{
	global.assign_inv = 2;
	global.kr = clamp(global.kr, 0, max_kr);
	if global.kr >= global.hp global.kr = global.hp - 1;
	
	if global.kr
	{
		__kr_timer++;
		if
		(__kr_timer == 2 && global.kr >= 40) ||
		(__kr_timer == 4 && global.kr >= 30) || 
		(__kr_timer == 10 && global.kr >= 20) ||
		(__kr_timer == 30 && global.kr >= 10) ||
		__kr_timer == 60
		{
			__kr_timer = 0;
			global.kr--;
			global.hp--;
		}
		if global.hp <= 0 global.hp = 1;
	}
	else __kr_timer = 0;
}
else
{
	__kr_timer = 0;
	global.kr = 0;
}

if global.hp <= 0 && global.deadable
	if !global.debug gameover();
	else
	{
		global.hp = global.hp_max;
		audio_play(snd_item_heal);
	}

