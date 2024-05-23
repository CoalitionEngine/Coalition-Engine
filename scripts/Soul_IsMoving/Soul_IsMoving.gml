///@desc Return whether is soul moving or not
///@param {bool} mode	Whether the check is position based or input based
function Soul_IsMoving(input_based = false) {
	forceinline
	var target_soul = BattleSoulList[TargetSoul];
	return (input_based ?
	(input_distance("left", "right", "up", "down") != 0) :
	floor(target_soul.x) != floor(target_soul.xprevious) ||
	floor(target_soul.y) != floor(target_soul.yprevious));
}