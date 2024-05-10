if t >= 0 && time < 19640
{
	t = time / 60;
	AudioStickToTime(bgm, t);
}
if time and time < 2780
	if keyboard_check_pressed(ord("S"))
	{
		time = 2780;
		oBattleController.Button.OverrideAlpha=[0.5, 0.5, 0.5, 0.5];
		oBattleController.ui_override_alpha=[1, 1, 1, 1, 1, 1];
		oBoard.image_alpha = 1;
		oSoul.image_alpha = 1;
		oSoul.moveable = 1;
		enemy_sprite_index[2] = 0;
		wiggle = 1;
		TweenDestroy(oGlobal);
		Camera.Scale(1, 1);
	}
if time > 5350 and time < 6320
{
	with oSoul
		if y < 0 or y > 480
			global.hp -= global.hp;
}
if time > 9400 and time < 9650
{
	if rectangle_in_rectangle(oSoul.bbox_left, oSoul.bbox_top, oSoul.bbox_right, oSoul.bbox_bottom,
	22, 432, 132, 474)
	{
		if !soul_in_button
		{
			audio_play(snd_menu_switch);
			soul_in_button = true;
		}
	}
	else soul_in_button = false;
	with oBattleController
	{
		Button.Scale[0] += (Button.ScaleTarget[other.soul_in_button] - Button.Scale[0]) / 6;
		Button.Alpha[0] += (Button.AlphaTarget[other.soul_in_button] - Button.Alpha[0]) / 6;
		for (var i = 0; i < 3; ++i)
		Button.Color[0][i]+=(Button.ColorTarget[0][other.soul_in_button][i]-Button.Color[0][i])/6;
	}
}
if time > 13520 and time < 14619
if instance_exists(oBulletParents)
oBulletParents.can_hurt = 0;
if time > 14620 and time < 16760 {
	if !(time % irandom_range(3,7))
	global.data.lv = choose(8, 19);
	papyrus_x = x;
	if instance_exists(oBulletBone) {
		with oBulletBone {
			sprite_index = sprBonePap;
			hit_destroy = 1;
			damage = 10;
		}
	}
	if global.hp <= 9
		if global.debug global.hp = 1;
}