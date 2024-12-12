/// @description Initialization
//Initalization script
Initialize();
//Set game caption
window_set_caption("Coalition Engine");
window_set_caption("Undertale");
//Apply window centering (Required as game_restart is overhauled)
window_center();
//Sets the game speed to 60 FPS
game_set_speed(60, gamespeed_fps);
//Debug use
room_goto(rDebug);