event_inherited();
active = false;

timer = 0;
type = 0;
state = 0;
height = 25;
warn_color = c_red;
warn_alpha_filled = 0.25;
warn_color_swap = true;
time_warn = 18;
time_move = 5;
time_stay = 16;
WarnTimer = 0;
sound_warn = true;
sound_create = true;
cone = 1;
object = sprBone;
ease = "";
width = -1;
distance = array_create(2, 0);
alarm[0] = 1;
// x1 x2 x3 x4
// y1 y2 y3 y4
WarningBoxPos = ds_grid_create(4, 2);