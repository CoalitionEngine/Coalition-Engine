var i = 0, Lines = LineSys.__Lines;
repeat ds_list_size(Lines)
{
	var curLine = Lines[| i];
	with curLine
	{
		Step();
		if ds_list_size(DragLines) > 0
		{
			var ii = 0;
			repeat ds_list_size(DragLines)
			{
				DragLines[| ii].Step();
				++ii;
			}
		}
		if duration > 0 duration--;
		if duration <= 0 && duration > -1 DisposeLine(self);
	}
	++i;
}