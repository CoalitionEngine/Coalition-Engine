if NOOB_MODE
/**
	Sets the Damage of the enemy (Taken by enemy, not inflicted to player)
	@param {Asset.GMObject} enemy	The enemy to set the damage to
	@param {real} damage			The attack value
*/
function Enemy_SetDamage(enemy, damage) {
	forceinline
	EnemyData.SetDamage(enemy, damage);
}