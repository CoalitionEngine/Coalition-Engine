/// @description Global
//Quitting
if (InputCheck(INPUT_VERB.PAUSE))
{
	if (__quit_timer++ >= 60)
		game_end();
}
else
	__quit_timer = __quit_timer > 0 ? __quit_timer - 2 : 0;
//Global timer
global.timer++;
//Restart game
if (keyboard_check_pressed(vk_f2))
	game_restart();
//Fullscreen
if (keyboard_check_pressed(vk_f4))
{
	window_set_fullscreen(!window_get_fullscreen());
	alarm[0] = 1;
}
//Debug functions
if (ALLOW_DEBUG)
{
	global.__CoalitionDebug ^= keyboard_check_released(vk_f3);
	global.__CoalitionShowHitbox ^= keyboard_check_released(vk_f9);
	if (keyboard_check_pressed(vk_f7))
		room_goto(rCoalitionDebug);
	//Nested-if to ensure evaluation order
	if (keyboard_check(vk_alt))
		if (keyboard_check_pressed(ord("S")))
			CoalitionScreenshot(room_get_name(room));
	if (keyboard_check_pressed(vk_f5))
		room_restart();
}