// Inherit the parent event
event_inherited();


scribble_typists_add_event("test", function() {
	global.EncounterID = 0;
	Encounter.Begin();
});
SetInteractable(true, function() {
	Overworld_CreateDialog("* i exist for no reason except\n  for this[delay,333][test]");
});

function CheckCollide() {
	for (var i = 0; i < 4; i++)
		if place_meeting(x + cos(i * 90), y - sin(i * 90), oOWPlayer)
			return true;
	return false;
}