///@desc Battle Instances
globalvar BattleBoardList, BattleSoulList, TargetBoard, TargetSoul, VertexBoardList;
TargetBoard = 0;
TargetSoul = 0;
BattleBoardList = [];
VertexBoardList = [];
BattleSoulList = [];
instance_create_depth(320, 320, -1, oBoard);
instance_create_depth(48, 454, -1, oSoul);
EnemyData.LoadEncounter();
if ALLOW_DEBUG
	global.debug = false;
oGlobal.MainCamera.target = noone;