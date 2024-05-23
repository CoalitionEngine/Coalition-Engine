var sprite = object,
	index = 2,
	spacing = sprite_get_height(object),
	head = cone;

if head == 2
{
	index = 4;
	spacing -= 2;
}
//Color
var color, color_outline;
switch type
{
	case 0: color = c_white;	break;
	case 1: color = c_aqua;		break;
	case 2: color = c_orange;	break;
}
color_outline = color;

var pos = [0, 0],
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

if _dir == DIR.UP || _dir == DIR.DOWN
{
	pos[0] = _dir == DIR.UP ? _y - _height / 14 - 6 : _y - _height + 6;
	pos[1] = _dir != DIR.UP ? _y + _height / 14 + 6 : _y + _height - 6;
	_angle = dir == DIR.UP ? -90 : 90;
	var tar_y = (pos[0] + pos[1]) / 2, tar_scale = (_height + 12) / 14;
	for (var i = board_l - spacing; i < board_r + spacing; i += spacing)
	{
		draw_sprite_ext(sprite, index, i, tar_y, tar_scale, 1, _angle, color, _alpha);
		draw_sprite_ext(sprite, index + 1, i, tar_y, tar_scale, 1, _angle, color_outline, _alpha);
	}
	//Check collision
	if collision_rectangle(board_l, pos[0] + 2, board_r, pos[1] - 2, BattleSoulList[TargetBoard], false, true)
	{
		var collision = true;
		if type != 0 and type != 3
		{
			collision = Soul_IsMoving();
			collision = (type == 1 ? collision : !collision);
		}
		if collision Soul_Hurt(damage);
	}
	// Hitbox
	if global.show_hitbox
	{
		draw_set_color(c_red)
		draw_rectangle(board_l, pos[0] + 2, board_r, pos[1] - 2, false)
	}
}
		
else if _dir == DIR.LEFT || _dir == DIR.RIGHT
{
	pos[0] = dir == DIR.LEFT ? _x - _height / 14 + 10 : _x - _height + 10;
	pos[1] = dir != DIR.LEFT ? _x + _height / 14 - 10 : _x + _height - 10;
	_angle = dir == DIR.LEFT ? 0 : 180;
	var tar_x = (pos[0] + pos[1]) / 2, tar_scale = (_height + 20) / 14;
	for (var i = board_u - spacing; i < board_d + spacing; i += spacing)
	{
		draw_sprite_ext(sprite, index, tar_x, i, tar_scale, 1, _angle, color, _alpha);
		draw_sprite_ext(sprite, index + 1, tar_x, i, tar_scale, 1, _angle, color_outline, _alpha);
	}
	//Collision
	if collision_rectangle(pos[0] - 10, board_u - 10, pos[1] + 10, board_d + 10, oSoul, false, true)
	{
		var collision = true;
		if type != 0 and type != 3
		{
			collision = Soul_IsMoving();
			collision = (type == 1 ? collision : !collision);
		}
		if collision Soul_Hurt(damage);
	}
	// Hitbox
	if global.show_hitbox
	{
		draw_set_color(c_red);
		draw_rectangle(pos[0] - 10, board_u - 10, pos[1] + 10, board_d + 10, false);
	}
}