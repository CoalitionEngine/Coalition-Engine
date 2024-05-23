if NOOB_MODE
/**
	Sets whether the enemy can be spared
	@param {Asset.GMObject} enemy	The enemy to set whether it is sparable
	@param {bool}  spareable		Can the enemy be spared
*/
function Enemy_SetSpareable(enemy, spareable) {
	forceinline
	EnemyData.SetSpareable(enemy, spareable);
}