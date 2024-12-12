//Loads texture group
texturegroup_load("texbattle");
//Pre-bake outline font for damage
scribble_font_bake_outline_8dir_2px("fnt_dmg", "fnt_dmg_outlined", c_black, true);
Fader_Fade(1, 0, 20);
draw_set_align();
//Current menu state
menu_state = 0;
//CUrrent battle state
battle_state = 0;
//The turn elapsed in the battle
battle_turn = 0;
//The button chosen by the player
menu_button_choice = 0;
//The array of choices chosen by the player in each button
menu_choice = array_create(4, 0);
//Whether the button will activate a turn when chosen (Bitwise variable)
__button_choice_activate_turn = 1 + 2 + 8;
//Whether the ACT will trigger a turn (Bitwise variable)
__action_trigger_turn = 0;
//Player's previous button choice
__last_choice = 0;
//Whether the soul will change its angle in the menu
change_soul_angle = true;
//Whether KR is activated
global.kr_activation = true;
//The maximum amount of KR the palyer can have
max_kr = 40;
global.hp = global.hp_max;
//Reloads the text for localization
ReloadTexts();
//Spare text color
global.spare_text_color = (!irandom(100) ? c_fuchsia : c_yellow);

#region Fight Aiming Functions
//The struct of the target BG
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
//The struct of the aiming bar
Aim = {};
with Aim
{
	scale	= 1;
	angle	= 0;
	color	= c_white;
	retract = choose(-1, 1);
}
///Resets the fight aiming data
function ResetFightAim()
{
	with Target
	{
		buffer = 3;
		state = 1;
		side = array_create_ext(Count, function() { return choose(1, -1); });
		xscale = 1;
		yscale = 1;
		frame = 0;
		alpha = 1;
		retract_method = choose(0, 1);
		var TargetCount = Count;
	}
	with Aim
	{
		scale = array_create(TargetCount, 1);
		angle = 0;
		color = array_create(TargetCount, c_white);
		retract = choose(-1, 1);
	}
	//Allows multiple aiming bars
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
		var oBC = self;
		with Aim
		{
			HitCount = 0;
			Miss = 0;
			Attack = {};
			Base = oBC;
			with Attack
			{
				CritAmount = 0;
				Crit = false;
				Color = c_white;
				EnemyY = oBC.enemy_instance[instance_find(oEnemyParent, oBC.menu_choice[0]).__enemy_slot].y - 50;
				Sprite = global.MultiBarAttackSprite;
				Index = 0;
				Angle = 0;
				Alpha = 1;
				//star angle, alpha, angle change, distance, speed, friction
				StarData = array_create(8, {image_angle: 0, image_alpha: 1, rotate: 12.25, distance: 0, speed: 8, friction: 0.32});
				Time = 0;
				Distance = 0;
			}
		}
	}
}
///Draws the stars for the multibar attack
///@param {Asset.GMSprite} sprite The sprite of the star
function DrawMultibarAttackStar(sprite)
{
	aggressive_forceinline;
	var size, _time = Aim.Attack.Time;
	//Adjust the size of the star based on the sprite
	switch sprite
	{
		case sprFrypanStar: size = 1.5; break;
		case sprGunStar: size = 0.75; break;
	}
	//Draws the 8 stars
	for (var i = 0; i < 8; ++i) {
		var _star_data = Aim.Attack.StarData[i];
		//Stops processing logic if the stars are not visible
		if _star_data.image_alpha < 0 break;
		//Apply friction
		if _star_data.speed - _star_data.friction > 0
			_star_data.speed -= _star_data.friction;
		//Position changing
		_star_data.distance += _star_data.speed;
		var _star_x = 160 * (target_option + 1) + lengthdir_x(_star_data.distance, i * 45),
			_star_y = Aim.Attack.EnemyY + lengthdir_y(_star_data.distance, i * 45);
		//Fading
		if _star_data.speed < 2.5
		{
			_star_data.image_alpha -= 1/120;
			if _star_data.rotate > 1 _star_data.rotate -= 0.25;
		}
		_star_data.image_angle += _star_data.rotate;
		draw_sprite_ext(sprite, 0, _star_x, _star_y, size, size, _star_data.image_angle, Aim.Attack.Color, _star_data.image_alpha);
		Aim.Attack.StarData[i] = _star_data;
	}
}
///Draws the main sprite for the multibar attack
///@param {Asset.GMSprite} sprite The sprite of the main attack
function DrawMultiAttackMain(sprite)
{
	aggressive_forceinline;
	var size = 1, _time = Aim.Attack.Time, _alpha = Aim.Attack.Alpha,
		size_increase, max_size, size_reduction;
	switch sprite
	{
		case sprFrypanAttack:
			size_increase = 0.3;
			max_size = 2.8;
			size_reduction = 0.6;
			break;
		case sprGunCircle:
			size_increase = 0.4;
			max_size = 3.5;
			size_reduction = 0.3;
			_time -= 9;
			break;
	}
	var time_before_fully_expand = round((max_size - size) / size_increase);
	if _time < time_before_fully_expand
		size += size_increase * _time;
	else 
	{
		size = max(0, max_size - size_reduction * (_time - time_before_fully_expand));
		_alpha -= 0.2;
	}
	draw_sprite_ext(sprite, posmod(_time / 2, 2), 320, Aim.Attack.EnemyY, size, size, _time * Aim.Attack.Angle, Aim.Attack.Color, _alpha);
}
#endregion
#region Menu Dialog Funtions
//The text to display at the menu
__menu_text = "Just a basic test that's\n  long enough for a functional\n  typist test.[delay,3000][/page]* This is a test if the\n  page function is functional[delay,3000]![/page]* Another test if this is\n  functional and good to go!"
//The default menu text...duh
default_menu_text = __menu_text;
__menu_text_typist = scribble_typist().in(0.5, 0).sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*");

Battle.SetMenuDialog(__menu_text);
#endregion
#region KR Functions
__kr_timer = 0;
#endregion
#region Button Functions
//The button data struct
Button = {};
with Button
{
	Sprites			= [sprButtonFight, sprButtonAct, sprButtonItem, sprButtonMercy];
	Position		= [87, 453, 240, 453, 400, 453, 555, 453];
	TargetState		= [MENU_STATE.FIGHT, MENU_STATE.ACT, MENU_STATE.ITEM, MENU_STATE.MERCY];
	/*
		User defined states and logic
		i.e.
		ExtraStateProcess = function() {
			if menu_state == MENU_STATE.CUSTOM_STATE
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
}
//Button update logic
Button.Update = function(duration = global.battle_lerp_speed == 1 ? 1 : 30) {
	static UpdateData = function(i, duration, menu_state)
	{
		if Item_Count() == 0 ColorTarget[2] = array_create(2, c_ltgray);
		ColorLerpScale[i] = EaseOutQuad(ColorLerpTimer[i], 0, 1, duration);
		Color[i] = merge_color(ColorTarget[i][0], ColorTarget[i][menu_state >= 0], ColorLerpScale[i]);
		Color[i] = merge_color(c_black, Color[i], Alpha[i]);
	}
	var i = 0, __battle_state = battle_state, __menu_state = menu_state, __menu_button_choice = menu_button_choice;
	with Button
	{
		repeat array_length(Sprites)
		{
			if __battle_state != BATTLE_STATE.MENU
			{
				if ColorLerpTimer[i] > 0 ColorLerpTimer[i]--;
				Scale[i] += (ScaleTarget[0] - Scale[i]) / 6;
				Alpha[i] += (AlphaTarget[0] - Alpha[i]) / 6;
			}
			else
			{
				if i == __menu_button_choice
				{
					if ColorLerpTimer[i] < duration ColorLerpTimer[i]++;
					Scale[i] += (ScaleTarget[1] - Scale[i]) / 6;
					Alpha[i] += (AlphaTarget[1] - Alpha[i]) / 6;
				}
				else
				{
					if ColorLerpTimer[i] > 0 ColorLerpTimer[i]--;
					Scale[i] += (ScaleTarget[0] - Scale[i]) / 6;
					Alpha[i] += (AlphaTarget[0] - Alpha[i]) / 6;
				}
			}
			if OverrideAlpha[i] != 1 Alpha[i] = OverrideAlpha[i];
			UpdateData(i, duration, __menu_state);
			++i;
		}
	}
};
#endregion
#region UI Functions
if ALLOW_DEBUG
{
	debug = false;
	debug_alpha = 0;
}
//UI data struct
ui = { x : 275, y : 400, alpha : 1, override_alpha : array_create(6, 1) };
//The drawing HP value
hp = global.hp;
//The drawing HP max value
hp_max = global.hp_max;
//The text for HP
hp_text = "HP";
//The drawing KR value
kr = global.kr;
//The text for KR
kr_text = "KR";
//The color of the name text
name_col = c_white;
//The color of the LV value
lv_num_col = c_white;
//The color of the LV text
lv_text_col = c_white;
//The color of the HP background bar
hp_max_col = c_red;
//The color of the HP foreground bar
hp_bar_col = c_yellow;
//The default color for the texts
hp_text_col = c_white;
//The color of the KT bar
kr_bar_col = c_fuchsia;
//The color of the KR text, when KR is not 0
kr_text_col = c_white;
//The lerping speed of the bars
refill_speed = 0.2;
//The amount of predicted HP
__hp_predict = 0;
//Whether there will have a prediction for HP when hovering on item
show_predict_hp = true;
//Whether the board will mask the UI
board_cover_ui = false;
//Whether the board will mask the buttons
board_cover_button = false;
//The type for the item type
item_scroll_type = ITEM_SCROLL.VERTICAL;
//The custom logic of item scrolling
item_custom_scroll_method = method(self, COALITION_EMPTY_FUNCTION);
//The custom logic of item drawing
item_custom_draw_method = method(self, COALITION_EMPTY_FUNCTION);
//Internal item drawing data
__item_lerp_x = array_create(8, 0);
__item_lerp_y = array_create(8, 0);
__item_count = Item_Count();

__item_lerp_color = array_create(8, c_dkgray);
__item_lerp_x_target = 0;
__item_lerp_y_target = 0;
__item_lerp_color_amount = array_create(8, 16 / 255);
__item_lerp_color_amount_target = array_create(8, 16 / 255);
item_desc_x = 360;
item_desc_alpha = 0;
#endregion
#region Flee
//Whether fleeing is enabled for the battle
enalbe_flee = true;
//The text that may display when fleeing
flee_text_list =
[
	"I have better things to do.",
	"flee text 2"
];
__FleeTextNum = irandom(array_length(flee_text_list) - 1);
__FleeState = 0;
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
///Calculates the damage inflicting to the enemy
///@param {real} distance_to_center The distance to the center of the bar
///@param {real} enemy_under_attack The enemy that is under attack
///@param {real} crit_amount The amount of bars that had critical hits (Only for multiple bars)
function __CalculateMenuDamage(distance_to_center, enemy_under_attack, crit_amount = 0)
{
	aggressive_forceinline;
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
	Enemy.SetDamage(target, damage);
}
///(Internal) Begins the turn
function __begin_turn() {
	aggressive_forceinline;
	//If the choice is not an act, check whether it triggers the turn
	if (__last_choice != 1 ? bool(__button_choice_activate_turn & quick_pow(2, __last_choice)) :
	//If it is an act, check whether the act chosen activates the turn
	((__button_choice_activate_turn & 2) && (__action_trigger_turn & quick_pow(2, menu_choice[1]))))
	{
		if __last_choice == 1
		{
			battle_state = BATTLE_STATE.DIALOG;
			oEnemyParent.__state = 1;
			__last_choice = 0;
			battle_turn++;
			with oEnemyParent
			{
				current_turn = __turn_determined ? current_turn : DetermineTurn();
				if array_length(PreAttackFunctions) > current_turn
					PreAttackFunctions[current_turn]();
			}
		}
		else
		{
			battle_state = BATTLE_STATE.IN_TURN;
			oEnemyParent.__state = BATTLE_STATE.IN_TURN;
		}
		oSoul.image_angle = 0;
		Soul_SetPos(320, 320, 0);
	}
	else //Reset to menu
	{
		menu_choice = array_create(4, 0);
		__menu_text_typist.reset();
		battle_state = 0;
		menu_state = 0;
		__last_choice = 0;
	}
}
///Call gameover event
function __gameover() {
	forceinline;
	global.__gameover_soul_x = oSoul.x;
	global.__gameover_soul_y = oSoul.y;
	audio_stop_all();
	room_goto(room_gameover);
	// Insert file saving and events if needed
}
///Begins the spare event
///@param {bool} activate_turn Whether the sparing activates the turn or not
function __begin_spare(activate_turn) {
	forceinline;
	oEnemyParent.__is_being_spared = true;
	oEnemyParent.spare_end_begin_turn = activate_turn;
	if !activate_turn {
		menu_state = MENU_STATE.BUTTON_SELECTION;
		battle_state = BATTLE_STATE.MENU;
	}
}
///Ends the battle
function __end_battle() {
	forceinline;
	battle_state = BATTLE_STATE.RESULT;
	if !global.BossFight {
		__battle_end_text = lexicon_text("Battle.Win", string(Result.Exp), string(Result.Gold));
		if Player.LV() < 20 && COALITION_DATA.Exp + Result.Exp >= Player.GetExpNext() {
			COALITION_DATA.lv++;
			if Player.HP() == Player.HPMax()
				Player.HPMax(Player.LV() == 20 ? 99 : Player.LV() * 4 + 16);
			__battle_end_text += lexicon_text("Battle.LoveInc");
			audio_play(snd_level_up);
		}
		__battle_end_text_writer = scribble("* " + __battle_end_text, "__Coalition_Battle").starting_format(DefaultFontNB, c_white).page(0);
		__battle_end_text_typist = scribble_typist().in(0.5, 0).sound_per_char(snd_txtTyper, 1, 1, " ^!.?,:/\\|*");
	} else {
		Fader_Fade(0, 1, 40, 0, c_black);
	}
}
///Starts the dialog event
function __dialog_start() {
	forceinline;
	with oEnemyParent
	{
		current_turn= __turn_determined ? current_turn : DetermineTurn();
		if array_length(PreAttackFunctions) > current_turn
			PreAttackFunctions[max(0, current_turn)]();
		__state = 1;
	}
	battle_state = BATTLE_STATE.DIALOG;
	Soul_SetPos(320, 320, 0);
}
///Ends the current turn of the battle
function __end_turn()
{
	aggressive_forceinline;
	//Set menu dialog
	__menu_text_typist.reset();
	__text_writer.page(0);
	Battle.SetMenuDialog(default_menu_text);
	//Reset menu state
	battle_state = 0;
	menu_state = 0;
	//Effect removal
	with Effect
		if SeaTea
		{
			if !--SeaTeaTurns
			{
				SeaTeaTurns = 4;
				SeaTea = false;
				global.spd /= 2;
			}
		}
	//Armor healing
	if is_odd(battle_turn) && is_val(COALITION_DATA.DefenseItem, "Temmie Armor", "Stained Apron")
	{
		global.hp++;
		audio_play(snd_item_heal);
	}
	//Reset box
	Board_Reset();
	//Reset soul
	with oSoul
		draw_angle = (mode == SOUL_MODE.YELLOW ? 180 : 0);
	//Clear bones
	with oBulletBone
		if retract_on_end
		{
			at_turn_end = true;
			destroy_on_turn_end = false;
			can_hurt = 0;
			TweenFire(id, "", 0, false, 0, 25, "length>", 10);
			alarm[1] = 25;
		}
	with oBulletParents
		if destroy_on_turn_end instance_destroy();
	state = 0;
	time = -1;
	with oEnemyParent
	{
		__state = BATTLE_STATE.MENU;
		time = 0;
		__turn_has_ended = false;
		__turn_determined = false;
		//If there is no existing dialog, add an empty string
		if array_length(dialog_text) <= ++current_turn then array_push(dialog_text, "");
		dialog_init(dialog_text[current_turn]);
		//Execute post attack functions
		var NewTurn = DetermineTurn();
		if array_length(PostAttackFunctions) > NewTurn PostAttackFunctions[NewTurn]();
	}
}
///Exits the fight
function __ExitFight()
{
	static __ReturnToOverworld = function() {
		oOWController.OverworldSubRoom = global.__CurrentOverworldSubRoom;
		oOWPlayer.x = global.__CurrentOverworldPosition.x;
		oOWPlayer.y = global.__CurrentOverworldPosition.y;
		oOWPlayer.dir = global.__CurrentOverworldDirection;
	}
	//Event after fight ends
	//If player came from an overworld, go back
	if variable_global_exists("__CurrentOverworldRoom")
	{
		room_goto(global.__CurrentOverworldRoom);
		invoke(__ReturnToOverworld, [], 1);
	}
	//if else then uh...restart game i guess
	else game_restart();
}
#endregion