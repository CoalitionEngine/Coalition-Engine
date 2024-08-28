if CheckCollide() && CheckConfirm() && !oOWController.dialog_exists && !oOWPlayer.ForceCollideless
{
	Collided = true;
	OverworldDialog(text);
	oOWController.menu_disable = true;
}