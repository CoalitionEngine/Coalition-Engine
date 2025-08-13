/// @description KR Drain & Game Over
if (global.__CoalitionPlayerKREnabled)
{
	global.__CoalitionPlayerAssignInvincibility = 2;
	global.__CoalitionPlayerKR = clamp(global.__CoalitionPlayerKR, 0, global.__CoalitionPlayerMaxKR);
	if (global.__CoalitionPlayerKR >= global.HP)
		global.__CoalitionPlayerKR = global.HP - 1;
	
	if (global.__CoalitionPlayerKR)
	{
		__kr_timer++;
		if (
		(__kr_timer == 2 && global.__CoalitionPlayerKR >= 40) ||
		(__kr_timer == 4 && global.__CoalitionPlayerKR >= 30) || 
		(__kr_timer == 10 && global.__CoalitionPlayerKR >= 20) ||
		(__kr_timer == 30 && global.__CoalitionPlayerKR >= 10) ||
		__kr_timer == 60)
		{
			__kr_timer = 0;
			global.__CoalitionPlayerKR--;
			global.HP--;
		}
		if (global.HP <= 0)
			global.HP = 1;
	}
	else
		__kr_timer = 0;
}
else
{
	__kr_timer = 0;
	global.__CoalitionPlayerKR = 0;
}

if (global.HP <= 0 && global.CoalitionBattlePlayerCanDie)
	if (!global.__CoalitionDebug)
		__gameover();
	else
	{
		global.HP = global.MaxHP;
		audio_play(snd_item_heal);
	}

