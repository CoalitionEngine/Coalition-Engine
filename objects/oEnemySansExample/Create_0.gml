live;
event_inherited();
with EnemyData
{
	SetName(other, "Sans");
	SetAct(other, 0, "Check", "funny skeleton man[delay,1000] 1 ATK 1 DEF");
	SetAct(other, 1, "sans 1", "sans 1 text");
	SetAct(other, 2, "sans2", "sans2twxt");
	SetAct(other, 3, "sans3", "sans3text");
	SetAct(other, 4, "sans4", "sans4text");
	SetHPStats(other, 100, 50);
	SetReward(other, 100, 100);
}
enemy_is_spareable = true;
default_font = "fnt_sans";
default_sound = snd_txtSans;
is_dodge = false;
enemy_sprites = [
	spr_sans_legs,
	spr_sans_body,
	spr_sans_head,
];
enemy_sprite_index = [0, 0, 0, 0];
enemy_sprite_scale = [
	[1, 1],
	[1, 1],
	[1, 1],
];
enemy_sprite_draw_method = [
	"pos",
	"ext",
	"ext",
];
enemy_sprite_pos = [
	[-47, -50, 47, -50, 47, 0, -47, 0],
	[0, -40],
	[0, -75],
];
// Sining method, multiplier, multiplier, rate, rate
enemy_sprite_wiggle = [
	["sin", .1, .2, 2.1, 1.3],
	["sin", .1, .2, 2.1, 1.4],
	["sin", .1, .2, 1.7, 1.2],
];

SlammingEnabled = true;
SlamSprites = [
	[spr_sans_slam_hor],
	[spr_sans_slam_ver],
	[spr_sans_slam_hor],
	[spr_sans_slam_ver],
];
SlamSpriteTargetIndex = [
	[1, 0, 0, 1, 2],
	[1, 0, 0, 1, 2],
	[0, 1, 2, 2, 2],
	[0, 1, 2, 2, 2],
];

//begin_at_turn = true;

writer = scribble_typist()
.in(0.5, 0)
.sound_per_char(snd_txtDefault, 1, 1)
.function_on_complete(function() { print(time)});

SetText = function(txt)
{
	tutorial_text = scribble(txt)
	.starting_format("fnt_dt_sans", c_white)
	.wrap(526)
}
SetText("");

dialog_size[3] = 80;

dodge_to = choose(-150, 150);
dodge_method = function()
{
	TweenFire("~", "oQuad", "#p", ">1", "$20", "damage_y>", "@-50");
	TweenFire("~", ["oQuad", "iQuad"], "#p", ">1", "|35", "$25", "x>", "@-dodge_to");
}

surf = -1;

//ShaderSetUniform(AddShaderEffect(shdBlueReduce), "reduceAmount", 0.4);

var text;
for(var i = 0; i < 12; i++)
{
	text = LoadTextFromFile("SansTest2.txt", 1, "@" + string(i));
	BattleData.EnemyDialog(self, i, text);
}
event_user(1);

//AddGPU(id, ev_draw_normal, bm_max, function() {
//	draw_gradient_ext(0, 480, 640, 240, 0, c_red);
//});
//AddGPU(id, ev_draw_normal, bm_max, function() {
//	draw_gradient_ext(640, 480, 480, 160, 90, c_aqua);
//});
//var tmp =
//AddGPU(id, ev_draw_normal, bm_max, function() {
//	draw_gradient_ext(0, 0, 480, 160, -90, c_white);
//});
//AddGPU(id, ev_draw_normal, bm_max, function() {
//	draw_gradient_ext(640, 0, 640, 240, 180, c_yellow);
//});
//GPURemove(tmp);
//AddGPUExt(id, ev_draw_normal, bm_inv_dest_color, bm_zero, function() {
//	draw_circle(mouse_x, mouse_y, 50, false);
//});
//draw_set_circle_precision(64);
//AddGPU(id, ev_draw_normal, bm_add, function() {
//	draw_circle_color(mouse_x, mouse_y, 120, c_purple, c_black, false);
//});

global.lerp_speed = 1;
global.battle_lerp_speed = 1;
//global.hp = 30;

//Shader = AddShaderEffect(shdSine, true);
//ShaderSetUniform(Shader, "intensity", 1);
//ShaderSetUniform(Shader, "amplitude", 10);
//ShaderSetUniform(Shader, "mode", 5);
