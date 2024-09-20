var curShield = self, ShieldID = ID;
with oGreenArr
{
	//Only check collision if they are the same type
	if Color == ShieldID &&  place_meeting(x, y, curShield)
	{
		audio_play(snd_ding);
		instance_destroy();
		other.HittingArrow = true;
		other.HitTimer = 5;
	}
}