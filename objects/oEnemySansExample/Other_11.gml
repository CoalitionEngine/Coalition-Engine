///@desc Set attacks
SetAttack(1, function() {
	var below = oBoard.depth + 1;
	if time == 10
	{
		Soul.SetMode(SOUL_MODE.BLUE)
		with Board
		{
			SetSize(30, 30, 30, 30, 0);
			SetPos(320, 240, 0);
		}
		
		Soul.SetPos(320, 240, 0)
		//with oBoard.ConvertToVertex()
		//	InsertPolygonPoint(4, 320, 200)
		TweenFire(self, "iBack", 0, 0, 0, 60, "x>", 900);
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
	if time == 900 EndTurn();
});
SetAttack(2, function() {
	Board.SetSize(8, 8, 8, 8, 0);
	if time == 120 EndTurn();
});
SetAttack(0, function() {
	if (time == 0)
	{
		with CreateNormalLine(320, -20, 0,, 3)
		{
			duration = 50
			vspeed = 2;
		}
		Board.SetSize(42, 42, 42, 42, 0);
		Board.SetPos(320, 240, 0);
		Shield.Add(c_blue, c_white, [ord("D"), ord("W"), ord("A"), ord("S")]);
		Soul.SetMode(SOUL_MODE.GREEN);
		CreateArrows(120, 30, 6, [
			"$1", "", "$2", "", "$3", "", "$0", "",
			"", "", "", "", "", "", "", "",
			"", "", "", "", "", "", "", "",
		]);
	}
	if (time == 9000)
		EndTurn();
});
PreAttackFunction(3, function() {
	Board.SetSize(, 160, 320, 320, 0);
	with oBattleController
	{
		Button.BeneathBoard = true;
		UI.BeneathBoard = true;
	}
});
SetAttack(3, function() {
	if !(time % 15)
	{
		oGlobal.__MainCamera.camAngleXShake = random_range(-5, 5);
		oGlobal.__MainCamera.camAngleYShake = random_range(-5, 5);
	}
	if (time == 300) EndTurn();
});
SetAttack(4, function() {
	
});