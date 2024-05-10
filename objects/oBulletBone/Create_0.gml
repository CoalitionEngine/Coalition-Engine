event_inherited();
length = 20;
image_angle = 90;
image_speed = 0;
destroyable = false;
rotate = 0;
duration = -1;
DurationTimer = 0;
mode = 0;
type = 0;
base_color = c_white;
len_load();
axis_load();
dir = 0;
timer = 0;

retract_on_end = false;
//Whether to set the image_angle as the direction automatically
angle_to_direction = false;
//Checks whether the current state is at the end of the turn
at_turn_end = false;