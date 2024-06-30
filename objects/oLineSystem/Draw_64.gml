var i = 0, Lines = LineSys.__Lines;
gpu_push_state();
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
repeat ds_list_size(Lines)
{
	var curLine = Lines[| i];
	with curLine
	{
		if gui
		{
			gpu_set_depth(depth);
			if ds_list_size(DragLines) > 0
			{
				var ii = 0;
				repeat ds_list_size(DragLines)
				{
					DragLines[| ii].Draw();
					++ii;
				}
			}
			Draw();
		}
	}
	++i;
}
gpu_pop_state();