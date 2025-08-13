event_inherited();
//The length of the bone, minimal value is 14
Length = 20;
image_angle = 90;
//The speed has to be set to 0 to prevent it becoming a different bone
image_speed = 0;
//Whether the bone will be destroyed when outside the screen
AutoDestroy = false;
//The rotation speed of the bone
RotateSpeed = 0;
//The duration of the bone
Duration = -1;
__DurationTimer = 0;
//The mode of the bone, each representing whether it will be locked to a direction of the board
__stick_direction = 0;
//The color type of the bone 0-> White, 1-> Blue, 2-> Orange
__type = 0;
//The main color of the bone
__default_color = c_white;
len_load();
axis_load();
//Whether the bone will animate it's length to 0 (Actually 14) when the turn ends before destroying itself
RetractOnTurnEnd = false;
//Whether to set the image_angle as the direction automatically
AngleAsDirection = false;
//Checks whether the current state is at the end of the turn
__at_turn_end = false;
//The outline of the bone
OutlineEnabled = false;
OutlineColor = c_white;

if (__COALITION_VISUAL_MODE)
{
	__associate_visual_creation_script = [
		Bullet_Bone,
		Bullet_BoneLeft
	];
	__associate_visual_creation_arguments = [
		["x", "y", "length", "hspeed", "vspeed"],
		["y", "length", "vspeed"],
	];
	__associate_visual_creation_argument_types = [
		["real", "real", "real", "real", "real"],
		["real", "real", "real"],
	];
}