///Render all bullets that are the depth of the board on screen (bullets that only show inside the board)
function RenderBullets() {
	forceinline
	if !instance_exists(oBulletParents) exit;
	//if the board is normal, carry out normal masking
	if !oBoard.VertexMode Battle_Masking_Start(true);
	else
	{
		//If not, check for clip surface, set to the surface if it exists.
		if !surface_exists(oVertexBoard.ClipSurf) exit;
		surface_set_target(oVertexBoard.ClipSurf);
	}
	//Mark all bullets as not yet rendered
	with oBulletParents __bullet_rendered = false;
	//Check for bone and draws them
	if instance_exists(oBulletBone)
		with oBulletBone if depth == oBoard.depth
		{
			event_user(0);
			__bullet_rendered = true;
		}
	//Draws platform
	if instance_exists(oPlatform)
		with oPlatform if depth == oBoard.depth event_user(0);
	//Draws bone walls
	if instance_exists(oBulletBoneWall)
		with oBulletBoneWall if depth == oBoard.depth
		{
			event_user(0);
			__bullet_rendered = true;
		}
	if instance_exists(oBulletCustomBoneWall)
		with oBulletCustomBoneWall if active && time_warn && oBoard.VertexMode
		{
			//This only draws the warning box as the custom bone wall uses bones itself
			event_user(0);
			__bullet_rendered = true;
		}
	with oBulletParents
	{
		if depth == oBoard.depth
		{
			if sprite_index != -1 && !__bullet_rendered
			{
				if RenderCheck == -1 event_user(0);
				else if RenderCheck() event_user(0);
				//There is no need to mark these bullets as rendered
				//as there are no more rendering to be done
			}
		}
		else event_perform(ev_draw, 0);
	}
	
	//End masking
	if !oBoard.VertexMode Battle_Masking_End();
	else surface_reset_target();
}