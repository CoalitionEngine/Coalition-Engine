///@category Core Functions
///@title Rendering

///@func RenderBullets()
///@desc Render all bullets that are the depth of the board on screen (bullets that only show inside the board)
function RenderBullets() {
	forceinline
	static  __bone_draw_event = function() {
		var _color = base_color,
		_angle = image_angle + Axis.angle + Len.angle_extra;
		switch type
		{
			case 1: _color = c_aqua;	break;
			case 2: _color = c_orange;	break;
		}
		var _color_outline = _color;
		//Using image_index in case you are using several indexes for several types of bones
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, _angle, _color, image_alpha);
		draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, 1, _angle, _color_outline, image_alpha);
	};
	//If nothing that requires to be renders exist, don't render anything
	if !instance_exists(oBulletParents) && !instance_exists(oPlatform) exit;
	//if the board is normal, carry out normal masking
	if !oBoard.VertexMode Battle_Masking_Start(true);
	else
	{
		//If not, check for clip surface, set to the surface if it exists.
		if !surface_exists(oVertexBoard.ClipSurf) exit;
		surface_set_target(oVertexBoard.ClipSurf);
	}
	var BoardDepth = oBoard.depth;
	//Mark all bullets as not yet rendered
	with oBulletParents __bullet_rendered = false;
	//Check for bone and draws them
	if instance_exists(oBulletBone)
	{
		with oBulletBone if depth == BoardDepth
		{
			__bone_draw_event();
			__bullet_rendered = true;
		}
	}
	//Draws platform
	if instance_exists(oPlatform)
	{
		with oPlatform if depth == BoardDepth event_user(0);
	}
	//Draws bone walls
	if instance_exists(oBulletBoneWall)
	{
		with oBulletBoneWall if depth == BoardDepth
		{
			event_user(0);
			__bullet_rendered = true;
		}
	}
	if instance_exists(oBulletCustomBoneWall)
	{
		with oBulletCustomBoneWall if active && time_warn && oBoard.VertexMode
		{
			//This only draws the warning box as the custom bone wall uses bones itself
			event_user(0);
			__bullet_rendered = true;
		}
	}
	with oBulletParents
	{
		//Blaster drawing is reserved for later
		if object_get_name(self) != "oGB"
		{
			if depth == BoardDepth
			{
				if sprite_index != -1 && !__bullet_rendered
				{
					var WillRender = is_callable(RenderCheck) ? RenderCheck() : RenderCheck == -1;
					if WillRender event_user(0);
					//There is no need to mark these bullets as rendered
					//as there are no more rendering to be done
				}
			}
			else event_perform(ev_draw, 0);
		}
	}
	
	//End masking
	if !oBoard.VertexMode Battle_Masking_End();
	else surface_reset_target();
}

///@text 
///?> You may want to edit this script when you add more bullets