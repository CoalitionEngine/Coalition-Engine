/// @category Battle
/// @title Battle Masking Functions
/// @text Below are the functions you'll use to mask sprites inside the board

/// @func Battle_Masking_Start([spr], [board])
/// @desc Begins the drawing of board masking
/// @param {bool} sprite Whether a sprite used for masking
/// @param {Asset.GMObject} board Which board to mask in
function Battle_Masking_Start(spr = false, board = undefined) {
	aggressive_forceinline
	board ??= BattleBoardList[TargetBoard];
	var target_surf = board.surface;
	if board.VertexMode
	{
		board = VertexBoardList[TargetBoard];
		//target_surf = board.ClipSurfTex;
		target_surf = board.ClipSurf;
	}
	if oGlobal.MainCamera.enable_z exit;
	var shader = spr ? shdClipMaskSpr : shdClipMask;
	shader_set(shader);
	var u_mask = shader_get_sampler_index(shader, "u_mask");
	//texture_set_stage(u_mask, is_ptr(target_surf) ? target_surf: surface_get_texture(target_surf));
	texture_set_stage(u_mask, surface_get_texture(target_surf));
	var u_rect = shader_get_uniform(shader, "u_rect"),
		window_width = 640, window_height = 480;
	shader_set_uniform_f(u_rect, 0, 0, window_width, window_height);
}

///@func Battle_Masking_End([board])
///@desc Ends the masked drawing
///@param {Asset.GMObject} board Which board that was used to mask in
function Battle_Masking_End(board = undefined) {
	forceinline
	board ??= BattleBoardList[TargetBoard];
	if oGlobal.MainCamera.enable_z exit;
	shader_reset();
}