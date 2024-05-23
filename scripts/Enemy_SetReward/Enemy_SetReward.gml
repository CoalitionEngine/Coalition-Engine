/**
	Sets the Reward of the enemy
	@param {Asset.GMObject} enemy	The enemy to set the rewards to
	@param {real}  Exp				Rewarded EXP points
	@param {real}  Gold				Rewarded Gold
*/
function Enemy_SetReward(enemy, Exp, Gold) {
	forceinline
	EnemyData.SetReward(enemy, Exp, Gold);
}