///@category Soul
///@title Movement Checking

///@func Soul_IsMoving([input_based])
///@desc Returns whether is soul moving or not
///@param {bool} mode Whether the check is position based or input based
///@return {bool}
function Soul_IsMoving(input_based = false) {
	forceinline
	var target_soul = BattleSoulList[TargetSoul];
	return (input_based ? (CHECK_MOVING) :
	(floor(target_soul.x) != floor(target_soul.xprevious) ||
	floor(target_soul.y) != floor(target_soul.yprevious)));
}
///@text
///!> Due to the behaviour of Game Maker of x/yprevious, you should call this function in End Step event.