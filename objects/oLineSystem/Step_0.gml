var i = 0, Lines = LineSys.__Lines;
repeat (ds_list_size(Lines))
{
	with (Lines[| i])
	{
		Step();
		if (duration != -1 && --duration <= 0)
		{
			DisposeLine(self);
			continue;
		}
		if (ds_list_size(DragLines) > 0)
		{
			var ii = 0;
			repeat (ds_list_size(DragLines))
				DragLines[| ii++].Step();
		}
	}
	++i;
}