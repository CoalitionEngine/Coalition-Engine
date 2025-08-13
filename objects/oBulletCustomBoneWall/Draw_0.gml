if (__active && __time_warn > 0 && !oBoard.VertexMode)
{
	Battle_Masking_Start();
	event_user(0);
	Battle_Masking_End();
}