event_inherited();
Player.EnableKR(true, 40);
Player.HP(Player.HPMax());
with Enemy
{
	SetName(other, "Sans");
	SetAct(other, 0, "Check", "funny skeleton man[delay,1000] 1 ATK 1 DEF");
	SetAct(other, 1, "sans 1", "sans 1 text");
	SetAct(other, 2, "sans2", "sans2twxt");
	SetAct(other, 3, "sans3", "sans3text");
	SetAct(other, 4, "sans4", "sans4text");
	SetHPStats(other, 600, 400);
	SetReward(other, 100, 100);
}
Dialog.DefaultFont = "fnt_sans";
Dialog.DefaultSound = snd_txtSans;

Battle.EnemyDialog(this, 0, "Turn 0.").EnemyDialog(this, 1, "Turn 1.").SetButtonActivateTurn(2, false);
//__spareable = true;
Dialog.DefaultFont = "fnt_sans";
Dialog.DefaultSound = snd_txtSans;
//CanDodge = true;
InitSprite(0, spr_sans_legs, 0, "pos", [-47, -50, 47, -50, 47, 0, -47, 0]);
SetWiggle(0, "sin", 0.1, 0.2, 2.1, 1.3);
InitSprite(1, spr_sans_body, 0, "ext", [0, -40]);
SetWiggle(1, "sin", 0.1, 0.2, 2.1, 1.4);
InitSprite(2, spr_sans_head, 0, "ext", [0, -75]);
SetWiggle(2, "sin", 0.1, 0.2, 1.7, 1.2);

SlammingEnabled = true;
SetSlamSprites(0, spr_sans_slam_hor, [1, 0, 0, 1, 2]);
SetSlamSprites(90, spr_sans_slam_ver, [1, 0, 0, 1, 2]);
SetSlamSprites(180, spr_sans_slam_hor, [0, 1, 2, 2, 2]);
SetSlamSprites(270, spr_sans_slam_ver, [0, 1, 2, 2, 2]);

//BeginAtTurn = true;

dodge_to = choose(-150, 150);
DodgeMethod = function()
{
	TweenFire("~", "oQuad", "#p", ">1", "$20", "DamageTextY>", "@-50");
	TweenFire("~", ["oQuad", "iQuad"], "#p", ">1", "|35", "$25", "x>", "@-dodge_to");
}

surf = -1;

//ShaderSetUniform(AddShaderEffect(shdBlueReduce), "reduceAmount", 0.4);

Dialog.x += 50;
Dialog.y -= 70;
event_user(1);


//global.CoalitionUILerpSpeed = 1;
//global.CoalitionBattleLerpSpeed = 1;
//global.HP = 30;

//Shader = AddShaderEffect(shdSine, true);
//ShaderSetUniform(Shader, "intensity", 1);
//ShaderSetUniform(Shader, "amplitude", 10);
//ShaderSetUniform(Shader, "mode", 5);

audio_stop_all();