///@desc Set attacks
live;
SetAttack(0, function() {
	var below = oBoard.depth + 1;
	if time > 10 AudioStickToTime(bgm, (time - 10) / 60);
	if time == 10
	{
		Soul_SetMode(SOUL_MODE.BLUE)
		with Board
		{
			SetSize(30, 30, 30, 30, 0);
			SetPos(320, 240, 0);
		}
		
		Soul_SetPos(320, 240, 0)
		//with oBoard.ConvertToVertex()
		//	InsertPolygonPoint(4, 320, 200)
		TweenFire(self, "iBack", 0, 0, 0, 60, "x>", 900);
		BGM = audio_create_stream("Music/Break Over.ogg");
		bgm = audio_play(BGM);
	}
	else if time == 80
	{
		with CreateNormalLine(100, 140, 90,,,, below)
		{
			duration = 140;
			TweenFire(self, "oQuad", 0, 0, 0, 90, "x>", 540, "y>", 340, "image_angle>", -135);
			TweenFire(self, "iQuad", 0, 0, 90, 45, "x>", -40, "y>", -240);
			for (var i = 0; i < 5; ++i)
				AddDragLine(i * 2 + 1, 0.5);
		}
	}
	else if time == 240
	{
		with CreateNormalLine(540, 140, -90,,,, below)
		{
			duration = 140;
			TweenFire(self, "oQuad", 0, 0, 0, 90, "x>", 100, "y>", 340, "image_angle>", 135);
			TweenFire(self, "iQuad", 0, 0, 90, 45, "x>", 680, "y>", -240);
			for (var i = 0; i < 5; ++i)
				AddDragLine(i * 2 + 1, 0.5);
		}
	}
	else if time == 400
	{
		with CreateNormalLine(100, 140, 90,,,, below)
		{
			duration = 140;
			mirror.horizontal = true;
			TweenFire(self, "oQuad", 0, 0, 0, 90, "x>", 540, "y>", 340, "image_angle>", -135);
			TweenFire(self, "iQuad", 0, 0, 90, 45, "x>", -40, "y>", -240);
			for (var i = 0; i < 5; ++i)
				AddDragLine(i * 2 + 1, 0.5);
		}
	}
	else if time == 560
	{
		with CreateNormalLine(540, 140, -90,,,, below)
		{
			duration = 140;
			mirror.oblique = true;
			TweenFire(self, "oQuad", 0, 0, 0, 90, "x>", 100, "y>", 340, "image_angle>", 135);
			TweenFire(self, "iQuad", 0, 0, 90, 45, "x>", 680, "y>", -240);
			for (var i = 0; i < 5; ++i)
				AddDragLine(i * 2 + 1, 0.5);
		}
	}
	//if time == 900 end_turn();
});
SetAttack(1, function() {
	Board.SetSize(8, 8, 8, 8, 0);
	if time == 120 end_turn();
});