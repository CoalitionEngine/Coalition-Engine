///@category Core Functions
///@title Rendering

///@func __RenderBullets()
///@desc Render all bullets that are the depth of the board on screen (bullets that only show inside the board)
function __RenderBullets() {
	forceinline
	static __mask_surf = surface_create(640, 480, surface_r8unorm);
	//If no objects that are required to render exists, don't render anything
	if (!instance_exists(oBulletParents) && !instance_exists(oPlatform))
		exit;
	//Creates a surface for the drawing region for the bullets
	if (!surface_exists(__mask_surf)) __mask_surf = surface_create(640, 480, surface_r8unorm);
	surface_set_target(__mask_surf);
	//Fills the entire view
	draw_clear(c_white);
	//Cuts out the board
	gpu_push_state();
	gpu_set_blendmode(bm_subtract);
	with (oBoard)
		__DrawBackground(c_black);
	with (oVertexBoard)
		__DrawBackground(c_black);
	gpu_pop_state();
	//Draw cover board masks
	with (oBoardCover)
		draw_sprite_ext(sprPixelBig, 0, x + lengthdir_x((right - left) / 2, image_angle), y + lengthdir_x((down - up) / 2, image_angle), (right + left) / 2, (down +  up) / 2, image_angle, c_black, 1);
	//End masking creation
	surface_reset_target();
	gpu_push_state();
	//Clear stencil buffer
	draw_clear_stencil(0);
	//Write to mask
	gpu_set_stencil_enable(true);
	gpu_set_stencil_write_mask(1);
	gpu_set_stencil_pass(stencilop_replace);
	//Create mask
	gpu_set_alphatestenable(true);
	gpu_set_alphatestref(127);
	gpu_set_colorwriteenable(false, false, false, false);
	//Apply masking surface
	draw_surface(__mask_surf, 0, 0);
	gpu_set_colorwriteenable(true, true, true, true);
	gpu_set_alphatestenable(false);
	//Read from stored mask
	gpu_set_stencil_ref(1);
	gpu_set_stencil_read_mask(1);
	gpu_set_stencil_pass(stencilop_keep);
	gpu_set_stencil_func(cmpfunc_notequal);
	//Begin masking
	Battle_Masking_Start();
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	var BoardDepth = oBoard.depth;
	gpu_set_depth(BoardDepth);
	//Mark all bullets as not yet rendered
	with (oBulletParents)
		__bullet_rendered = false;
	//Check for bone and draws them
	if (instance_exists(oBulletBone))
	{
		with (oBulletBone)
			if (depth == BoardDepth)
			{
				var _color = __default_color,
				_angle = image_angle + Axis.angle + Len.angle_extra;
				switch (__type)
				{
					case 1: _color = c_aqua;	break;
					case 2: _color = c_orange;	break;
				}
				//Using image_index in case you are using several indexes for several types of bones
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, _angle, _color, image_alpha);
				if (OutlineEnabled)
					draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, 1, _angle, OutlineColor, image_alpha);
				__bullet_rendered = true;
			}
	}
	//Draws platform
	if (instance_exists(oPlatform))
	{
		with (oPlatform)
			if (depth == BoardDepth)
				event_user(0);
	}
	//Draws bone walls
	if (instance_exists(oBulletCustomBoneWall))
	{
		with (oBulletCustomBoneWall)
		{
			__bullet_rendered = true;
			if (__active && __time_warn > 0)
				event_user(0);
		}
	}

	with (oBulletParents)
	{
		//Blaster drawing is reserved for later
		if (!__bullet_rendered && depth >= BoardDepth && is_callable(RenderCheck) && RenderCheck())
		{
			gpu_set_depth(depth);
			event_user(0);
		}
		//There is no need to mark these bullets as rendered
		//as there are no more rendering to be done
	}
	gpu_pop_state();
	//End masking
	Battle_Masking_End();
}