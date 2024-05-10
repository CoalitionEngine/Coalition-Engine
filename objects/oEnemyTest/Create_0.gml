event_inherited();
enemy_name = "Migosip";
enemy_act = ["Check", "Run", "Encourage", "Insult"];
enemy_act_text = ["Migosip[delay,100] 4 ATK 5 DEF[delay,500]\n  He looks tired.",
"",
"",
""];

/*
他的一般攻击和原版类似，一开始并不会有什么动作，只是一只蟑螂在下面平静的站着

这是第一回合，但在第二回合会有许多忧郁虫虫的小光粒子盘旋

下面依然站着一只蟑螂

第三回合是一只蟑螂在一张工作台前睡觉，头顶不断有zzzzzz飞出

第四回合玩家要操纵红心不断飞过蟑螂人群，还要躲避头上的掉落物(小光球)

截下来就是后三回合不断重复直达怪物被杀死



有三个选项:
逃跑(跳出来文本:你永远无法逃避职场)

鼓励(1，你告诉焦虑蟑螂它马上就要放假了 2，你告诉焦虑蟑螂它可以带薪休假 3，你告诉焦虑蟑螂它你很努力了)

辱骂(你痛批了一顿资本主义)

到达鼓励2后必须辱骂两次

才能触发鼓励3达成饶恕

鼓励1
角色文本:“真，真的吗...？”
鼓励2
角色文本:“这真的...但你真的懂我吗...？”
鼓励3
角色文本:“谢谢你！伟大的社会主义战士！”

辱骂
角色文本:“对！太对了！”
*/
enemy_sprites =
[
	sprNET,
];
enemy_sprite_draw_method =
[
	"",
];
enemy_sprite_scale = [
	[2, 2],
];
enemy_sprite_pos =
[
	[0, 0],
];
enemy_sprite_wiggle = [];

dialog_y_from_top = 20;
dialog_size[2] += 15;
dialog_size[3] += 85;

damage = 20;
EnemyData.SetHPStats(self, 100, 100, 0);
EnemyData.SetDefense(self, 28);
is_dodge = false;
wiggle = false;
enemy_is_spareable = false;

Battle_SetTurnTime(
[
	500,
]
);
Battle_SetTurnBoardSize(
[
	[75, 75, 75, 75],
]);
EnemyData.SetReward(self, irandom_range(10, 20) ,irandom_range(3, 7))

TurnData.HealAttacks[0] = 
function()
{
	if time == 1
		Set_BoardSize(70, 70, 70, 70);
	if time >= 30
	{
		var dir = time * 3.5;
		Blaster_Circle([320,320], [600, 150], [dir, dir], [dir, dir + 180], [1, 2], [30, 20, 20]);
	}
}
TurnData.HealTime = [600];

global.data.name = "Chara";
global.data.lv = 1;
global.hp_max = 20;
global.hp = 20;
global.kr_activation = false;
global.inv = 1;
global.assign_inv = 30;
global.damage = 3;
global.item = [0];
global.RGBBlaster = false;

window_set_caption("NexteraTale");

