// Inherit the parent event
event_inherited();


scribble_typists_add_event("test", function() {
	global.battle_encounter = 0;
	oOWPlayer.Encounter_Begin();
});
SetInteractable(true, function() {
	OverworldDialog("* i exist for no reason except\n  for this[delay,333][test]");
});

function CheckCollide() {
	for (var i = 0; i < 4; i++)
		if place_meeting(x + lengthdir_x(1, i * 90), y + lengthdir_y(1, i * 90), oOWPlayer)
			return true;
	return false;
}