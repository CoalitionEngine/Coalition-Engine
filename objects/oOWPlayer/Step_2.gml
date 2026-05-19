//Cutscene character walking animation check
if (CutsceneIsActive() && CutsceneCharacterAutoIndex() && x == xprevious && y == yprevious)
	image_index = 0;
//Party member position update
if (!CutsceneIsActive() && (x != xprevious || y != yprevious))
{
	ds_list_add(__PartyMemberData, {
		x, y, FacingDirection, image_index
	});
}