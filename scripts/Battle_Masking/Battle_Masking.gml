/// @category Battle
/// @title Battle Masking Functions
/// @text Below are the functions you'll use to mask things inside the board

/// @func Battle_Masking_Start()
/// @desc Begins the drawing of board masking
function Battle_Masking_Start() {
	aggressive_forceinline
	static __surf = surface_create(640, 480);
	if (oGlobal.__MainCamera.enable_z)
		exit;
	//Store all board surfaces
	if (!surface_exists(__surf)) __surf = surface_create(640, 480);
	surface_set_target(__surf);
	draw_clear_alpha(c_black, 0);
	with (oVertexBoard)
		__DrawBackground(c_white);
	with (oBoard)
	{
		if (!VertexMode)
			draw_surface(__surface, 0, 0);
	}
	surface_reset_target();
	//Masking shader
	shader_set(shdClipMaskSpr);
	var u_mask = shader_get_sampler_index(shdClipMaskSpr, "u_mask");
	texture_set_stage(u_mask, surface_get_texture(__surf));
	var u_rect = shader_get_uniform(shdClipMaskSpr, "u_rect"),
		window_width = 640, window_height = 480;
	shader_set_uniform_f(u_rect, 0, 0, window_width, window_height);
}

///@func Battle_Masking_End([board])
///@desc Ends the masked drawing
function Battle_Masking_End() {
	forceinline
	if (!oGlobal.__MainCamera.enable_z)
		shader_reset();
}