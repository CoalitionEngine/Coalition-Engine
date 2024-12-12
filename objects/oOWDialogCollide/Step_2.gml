//Check for collision and confirm input
if CheckCollide() && CheckConfirm() && !oOWController.dialog_exists && !oOWPlayer.__ForceCollideless
{
	Collided = true;
	OverworldDialog(text);
	oOWController.menu_disable = true;
}