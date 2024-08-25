// Inherit the parent event
event_inherited();


scribble_typists_add_event("test", function() {
	global.battle_encounter = 0;
	oOWPlayer.Encounter_Begin();
});
SetInteractable(true, function() {
	OverworldDialog("* i exist for no reason except\n  for this[delay,333][test]");
});