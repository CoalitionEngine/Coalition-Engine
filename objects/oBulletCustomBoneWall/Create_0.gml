event_inherited();
//Whether the bonewall is active or not, it not, it is at the warning state
active = false;
//Internal timer of bonewall
__timer = 0;
//The type of the bonewall, 0-> White, 1-> Blue, 2-> Orange
type = 0;
//The current state of the bonewall
state = 0;
//The length of the bones created using the custom bonewall
height = 25;
//The color of the warning box
warn_color = c_red;
//The alpha fill of the warning box
warn_alpha_filled = 0.25;
//Whether the color will swap to c_yellow during the warning phase
warn_color_swap = true;
//The warning duration
time_warn = 18;
//The duration of bone movement
time_move = 5;
//The duration of the bonewall
time_stay = 16;
//Internal warning phase timer
__WarnTimer = 0;
//Whether there will be a sound to creating the bones
sound_create = true;
//Whether the bonewall does not have a head or not
cone = false;
//The object used for the bonewall (It can be custom, like a knife)
object = oBulletBone;
//The easing method of the bonewall intro/outro
ease = "";
//The width of the board
__width = -1;
//The inital distance and the target distance of the bonewall with respect to the "target position"
distance = array_create(2, 0);
alarm[0] = 1;
// x1 x2 x3 x4
// y1 y2 y3 y4
WarningBoxPos = ds_grid_create(4, 2);