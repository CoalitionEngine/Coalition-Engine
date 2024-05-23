if NOOB_MODE
/**
	Sets the Defense of the enemy
	@param {Asset.GMObject} enemy	The enemy to set the defense to
	@param {real}  value			The defense value
*/
function Enemy_SetDefense(enemy, value) {
	forceinline
	EnemyData.SetDefense(enemy, value);
}