if place_meeting(x, y, oOWPlayer) && CheckConfirm() && !oOWController.dialog_exists && !oOWPlayer.ForceCollideless
{
	Collided = true;
	OverworldDialog(text);
	oOWController.menu_disable = true;
}