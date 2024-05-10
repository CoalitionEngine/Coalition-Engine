ContainsDust = 0;
event_inherited();
enemy_name = "Sans";
enemy_act = ["Check", "sans 1", "sans2", "sans3", "sans4", "sans5"];
enemy_act_text = ["funny skeleton man[delay,1000] 1 ATK 1 DEF", "sans 1 text", "sans2twxt", "sans3text", "sans4text", "sans5tex"];
EnemyData.SetHPStats(self, 100, 50, 0);
is_dodge = 1;
begin_at_turn = 1;

enemy_sprites = [
];

Battle_SetTurnTime(
[
infinity,
]
);

Battle_SetTurnBoardSize(
[
	[42, 42, 42, 42],
]);

Battle_EnemyDialog(0, [
	""
]);
bgm = -1;

var index = CreateNormalLine(0, 0, 0, 480, 10, c_white, 2, 0);
SetLineProperties(index, SetLineProperty.Properties, [LineProperties.TRAIL, 5, 120]);
SetLineProperties(index, SetLineProperty.Duration, infinity);