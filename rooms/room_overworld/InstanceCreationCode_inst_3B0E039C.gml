SetInteractable(false, function() {
	instance_destroy(self);
	CutsceneStart();
	CutsceneEvent(60, function() {
		Overworld_CreateDialog("[skippable,false]This is a cutscene[fdelay,30][end]",, snd_txtTyper);
	});
	CutsceneEvent(120, function() {
		CutsceneMoveChar(oOWPlayer, 225, 2);
	}, 10);
	CutsceneEvent(150, function() {
		CutsceneMoveChar(oOWPlayer, 0, 2);
	}, 15);
	CutsceneEvent(180, function() {
		CutsceneMoveChar(oOWPlayer, 135, 2);
	}, 30);
	CutsceneEvent(220, function() {
		Camera.RotateTo(0, 360, 90);
		Overworld_CreateDialog("[skippable,false]Speeeeeeeeeeeen[fdelay,50][end]",, snd_txtTyper);
	});
	CutsceneEvent(320, function() {
		Overworld_CreateDialog("[skippable,false]End of cutscene demo[fdelay,20][end]",, snd_txtTyper);
	});
	CutsceneEvent(400, CutsceneEnd);
});