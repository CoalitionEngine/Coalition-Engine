if (VertexMode)
	exit;
//Rotation
image_angle += rotate;
//Get diagonal distance
__diagonal = point_distance(0, 0, right + left, up + down) / 2;
__true_x = x + lengthdir_x((right - left) / 2, image_angle);
__true_y = y + lengthdir_x((down - up) / 2, image_angle);