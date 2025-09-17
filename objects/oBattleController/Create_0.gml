//Loads texture group
texturegroup_load("texbattle");
//Pre-bake outline font for damage
scribble_font_bake_outline_8dir_2px("fnt_dmg", "fnt_dmg_outlined", c_black, true);
Fader_Fade(1, 0, 20);
draw_set_align();
#region Initalize global battle variables
globalvar BattleBoardList, BattleSoulList, TargetBoard, TargetSoul, VertexBoardList, __BulletList;
TargetBoard = 0;
TargetSoul = 0;
BattleBoardList = [];
VertexBoardList = [];
BattleSoulList = [];
__BulletList = [];
instance_create_depth(320, 320, 0, oBoard);
instance_create_depth(48, 454, 0, oSoul);
Camera.Init();
if (ALLOW_DEBUG)
	global.__CoalitionDebug = false;
#endregion
//Current menu state
__menu_state = 0;
//Current battle state
__battle_state = 0;
//The turn elapsed in the battle
__battle_turn = 0;
//The button chosen by the player
__menu_button_choice = 0;
//The array of choices chosen by the player in each button
__menu_choices = array_create(4, 0);
//Whether the button will activate a turn when chosen (Bitwise variable)
__button_choice_activate_turn = 1 + 2 + 8;
//Whether the ACT will trigger a turn (Bitwise variable)
__action_trigger_turn = 0;
//Player's previous button choice
__last_choice = 0;
//Spared enemies
__spared_enemies_surfaces = [];
//Whether the soul will change its angle in the menu
ChangeSoulAngle = true;
//Reloads the text for localization
ReloadTexts();
//Spare text color
global.SpareTextColor = (!irandom(100) ? c_fuchsia : c_yellow);

#region Fight Aiming Functions
//The struct of the target BG
Target = {};
with (Target)
{
	__state			= 0;
	__time			= 0;
	__retract_method	= choose(0, 1);
	__MinimalAttackWaitTime		= -1;
	Sprite			= sprTargetBG;
}
//The struct of the aiming bar
__Aim = {};
__ResetFightAim();
///Resets the fight aiming data
function __ResetFightAim()
{
	with (COALITION_DATA.AttackItem)
	{
		__AttackAnimationTimer = 0;
		__AttackAnimationLanded = false;
		__AttackAnimationEnded = false;
	}
	with (Target)
	{
		__InputBuffer = 3;
		__state = 1;
		__side = array_create_ext(global.__CoalitionAttackBarCount, function() { return choose(1, -1); });
		__xscale = 1;
		__yscale = 1;
		__frame = 0;
		__alpha = 1;
		__retract_method = choose(0, 1);
	}
	with (__Aim)
	{
		scale = array_create(global.__CoalitionAttackBarCount, 1);
		angle = 0;
		color = array_create(global.__CoalitionAttackBarCount, c_white);
		retract = choose(-1, 1);
	}
	//Allows multiple aiming bars
	var interval = irandom_range(60, 120), hspd = 4 + random(3);
	for (var i = 0; i < global.__CoalitionAttackBarCount; ++i) {
		Target.__time[i] = 0;
		with (__Aim)
		{
			InitialX[i] = 320 + (other.Target.__side[i] * (290 + interval));
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
	if (global.__CoalitionAttackBarCount > 1)
	{
		with (__Aim)
		{
			HitCount = 0;
			Miss = 0;
			Attack = {};
			Base = oBattleController;
			with (Attack)
			{
				CritAmount = 0;
				Crit = false;
				Color = c_white;
				Index = 0;
				Angle = 0;
				Alpha = 1;
				Distance = 0;
			}
		}
	}
}
#macro __COALITION_BATTLE_DRAW_ATTACK_ANIMATION if (_target_state == 2 && !COALITION_DATA.AttackItem.__AttackAnimationEnded)\
					{\
						var strike_target_x = 160 * (__target_option + 1);\
						var target_enemy = __enemies[__target_option];\
						with (COALITION_DATA.AttackItem)\
						{\
							__AttackAnimation(strike_target_x, target_enemy.y - target_enemy.__enemy_total_height / 2);\
							__AttackAnimationTimer++;\
						}\
						if (COALITION_DATA.AttackItem.__AttackAnimationLanded)\
						{\
							__enemies[__target_option].__is_being_attacked = true;\
						}\
					}
#macro __COALITION_BATTLE_END_ATTACK_ANIMATION if ((_target_xscale < 0.08 || _target_yscale < 0.08) && COALITION_DATA.AttackItem.__AttackAnimationEnded)\
					{\
						_target_state = 0;\
						__dialog_start();\
						__menu_state = -1;\
					}
//Reset weapon animation variables
with (COALITION_DATA.AttackItem)
{
	__AttackAnimationTimer = 0;
	__AttackAnimationLanded = false;
	__AttackAnimationEnded = false;
}
#endregion
#region Menu Dialog Funtions
//The text to display at the menu
__menu_text = "Just a basic test that's\n  long enough for a functional\n  typist test.[delay,3000][/page]* This is a test if the\n  page function is functional[delay,3000]![/page]* Another test if this is\n  functional and good to go!"
//The default menu text...duh
__default_menu_text = __menu_text;
//Whether the current menu dialog contains an asterisk
__has_asterisk = true;
__menu_text_typist = scribble_typist().in(0.5, 0).sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*");

Battle.SetMenuDialog(__menu_text);
#endregion
#region KR Functions
__kr_timer = 0;
#endregion
#region Button Functions
//The button data struct
Button = {};
with (Button)
{
	Sprites			= [sprButtonFight, sprButtonAct, sprButtonItem, sprButtonMercy];
	Position		= [87, 453, 240, 453, 400, 453, 555, 453];
	TargetState		= [MENU_STATE.FIGHT, MENU_STATE.ACT, MENU_STATE.ITEM, MENU_STATE.MERCY];
	/*
		User defined states and logic
		i.e.
		ExtraStateProcess = function() {
			if (Battle.MenuState() == MENU_STATE.CUSTOM_STATE)
			{
				Process logic
			}
		}
	*/
	ExtraStateProcess = method(self, COALITION_EMPTY_FUNCTION);
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
		ColorLerpTimer = array_create(array_length(Sprites), 0);
	}
	ResetTimer();
	//Whether the board will mask the buttons
	BeneathBoard = false;
}
//Button update logic
Button.Update = function(duration = global.CoalitionBattleLerpSpeed == 1 ? 1 : 30) {
	static UpdateData = function(i, duration, __menu_state)
	{
		if (Item_Count() == 0)
			ColorTarget[2] = array_create(2, c_ltgray);
		ColorLerpScale[i] = EaseOutQuad(ColorLerpTimer[i], 0, 1, duration);
		Color[i] = merge_color(ColorTarget[i][0], ColorTarget[i][__menu_state >= 0], ColorLerpScale[i]);
		Color[i] = merge_color(c_black, Color[i], Alpha[i]);
	}
	var i = 0, __battle_state = self.__battle_state, __menu_state = self.__menu_state, __menu_button_choice = self.__menu_button_choice;
	with (Button)
	{
		repeat (array_length(Sprites))
		{
			if (__battle_state != BATTLE_STATE.MENU)
			{
				if (ColorLerpTimer[i] > 0)
					ColorLerpTimer[i]--;
				Scale[i] += (ScaleTarget[0] - Scale[i]) / 6;
				Alpha[i] += (AlphaTarget[0] - Alpha[i]) / 6;
			}
			else
			{
				if (i == __menu_button_choice)
				{
					if (ColorLerpTimer[i] < duration)
						ColorLerpTimer[i]++;
					Scale[i] += (ScaleTarget[1] - Scale[i]) / 6;
					Alpha[i] += (AlphaTarget[1] - Alpha[i]) / 6;
				}
				else
				{
					if (ColorLerpTimer[i] > 0)
						ColorLerpTimer[i]--;
					Scale[i] += (ScaleTarget[0] - Scale[i]) / 6;
					Alpha[i] += (AlphaTarget[0] - Alpha[i]) / 6;
				}
			}
			if (OverrideAlpha[i] != 1)
				Alpha[i] = OverrideAlpha[i];
			UpdateData(i, duration, __menu_state);
			++i;
		}
	}
};
#endregion
#region UI Functions
if (ALLOW_DEBUG)
{
	__debug_alpha = 0;
}
//UI data struct
UI = {
	x: 275,
	y: 400,
	Alpha: 1,
	OverrideAlpha: array_create(6, 1),
	//The drawing HP value
	__HP: global.HP,
	///The drawing max HP value
	__MaxHP: global.MaxHP,
	//The text for HP
	HPText: "HP",
	//The color for the HP text
	HPTextColor: c_white,
	//The drawing KR value
	__KR: global.__CoalitionPlayerKR,
	//The text for KR
	KRText: "KR",
	//The color of the KR text, when KR is not 0
	KRTextColor: c_white,
	//The color of the name text
	NameColor: c_white,
	//The color of the LV value
	LVValueColor: c_white,
	//The color of the LV text
	LVTextColor: c_white,
	//The color of the HP background bar
	HPBarBackgroundColor: c_red,
	//The color of the HP foreground bar
	HPBarForegroundColor: c_yellow,
	//The color of the KR bar
	KRBarColor: c_fuchsia,
	//The lerping speed of the bars
	RefillSpeed: 0.2,
	//The amount of predicted HP
	__hp_predict: 0,
	//Whether there will have a prediction for HP when hovering on item
	ShowPredictHP: true,
	//Whether the board will mask the UI
	BeneathBoard: false,
};
//The type for the item type
ItemMenuScrollType = ITEM_SCROLL.DEFAULT;
//The custom logic of item scrolling
ItemMenuCustomStepMethod = method(self, COALITION_EMPTY_FUNCTION);
//The custom logic of item drawing
ItemMenuCustomDrawMethod = method(self, COALITION_EMPTY_FUNCTION);
//Internal item drawing data
__item_lerp_x = array_create(8, 0);
__item_lerp_y = array_create(8, 0);
__item_count = Item_Count();

__item_lerp_color = array_create(8, c_dkgray);
__item_lerp_x_target = 0;
__item_lerp_y_target = 0;
__item_lerp_color_amount = array_create(8, 16 / 255);
__item_lerp_color_amount_target = array_create(8, 16 / 255);
__item_desc_x = 360;
__item_desc_alpha = 0;
#endregion
#region Flee
//Whether fleeing is enabled for the battle
FleeEnabled = true;
//The text that may display when fleeing
FleeTextList =
[
	"I have better things to do.",
	"flee text 2"
];
__FleeTextNum = irandom(array_length(FleeTextList) - 1);
__FleeState = 0;
#endregion
#region Results
__Result = {
	Exp: 0,
	Gold: 0
}
#endregion
#region Effects in battle
__item_process_list = [];
#endregion
#region Internal Functions
///Calculates the damage inflicting to the enemy
///@param {real} distance_to_center The distance to the center of the bar
///@param {real} enemy_under_attack The enemy that is under attack
///@param {real} crit_amount The amount of bars that had critical hits (Only for multiple bars)
function __CalculateMenuDamage(distance_to_center, enemy_under_attack, crit_amount = 0)
{
	aggressive_forceinline;
	var damage = global.__CoalitionPlayerBaseAttack + global.player_attack + global.__CoalitionPlayerAttackBoost,
		target = __enemies[enemy_under_attack],
		enemy_def = target.__defense;
	//Check if enemy is spareable -> reduce the DEF
	if (target.__spareable)
		enemy_def *= -30;
	//Reduce the damage by the defense of the enemy
	damage -= enemy_def;
	//Multiply the damage for the critical attack
	damage *= 2;
	if (distance_to_center > 15)
		//Reduce the damage for the non-critical attack
		damage *= (1 - distance_to_center / 273);
	//Sets damage to be random of the actual damage (idk what im saying)
	damage *= random_range(0.9, 1.1);
	//For multibar attack
	if (crit_amount > 0)
	{
		var average_damage = damage / global.__CoalitionAttackBarCount, i = 0;
		damage = 0;
		repeat (global.__CoalitionAttackBarCount)
		{
			//If the bar is a critical attack, multiply by 2
			var multiplier = ((i++) < crit_amount) ? 2 : 1;
			damage += average_damage * multiplier;
		}
	}
	//Sets the minimal damage to be 1
	damage = max(round(damage), 1);
	Enemy.SetDamage(target, damage);
}
///(Internal) Begins the turn
function __begin_turn() {
	aggressive_forceinline;
	//If the choice is not an act, check whether it triggers the turn
	if (__last_choice != 1 ? bool(__button_choice_activate_turn & quick_pow(2, __last_choice)) :
	//If it is an act, check whether the act chosen activates the turn
	((__button_choice_activate_turn & 2) && (__action_trigger_turn & quick_pow(2, __menu_choices[1]))))
	{
		if (__last_choice != 0)
		{
			__battle_state = BATTLE_STATE.DIALOG;
			oEnemyParent.__state = BATTLE_STATE.DIALOG;
			__last_choice = 0;
			__battle_turn++;
			with (oEnemyParent)
			{
				__current_turn = __turn_determined ? __current_turn : DetermineTurn();
				if (array_length(__PreAttackFunctions) > __current_turn)
					__PreAttackFunctions[__current_turn]();
			}
		}
		else
		{
			__battle_state = BATTLE_STATE.IN_TURN;
			oEnemyParent.__state = BATTLE_STATE.IN_TURN;
		}
		oSoul.image_angle = 0;
		Soul.SetPos(320, 320, 0);
	}
	else //Reset to menu
	{
		__menu_choices = array_create(4, 0);
		__menu_text_typist.reset();
		__battle_state = 0;
		__menu_state = 0;
		__last_choice = 0;
	}
}
///Call gameover event
function __gameover() {
	forceinline;
	global.__CoalitionGameOverSoulPosition = new Vector2(oSoul.x, oSoul.y);
	audio_stop_all();
	room_goto(room_gameover);
	// Insert file saving and events if needed
}
///Begins the spare event
///@param {bool} activate_turn Whether the sparing activates the turn or not
function __begin_spare(activate_turn) {
	forceinline;
	oEnemyParent.__is_being_spared = true;
	oEnemyParent.__spare_end_begin_turn = activate_turn;
	if (!activate_turn)
	{
		__menu_state = MENU_STATE.BUTTON_SELECTION;
		__battle_state = BATTLE_STATE.MENU;
	}
}
///Ends the battle
function __end_battle() {
	forceinline;
	//Clear item effects
	array_foreach(__item_process_list, function(_element, _index) {
		with (_element)
		{
			if (is_callable(EffectRemove))
				EffectRemove();
		}
	});
	__battle_state = BATTLE_STATE.RESULT;
	if (!global.__BossFight)
	{
		__battle_end_text = lexicon_text("Battle.Win", __Result.Exp, __Result.Gold);
		if (Player.LV() < 20 && Player.Exp() + __Result.Exp >= Player.GetExpNext())
		{
			Player.LV(Player.LV() + 1);
			if (Player.HP() == Player.HPMax())
				Player.HPMax(Player.LV() == 20 ? 99 : Player.LV() * 4 + 16);
			__battle_end_text += lexicon_text("Battle.LoveInc");
			audio_play(snd_level_up);
		}
		__battle_end_text_writer = scribble("* " + __battle_end_text, "__Coalition_Battle").starting_format(__DefaultFontNoBracket, c_white).page(0);
		__battle_end_text_typist = scribble_typist().in(0.5, 0).sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*");
	}
	else
		Fader_Fade(0, 1, 40, 0, c_black);
}
///Starts the dialog event
function __dialog_start() {
	forceinline;
	with (oEnemyParent)
	{
		__current_turn= __turn_determined ? __current_turn : DetermineTurn();
		if (array_length(__PreAttackFunctions) > __current_turn)
			__PreAttackFunctions[max(0, __current_turn)]();
		__state = 1;
	}
	__battle_state = BATTLE_STATE.DIALOG;
	Soul.SetPos(320, 320, 0);
}
///Ends the current turn of the battle
function __end_turn()
{
	aggressive_forceinline;
	//Set menu dialog
	__menu_text_typist.reset();
	__text_writer.page(0);
	Battle.SetMenuDialog(__menu_text, !__has_asterisk);
	//Reset menu state
	__battle_state = 0;
	__menu_state = 0;
	//Effect proccessing
	var i = 0;
	repeat (array_length(__item_process_list))
	{
		with (__item_process_list[i])
		{
			if (is_callable(EffectAtTurnEnd))
				EffectAtTurnEnd();
		}
		if (__item_process_list[i].__item_effect_expired)
		{
			with (__item_process_list[i])
				if (is_callable(EffectRemove))
					EffectRemove();
			array_delete(__item_process_list, i, 1);
		}
		else
			++i;
	}
	//Equipment specific events
	COALITION_DATA.AttackItem.EndTurnEvent();
	COALITION_DATA.DefenseItem.EndTurnEvent();
	//Reset box
	Board.Reset();
	//Reset soul
	with (oSoul)
		ExtraAngle = (__SoulMode == SOUL_MODE.YELLOW ? 180 : 0);
	//Clear bones
	with (oBulletBone)
		if (RetractOnTurnEnd)
		{
			__at_turn_end = true;
			DestroyOnTurnEnd = false;
			Hurtable = 0;
			TweenFire(id, "", 0, false, 0, 25, "length>", 10);
			alarm[1] = 25;
		}
	with (oBulletParents)
		if (DestroyOnTurnEnd)
			instance_destroy();
	__battle_state = BATTLE_STATE.MENU;
	time = -1;
	with (oEnemyParent)
	{
		__state = BATTLE_STATE.MENU;
		time = 0;
		__turn_has_ended = false;
		__turn_determined = false;
		//Execute post attack functions
		if (__current_turn > -1 && array_length(__PostAttackFunctions) > __current_turn)
			__PostAttackFunctions[__current_turn]();
		//If there is no existing dialog, add an empty string
		if (array_length(__dialog_text) <= ++__current_turn)
			array_push(__dialog_text, "");
		ParseDialog(__dialog_text[__current_turn]);
	}
}
///Exits the fight
function __ExitFight()
{
	static __ReturnToOverworld = function() {
		oOWController.__OverworldSubRoom = global.__CurrentOverworldSubRoom;
		oOWPlayer.x = global.__CurrentOverworldPosition.x;
		oOWPlayer.y = global.__CurrentOverworldPosition.y;
		oOWPlayer.FacingDirection = global.__CurrentOverworldDirection;
	}
	//Event after fight ends
	//If player came from an overworld, go back
	if (variable_global_exists("__CurrentOverworldRoom"))
	{
		room_goto(global.__CurrentOverworldRoom);
		invoke(__ReturnToOverworld, [], 1);
	}
	//if else then uh...restart game i guess
	else
		game_restart();
}
function __DrawUI(override_color = undefined) {
	forceinline
	with (UI)
	{
		var hp_x =				x - global.__CoalitionPlayerKREnabled * 20,
			name_x =			x - 245,
			name =				Player.Name(),
			bar_multiplier =	1.2, //Default multiplier from UNDERTALE
			_alpha =			Alpha;
		// Linear health updating / higher RefillSpeed = faster refill / max RefillSpeed is 1
		__HP += (global.HP - __HP) * RefillSpeed;
		__MaxHP += (global.MaxHP - __MaxHP) * RefillSpeed;
		__KR += (global.__CoalitionPlayerKR - __KR) * RefillSpeed;
		__HP = clamp(__HP, 0, global.MaxHP);
		__MaxHP = clamp(__MaxHP, 0, global.MaxHP);
		__KR = clamp(__KR, 0, global.__CoalitionPlayerMaxKR);
		var _hp = __HP * bar_multiplier,
			_hp_max = __MaxHP * bar_multiplier,
			_kr = __KR * bar_multiplier;
		//Prevent long decimals
		if (abs(__HP - global.HP) < 0.1)
			__HP = global.HP;
		if (abs(__KR - global.__CoalitionPlayerKR) < 0.1)
			__KR = global.__CoalitionPlayerKR;
	
		draw_set_font(fnt_mnc); // Name - LV Font
		// Name
		var f_alpha = min(OverrideAlpha[0], _alpha);
		if (f_alpha > 0)
		{
			var _name_col = override_color ?? NameColor;
			draw_text_color(name_x, y, name, _name_col, _name_col, _name_col, _name_col, f_alpha);
		}
		//Debug indication
		if (ALLOW_DEBUG && other.__debug_alpha > 0)
		{
			var col = override_color ?? make_color_hsv(global.timer % 255, 255, 255);
			draw_text_color(name_x, y, name, col, col, col, col, other.__debug_alpha);
		}
		// LV Icon
		f_alpha = min(OverrideAlpha[1], _alpha);
		if (f_alpha > 0)
		{
			var str_width = string_width(name);
			var lv_col = override_color ?? LVValueColor;
			draw_text_color(name_x + str_width, y, "   LV ", lv_col, lv_col, lv_col, lv_col, f_alpha);
			// LV Counter
			str_width += string_width("   LV ");
			var lv_text_col = override_color ?? LVValueColor;
			draw_text_color(name_x + str_width, y, Player.LV(), lv_text_col, lv_text_col, lv_text_col, lv_text_col, f_alpha);
		}

		draw_set_font(fnt_uicon); // Icon Font
		// HP Icon
		f_alpha = min(OverrideAlpha[2], _alpha);
		if (f_alpha > 0)
		{
			var hp_col = override_color ?? HPTextColor;
			draw_text_color(hp_x - 31, y + 5, HPText, hp_col, hp_col, hp_col, hp_col, f_alpha);
		}

		// Background bar
		f_alpha = min(OverrideAlpha[3], _alpha);
		if (f_alpha > 0)
		{
			var hp_back_col = override_color ?? HPBarBackgroundColor;
			draw_sprite_ext(sprPixel, 0, hp_x, y, _hp_max, 20, 0, hp_back_col, f_alpha);
			// HP bar
			var hp_fore_col = override_color ?? HPBarForegroundColor;
			draw_sprite_ext(sprPixel, 0, hp_x, y, _hp, 20, 0, hp_fore_col, f_alpha);
		}
	}
	//Healing Prediction
	if (__menu_state == MENU_STATE.ITEM)
	{
		var predict_col = override_color ?? c_lime;
		with (UI)
		{
			if (ShowPredictHP)
			{
				__hp_predict += (global.__CoalitionUserItems[other.__menu_choices[2]].Heal - __hp_predict) * RefillSpeed;
				draw_sprite_ext(sprPixel, 0, hp_x + _hp, y, min(__HP + __hp_predict, __MaxHP) * bar_multiplier - _hp, 20, 0, predict_col, abs(dsin(global.timer * 2) * .5) + .2);
			}
		}
	}

	// KR bar
	with (UI)
	{
		var final_kr_col = override_color ?? (round(__KR) ? KRBarColor : KRTextColor);
		if (global.__CoalitionPlayerKREnabled)
		{
			// Draw icon
			f_alpha = min(OverrideAlpha[4], _alpha);
			draw_set_alpha(f_alpha);
			// Draw the bar
			if (round(__KR))
				draw_sprite_ext(sprPixel, 0, hp_x + _hp + 1, y, max(-_kr, -_hp) - 1, 20, 0, final_kr_col, 1);

			draw_text_color(hp_x + 10 + _hp_max, y + 5, KRText, final_kr_col, final_kr_col, final_kr_col, final_kr_col, f_alpha);
		}
		draw_set_alpha(Alpha);
		// Zeropadding
		var hp_counter = string(round(__HP)),
			hp_max_counter = string(round(__MaxHP));
		if (round(__HP) < 10)
			hp_counter = "0" + hp_counter;
		if (round(__MaxHP) < 10)
			hp_max_counter = "0" + hp_max_counter;
		// Draw the health counter
		f_alpha = min(OverrideAlpha[5], _alpha);
		draw_set_font(fnt_mnc); // Counter Font
		var offset = global.__CoalitionPlayerKREnabled ? (20 + string_width(KRText)) : 15;
		draw_text_color(hp_x + offset + _hp_max, y, string_concat(hp_counter, " / ", hp_max_counter), final_kr_col, final_kr_col, final_kr_col, final_kr_col, f_alpha);
	}
	draw_set_color(c_white);
	draw_set_alpha(1);
}
#endregion
Enemy.LoadEncounter();