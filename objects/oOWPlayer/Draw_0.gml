///@desc Drawing
//Sets a black mask on player, similar to the Last Corridor
if (__COALITION_SHOWCASE && room == room_overworld) shader_set(shdBlackMask);
draw_self();
for (var i = 0, PartyMemDataCount = ds_list_size(__PartyMemberData); i < COALITION_OVERWORD_PARTY_MAX_MEMBERS; ++i) {
	var curPartyMember = __PartyMembers[i];
	if (PartyMemDataCount > 15 * i)
	{
		var curPartyMemberData = __PartyMemberData[| 15 * i];
		curPartyMember.x = curPartyMemberData.x;
		curPartyMember.y = curPartyMemberData.y;
		curPartyMember.image_index = curPartyMemberData.image_index;
		curPartyMember.FacingDirection = curPartyMemberData.FacingDirection;
		__PartyMembers[i] = curPartyMember;
	}
	with (curPartyMember)
		draw_sprite_ext(__GetDirectionalSprite(FacingDirection), image_index, x, y, __SpriteShouldFlip() ? -1 : 1, 1, 0, c_white, 1);
}
while (PartyMemDataCount > 15 * COALITION_OVERWORD_PARTY_MAX_MEMBERS)
	ds_list_delete(__PartyMemberData, 0);
if (__COALITION_SHOWCASE && shader_current() != -1) shader_reset();
CoalitionShowHitbox(c_purple);

if (Encounter.__AnimationActivated)
	Encounter.__State.Draw();