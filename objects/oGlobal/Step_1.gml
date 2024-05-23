/// @description Global
if input_check("pause") or input_check_double("pause")
{
	if quit_timer++ >= 60 game_end();
}
else quit_timer = quit_timer > 0 ? quit_timer - 2 : 0;

global.timer++;

if keyboard_check_pressed(vk_f2)
{
	audio_stop_all();
	game_restart();
}
if keyboard_check_pressed(vk_f4)
{
	window_set_fullscreen(!window_get_fullscreen());
	alarm[0] = 1;
}
//Debug functions
if ALLOW_DEBUG
{
	global.debug ^= keyboard_check_released(vk_f3);
	global.show_hitbox ^= keyboard_check_released(vk_f9);
	if keyboard_check_pressed(vk_f7)
		room_goto(rDebug);
	if keyboard_check(vk_alt)
		if keyboard_check_pressed(ord("S"))
			Screenshot(room_get_name(room));
	if keyboard_check_pressed(vk_f5) room_restart();
}

if RGBShake > 0 RGBShake -= RGBDecrease;
else if !surface_exists(RGBSurf) RGBSurf = surface_create(640, 480);