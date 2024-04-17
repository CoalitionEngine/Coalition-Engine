#macro ES_LINE_SYSTEM_VERSION "Beta v0.1"

function LineSystemInitalize()
{
	Texture = ds_list_create();
	StartPos = ds_list_create();
	EndPos = ds_list_create();
	Width = ds_list_create();
	Color = ds_list_create();
	Alpha = ds_list_create();
	Depth = ds_list_create();
	VertexList = ds_list_create();
}
/*
	 Creates a line with the given position as the center
	 @param {real} x
	 @param {real} y
	 @param {real} angle
	 @param {real} length
	 @param {real} width
	 @param {Constant.Color} color
	 @param {real} depth
	 @param {Asset.GMSprite} texture
*/
function CreateLinePos(x, y, angle, length, width = 5, color = c_white, alpha = 1, depth = 0, texture = sprPixel)
{
	if !instance_exists(oLineSystem) instance_create_depth(0, 0, 0, oLineSystem);
	print(1);
	with oLineSystem
	{
		var Center = new Vector2(x, y), Dist = new Vector2(length / 2, angle);
		ds_list_add(StartPos, Center.Add(Dist));
		ds_list_add(EndPos, Center.Subtract(Dist));
		ds_list_add(Width, width);
		ds_list_add(Color, color);
		ds_list_add(Alpha, alpha);
		ds_list_add(Depth, depth);
		ds_list_add(Texture, texture);
	}
}
