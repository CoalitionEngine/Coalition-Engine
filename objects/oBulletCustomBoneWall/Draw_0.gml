if active && time_warn && !oBoard.VertexMode
{
	Battle_Masking_Start();
	event_user(0);
	Battle_Masking_End();
}