image_alpha = 1;
depth = oBoard.depth - 1;
surface = surface_create(640, 480);

up = 40;
down = 40;
left = 40;
right = 40;

__frame_x = array_create(4, 0);
__frame_y = array_create(4, 0);

__bg_x = 0;
__bg_y = 0;
__bg_w = 0;
__bg_h = 0;

thickness_frame = 5;

point_x = 0;
point_y = 0;

contains_soul = false;

rotate = 0;

InitX = xstart;
InitY = ystart;