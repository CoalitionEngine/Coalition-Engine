//This is very stupid, but this is one of the only ways to not spam rooms
///@desc Loads all the positions for the camera to lock for the sub rooms in overworld
function LoadCameraLockPositions()
{
	aggressive_forceinline
	/*
		You have to manually add every position for now
		because i cant think of a way for using a single instance
		as a camera scroll lock
		
		Switch case is used to prevent unneeded data to be loaded in
		
		Each entry of the array corresponds to the respective id
		in the OverworldSubRoom
	*/
	CameraLockPositions = ds_list_create();
	switch room
	{
		case rUTDemo:
			ds_list_add(CameraLockPositions, [1200, 1042, 1520, 1505]);
			ds_list_add(CameraLockPositions, [1200, 802, 1520, 1041]);
			break;
		default:
			ds_list_add(CameraLockPositions, [0, 0, room_width, room_height]);
			break;
	}
}

///Sets the names of the rooms (and sub-rooms)
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
/**
	Moves the player from one (sub)room to another
	@param {Asset.GMRoom} Main_room	The main room (use 'room' for current)
	@param {real} Sub_room			The sub room (Best to use macros)
	@param {real} PlayerX			The target player x position
	@param {real} PlayerY			The target player y position
*/
function MoveToRoom(Main, Sub, PlayerX, PlayerY)
{
	aggressive_forceinline
	oOWPlayer.moveable = false;
	with oOWController
	{
		var transSpd = OverworldTransitionSpeed;
		OverworldRoomTransitionArguments = room != Main ? [Main] : [Sub, PlayerX, PlayerY];
		OverworldRoomTransitionMethod = room != Main ?
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