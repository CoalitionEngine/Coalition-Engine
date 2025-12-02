///@category Core Functions
///@title Rendering

///@func __RenderBullets()
///@desc Render all bullets that are the depth of the board on screen (bullets that only show inside the board)
function __RenderBullets() {
	forceinline
	//If no objects that are required to render exists, don't render anything
	if (!instance_exists(oBulletParents) && !instance_exists(oPlatform))
		exit;
	gpu_push_state();
	//Clear stencil buffer
	draw_clear_stencil(0);
	//Write to mask
	gpu_set_stencil_enable(true);
	gpu_set_stencil_write_mask(1);
	gpu_set_stencil_pass(stencilop_replace);
	//Create mask
	gpu_push_state();
	gpu_set_alphatestenable(true);
	gpu_set_alphatestref(127);
	gpu_set_colorwriteenable(false, false, false, false);
	//Apply masking surface
	draw_surface(__mask_surf, 0, 0);
	gpu_pop_state();
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
	//Check for bone and draws them
	if (instance_exists(oBulletBone))
	{
		with (oBulletBone)
		{
			if (depth >= BoardDepth && __InAnyBoard())
				__Draw();
			__bullet_rendered = true;
		}
	}
	//Draws platform
	if (instance_exists(oPlatform))
	{
		with (oPlatform)
			if (depth >= BoardDepth && __InAnyBoard())
				__Draw();
	}
	//Draws bone walls
	if (instance_exists(oBulletCustomBoneWall))
	{
		with (oBulletCustomBoneWall)
		{
			__bullet_rendered = true;
			if (__active && __time_warn > 0)
				__Draw();
		}
	}

	with (oBulletParents)
	{
		//Blaster drawing is reserved for later
		if (!__bullet_rendered && depth >= BoardDepth && is_callable(RenderCheck) && RenderCheck())
		{
			gpu_set_depth(depth);
			__Draw();
		}
		//There is no need to mark these bullets as rendered
		//as there are no more rendering to be done
	}
	gpu_pop_state();
	//End masking
	Battle_Masking_End();
}