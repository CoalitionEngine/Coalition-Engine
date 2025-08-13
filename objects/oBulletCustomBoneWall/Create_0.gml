event_inherited();
RenderCheck = function() {
	return __active && __time_warn == 0 && oBoard.VertexMode;
}
//Whether the bonewall is active or not, it not, it is at the warning state
__active = false;
//Internal timer of bonewall
__timer = 0;
//The type of the bonewall, 0-> White, 1-> Blue, 2-> Orange
__type = 0;
//The current state of the bonewall
__state = 0;
//The length of the bones created using the custom bonewall
__height = 25;
//The color of the warning box
WarnColors = [c_red, c_yellow];
//The alpha fill of the warning box
WarnAlphas = [0.25, 0.5];
//Whether the color will swap to c_yellow during the warning phase
WarnSwapColor = true;
//The warning duration
__time_warn = 18;
//The duration of bone movement
__time_move = 5;
//The duration of the bonewall
__time_stay = 16;
//Internal warning phase timer
__WarnTimer = 0;
//Whether there will be a sound to creating the bones
__play_sound_at_create = true;
//Whether the bonewall does not have a head or not
DrawHead = false;
//The object used for the bonewall (It can be custom, like a knife)
__object = oBulletBone;
//The easing method of the bonewall intro/outro
__animation_ease = ["", ""];
//The width of the board
__width = -1;
//The inital distance and the target distance of the bonewall with respect to the "target position"
__distances = array_create(2, 0);
alarm[0] = 1;
// x1 x2 x3 x4
// y1 y2 y3 y4
__warning_box_positions = ds_grid_create(4, 2);