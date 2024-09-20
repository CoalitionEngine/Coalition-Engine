event_inherited();

hit_destroy = true;
//The direction of the arrow
dir = 0;
//The target direction of the arrow
target_dir = 0;
//Direction displacement of the arrow
dir_a = 0;
//The speed of the arrow
spd = 5;
//The image index of the arrow
index = 0;
//The mode of the arrow, whether it is a yellow arrow, diagonal arrow etc
mode = 0;
//The distance between the arrow and the target
len = 1000;
//The color of the shield the arrow should hit
Color = 0;
//The rotation direction of the arrow (Yellow arrows), 1 for couterclockwise and -1 for clockwise
RotateDirection = 1;
//The easing method of the rotation
RotateEasing = "";
image_speed = 0;


//Copying Rhythm Recall let's go~
JudgeMode = "Strict";

function IsNearest() {
	for (var i = 0, num = instance_number(oGreenArr), inst = array_create(num); i < num; ++i) {
		inst[i] = instance_find(oGreenArr, i).len;
	}
	array_sort(inst, true);
	return self.len == inst[0];
}