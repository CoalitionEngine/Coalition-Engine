if NOOB_MODE
///Sets the max hp of the player
///@param {real} maxhp The max HP to set
function Player_SetMaxHP(maxhp) {
	forceinline
	Player.HPMax(maxhp);
}