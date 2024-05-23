//Loads texture group
texturegroup_load("texbattle");
Fader_Fade(1, 0, 20);
draw_set_align(fa_left, fa_top);
menu_state = 0;
battle_state = 0;
battle_turn = 0;
menu_button_choice = 0;
menu_choice = array_create(4, 0); // Fight - Act - Item - Mercy
activate_turn = [1, 1, 0, 1];
action_trigger_turn = array_create(6, 0);
action_trigger_turn[2] = 1;
begin_at_turn = false;
last_choice = 0;
lerp_speed = global.battle_lerp_speed;

global.kr_activation = true;
global.hp = global.hp_max;
max_kr = 40;

ReloadTexts();

#region Fight Aiming Functions
Target = {};
with Target
{
	Count			= global.bar_count;
	state			= 0;
	side			= [choose(1, -1)];
	time			= 0;
	xscale			= 1;
	yscale			= 1;
	frame			= 0;
	alpha			= 1;
	buffer			= 0;
	retract_method	= choose(0, 1);
	WaitTime		= -1;
	Sprite			= sprTargetBG;
}
Aim = {};
with Aim
{
	scale	= 1;
	angle	= 0;
	color	= c_white;
	retract = choose(-1, 1);
}
function ResetFightAim()
{
	var __f = function()
	{
		var _f = function() {
			return choose(1, -1);
		}
		return array_create_ext(Target.Count, _f);
	}
	with Target
	{
		buffer = 3;
		state = 1;
		side = __f();
		xscale = 1;
		yscale = 1;
		frame = 0;
		alpha = 1;
		retract_method = choose(0, 1);
	}
	var TargetCount = Target.Count;
	with Aim
	{
		scale = array_create(TargetCount, 1);
		angle = 0;
		color = array_create(TargetCount, c_white);
		retract = choose(-1, 1);
	}
	var interval = irandom_range(60, 120), hspd = 4 + random(3);
	for (var i = 0; i < TargetCount; ++i) {
		Target.time[i] = 0;
		with Aim
		{
			InitialX[i] = 320 + (other.Target.side[i] * (290 + interval));
			Alpha[i] = 1;
			HasBeenPressed[i] = false;
			Sprite[i] = sprTargetAim;
			Fade[i] = false;
			Hspeed[i] = hspd;
			ForceCenter[i] = false;
			Expand[i] = false;
			Time[i] = 0;
			Faded[i] = 0;
		}
		interval += irandom_range(60, 120);
	}
	if Target.Count > 1
	{
		with Aim
		{
			HitCount = 0;
			Miss = 0;
			Attack = {};
			Base = other;
			with Attack
			{
				CritAmount = 0;
				Crit = false;
				Color = c_white;
				EnemyY = other.Base.enemy_instance[other.Base.menu_choice[0]].y - 50;
				Sprite = -1;
				Index = 0;
				Angle = 0;
				Alpha = 1;
				//star angle, alpha, angle change, distance, speed, friction
				StarData = array_create(8, [0, 1, 12.25, 0, 8, 0.34]);
				Time = 0;
				Distance = 0;
			}
		}
	}
}
#endregion
#region Menu Dialog Funtions
menu_text = "Just a basic test that's\n  long enough for a functional\n  typist test.[delay,3000][/page]* This is a test if the\n  page function is functional[delay,3000]![/page]* Another test if this is\n  functional and good to go!"
default_menu_text = menu_text;
menu_text_typist = scribble_typist()
	.in(0.5, 0)
	.sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*")

BattleData.SetMenuDialog(menu_text);
#endregion
#region KR Functions
kr_timer = 0;
hp_previous = global.hp;
#endregion
#region Button Functions
Button = {};
with Button
{
	Sprites			= [sprButtonFight, sprButtonAct, sprButtonItem, sprButtonMercy];
	Position		= [87, 453, 240, 453, 400, 453, 555, 453];
	var DefaultButtonAmount = array_length(Sprites);
	Alpha			= array_create(DefaultButtonAmount, 0.25);
	OverrideAlpha	= array_create(DefaultButtonAmount, 1);
	Scale			= array_create(DefaultButtonAmount, 1);
	DefaultColor	= make_color_rgb(242, 101, 34);
	Color			= array_create(DefaultButtonAmount, DefaultColor); //rgb
	Angle			= array_create(DefaultButtonAmount, 0);
	AlphaTarget		= [0.25, 1];
	ScaleTarget		= [1, 1.2];
	ColorTarget		= array_create(DefaultButtonAmount, [DefaultColor, c_yellow]);
	BackgroundCover = false;
	ColorLerpScale	= array_create(DefaultButtonAmount, 0);
	ResetTimer		= function() {
		ColorLerpTimer = array_create(array_length(oBattleController.Button.Sprites), 0);
	}
	ResetTimer();
}
Button.Update = function(duration = global.battle_lerp_speed == 1 ? 1 : 30) {
	static UpdateData = function(i, duration)
	{
		if Item_Count() == 0 Button.ColorTarget[2] = [c_ltgray, c_ltgray];
		Button.ColorLerpScale[i] = EaseOutQuad(Button.ColorLerpTimer[i], 0, 1, duration);
		Button.Color[i] = merge_color(Button.ColorTarget[i][0], Button.ColorTarget[i][menu_state >= 0], Button.ColorLerpScale[i]);
		Button.Color[i] = merge_color(c_black, Button.Color[i], Button.Alpha[i]);
	}
	var i = 0;
	repeat array_length(Button.Sprites)
	{
		if battle_state != BATTLE_STATE.MENU
		{
			if Button.ColorLerpTimer[i] > 0 Button.ColorLerpTimer[i]--;
			Button.Scale[i] += (Button.ScaleTarget[0] - Button.Scale[i]) / 6;
			Button.Alpha[i] += (Button.AlphaTarget[0] - Button.Alpha[i]) / 6;
		}
		else
		{
			if i == menu_button_choice
			{
				if Button.ColorLerpTimer[i] < duration Button.ColorLerpTimer[i]++;
				Button.Scale[i] += (Button.ScaleTarget[1] - Button.Scale[i]) / 6;
				Button.Alpha[i] += (Button.AlphaTarget[1] - Button.Alpha[i]) / 6;
			}
			else
			{
				if Button.ColorLerpTimer[i] > 0 Button.ColorLerpTimer[i]--;
				Button.Scale[i] += (Button.ScaleTarget[0] - Button.Scale[i]) / 6;
				Button.Alpha[i] += (Button.AlphaTarget[0] - Button.Alpha[i]) / 6;
			}
		}
		if Button.OverrideAlpha[i] != 1 Button.Alpha[i] = Button.OverrideAlpha[i];
		UpdateData(i, duration);
		++i;
	}
}
#endregion
#region UI Functions
if ALLOW_DEBUG
{
	debug = false;
	debug_alpha = 0;
	ca = 0;
}
ui_x = 275;
ui_y = 400;
ui_alpha = 1;
//Name, LV, HP Icon, HP Bar, KR Text, HP Text
ui_override_alpha = array_create(6, 1);
hp = global.hp;
hp_max = global.hp_max;
kr = global.kr;
refill_speed = 0.2;
hp_predict = 0;
show_predict_hp = true;
board_cover_hp_bar = false;
board_cover_button = false;
board_full_cover = false;
item_scroll_type = ITEM_SCROLL.DEFAULT;
item_scroll_alpha = array_create(3, 0.5);
item_lerp_x = array_create(8, 0);
item_lerp_y = array_create(8, 0);
item_space = Item_Space();

for (var i = 0; i < 8; ++i)
	item_lerp_color[i] = c_dkgray; 

item_lerp_x_target = 0;
item_lerp_y_target = 0;
item_lerp_color_amount = array_create(8, 16 / 255);
item_lerp_color_amount_target = array_create(8, 16 / 255);
item_desc_x = 360;
item_desc_alpha = 0;
#endregion
#region Flee
allow_run = true;
FleeText =
[
	"I have better things to do.",
	"flee text 2"
]
FleeTextNum = irandom(array_length(FleeText) - 1);
FleeState = 0;
#endregion
#region Dialog Stuff
dialog_is_end = 0;
#endregion
#region Results
Result = {};
with Result
{
	Exp = 0;
	Gold = 0;
}
#endregion
#region Effects in battle
Effect = {};
with Effect
{
	SeaTea = false;
	SeaTeaTurns = 4;
}
#endregion
#region Internal Functions
/**
	(Internal) Calculates the damage inflicting to the enemy
*/
function Calculate_MenuDamage(distance_to_center, enemy_under_attack, crit_amount = 0)
{
	var damage = global.player_base_atk + global.player_attack + global.player_attack_boost,
		target = enemy[enemy_under_attack],
		enemy_def = target.enemy_defense;
	//Check if enemy is spareable -> reduce the DEF
	if target.enemy_is_spareable enemy_def *= -30;
	//Reduce the damage by the defense of the enemy
	damage -= enemy_def;
	//Multiply the damage for the critical attack
	damage *= 2;
	if distance_to_center > 15
		//Reduce the damage for the non-critical attack
		damage *= (1 - distance_to_center / 273);
	//Sets damage to be random of the actual damage (idk what im saying)
	damage *= random_range(0.9, 1.1);
	//For multibar attack
	if crit_amount > 0
	{
		var average_damage = damage / global.bar_count, i = 0;
		damage = 0;
		repeat global.bar_count
		{
			//If the bar is a critical attack, multiply by 2
			var multiplier = ((i++) < crit_amount) ? 2 : 1;
			damage += average_damage * multiplier;
		}
	}
	//Sets the minimal damage to be 1
	damage = max(round(damage), 1);
	with target
		EnemyData.SetDamage(id, damage);
}
/**
	(Internal) Begins the turn
*/
function begin_turn() {
	//If the choice is not an act, check whether it triggers the turn
	if (last_choice != 1 ? activate_turn[last_choice] :
	//If it is an act, check whether the act chosen activates the turn
	(activate_turn[1] && action_trigger_turn[menu_choice[1]] != 0))
	{
		if last_choice == 1
		{
			battle_state = BATTLE_STATE.DIALOG;
			oEnemyParent.state = 1;
			last_choice = 0;
			battle_turn++;
			BattleData.Turn(oEnemyParent.DetermineTurn());
			with oEnemyParent
			{
				if array_length(PreAttackFunctions) > BattleData.Turn()
					PreAttackFunctions[BattleData.Turn()]();
			}
		}
		else
		{
			battle_state = BATTLE_STATE.IN_TURN;
			oEnemyParent.state = 2;
		}
		oSoul.image_angle = 0;
		Soul_SetPos(320, 320, 0);
	}
	else //Reset to menu
	{
		menu_choice = array_create(4, 0);
		menu_text_typist.reset();
		battle_state = 0;
		menu_state = 0;
		last_choice = 0;
	}
}
/**
	Call gameover event
*/
function gameover() {
	global.soul_x = oSoul.x;
	global.soul_y = oSoul.y;
	audio_stop_all();
	room_goto(room_gameover);
	// Insert file saving and events if needed
}

/**
	(Internal) Begins the spare event
*/
function begin_spare(activate_the_turn) {
	oEnemyParent.is_being_spared = true;
	oEnemyParent.spare_end_begin_turn = activate_the_turn;
	if !activate_the_turn {
		menu_state = MENU_STATE.BUTTON_SELECTION;
		battle_state = BATTLE_STATE.MENU;
	}
}

/**
	(Internal) Ends the battle
*/
function end_battle() {
	battle_state = BATTLE_STATE.RESULT;
	if !global.BossFight {
		battle_end_text = lexicon_text("Battle.Win", string(Result.Exp), string(Result.Gold));
		if Player.LV() < 20 && global.data.Exp + Result.Exp >= Player.GetExpNext() {
			global.data.lv++;
			if Player.HP() == Player.HPMax()
				Player.HPMax(Player.LV() == 20 ? 99 : Player.LV() * 4 + 16);
			battle_end_text += lexicon_text("Battle.LoveInc");
			audio_play(snd_level_up);
		}
		battle_end_text_writer = scribble("* " + battle_end_text);
		if battle_end_text_writer.get_page() != 0 battle_end_text_writer.page(0);
		battle_end_text_typist = scribble_typist()
			.in(0.5, 0)
			.sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*")
	} else {
		Fader_Fade(0, 1, 40, 0, c_black);
	}
}
/**
	(Internal) Starts the dialog event
*/
function dialog_start() {
	with oEnemyParent
	{
		if array_length(PreAttackFunctions) > DetermineTurn()
			PreAttackFunctions[max(0, DetermineTurn())]();
		state = 1;
	}
	battle_state = BATTLE_STATE.DIALOG;
	Soul_SetPos(320, 320, 0);
}
#endregion