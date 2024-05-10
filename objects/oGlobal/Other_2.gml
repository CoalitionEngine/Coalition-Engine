/// @description Initialization

Initialize();

window_set_caption("Coalition Engine");
window_set_caption("Undertale");

window_center();

game_set_speed(60, gamespeed_fps);

//room_goto(rIntro);
//room_goto(room_battle);
//room_goto(room_overworld);
//room_goto(rUTDemo);
room_goto(rDebug);