/// @description KR Drain & Game Over
if global.kr_activation
{
	global.assign_inv = 2;
	global.kr = clamp(global.kr, 0, max_kr);
	if global.kr >= global.hp global.kr = global.hp - 1;
	
	if global.kr
	{
		kr_timer++;
		if
		(kr_timer == 2 and global.kr >= 40) or
		(kr_timer == 4 and global.kr >= 30) or 
		(kr_timer == 10 and global.kr >= 20) or
		(kr_timer == 30 and global.kr >= 10) or
		kr_timer == 60
		{
			kr_timer = 0;
			global.kr--;
			global.hp--;
		}
		if global.hp <= 0 global.hp = 1;
	}
	else kr_timer = 0;
}
else
{
	kr_timer = 0;
	global.kr = 0;
}

if global.hp <= 0 && global.deadable
	if !global.debug gameover();
	else
	{
		global.hp = global.hp_max;
		audio_play(snd_item_heal);
	}

