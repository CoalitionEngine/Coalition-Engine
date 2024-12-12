event_inherited();
//The length of the bone, minimal value is 14
length = 20;
image_angle = 90;
//The speed has to be set to 0 to prevent it becoming a different bone
image_speed = 0;
//Whether the bone will be destroyed when outside the screen
destroyable = false;
//The rotation speed of the bone
rotate = 0;
//The duration of the bone
duration = -1;
__DurationTimer = 0;
//The mode of the bone, each representing whether it will be locked to a direction of the board
mode = 0;
//The color type of the bone 0-> White, 1-> Blue, 2-> Orange
type = 0;
//The main color of the bone
base_color = c_white;
len_load();
axis_load();
//Whether the bone will animate it's length to 0 (Actually 14) when the turn ends before destroying itself
retract_on_end = false;
//Whether to set the image_angle as the direction automatically
angle_to_direction = false;
//Checks whether the current state is at the end of the turn
at_turn_end = false;
//The outline of the bone
outline_enabled = false;
outline_color = c_white;