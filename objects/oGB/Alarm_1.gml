///@desc Auto index during fire
var num = sprite_get_number(gb_sprite) - 1;
gb_index = (gb_index != num ? num : num - 1);
alarm[1] = 2;
