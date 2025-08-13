//Rotation
image_angle += RotateSpeed;
//Board surface check
if (!surface_exists(__surface)) __surface = surface_create(640, 480);

// Frames
var _frame_x = __frame_x,
	_frame_y = __frame_y;
// Top
point_xy(x - left - FrameThickness, y - up - FrameThickness);
_frame_x[0] = point_x;
_frame_y[0] = point_y;

// Left
_frame_x[2] = point_x;
_frame_y[2] = point_y;

// Bottom
point_xy(x - left - FrameThickness, y + down);
_frame_x[1] = point_x;
_frame_y[1] = point_y;

// Right
point_xy(x + right, y - up - FrameThickness);
_frame_x[3] = point_x;
_frame_y[3] = point_y;

__frame_x = _frame_x;
__frame_y = _frame_y;

//Apply frame thickness to collision checking
left += FrameThickness
right += FrameThickness;
up += FrameThickness;
down += FrameThickness;
image_xscale = (right + left) / 2 + 4;
image_yscale = (up + down) / 2 + 4;
//Check for soul collision, there has to be a better way
var //Store the coordinates of the edges
	edges_list = [
		x + lengthdir_x(-left - 8, image_angle) + lengthdir_y(-up - 8, -image_angle),
		y + lengthdir_x(-up - 8, image_angle) - lengthdir_y(-left - 8, -image_angle),
		
		x + lengthdir_x(right + 8, image_angle) + lengthdir_y(-up - 8, -image_angle),
		y + lengthdir_x(-up - 8, image_angle) - lengthdir_y(right + 8, -image_angle),
		
		x + lengthdir_x(right + 8, image_angle) + lengthdir_y(down + 8, -image_angle),
		y + lengthdir_x(down + 8, image_angle) - lengthdir_y(right + 8, -image_angle),
		
		x + lengthdir_x(-left - 8, image_angle) + lengthdir_y(down + 8, -image_angle),
		y + lengthdir_x(down + 8, image_angle) - lengthdir_y(-left - 8, -image_angle)
	];
//Set max iteration count to prevent potential edge cases where the soul gets stuck infinitely
var max_iterations = 10;
//I hate this code
var check_x = lengthdir_x((right - left) / 2, image_angle),
	check_y = lengthdir_x((down - up) / 2, image_angle);
while (instance_place(x + check_x, y + check_y, oSoul) != noone)
{
	with instance_place(x + check_x, y + check_y, oSoul)
	{
		//Gets the nearest edge of the board from the soul
		var points = array_create(4, array_create(2)), dists = array_create(4), i = 0;
		repeat (4)
		{
			points[i] = nearestPointOnEdge(x, y, edges_list[i * 2], edges_list[i * 2 + 1], edges_list[(i * 2 + 2) % 8], edges_list[(i * 2 + 3) % 8]);
			dists[i] = point_distance(x, y, points[i].x, points[i].y);
			++i;
		}
		var nearest_dist = array_min(dists),
			nearest_index = array_get_index(dists, nearest_dist),
			nearestPt = points[nearest_index], x_prev = x, y_prev = y;
			
		var board = COALITION_CURRENT_BOARD, board_x = board.x, board_y = board.y,
			board_angle = board.image_angle,
			TL = new Vector2(-board.left, -board.up).Rotated(board_angle),
			TR = new Vector2(board.right, -board.up).Rotated(board_angle),
			BL = new Vector2(-board.left, board.down).Rotated(board_angle),
			BR = new Vector2(board.right, board.down).Rotated(board_angle),
			board_vertices =
			[
				board_x + TL.x, board_y + TL.y,
				board_x + TR.x, board_y + TR.y,
				board_x + BR.x, board_y + BR.y,
				board_x + BL.x, board_y + BL.y,
			], k = 0;
		while (!point_in_parallelogram(nearestPt.x, nearestPt.y, board_vertices) && array_length(dists) > 1 && ++k < 4)
		{
			array_delete(dists, nearest_index, 1);
			nearest_dist = array_min(dists);
			nearest_index = array_get_index(dists, nearest_dist);
			nearestPt = points[nearest_index];
		}
		//Applies nearest position
		x = nearestPt.x;
		y = nearestPt.y;
		//Check for corner cases, they need to be moved a little more to prevent being stuck at the corner
		var target_dir = point_direction(x_prev, y_prev, x, y);
		if (target_dir % 45 > 40)
		{
			x += global.__CoalitionPlayerSpeed * dcos(target_dir);
			y += global.__CoalitionPlayerSpeed * -dsin(target_dir);
		}
	}
	if (--max_iterations < 0)
		break;
}
left -= FrameThickness;
right -= FrameThickness;
up -= FrameThickness;
down -= FrameThickness;


// Background/Surface
point_xy(x - left, y - up);
__bg_x = point_x;
__bg_y = point_y;
__bg_w = left + right;
__bg_h = up + down;

surface_set_target(__surface);
draw_clear_alpha(c_white, 0);
draw_clear_alpha(c_black, 0);
//There has to be a way to handle this better
var displace_x = abs(lengthdir_x(FrameThickness, image_angle) + lengthdir_y(FrameThickness, -image_angle)),
	displace_y = lengthdir_x(FrameThickness, image_angle) - lengthdir_y(FrameThickness, -image_angle - 90);
draw_sprite_ext(sprPixel, 0, __bg_x + displace_x, __bg_y + displace_y, __bg_w + 5, __bg_h + 5, image_angle, c_black, image_alpha);
//Draws the board
for (var i = 0; i < 4; ++i)
	draw_sprite_ext(sprPixel, 0, _frame_x[i] + displace_x, _frame_y[i] + displace_y, i < 2 ? left + right + FrameThickness * 2 : FrameThickness, i >= 2 ? up + down + FrameThickness * 2 : FrameThickness, image_angle, image_blend, image_alpha);
surface_reset_target();