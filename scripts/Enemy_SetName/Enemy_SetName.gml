if NOOB_MODE
///Sets the name of the enemy
///@param {Asset.GMObject}	enemy	The enemy to set the name of
///@param {string}	text			The name to set to
function Enemy_SetName(enemy, name) {
	forceinline
	EnemyData.SetName(enemy, name);
}