with oGreenArr
{
	//Only check collision if they are the same type
	if Color == other.ID
	{
		if place_meeting(x, y, other)
		{
			audio_play(snd_ding);
			instance_destroy();
			other.HittingArrow = true;
			other.HitTimer = 5;
		}
	}
}