///@desc Set attacks
live;
SetAttack(0, function() {
	if time == 10
	{
		oBattleController.board_cover_button = true;
		oBattleController.board_cover_ui = true;
		Board.SetSize(40, 140, 140, 140, 0);
		//CreateBlaster(320, 0, 320, 320, 0, 0, 2, 2, 30, 30, 30);
		//Bullet_BoneWall(0, 70, 50, 50);
		//Bullet_CustomBoneWall(30, 150, [400, 200], 50, 50);
		//SoulSetMode(SOUL_MODE.GREEN);
		//Board_SetGreenBox();
		Slam(270);
		MakePlatform(320, 360, 0, 0, 30, );
		//Battle_BoneCube(320, 320, 0, 0, 0, 3, 2, -1, 20, 20, 20, 40);
		//with oBoard.ConvertToVertex() InsertPolygonPoint(4, random_range(290, 330), random_range(280, 290));
	}
	//{
	//	with oBoard.ConvertToVertex() InsertPolygonPoint(4, random_range(200, 400), random_range(100, 370));
	//	Bullet_Bone(320, 320, 1000, 0, 0, 1, 0,,, 3);
	//	Bullet_Bone(320, 320, 1000, 0, 0, 1, 1,, 0, 3);
	//}
	//if time > 10
	//	oVertexBoard.SetPolygonPoint(8, random_range(200, 400), random_range(100, 370));
	if time == 900 end_turn();
});
SetAttack(1, function() {
	Board.SetSize(8, 8, 8, 8, 0);
	if time == 120 end_turn();
});