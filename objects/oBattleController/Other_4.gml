///@desc Battle Instances
globalvar BattleBoardList, BattleSoulList, TargetBoard, TargetSoul;
TargetBoard = 0;
TargetSoul = 0;
BattleBoardList = [];
BattleSoulList = [];
instance_create_depth(320, 320, -1, oBoard);
instance_create_depth(48, 454, -1, oSoul);
Enemy_Function_Load();
if ALLOW_DEBUG
	global.debug = false;
oGlobal.MainCamera.target = noone;