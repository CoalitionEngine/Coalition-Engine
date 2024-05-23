///Deals damage to the soul
///@param {real} dmg	The Damage to Yellow HP (Default 1)
///@param {real} kr		The Damage to Purple KR (Default 1)
function Soul_Hurt(dmg = global.damage, kr = global.krdamage)
{
	forceinline
	if !global.inv && can_hurt
	{
		audio_play(snd_hurt);
		global.inv = global.assign_inv + global.player_inv_boost;
		global.hp -= dmg;
		if global.hp > 1 global.kr += kr;
		if hit_destroy
		{
			__CoalitionEngineError(object_get_parent(self) == oBulletParents,
			"Soul_Hurt() is only ment to be called in objects that are children to oBulletParents");
			instance_destroy();
		}
	}
}