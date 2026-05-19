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
		//Soul.SetMode(SOUL_MODE.PURPLE);
		//Board.SetSize(70, 70, 120, 120, 0);
		//oBoard.image_angle = 20;
		//Battle.Button(0).y = 100;
		//Battle.Button(0).OverrideAlpha = true;
		//Battle.Button(0).image_alpha = 1;
		//with (instance_create_depth(320, 250, 0, oVertexBoard))
		//{
			//Mode = VERTEX_BOX_MODE.CIRCLE;
			//Radius = 50;
		//}
		oBoard.ConvertToVertex();
		oVertexBoard.SetPolygonPoint(0, 320, 100);
		oVertexBoard.InsertPolygonPoint(1, 350, 100);
		//oBattleController.Button.BeneathBoard = true;
		//oBattleController.UI.BeneathBoard = true;
		//for (var i = 0; i < 64 * 48; ++i) {
		//	Bullet_Bone((i % 64) * 10, (i div 64) * 10, 25, 0, 0,,,, point_direction((i % 64) * 10, (i div 64) * 10, 320, 320));
		//}
	}
	if (keyboard_check_pressed(ord("W")))
		Soul.Slam(DIR.UP, 40);
	if (keyboard_check_pressed(ord("A")))
		Soul.Slam(DIR.LEFT, 40);
	if (keyboard_check_pressed(ord("S")))
		Soul.Slam(DIR.DOWN, 40);
	if (keyboard_check_pressed(ord("D")))
		Soul.Slam(DIR.RIGHT, 40);
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