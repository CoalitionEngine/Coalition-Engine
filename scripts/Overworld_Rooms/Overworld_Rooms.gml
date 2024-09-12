///@category Overworld
///@title Rooms
///@text This is very stupid, but this is one of the only ways to not spam rooms

///@func LoadCameraLockPositions()
///@desc Loads all the positions for the camera to lock for the sub rooms in overworld, use oOWCameraLock in your room to set up camera clamping
function LoadCameraLockPositions()
{
	aggressive_forceinline
	CameraLockPositions = {};
	var i = 0, n = instance_number(oOWCameraLock);
	repeat n
	{
		var curCamLockObj = instance_find(oOWCameraLock, i);
		if !struct_exists(CameraLockPositions, curCamLockObj.SubroomIndex)
			CameraLockPositions[$ curCamLockObj.SubroomIndex] = [curCamLockObj.x, curCamLockObj.y];
		else
		{
			//Value swapping if the latter checked instance is to the left/down of the earlier instance
			if curCamLockObj.x < CameraLockPositions[$ curCamLockObj.SubroomIndex][0]
			{
				CameraLockPositions[$ curCamLockObj.SubroomIndex][2] = CameraLockPositions[$ curCamLockObj.SubroomIndex][0];
				CameraLockPositions[$ curCamLockObj.SubroomIndex][0] = curCamLockObj.x;
			}
			else
				CameraLockPositions[$ curCamLockObj.SubroomIndex][2] = curCamLockObj.x;
			if curCamLockObj.y < CameraLockPositions[$ curCamLockObj.SubroomIndex][1]
			{
				CameraLockPositions[$ curCamLockObj.SubroomIndex][3] = CameraLockPositions[$ curCamLockObj.SubroomIndex][1];
				CameraLockPositions[$ curCamLockObj.SubroomIndex][1] = curCamLockObj.y;
			}
			else
				CameraLockPositions[$ curCamLockObj.SubroomIndex][3] = curCamLockObj.y;
		}
		++i;
	}
	//If there are no camera hint objects
	if n == 0
	{
		CameraLockPositions[$ 0] = [0, 0, room_width, room_height];
	}
}

///@func SetRoomNames()
///@desc Sets the names of the rooms (and sub-rooms)
function SetRoomNames()
{
	aggressive_forceinline
	RoomNames = ds_list_create();
	switch room
	{
		case rUTDemo:
			ds_list_add(RoomNames, "Ruins Entrance");
			ds_list_add(RoomNames, "Ruins some other place");
			break;
		default:
			ds_list_add(RoomNames, room_get_name(room));
			break;
	}
}
///@func MoveToRoom(MainRoom, SubRoom, PlayerX, PlayerY)
///@desc Moves the player from one (sub)room to another
///@param {Asset.GMRoom} Main_room The main room (use 'room' for current room)
///@param {real} Sub_room The sub room (Best to use macros if you are unsure)
///@param {real} PlayerX The player x coordinate after transitioning to the next room
///@param {real} PlayerY The player y coordinate after transitioning to the next room
function MoveToRoom(Main, Sub, PlayerX, PlayerY)
{
	aggressive_forceinline
	oOWPlayer.moveable = false;
	with oOWController
	{
		var transSpd = OverworldTransitionSpeed;
		__OverworldRoomTransitionArguments = room != Main ? [Main] : [Sub, PlayerX, PlayerY];
		__OverworldRoomTransitionMethod = room != Main ?
			function(Main)
			{
				//If the room is different, move to that room
				room_goto(Main);
			}
			:
			function(Sub, PlayerX, PlayerY)
			{
				//If the target is a sub-room, move to target position
				with oOWPlayer
				{
					x = PlayerX;
					y = PlayerY;
				}
				OverworldSubRoom = Sub;
			}
		alarm[0] = transSpd;
		alarm[1] = transSpd * 2;
	}
	//Fade to black and fades back out
	Fader_Fade_InOut(0, 1, 0, transSpd, 0, transSpd,, c_black);
}