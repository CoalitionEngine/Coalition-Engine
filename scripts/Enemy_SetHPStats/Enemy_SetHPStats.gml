if NOOB_MODE
/**
	Sets the HP data of the enemy
	@param {Asset.GMObject} enemy	The enemy to set the HP data to
	@param {real} max_hp			The max hp of the enemy
	@param {real} current_hp		The current hp of the enemy (Default max)
	@param {bool} draw_hp_bar		Whether the hp bar will be drawn in the menu
*/
function Enemy_SetHPStats(enemy, max_hp, current_hp = max_hp, draw_hp_bar = true) {
	forceinline
	EnemyData.SetHPStats(enemy, max_hp, current_hp, draw_hp_bar);
}