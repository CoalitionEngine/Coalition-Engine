if (Len.activate)
	len_step();
if (State != YELLOW_BOMB_STATE.IDLE)
{
	x = __curX;
	y = __curY;
	__index += 0.5;
	if (__index >= 7 && State == YELLOW_BOMB_STATE.EXPLODE)
		instance_destroy();
}
if (State == YELLOW_BOMB_STATE.SHOT && __index == 10)
{
	audio_stop_sound(__sound);
	audio_play(snd_yellow_bomb_explode);
	State = YELLOW_BOMB_STATE.EXPLODE;
	__index = 0;
}