///@category Shop
///@title EnterShop

///@func EnterShop([immediate])
///@desc Enters the shop from the current room
///@param {bool} immediate Whether you immediately go to the shop without transition (Default false)
function EnterShop(immediate = false) {
	var delay = 0;
	if (!immediate)
	{
		Fader_Fade(0, 1, 30,, c_black);
		Fader_Fade(1, 0, 30, 30, c_black);
		delay = 30;
	}
	//Check wheteher the function is called from the overworld
	if (instance_exists(oOWPlayer))
	{	
		global.__CurrentOverworldRoom = room;
		global.__CurrentOverworldSubRoom = oOWController.__OverworldSubRoom;
		with (oOWPlayer)
		{
			global.__CurrentOverworldPosition = {x: xprevious, y: yprevious};
			global.__CurrentOverworldDirection = FacingDirection;
		}
	}
	invoke(room_goto, [room_shop], delay);
	invoke(Camera.Init, [], delay);
}