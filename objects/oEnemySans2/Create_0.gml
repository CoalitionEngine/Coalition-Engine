event_inherited();
enemy_name = "Sans";
enemy_act = ["Check","SAns 1","sans2","sans3","sans4","sans5"];
enemy_act_text = ["funny skeleton man[delay,1000] 1 ATK 1 DEF","sans 1 text","sans2twxt","sans3text","sans4text","sans5tex"];
EnemyData.SetHPStats(self, 680, 680, 0);
damage = irandom_range(300,500);
is_dodge = true;
begin_at_turn = true;
wiggle = false;
Set_BoardSize(70, 70, 70, 70, 0);
oBoard.image_alpha = 0;
oSoul.image_alpha = 0;
oSoul.moveable = false;
BGM = audio_create_stream("Music/MusSans.ogg");
t = -1;
with oBattleController {
	Button.OverrideAlpha=[0, 0, 0, 0];
	Button.Alpha=[0, 0, 0, 0];
	ui_override_alpha=[0, 0, 0, 0, 0, 0];
}

Battle_SetTurnTime(
[
infinity,
]
);
Battle_SetTurnBoardSize(
[
	[70, 70, 70, 70],
]);

Battle_EnemyDialog(0, [
	""
]);
global.data.name = "Frisk";
global.data.lv = 19;
global.hp_max = 92;
global.hp = 92;
draw_papyrus = 0;
papyrus_x = 320;
enemy_sprite_index[2] = 4;