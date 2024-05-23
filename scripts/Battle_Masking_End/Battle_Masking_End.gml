///Ends the masked drawing
///@param {Asset.GMObject,Array} board	Which board that was used to mask in
function Battle_Masking_End(board = undefined) {
	forceinline
	board ??= BattleBoardList[TargetBoard];
	if oGlobal.MainCamera.enable_z exit;
	shader_reset();
}