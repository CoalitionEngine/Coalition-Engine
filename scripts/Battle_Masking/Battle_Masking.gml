/// @category Battle
/// @title Battle Masking Functions
/// @text Below are the functions you'll use to mask things inside the board

/// @func Battle_Masking_Start([spr])
/// @desc Begins the drawing of board masking
/// @param {bool} sprite Whether a sprite used for masking
function Battle_Masking_Start(spr = false) {
	aggressive_forceinline
	static __surf = surface_create(640, 480);
	if (oGlobal.__MainCamera.enable_z)
		exit;
	//Store all board surfaces
	if (!surface_exists(__surf)) __surf = surface_create(640, 480);
	surface_set_target(__surf);
	draw_clear_alpha(c_black, 0);
	var i = 0;
	repeat (instance_number(oVertexBoard))
		draw_surface(instance_find(oVertexBoard, i++).__clip_surf, 0, 0);
	i = 0;
	repeat (instance_number(oBoard))
	{
		var curBoard = instance_find(oBoard, i++);
		if (!curBoard.VertexMode)
			draw_surface(curBoard.__surface, 0, 0);
	}
	surface_reset_target();
	//Masking shader
	var shader = spr ? shdClipMaskSpr : shdClipMask;
	shader_set(shader);
	var u_mask = shader_get_sampler_index(shader, "u_mask");
	texture_set_stage(u_mask, surface_get_texture(__surf));
	var u_rect = shader_get_uniform(shader, "u_rect"),
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