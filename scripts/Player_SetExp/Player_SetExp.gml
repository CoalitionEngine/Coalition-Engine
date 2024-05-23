if NOOB_MODE
///Sets the current Exp the player has
///@param {real} amount The amount of exp to set
function Player_SetExp(amount) {
	forceinline
	Player.Exp(amount);
}