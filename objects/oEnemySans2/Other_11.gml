event_inherited();
//Intro
TurnCreate(0, 0, 0, function() {
	bgm = audio_play_sound(BGM, 1, 0);
	t = 0;
	with oGlobal
	{
		Song.Activate = true;
		Song.Name = "\nReality Check Through The Skull";
	}
});
TurnCreate(0, 1, 60, function() {
	with oBattleController {
		ui_override_alpha[0] += 1 / 60;
		ui_override_alpha[1] += 1 / 60;
	}
}, 60, 2);
TurnCreate(0, 2, 340, function() {
	with oBattleController {
		ui_override_alpha[2] += 1 / 60;
		ui_override_alpha[3] += 1 / 60;
		ui_override_alpha[4] += 1 / 60;
	}
}, 60, 2);
TurnCreate(0, 3, 640, function() {
	oBattleController.ui_override_alpha[5] += 1 / 60;
}, 60, 2);
TurnCreate(0, 4, 990, function() {
	oBattleController.Button.OverrideAlpha[1] += 1 / 120;
}, 60, 2);
TurnCreate(0, 5, 1200, function() {
	oBattleController.Button.OverrideAlpha[2] += 1 / 120;
}, 60, 2);
TurnCreate(0, 6, 1460, function() {
	oBattleController.Button.OverrideAlpha[3] += 1 / 120;
}, 60, 2);
TurnCreate(0, 7, 1650, function() {
	oBattleController.Button.OverrideAlpha[0] += 1 / 120;
}, 60, 2);
TurnCreate(0, 8, 1890, function() {
	oBoard.image_alpha += 1 / 60;
}, 60, 2);
TurnCreate(0, 9, 2030, function() {
	enemy_sprite_index[2] = 10;
});
TurnCreate(0, 10, 2110, function() {
	enemy_sprite_index[2] = 9;
});
TurnCreate(0, 11, 2240, function() {
	enemy_sprite_index[2] = 2;
});
TurnCreate(0, 12, 2340, function() {
	enemy_sprite_index[2] = 4;
});
TurnCreate(0, 13, 2460, function() {
	enemy_sprite_index[2] = 9;
});
TurnCreate(0, 14, 2560, function() {
	enemy_sprite_index[2] = 8;
});
TurnCreate(0, 15, 2660, function() {
	enemy_sprite_index[2] = enemy_sprite_index[2] == 6 ? 7 : 6;
}, 35, 3);
TurnCreate(0, 16, 2660, function() {
	oBattleController.x = 320;
	oBattleController.y = 170;
	oGlobal.MainCamera.target = oBattleController;
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "camera_scale_x", 1, 5);
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "camera_scale_y", 1, 5);
});
TurnCreate(0, 17, 2780, function() {
	wiggle = 1;
	oSoul.image_alpha = 1;
	enemy_sprite_index[2] = 0;
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 20, "camera_scale_x", 5, 1);
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 20, "camera_scale_y", 5, 1);
});
//Attacks
TurnCreate(0, 18, 2790, function() {
	oSoul.moveable = true;
	Slam(DIR.DOWN);
	Bullet_BoneWall(DIR.DOWN, 70, 200, 50);
})
TurnCreate(0, 19, 2830, function() {
	Slam(DIR.RIGHT);
	Bullet_BoneWall(DIR.RIGHT, 20, 20, 20);
	Bullet_BoneWall(DIR.RIGHT, 80, 40, 30);
});
TurnCreate(0, 20, 2870, function() {
	Slam(DIR.UP);
	Bullet_BoneWall(DIR.UP, 20, 20, 20);
	Bullet_BoneWall(DIR.UP, 70, 80, 30);
});
TurnCreate(0, 21, 2920, function() {
	Slam(DIR.LEFT);
	Bullet_BoneWall(DIR.LEFT, 20, 20, 20);
});
TurnCreate(0, 22, 3030, function() {
	Slam(DIR.UP);
	Bullet_BoneGapV(420, 320, -3, 20);
	Bullet_BoneGapH(320, 220, 3, 20);
});
TurnCreate(0, 23, 3100, function() {
	Slam(DIR.DOWN);
	for (var i = 0; i < 30; ++i)
		Bullet_BoneGapH(320 + sin(i / 3) * (50 - i * 40 / 30),
		250 - i * 20, 3, 35 - i / 2, 0, 0, 0, 480 - (250 - i * 20) / 3)
});
TurnCreate(0, 24, 3140, function() {
	Soul_SetMode(SOUL_MODE.RED);
});
TurnCreate(0, 25, 3250, function() {
	Blaster_Circle([320, 320], [600, 200], [time - 3470, time - 3470],
					[time - 3470, time - 3290], [1, 2], [40, 10, 20]);
}, 30, 10);
TurnCreate(0, 26, 3280, function() {
	for (var i = 0; i < 4; ++i) {
		Blaster_Circle([320, 320], [600, 150], [i * 90 + 45, i * 90 + 45],
		[i * -90, i * 90 + 225], [2, 2], [60, 10, 20])
	}
});
TurnCreate(0, 27, 3330, function() {
	for (var i = 0; i < 4; ++i) {
		Blaster_Circle([320, 320], [600, 150], [i * 90, i * 90],
		[i * 90, i * 90 + 180], [2, 2], [60, 10, 20])
	}
});
TurnCreate(0, 28, 3380, function() {
	for (var i = 0; i < 4; ++i) {
		Blaster_Circle([320, 320], [600, 150], [i * 90 + 45, i * 90 + 45],
		[i * -90, i * 90 + 225], [2, 2], [60, 10, 10])
	}
});
TurnCreate(0, 29, 3430, function() {
	for (var i = 0; i < 4; ++i) {
		Blaster_Circle([320, 320], [600, 150], [i * 90, i * 90],
		[i * 90, i * 90 + 180], [2, 2], [60, 10, 10])
	}
});
TurnCreate(0, 30, 3480, function() {
	for (var i = 0; i < 4; ++i) {
		Blaster_Circle([320, 320], [600, 150], [i * 90 + 45, i * 90 + 45],
		[i * -90, i * 90 + 225], [2, 2], [60, 10, 10])
	}
});
TurnCreate(0, 31, 3530, function() {
	for (var i = 0; i < 4; ++i) {
		Blaster_Circle([320, 320], [600, 150], [i * 90, i * 90],
		[i * 90, i * 90 + 180], [2, 2], [60, 10, 10])
	}
});
TurnCreate(0, 32, 3630, function() {
	Slam(DIR.DOWN);
	Set_BoardSize(60, 70, 125, 125, 60);
	for (var i = 0; i < 25; ++i) {
		var a = Bullet_Bone(190, 250, 290, 0, 0, 0, 0, 0, i * 9, -6, 0, 30 + i * 1.5);
		a.image_alpha = 0;
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, (i - 1) * 1.5, 0, "image_alpha", 0, 1);
		a = Bullet_Bone(450, 250, 290, 0, 0, 0, 0, 0, -i * 9, 6, 0, 30 + i * 1.5);
		a.image_alpha = 0;
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, (i - 1) * 1.5, 0, "image_alpha", 0, 1);
	}
});
TurnCreate(0, 33, 3650, function() {
	var a = Bullet_BoneBottom(190, 15, 5);
	a.mode = 2;
}, 81, 5);
TurnCreate(0, 34, 3650, function() {
	platform = MakePlatform(320, 390, 0, 0, 45);
	TweenFire(platform, EaseOutBack, TWEEN_MODE_ONCE, false, 0, 55, "y", 390, 360);
});
TurnCreate(0, 35, 3710, function() {
	for (var i = 0; i < 6; ++i) {
		Bullet_BoneBottom(190 - i * 15, 90, 6);
	}
});
TurnCreate(0, 36, 3750, function() {
	TweenFire(platform, EaseInOutSine, TWEEN_MODE_ONCE, false, 0, 45, "x", 320, 370);
	for (var i = 0; i < 3; ++i) {
		TweenFire(platform, EaseInOutSine, TWEEN_MODE_BOUNCE, false, i * 90 + 45, 45, "x", 370, 270);
	}
	for (var i = 1; i < 3; ++i) {
		Bullet_BoneBottom(510, 60, -i * 1.5 - 2);
	}
	Bullet_BoneBottom(510, 60, -1.5);
});
TurnCreate(0, 37, 3920, function() {
	audio_play(snd_warning);
	Bullet_Bone(oSoul.x, min(oSoul.y - 130, 190), 25, 0, 6, 0, 0, 0, 0, 3);
	Bullet_Bone(max(oSoul.x + 130, 510), oSoul.y, 25, -6, 0, 0, 0, 0, 90, -3);
});
TurnCreate(0, 38, 3950, function() {
	audio_play(snd_ding);
	platform.sticky = false;
	platform.effect = 1;
});
TurnCreate(0, 39, 4080, function() {
	Bullet_BoneWall(DIR.UP, 105, 10, 30);
	var a = Bullet_Bone(platform.x - 60, 390, 0, 4, 0, 0, 0, 2, 90, 0, 0, 60);
	TweenFire(a, EaseOutBack, TWEEN_MODE_ONCE, false, 0, 30, "length", 0, 30);
		a = Bullet_Bone(platform.x - 15, 390, 0, 4, 0, 0, 0, 2, 90, 0, 0, 60);
	TweenFire(a, EaseOutBack, TWEEN_MODE_ONCE, false, 0, 30, "length", 0, 30);
});
TurnCreate(0, 40, 4090, function() {
	with platform {
		motion_set(30, 5);
		gravity = 0.18;
	}
	Bullet_BoneBottom(190, 25, 4, 1);
	Bullet_BoneBottom(450, 25, -4);
});
TurnCreate(0, 41, 4140, function() {
	Bullet_BoneTop(180, 100, 5);
	Bullet_BoneTop(460, 100, -5);
	var a = Bullet_BoneBottom(450, 25, -7, 1);
	a.mode = 2;
	platform = MakePlatform(320, 260 + 140 / 3 - 10, 0, 0, 0);
	TweenFire(platform, EaseOutQuad, TWEEN_MODE_ONCE, false, 40, 60, "length", 0, 140);
});
TurnCreate(0, 42, 4200, function() {
	Bullet_GasterBlaster([0, 270], [90, 0], [1.5, 2], [200, 270], [50, 10, 200]);
	Bullet_GasterBlaster([640, 370], [90, 180], [1.5, 2], [440, 370], [50, 10, 200]);
	Set_BoardSize(70, 70, 70, 70, 60);
});
TurnCreate(0, 43, 4200, function() {
	MakePlatform(470, 260 + 280 / 3 - 10, -2, 0, 50, 0, 0, 0);
}, 5, 70);
TurnCreate(0, 44, 4410, function() {
	Bullet_GasterBlaster([320, 0], [90, -90], [2, 2], [320, 220], [50, 20, 30]);
});
TurnCreate(0, 45, 4500, function() {
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 30, "x", 320, 200);
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 30, "y", y, 360);
	with oPlatform
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 30, "length", length, 0);
	oEnemyParent.Slamming = true;
	oEnemyParent.SlamDirection = DIR.RIGHT;
	TweenFire(oBoard, EaseLinear, TWEEN_MODE_ONCE, false, 0, 500, "image_angle", 0, -900);
	Set_BoardSize(60, 60, 60, 60, 30);
	Set_BoardPos(340, 310, 10);
	Soul_SetMode(SOUL_MODE.RED);
	oSoul.follow_board = 1;
});
TurnCreate(0, 46, 4510, function() {
	instance_destroy(oBulletBone);
	oSoul.follow_board = 0;
	for (var i = 1; i < 19; ++i) {
		Bullet_BoneLeft(270 - i * 70, 60, 3, 0, 0, 0, 0, (480 - (270 - i * 70)) / 3)
		Bullet_BoneRight(410 + i * 70, 60, -3, 0, 0, 0, 0, -(410 + i * 70) / 3)
		oBulletBone.axis = 1;
	}
});
TurnCreate(0, 47, 4530, function() {
	instance_destroy(oPlatform);
});
TurnCreate(0, 48, 4990, function() {
	instance_destroy(oBulletParents);
	Soul_SetMode(SOUL_MODE.RED);
	oSoul.follow_board = 1;
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 30, "x", x, 320);
	Set_BoardPos(510, 130, 20);
});
TurnCreate(0, 49, 5010, function() {
	oSoul.follow_board = 0;
});
TurnCreate(0, 50, 5030, function() {
	Set_BoardPos(100, 130, 390);
});
TurnCreate(0, 51, 5030, function() {
	Bullet_GasterBlaster([choose(0, 640), choose(0, 480)], [random(360), random(360)],
	[1, 2], [random_range(100, 540), random_range(100, 420)], [30, 30, 5]);
}, 22, 10);
TurnCreate(0, 52, 5320, function() {
	Slam(DIR.UP);
	oBoard.image_angle = 0;
	Set_BoardSize(90, 70, 50, 50, 30, EaseLinear)
});
TurnCreate(0, 53, 5350, function() {
	oBattleController.board_cover_hp_bar = true;
	oBattleController.board_cover_button = true;
	Soul_SetMode(SOUL_MODE.BLUE);
	oSoul.allow_outside = true;
	oSoul.alarm[0] = 1;
	Set_BoardSize(150, 370, 50, 50, 30);
	TweenFire(oSoul, EaseLinear, TWEEN_MODE_ONCE, false, 0, 30, "y", oSoul.y, 10);
});
TurnCreate(0, 54, 5350, function() {
	platform = MakePlatform(60, 480, 0, -2, 40, 0, -30, 1);
	TweenFire(platform, EaseInOutSine, TWEEN_MODE_PATROL, false, 0, 20, "image_angle", -30, 30);
	platform = MakePlatform(140, 0, 0, 2, 40, 0, 30, 1);
	TweenFire(platform, EaseInOutSine, TWEEN_MODE_PATROL, false, 0, 20, "image_angle", 30, -30);
}, 13, 40);
TurnCreate(0, 55, 5390, function() {
	Bullet_BoneLeft(0, 40, 3, 1);
	Bullet_BoneRight(480, 40, -3, 1);
}, 5, 90);
TurnCreate(0, 56, 5860, function() {
	platform = MakePlatform(60, 480, 0, -4, 40, 0, -30, 1);
	TweenFire(platform, EaseInOutSine, TWEEN_MODE_PATROL, false, 0, 20, "image_angle", -30, 30);
	platform = MakePlatform(140, 0, 0, 4, 40, 0, 30, 1);
	TweenFire(platform, EaseInOutSine, TWEEN_MODE_PATROL, false, 0, 20, "image_angle", 30, -30);
}, 9, 60);
TurnCreate(0, 57, 5870, function() {
	Bullet_GasterBlaster([100, 480], [-90, -90], [1, 2], [100, 0], [50, 40, 5])
}, 4, 130);
TurnCreate(0, 58, 6320, function() {
	y = ystart;
	enemy_sprite_index[2] = 4;
	Fader_Fade(1, 0, 450);
	instance_destroy(oBulletParents);
	instance_destroy(oPlatform);
	Set_BoardPos(320, 320, 0);
	Set_BoardSize(70, 70, 70, 70, 0);
	Soul_SetMode(SOUL_MODE.RED);
	audio_stop_sound(snd_ding);
	Soul_SetPos(320, 320, 0);
});
TurnCreate(0, 59, 6740, function() {
	enemy_sprite_index[2] = 9;
});
TurnCreate(0, 60, 7220, function() {
	Soul_SetMode(SOUL_MODE.BLUE);
});
TurnCreate(0, 61, 7250, function() {
	Bullet_BoneBottom(250, random_range(13, 40), 2);
	Bullet_BoneBottom(390, random_range(13, 40), -2);
}, 18, 45);
TurnCreate(0, 62, 8080, function() {
	Soul_SetMode(SOUL_MODE.RED);
	var a;
	for (var i = 0; i < 3; ++i) {
		a[i] = Bullet_Bone(250, 250, 0, 0, 0, 0, 0, 0, i * 120, -1);
		TweenFire(a[i], EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "length", 0, 240);
		a[i] = Bullet_Bone(390, 390, 0, 0, 0, 0, 0, 0, i * 120, -1);
		TweenFire(a[i], EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "length", 0, 240);
		a[i] = Bullet_Bone(390, 250, 0, 0, 0, 0, 0, 0, i * 120, -1);
		TweenFire(a[i], EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "length", 0, 60);
		a[i] = Bullet_Bone(250, 390, 0, 0, 0, 0, 0, 0, i * 120, -1);
		TweenFire(a[i], EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "length", 0, 60);
	}
});
TurnCreate(0, 63, 8980, function() {
	Set_BoardPos(75, 320, 9400 - 8980, EaseLinear);
	oBattleController.board_cover_hp_bar = false;
	oBattleController.board_cover_button = false;
	soul_in_button = 0;
	with oBulletBone
	TweenFire(id, EaseLinear, TWEEN_MODE_ONCE, false, 0, 9400 - 8980, "x", x, x - 250);
	audio_play(snd_ding);
	oBulletBone.type = 1;
});
TurnCreate(0, 64, 8980, function() {
	Blaster_Aim(random(360), [random_range(200, 440), random_range(220, 440)], [1, 2], [50, 30, 20]);
}, 7, 100);
TurnCreate(0, 65, 9400, function() {
	Set_BoardPos(75, 455, 240, EaseLinear);
	with oBulletBone
	TweenFire(id, EaseLinear, TWEEN_MODE_ONCE, false, 0, 240, "y", y, y + 90);
});
TurnCreate(0, 66, 9600, function() {
	Set_BoardSize(25, 25, 55, 55, 50);
});
TurnCreate(0, 67, 9650, function() {
	instance_create_depth(320, 160, -10, oStrike);
	var cho = choose(150, -150)
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 25, "x", x, x - cho);
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, false, 35, 25, "x", x - cho, x);
	enemy_sprite_index[2] = 5;
	oGB.state = 4;
	oGB.image_index = 4;
	with oBulletParents {
		motion_set(random(360), 2)
		gravity = 0.12;
	}
});
TurnCreate(0, 68, 9740, function() {
	oBulletParents.can_hurt = 0;
	wiggle = 0;
	enemy_sprite_index[2] = enemy_sprite_index[2] == 6 ? 7 : 6;
}, 35, 3);
TurnCreate(0, 69, 9740, function() {
	Set_BoardPos(320, 320, 40, EaseLinear);
	Set_BoardSize(50, 50, 50, 50, 40, EaseLinear);
	Soul_SetPos(320, 320, 40);
	oSoul.moveable = 0;
	oGlobal.MainCamera.target = oSoul;
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "camera_scale_x", 1, 5);
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 120, "camera_scale_y", 1, 5);
});
TurnCreate(0, 70, 9781, function() {
	TweenFire(oGlobal, EaseLinear, TWEEN_MODE_ONCE, false, 0, 80, "camera_shake_i", 0, 15);
});
TurnCreate(0, 71, 9850, function() {
	wiggle = 1;
	enemy_sprite_index[2] = 0;
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 10, "camera_scale_x", 5, 1);
	TweenFire(oGlobal, EaseOutQuad, TWEEN_MODE_ONCE, false, 0, 10, "camera_scale_y", 5, 1);
});
TurnCreate(0, 72, 9860, function() {
	Slam(DIR.RIGHT);
	oSoul.moveable = 1;
	oGlobal.MainCamera.target = noone;
	Bullet_BoneWall(DIR.RIGHT, 10, 5, 30);
});
TurnCreate(0, 73, 9870, function() {
	Slam(DIR.UP);
	Bullet_BoneWall(DIR.UP, 10, 5, 30);
});
TurnCreate(0, 74, 9880, function() {
	Slam(DIR.LEFT);
	Bullet_BoneWall(DIR.LEFT, 10, 5, 30);
});
TurnCreate(0, 75, 9900, function() {
	Slam(DIR.DOWN);
	Bullet_BoneWall(DIR.DOWN, 10, 5, 30);
});
TurnCreate(0, 76, 9920, function() {
	Soul_SetMode(SOUL_MODE.RED);
});
TurnCreate(0, 77, 9930, function() {
	audio_play(snd_bone);
	Bullet_BoneBottom(250, 50, 3);
	Bullet_BoneTop(390, 50, -3);
});
TurnCreate(0, 78, 9950, function() {
	Blaster_Aim(135, [200, 200], [1.5, 2], [40, 50, 5]);
	Blaster_Aim(45, [440, 200], [1.5, 2], [40, 50, 5]);
	audio_play(snd_bone);
	Bullet_BoneTop(250, 50, 3);
	Bullet_BoneBottom(390, 50, -3);
});
TurnCreate(0, 79, 9970, function() {
	audio_play(snd_bone);
	Bullet_BoneRight(250, 50, 3);
	Bullet_BoneLeft(390, 50, -3);
});
TurnCreate(0, 80, 9990, function() {
	Blaster_Aim(135, [200, 200], [1.5, 2], [40, 30, 5]);
	Blaster_Aim(45, [440, 200], [1.5, 2], [40, 30, 5]);
	audio_play(snd_bone);
	Bullet_BoneLeft(250, 50, 3);
	Bullet_BoneRight(390, 50, -3);
});
TurnCreate(0, 81, 10090, function() {
	audio_play(snd_bone);
	Bullet_BoneTop(390, 45, -3);
	Bullet_BoneBottom(250, 45, 3);
	Bullet_BoneRight(390, 45, -3);
});
TurnCreate(0, 82, 10110, function() {
	audio_play(snd_bone);
	Bullet_BoneTop(390, 45, -3);
	Bullet_BoneLeft(250, 45, 3);
	Bullet_BoneRight(390, 45, -3);
});
TurnCreate(0, 83, 10130, function() {
	audio_play(snd_bone);
	Bullet_BoneTop(390, 45, -3);
	Bullet_BoneBottom(250, 45, 3);
	Bullet_BoneLeft(250, 45, 3);
});
TurnCreate(0, 84, 10180, function() {
	if !(time % 20) Blaster_Aim(-90, [250, 200], [1, 2], [15, 5, 5]);
	else Blaster_Aim(0, [440, 390], [1, 2], [15, 5, 5]);
}, 5, 10);
TurnCreate(0, 85, 10200, function() {
	Bullet_GasterBlaster([0, 300], [-90, 0], [2, 2], [200, 300], [30, 50, 20]);
});
TurnCreate(0, 86, 10230, function() {
	Bullet_GasterBlaster([340, 0], [0, -90], [2, 2], [340, 200], [30, 20, 20]);
});
TurnCreate(0, 87, 10320, function() {
	Slam(DIR.DOWN, 0);
	for (var i = 0; i < 4; ++i) {
		var a = Bullet_Bone(0, 0, 0, 0, 0, 0, 0, 0, i * 90);
		with a {
			lenable = 1;
			len = 50;
			len_target = oBoard;
			len_dir = i * 90;
			len_angle = 1
			TweenFire(a, EaseOutQuart, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 60);
		}
	}
});
TurnCreate(0, 88, 10320, function() {
	Blaster_Aim(0, [random_range(200, 440), random_range(200, 440)], [1, 2], [40, 20, 5]);
}, 5, 90);
TurnCreate(0, 89, 10400, function() {
	Slam(posmod(oSoul.image_angle - 180, 360), 0);
}, 3, 120);
TurnCreate(0, 90, 10730, function() {
	audio_play(snd_noise);
	Fader_Fade(0, 1, 0);
	instance_destroy(oBulletParents);
	Soul_SetMode(SOUL_MODE.RED);
	Soul_SetPos(320, 320, 0);
	Set_BoardSize(70, 70, 70, 70, 0);
});
TurnCreate(0, 91, 10740, function() {
	Fader_Fade(1, 0, 0);
	audio_play(snd_noise);
	for (var i = 45; i <= 135; i += 90)
		Blaster_Circle([320, 320], [600, 150], [i, i], [i, i - 180], [2, 2], [60, 90, 10]);
	for (var i = 0; i < 36; ++i) {
		var a = Bullet_Bone(0, 0, 120, 0, 0, 0, 0, 0, i * 10, 0, 0, 120);
		with a {
			len_target = oBoard;
			lenable = 1;
			len = 70;
			len_dir = i * 10;
			len_angle = 1;
			len_dir_move = 2;
			TweenFire(id, EaseInSine, TWEEN_MODE_ONCE, false, 30, 40, "len", 70, 200)
		}
	}
});
TurnCreate(0, 92, 10770, function() {
	for (var i = 0; i <= 90; i += 90)
		Blaster_Circle([320, 320], [600, 150], [i, i], [i, i - 180], [2, 2], [60, 90, 10]);
});
TurnCreate(0, 93, 10800, function() {
	var a = Bullet_Bone(320, 320, 0, 0, 0, 0, 1, 0, 45, 1.5, 1, 120);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 160);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
	var a = Bullet_Bone(320, 320, 0, 0, 0, 0, 1, 0, 135, 1.5, 1, 120);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 160);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
	a = Bullet_Bone(320, 320, 0, 0, 0, 1, 1, 0, 100, -1, 1, 120);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 160);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
	TweenFire(a, EaseInOutQuad, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
});

TurnCreate(0, 94, 10960, function() {
	audio_play(snd_noise);
	Fader_Fade(0, 1, 0);
	instance_destroy(oBulletParents);
	Soul_SetMode(SOUL_MODE.RED);
	Soul_SetPos(320, 320, 0);
	Set_BoardSize(70, 70, 70, 70, 0);
});
TurnCreate(0, 95, 10970, function() {
	Fader_Fade(1, 0, 0);
	audio_play(snd_noise);
	for (var i = 45; i <= 135; i += 90)
		Blaster_Circle([320, 320], [600, 150], [i, i], [i, i - 180], [2, 2], [60, 90, 10]);
	for (var i = 0; i < 36; ++i) {
		var a = Bullet_Bone(0, 0, 120, 0, 0, 0, 0, 0, i * 10, 0, 0, 120);
		with a {
			len_target = oBoard;
			lenable = 1;
			len = 70;
			len_dir = i * 10;
			len_angle = 1;
			len_dir_move = 2;
			TweenFire(id, EaseInSine, TWEEN_MODE_ONCE, false, 30, 40, "len", 70, 200)
		}
	}
});
TurnCreate(0, 96, 11000, function() {
	for (var i = 0; i <= 90; i += 90)
		Blaster_Circle([320, 320], [600, 150], [i, i], [i, i - 180], [2, 2], [60, 90, 10]);
});
TurnCreate(0, 97, 11030, function() {
	var a = Bullet_Bone(320, 320, 0, 0, 0, 0, 1, 0, 45, 1.5, 1, 120);
	TweenFire(a, EaseOutSine, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 160);
	TweenFire(a, EaseOutSine, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
	var a = Bullet_Bone(320, 320, 0, 0, 0, 0, 1, 0, 135, 1.5, 1, 120);
	TweenFire(a, EaseOutSine, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 160);
	TweenFire(a, EaseOutSine, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
	a = Bullet_Bone(320, 320, 0, 0, 0, 1, 1, 0, 100, -1, 1, 120);
	TweenFire(a, EaseOutSine, TWEEN_MODE_ONCE, false, 0, 40, "length", 0, 160);
	TweenFire(a, EaseOutSine, TWEEN_MODE_ONCE, false, 80, 40, "length", 160, 0);
});
TurnCreate(0, 98, 11200, function() {
	Slam(DIR.DOWN);
	Bullet_BoneWall(DIR.DOWN, 40, 20, 10);
});
TurnCreate(0, 99, 11160, function() {
	Bullet_GasterBlaster([320, 0], [-90, -90], [2, 2], [320, 200], [40, 10, 10]);
});
TurnCreate(0, 100, 11210, function() {
	Bullet_GasterBlaster([260, 0], [-90, -90], [2, 2], [260, 200], [40, 10, 10]);
	Bullet_GasterBlaster([380, 0], [-90, -90], [2, 2], [380, 200], [40, 10, 10]);
});
TurnCreate(0, 101, 11230, function() {
	Bullet_GasterBlaster([0, oSoul.y], [-90, 0], [1, 2], [200, oSoul.y], [40, 10, 10]);
	Bullet_GasterBlaster([640, oSoul.y], [270, 180], [1, 2], [440, oSoul.y], [40, 10, 10]);
}, 3, 10);
TurnCreate(0, 102, 11300, function() {
	for (var i = 0; i < 30; ++i) {
		var a = Bullet_Bone(0, 0, 100, 0, 0, 0, 0, 0, i * 12);
		with a {
			len_target = oBoard;
			lenable = 1;
			len_dir = i * 12;
			len_angle = len_dir;
			len_dir_move = -3;
			len_angle = 1;
			len = 150;
			TweenFire(id, EaseInOutSine, TWEEN_MODE_BOUNCE, false, 0, 40, "len", 150, 60);
		}
	}
});
TurnCreate(0, 103, 11340, function() {
	Bullet_GasterBlaster([oSoul.x, 0], [0, -90], [1, 2], [oSoul.x, 200], [40, 10, 10]);
	Bullet_GasterBlaster([oSoul.x, 480], [0, 90], [1, 2], [oSoul.x, 440], [40, 10, 10]);
}, 3, 10);
TurnCreate(0, 104, 11400, function() {
	var pos = oSoul.x > 320;
	var tpos = [[250, 390], [390, 250]];
	var spd = 3 * sign(320 - tpos[pos, 0]);
	for (var i = 0; i < 3; ++i) {
		Bullet_BoneTop(tpos[pos, 0] - i * spd * 15, 100, spd);
		Bullet_BoneBottom(tpos[pos, 1] + i * spd * 15, 40, -spd);
	}
});
TurnCreate(0, 105, 11490, function() {
	for (var i = 0; i < 12; ++i) {
		var a = Bullet_Bone(0, 0, 140, 0, 0)
		a.lenable = 1;
		a.len_target = oBoard;
		a.len = 110;
		a.direction = random(360);
		TweenFire(a, EaseOutQuart, TWEEN_MODE_ONCE, false, 0, 50, "len_dir", 0, -i * 30);
		TweenFire(a, EaseOutQuart, TWEEN_MODE_ONCE, false, 0, 50, "image_angle", 0, -i * 30);
		TweenFire(a, EaseOutQuart, TWEEN_MODE_ONCE, false, 40, 50, "len_dir", -i * 30, -360);
		TweenFire(a, EaseOutQuart, TWEEN_MODE_ONCE, false, 40, 50, "image_angle", -i * 30, -360);
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, 80, 0, "lenable", 1, 0);
		TweenFire(a, EaseOutQuad, TWEEN_MODE_ONCE, false, 80, 40, "x", 430, 320);
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, 120, 0, "speed", 0, 3);
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, 120, 0, "gravity", 0, 0.2);
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, 120, 0, "type", 0, 1);
		TweenFire(a, EaseLinear, TWEEN_MODE_ONCE, false, 120, 0, "rotate", 0, random_range(-2, 2));
	}
});
TurnCreate(0, 106, 11570, function() {
	audio_play(snd_ding);
});
TurnCreate(0, 107, 11630, function() {
	with oBulletBone
	if !type
	instance_destroy();
	Soul_SetMode(SOUL_MODE.RED);
	Set_BoardSize(200, 70, 155, 155);
});
TurnCreate(0, 108, 11630, function() {
	enemy_sprite_index[2] = 5;
}, 35, 3);
TurnCreate(0, 109, 11650, function() {
	Blaster_Aim(random(360), [random_range(100, 540), random_range(100, 440)], [1, 2], [45, 30, 10]);
}, 30, 25);
TurnCreate(0, 110, 11650, function() {
	var a = time / 3;
	for (var i = 0; i < 360; i += 90) {
		i += a;
		Blaster_Circle([320, 255], [600, 60], [i - 180, i - 180], [i, i],
		[1, 2], [40, 20, 10]);
		i -= a;
	}
}, 13, 60);
TurnCreate(0, 111, 12500, function() {
	oBattleController.board_cover_hp_bar = true;
	oBattleController.board_cover_button = true;
	Set_BoardSize(320, 160, 320, 320);
	for (var i = 0; i < 300; ++i)
	{
		var a=Bullet_Bone(0,0,20,0,0,0,0,0,0,0,0);
		a.lenable=1;
		a.len_x=320;
		a.len_y=240;
		a.len=random_range(230,420);
		a.len_dir=random(360);
		a.image_angle=a.len_dir+90;
		a.len_angle=1;
		a.len_dir_move=random_range(1,4);
	}
});
TurnCreate(0, 112, 12530, function() {
	for (var i = 0; i < 8; ++i)
	{
		var a = Bullet_Bone(320, 240, 15, 0, 0, 0, 0, 0, 0,0,0,120)
		a.direction = sin(time / 40) * 80 + i * 45;
		a.speed = 4.5;
		a.image_angle=a.direction;
	}
}, 245, 5);
TurnCreate(0, 113, 12950, function() {
	var dir = random(360);
	for (var i = 0; i < 4; ++i)
	{
		var a = Bullet_Bone(320, 240, 40, 0, 0, 1, 0, 0, 0, 2,0,260)
		a.direction = dir + i * 90;
		a.speed = 4.5;
		a.image_angle=a.direction;
		TweenFire(a,EaseLinear,TWEEN_MODE_ONCE,false,40,50,"speed",4,-4)
		a = Bullet_Bone(320, 240, 40, 0, 0, 1, 0, 0, 0, -2,0,260)
		a.direction = dir + i * 90 + 45;
		a.speed = 4.5;
		a.image_angle=a.direction;
		TweenFire(a,EaseLinear,TWEEN_MODE_ONCE,false,40,50,"speed",4,-4)
	}
}, 14, 60);
TurnCreate(0,114,13350,function(){
	instance_create_depth(0,0,0,horrifi)
});
TurnCreate(0,115,13420,function(){
	with horrifi
	{
		horrifi_chromaticab_set(true, .87);
		horrifi_scanlines_set(true, .2);
		horrifi_vhs_set(true, .25);
		horrifi_noise_set(true, 0.5);
	}
});
TurnCreate(0,116,13470,function(){
	with horrifi
	{
		horrifi_chromaticab_set(true, .96);
		horrifi_scanlines_set(true, .4);
		horrifi_vhs_set(true, .5);
		horrifi_noise_set(true, .7);
	}
});
TurnCreate(0,117,13520,function(){
	with horrifi
	{
		horrifi_chromaticab_set(true, 1);
		horrifi_scanlines_set(true, .8);
		horrifi_vhs_set(true, .8);
		horrifi_noise_set(true, .9);
	}
});
TurnCreate(0,117,13540,function(){
	with horrifi
	{
		horrifi_chromaticab_set(true, 1.5);
		horrifi_scanlines_set(true, 1.4);
		horrifi_vhs_set(true, 1.4);
		horrifi_noise_set(true, 1.5);
	}
});
TurnCreate(0,118,13590,function(){
	with horrifi
	{
		horrifi_chromaticab_set(true, 2);
		horrifi_scanlines_set(true, 2);
		horrifi_vhs_set(true, 2);
		horrifi_noise_set(true, 2);
	}
});
TurnCreate(0,119,13620,function(){
	Fader_Fade(0,1,120);
});
TurnCreate(0,120,13740,function(){
	horrifi.horrifi_enable(false);
	instance_destroy(horrifi);
	instance_destroy(oBulletParents);
	Set_BoardSize(70,70,70,70,0);
	Soul_SetPos(320,320,0);
	oSoul.moveable=0;
});
TurnCreate(0,121,14620,function(){
	enemy_sprite_pos[0] = [0, 0, 0, 0, 0, 0, 0, 0];
	enemy_sprite_pos[1, 0] = 900;
	enemy_sprite_pos[2, 0] = 900;
	draw_papyrus = 1;
	global.hp = 48;
	global.hp_max = 48;
	Fader_Fade(1,0.4,120);
	oSoul.moveable=1;
	global.kr_activation = false;
	global.assign_inv = 60;
});
TurnCreate(0,122,14930,function(){
	instance_create_depth(320, 160, 0, oStrike)
});
TurnCreate(0,123,14960,function(){
	is_being_attacked = 1;
});
TurnCreate(0,124,15000,function(){
	Soul_SetMode(SOUL_MODE.BLUE);
});
TurnCreate(0,125,15000,function(){
	Bullet_BoneBottom(400,30,-2.2)
	Bullet_BoneBottom(460,110,-2.2,1)
},5,60);
TurnCreate(0,126,15360,function(){
	Bullet_BoneBottom(240,30,2.2)
	Bullet_BoneBottom(180,110,2.2,1)
},6,60);
TurnCreate(0 ,127, 15800, function() {
	Set_BoardSize(70,70,160,160,50,EaseOutQuad)
});
TurnCreate(0 ,128, 15860, function() {
	Bullet_BoneBottom(490,20,-1.5);
	Bullet_BoneTop(150,120,1.5);
},13,50);
TurnCreate(0 ,129, 15860, function() {
	var a = Bullet_Bone(oSoul.x, 100,140,0,0);
	TweenFire(a, EaseOutBounce, TWEEN_MODE_ONCE, false, 0, 60, "y", 100, 320);
	TweenFire(a, EaseInBack, TWEEN_MODE_ONCE, false, 80, 45, "y", 320, 540);
},7,100);
TurnCreate(0, 130, 16620, function() {
	Bullet_BoneFullV(150,6,1);
	Bullet_BoneFullV(490,-6,1);
	audio_play(snd_bone);
},8,15);
TurnCreate(0, 131, 16740, function() {
	instance_destroy(oBulletParents);
	oGlobal.fader_alpha = 1;
	audio_play(snd_noise);
});
TurnCreate(0, 132, 16760, function() {
	enemy_sprite_pos = [
		[-47, -50, 47, -50, 47, 0, -47, 0],
		[0, -40],
		[0, -75],
	];
	hspeed = -12;
	SoulSetMode(SOUL_MODE.RED);
	Set_BoardSize(50, 50, 320, 320, 0);
	Soul_SetPos(120,320,0);
	with oSoul
	{
		draw_angle += 90;
		Blend = c_blue;
		alarm[0] = 1;
		TweenEasyBlend(image_blend, c_blue, 0, 30, EaseLinear);
	}
	draw_papyrus = 0;
	global.data.lv = 18;
	global.kr = 0;
	global.hp = 88;
	global.hp_max = 88;
	audio_play(snd_item_heal);
	global.assign_inv = 60;
	global.kr_activation = true;
	Fader_Fade(1,0,30,0,c_red);
});
TurnCreate(0, 133, 16760, function() {
	enemy_sprite_index[2] = enemy_sprite_index[2] == 6 ? 7 : 6;
}, 597, 3);
TurnCreate(0, 134, 16820, function() {
	for (var i = 0; i < 330; ++i) {
		Bullet_BoneGapV(640 + i * 12, sin(i/15)*20+320, -12, 20, 0, 0, 0,(640+i*12)/12);
		if !(i%80) and i < 320 Bullet_BoneFullV(640+i*12,-14,1,0,0,0,(640+i*12)/14)
	}
	for (var i = 0; i < 89; ++i) {
		var a = Bullet_Bone(-10+i*10,i%2?260:380,0,0,0)
		TweenFire(a,EaseOutQuad,TWEEN_MODE_ONCE,false,i*5,30,"length",0,160)
		TweenFire(a,EaseOutQuad,TWEEN_MODE_ONCE,false,440,30,"length",160,100)
		TweenFire(a,EaseOutQuad,TWEEN_MODE_ONCE,false,480,30,"length",100,200)
	}
	oBulletBone.axis = 1;
})
TurnCreate(0, 135, 17280, function() {
	oGlobal.fader_color = c_black;
	Bullet_BoneWall(DIR.RIGHT,30,20,40)
	oBulletBone.type = 1;
	audio_play(snd_ding);
});
TurnCreate(0, 136, 17340, function() {
	Fader_Fade(0,1,1);
	audio_play(snd_noise);
});
TurnCreate(0, 137, 17350, function() {
	hspeed = 0;
	x = 320;
	with oSoul {
		Blend = c_red;
		TweenEasyBlend(image_blend, c_red, 0, 30, EaseLinear);
		draw_angle = 0;
	}
	instance_destroy(oBulletParents);
	Set_BoardSize(70,70,70,70,0);
	Soul_SetPos(320,320,0);
	Fader_Fade(1,0,1);
	audio_play(snd_noise);
	dir = random(360)
});
TurnCreate(0, 138, 17410, function() {
	dir += (time>=18030?4:-6);
	var t = dir;
	Blaster_Circle([320,320],[600,140],[t,t],[t,t+180],[2,2],[30,1,10])
	if time >=18030 {
		t+=90;
		Blaster_Circle([320,320],[600,140],[t,t],[t,t+180],[1.3,2],[30,1,10])
	}
},550,2);
TurnCreate(0, 139, 18550, function() {
	enemy_sprite_index[2] = 9;
});
TurnCreate(0, 140, 18610, function() {
	enemy_sprite_index[2] = 10;
});
TurnCreate(0, 141, 18720, function() {
	enemy_sprite_index[2] = 11;
});
TurnCreate(0, 142, 18940, function() {
	Fader_Fade(0,1,700);
});
TurnCreate(0, 143, 19640, function() {
	audio_stop_all();
	audio_destroy_stream(BGM);
	audio_play(snd_slice);
});
TurnCreate(0, 144, 19700, function() {
	audio_play(snd_damage);
});
TurnCreate(0, 145, 19760, function() {
	audio_play(snd_vaporize);
});
TurnCreate(0, 146, 19880, function() {
	Fader_Fade(1,0,60)
	room_goto(room_end);
});
