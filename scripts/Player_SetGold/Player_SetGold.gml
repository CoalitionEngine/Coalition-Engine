if NOOB_MODE
///Sets the current Gold the player has
///@param {real} amount The amount of gold to set
function Player_SetGold(amount) {
	forceinline
	Player.Gold(amount);
}