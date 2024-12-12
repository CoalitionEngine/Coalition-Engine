SetInteractable(false, function() {
	instance_destroy(self);
	CutsceneStart();
	CutsceneEvent(60, function() {
		OverworldDialog("[skippable,false]This is a cutscene[fdelay,30][end]",, snd_txtTyper);
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
		Camera.RotateTo(, 360, 90);
		OverworldDialog("[skippable,false]Speeeeeeeeeeeen[fdelay,50][end]",, snd_txtTyper);
	});
	CutsceneEvent(320, function() {
		OverworldDialog("[skippable,false]End of cutscene demo[fdelay,20][end]",, snd_txtTyper);
	});
	CutsceneEvent(380, CutsceneEnd);
});