event_inherited();
//Whether the bonewall is active or not, it not, it is at the warning state
active = false;
//Internal timer of bonewall
__timer = 0;
//Target position of the bonewall
target_x = 0;
target_y = 0;
//The type of the bonewall, 0-> White, 1-> Blue, 2-> Orange
type = 0;
//The current state of the bonewall
state = 0;
//The direction of the bonewall
dir = 0;
//The height of the bonewall
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
//The sprite of the bonewall
object = sprBone;

//Initalizes the bonewall
alarm[0] = 1;