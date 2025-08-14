var sprite = object,
	index = DrawHead ? 4 : 2,
	spacing = sprite_get_height(object) - (DrawHead ? 2 : 0),
	//Color
	color, color_outline;
switch (type)
{
	case 0: color = c_white;	break;
	case 1: color = c_aqua;		break;
	case 2: color = c_orange;	break;
}
color_outline = color;

var _edge_start = 0,
	_edge_end = 0,
	_angle = 0,
	_x = x,
	_y = y,
	_dir = dir,
	_height = height,
	_alpha = 1,
	_type = type,
	
	board = target_board,
	board_x = board.x,
	board_y = board.y,
	board_u = board_y - board.up,
	board_d = board_y + board.down,
	board_l = board_x - board.left,
	board_r = board_x + board.right;

if (_dir == DIR.UP || _dir == DIR.DOWN)
{
	_edge_start = _dir == DIR.UP ? _y - _height / 14 - 6 : _y - _height + 6;
	_edge_end = _dir != DIR.UP ? _y + _height / 14 + 6 : _y + _height - 6;
	_angle = dir == DIR.UP ? -90 : 90;
	var tar_y = (_edge_start + _edge_end) / 2, tar_scale = (_height + 12) / 14;
	for (var i = board_l - spacing; i < board_r + spacing; i += spacing)
	{
		draw_sprite_ext(sprite, index, i, tar_y, tar_scale, 1, _angle, color, _alpha);
		draw_sprite_ext(sprite, index + 1, i, tar_y, tar_scale, 1, _angle, color_outline, _alpha);
	}
	//Check collision
	if (collision_rectangle(board_l, _edge_start + 2, board_r, _edge_end - 2, BattleSoulList[TargetBoard], false, true))
	{
		var collision = true;
		if (type == 1 || type == 2)
			collision = (type == 1 ? Soul.IsMoving() : !Soul.IsMoving());
		if (collision) Soul.Hurt(__damage);
	}
	// Hitbox
	if (global.__CoalitionShowHitbox)
		draw_rectangle_color(board_l, _edge_start + 2, board_r, _edge_end - 2, c_red, c_red, c_red, c_red, false);
}
		
else if (_dir == DIR.LEFT || _dir == DIR.RIGHT)
{
	_edge_start = dir == DIR.LEFT ? _x - _height / 14 + 10 : _x - _height + 10;
	_edge_end = dir != DIR.LEFT ? _x + _height / 14 - 10 : _x + _height - 10;
	_angle = dir == DIR.LEFT ? 0 : 180;
	var tar_x = (_edge_start + _edge_end) / 2, tar_scale = (_height + 20) / 14;
	for (var i = board_u - spacing; i < board_d + spacing; i += spacing)
	{
		draw_sprite_ext(sprite, index, tar_x, i, tar_scale, 1, _angle, color, _alpha);
		draw_sprite_ext(sprite, index + 1, tar_x, i, tar_scale, 1, _angle, color_outline, _alpha);
	}
	//Collision
	if (collision_rectangle(_edge_start - 10, board_u - 10, _edge_end + 10, board_d + 10, BattleSoulList[TargetBoard], false, true))
	{
		var collision = true;
		if (type == 1  || type == 2)
			collision = (type == 1 ? Soul.IsMoving() : !Soul.IsMoving());
		if (collision) Soul.Hurt(__damage);
	}
	// Hitbox
	if (global.__CoalitionShowHitbox)
		draw_rectangle_color(_edge_start - 10, board_u - 10, _edge_end + 10, board_d + 10, c_red, c_red, c_red, c_red, false);
}