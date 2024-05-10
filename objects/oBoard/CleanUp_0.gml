//Frees stored surface
if surface_exists(surface) surface_free(surface);
//Removes itself form the global board array
var i = 0;
repeat array_length(BattleBoardList)
{
	if BattleBoardList[i] == id
	{
		array_delete(BattleBoardList, i, 1);
		exit;
	}
	++i;
}