event_inherited();
instance_check_create(oOWController);
Camera.Scale(2, 2);
moveable = true;
//You only need Up - Down - Left, because the Right is just an invert of Left, unless
//you have specific sprites for right side, then you should leave the 4th slot empty
dir_sprite = [sprFriskUp,  sprFriskDown, sprFriskLeft];
last_sprite = -1
last_dir = 1;
sprite_index = dir_sprite[2];
dir = DIR.DOWN;
image_speed = 0;
allow_run = true;
speed_multiplier = 1;

//Dialog_BeginOption("what you want do", ["continue", "end"],
//[function(){},  function(){game_end()}]);
//OverworldDialog("Welcome to the\n  Underg- Overworld!");
//var t = CreateTextWriter(20, 20, "[c_white][fnt_dt_sans][scale,1][spr_sans_head,0][scale,1]blabla[snd_item_heal]\nlba");
//t[0].in(0.5, 0)
//t[0].sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*")

encounter_state = 0;
encounter_time = 0;
encounter_draw = [0, 0, 0];
