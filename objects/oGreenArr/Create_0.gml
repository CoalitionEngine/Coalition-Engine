event_inherited();

hit_destroy = 1;
dir = 0;
target_dir = 0;
dir_a = 0;
spd = 5;
index = 0;
mode = 0;
len = 1000;
flipped = 0;
Color = 0;
RotateDirection = 1;
RotateEasing = "";
image_speed = 0;


//Copying Rhythm Recall let's go~
JudgeMode = "Strict";

function IsNearest() {
	for (var i = 0, num = instance_number(oGreenArr), inst = []; i < num; ++i) {
		inst[i] = instance_find(oGreenArr, i).len;
	}
	array_sort(inst, true);
	return self.len == inst[0];
}