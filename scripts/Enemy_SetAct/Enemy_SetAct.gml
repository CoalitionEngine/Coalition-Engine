if NOOB_MODE
/**
	Sets the act data of the enemy
	@param {Asset.GMObject} enemy	The enemy to set the act data to
	@param {real} act_number		The number of the act (First act, i.e. Check, is 0, the second is 1, and so on)
	@param {string} name			The name of the act
	@param {string} text			The text to display if selected
	@param {function} function		The function to execute if selected (Optional)
	@param {bool} trigger			Whether the action will trigger the turn
*/
function Enemy_SetAct(enemy, act, name, text, func = -1, trigger = oBattleController.activate_turn[1]) {
	forceinline
	EnemyData.SetAct(enemy, act, name, text, func, trigger);
}