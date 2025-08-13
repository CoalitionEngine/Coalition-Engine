///@category Overworld
///@title Rooms
///@text This is very stupid, but this is one of the only ways to not spam rooms

///@func SetRoomNames()
///@desc Sets the names of the rooms (and sub-rooms)
function SetRoomNames()
{
	aggressive_forceinline
	RoomNames = ds_list_create();
	if (__COALITION_SHOWCASE)
		switch (room)
		{
			case rUTDemo:
				ds_list_add(RoomNames, "Ruins Entrance");
				ds_list_add(RoomNames, "Ruins some other place");
				break;
		}
	switch (room)
	{
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
///@param {real} PlayerDirection The direction the player should be facing after room transition
function MoveToRoom(Main, Sub, PlayerX, PlayerY, PlayerDirection = oOWPlayer.FacingDirection)
{
	aggressive_forceinline
	oOWPlayer.Movable = false;
	with (oOWController)
	{
		__menu_disabled = true;
		var transSpd = OverworldTransitionSpeed;
		__OverworldRoomTransitionArguments = room != Main ? [Main] : [Sub, PlayerX, PlayerY, PlayerDirection];
		__OverworldRoomTransitionMethod = room != Main ?
			function(Main)
			{
				//If the room is different, move to that room
				room_goto(Main);
			}
			:
			function(Sub, PlayerX, PlayerY, PlayerDirection)
			{
				//If the target is a sub-room, move to target position
				with (oOWPlayer)
				{
					x = PlayerX;
					y = PlayerY;
					FacingDirection = PlayerDirection;
					sprite_index = __GetDirectionalSprite(FacingDirection);
					image_xscale = __SpriteShouldFlip() ? -1 : 1;
					__last_sprite = sprite_index;
				}
				__OverworldSubRoom = Sub;
			}
		alarm[0] = transSpd;
		alarm[1] = transSpd * 2;
	}
	//Fade to black and fades back out
	Fader_Fade(0, 1, transSpd,, c_black);
	Fader_Fade(1, 0, transSpd, transSpd, c_black);
}

///@func __LoadCameraLockPositions()
///@desc Loads all the positions for the camera to lock for the sub rooms in overworld, use oOWCameraLock in your room to set up camera clamping
function __LoadCameraLockPositions()
{
	aggressive_forceinline
	__CameraLockPositions = {};
	//If there are no camera hint objects
	if (!instance_exists(oOWCameraLock))
		__CameraLockPositions[$ 0] = [0, 0, room_width, room_height];
	else
	{
		var i = 0;
		repeat (instance_number(oOWCameraLock))
		{
			var curCamLockObj = instance_find(oOWCameraLock, i);
			if (!struct_exists(__CameraLockPositions, curCamLockObj.SubroomIndex))
				__CameraLockPositions[$ curCamLockObj.SubroomIndex] = [curCamLockObj.x, curCamLockObj.y];
			else
			{
				//Value swapping if the latter checked instance is to the left/down of the earlier instance
				if (curCamLockObj.x < __CameraLockPositions[$ curCamLockObj.SubroomIndex][0])
				{
					__CameraLockPositions[$ curCamLockObj.SubroomIndex][2] = __CameraLockPositions[$ curCamLockObj.SubroomIndex][0];
					__CameraLockPositions[$ curCamLockObj.SubroomIndex][0] = curCamLockObj.x;
				}
				else
					__CameraLockPositions[$ curCamLockObj.SubroomIndex][2] = curCamLockObj.x;
				if (curCamLockObj.y < __CameraLockPositions[$ curCamLockObj.SubroomIndex][1])
				{
					__CameraLockPositions[$ curCamLockObj.SubroomIndex][3] = __CameraLockPositions[$ curCamLockObj.SubroomIndex][1];
					__CameraLockPositions[$ curCamLockObj.SubroomIndex][1] = curCamLockObj.y;
				}
				else
					__CameraLockPositions[$ curCamLockObj.SubroomIndex][3] = curCamLockObj.y;
			}
			++i;
		}
	}
}