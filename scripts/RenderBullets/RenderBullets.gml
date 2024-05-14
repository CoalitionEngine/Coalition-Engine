///Render all bullets that are the depth of the board on screen (bullets that only show inside the board)
function RenderBullets() {
	gml_pragma("forceinline");
	//if the board is normal, carry out normal masking
	if !oBoard.VertexMode Battle_Masking_Start(true);
	else
	{
		//If not, check for clip surface, set to the surface if it exists.
		if !surface_exists(oVertexBoard.ClipSurf) exit;
		surface_set_target(oVertexBoard.ClipSurf);
	}
	//Check for bone and draws them
	if instance_exists(oBulletBone)
		with oBulletBone if depth >= oBoard.depth event_user(0);
	//Draws platform
	if instance_exists(oPlatform)
		with oPlatform if depth >= oBoard.depth event_user(0);
	//Draws bone walls
	if instance_exists(oBulletBoneWall)
		with oBulletBoneWall if depth >= oBoard.depth event_user(0);
	if instance_exists(oBulletCustomBoneWall)
		with oBulletCustomBoneWall if depth >= oBoard.depth && active && time_warn && oBoard.VertexMode
			event_user(0);
	with oBulletParents
	{
		if depth >= oBoard.depth && sprite_index != -1
		{
			if RenderCheck == -1 event_user(0);
			else if RenderCheck() event_user(0);
		}
	}
	
	//End masking
	if !oBoard.VertexMode Battle_Masking_End();
	else surface_reset_target();
}