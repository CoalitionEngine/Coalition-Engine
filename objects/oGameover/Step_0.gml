//If allowC is on then it will skip the gameover sequence by pressing C/Ctrl
if allowC && state < 3
{
	if PRESS_MENU
	{
		audio_stop_all();
		gameover_writer.page(gameover_writer.get_page_count());
		state = 3;
		time = 60;
	}
}

if state == 3
{
	if alpha > 0 alpha -= 0.01;
	if alpha <= 0
	{
		time++
		part_system_destroy(ps);
		part_type_destroy(p);
		if gameover_writer.get_page() != 0 gameover_writer.page(0);
	}
	if time >= 60
	{
		audio_destroy_stream(aud);
		game_restart();
	}
}
//Not very useful
if keyboard_check_pressed(ord("R"))
{
	audio_stop_all();
	room_goto_previous();
	audio_destroy_stream(aud);
}