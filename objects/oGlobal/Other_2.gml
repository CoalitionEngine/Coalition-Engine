/// @description Initialization
//Initialization script
Initialize();
//Set game caption
window_set_caption("Coalition Engine");
//Apply window centering (Required as game_restart is overhauled)
window_center();
//Sets the game speed to 60 FPS
game_set_speed(60, gamespeed_fps);
//Inital room
room_goto(room_intro);