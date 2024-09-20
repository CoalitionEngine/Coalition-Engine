clear_timesources;
//Reset camera
Camera.Init();
depth = 50;
//Set position
x = global.__gameover_soul_x;
y = global.__gameover_soul_y;
//Soft reset palyer stats
global.player_attack_boost = 0;
global.player_def_boost = 0;
image_speed = 0;
image_blend = c_red;
//Ensure all instances are destroyed
instance_destroy(oBulletParents);
instance_destroy(oPlatform);
Fader_Fade(,0, 0);
draw_set_font(fnt_8bitwonder);
draw_set_align(fa_center, fa_middle);

window_set_caption("Game Over");

time = 0;
state = 0;
alpha = 0;
//Whether pressing C will allow the player to exit the gameover screen early
allowC = true;
aud = audio_create_stream("Music/Gameover.ogg");
//Set particles
ps = part_system_create();
part_system_depth(ps, 0);

p = part_type_create();
part_type_sprite(p, sprSoulSlice, true, true, true);
part_type_direction(p, 0, 360, 0, 0);
part_type_speed(p, 1, 3, 0, 0);
part_type_gravity(p, 0.12, 270);
//Delay soul break
alarm[0] = 40;
//Set gameover texts
gameover_text = string_concat("[pause]You cannot give\nup just yet...[pause][/page]", COALITION_DATA.name, "![delay,500]\nStay determined...");
gameover_text_voice = snd_txtAsgore;
gameover_writer = scribble(gameover_text, "__Coalition_Gameover").page(0);

gameover_typist = scribble_typist().in(0.25, 0).sound_per_char(gameover_text_voice, 1, 1," ^!.?,:/\\|*")

function __ExitGameover()
{
	//Placeholder function for game over
	game_restart();
}