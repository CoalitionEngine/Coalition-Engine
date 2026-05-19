//Data
//Resets the camera scale
Camera.Scale(1);
//The name of the enemy
Name = "";
//The names of the act options
__ActNames = [];
//The text displayed when the act is selected
__ActTexts = [];
//The function to execute when the act is selected
__ActFunctions = [];
//The max HP of the enemy
MaxHP = 100;
//The current amount of HP of the enemy
HP = 100;
//This is for animating the HP bar
__HPBarHP = 100;
//Whether the enemy will have their HP bar drawn
MenuDrawHPBar = true;
//The color of the background of the HP bar
HPBarBackColor = c_dkgray;
//The color of the foreground of the HP bar
HPBarForeColor = c_lime;
//The amount of defense of the enemy
__defense = 1;
//Internal check for whether the enemy is actually in the battle or not
__enemy_in_battle = true;
//Whether the enemy is a boss or not
IsBoss = false;
//Rewards
__exp_reward = 0;
__gold_reward = 0;
//The current state of the enemy
__state = 0;
//Whether the battle will begin at a turn or not
BeginAtTurn = false;
//The current turn of the enemy attack (Do not confuse with current turn in battle)
__current_turn = 0;
//Internal check of whether the turn has ended for this enemy
__turn_has_ended = false;
//Whether the enemy will automatically be masked behind the board
AutoMask = false;
//Optional veriables for sprite drawing
__enemy_sprite = [];
__enemy_sprite_index = [];
__enemy_sprite_scale = [];
__enemy_sprite_draw_method = [];
__enemy_total_height = 0;
__enemy_max_width = 0;
__enemy_sprite_pos = [];
///Initalizes the sprite of the enemy
///@param {real} ID The ID of the sprite (Zero based)
///@param {Asset.GMSprite} sprite The sprite to set
///@param {real} index The index of the sprite
///@param {string} mode The mode of the drawing of the sprite, either "ext" or "pos"
///@param {Array} pos The position of the drawing, for "ext", it will be [displace x, displace y], for "pos", it will be [x1, y1, x2, y2, x3, y3, x4, y4] (refer to draw_sprite_pos)
///@param {Array} scale The scale of the sprites ("ext" exclusive, default [1, 1])
function InitSprite(num, sprite, index, mode, pos, scale = [1, 1])
{
	forceinline
	__enemy_sprite[num] = sprite;
	__enemy_sprite_index[num] = index;
	__enemy_sprite_draw_method[num] = mode;
	__enemy_sprite_pos[num] = pos;
	__enemy_sprite_scale[num] = scale;
}
///Sets the wiggling method of the sprite
///@param {real} ID The ID of the sprite
///@param {string} method The method of drawing, either "sin" or "cos"
///@param {real} x_mult The multiplication for the x wiggling
///@param {real} y_mult The multiplication for the y wiggling
///@param {real} x_rate The amplitude of the x wiggling
///@param {real} y_rate The amplitude of the y wiggling
function SetWiggle(num, meth, x_mult, y_mult, x_rate, y_rate)
{
	forceinline
	__enemy_sprite_wiggle[num] = [meth, x_mult, y_mult, x_rate, y_rate];
}
// Sining method, multiplier, multiplier, rate, rate
__enemy_sprite_wiggle = [];
//Whether the enemy will have a wiggle aniamtion
WiggleEnabled = true;
//Internal timer for wigglging animation
__wiggle_timer = 0;
//Slamming (If needed)
SlammingEnabled = false;
__slam_direction = DIR.DOWN;
__slamming = false;
__slam_timer = 0;
__slam_sprites = [];
__slam_sprite_target_indexes = [];
SlamSpriteNumber = 1;
SlamDuration = 25;
///Sets the sprites for the slam animation
///@param {real} dir The direction of the slam
///@param {Asset.GMSprite} sprite The sprite for slamming (The first argument you had put in `InitSprite`)
///@param {Array<Real>} indexes The order of image indexes of the sprite of slamming to use for the animation
function SetSlamSprites(dir, sprite, indexes)
{
	forceinline;
	__slam_sprites[dir / 90] = sprite;
	__slam_sprite_target_indexes[dir / 90] = indexes;
}
//The method of dodging of the enemy (If any)
DodgeMethod = method(undefined, COALITION_EMPTY_FUNCTION);
function GetDamageAnimationTimer() { forceinline; return __attack_time; }
function EndDodgeAnimation() { forceinline; __DodgeAnimationEnded = true; }
//Detect whether the dodge animation ended
__DodgeAnimationEnded = false;

//Dust
ContainsDust = true;
__dust = {
	__surface : -1,
	__surface_finalized : false,
	__finalized_surface : -1,
	__being_drawn : false
};
//The duration of the dusting animation (The duration of pause between dusting and result)
DustAnimDuration = 60;

//Dialog - Properties stated in documentation
Dialog = {x, y};
with (Dialog)
{
	Width = 190;
	Height = 85;
	Direction = DIR.LEFT;
	Color = c_white;
	OutlineColor = c_black;
	SpikeSprite = sprSpeechBubbleSpike;
	CornerSprite = sprSpeechBubbleCorner;
	DefaultFont = "";
	DefaultSound = snd_txtDefault;
}
__dialog_text = [""];
__dialog_at_mid_turn = false;
__dialog_text_typist = scribble_typist().in(0.5, 0);

///Sets the next text for enemy dialog
///@param {string} text The text to display
function ParseDialog(text = "")
{
	forceinline
	__text_writer = scribble(text, "__Coalition_Enemy").wrap(Dialog.Width - 15, Dialog.Height - 15)
					.starting_format(Dialog.DefaultFont, c_black).page(0);
	__dialog_text_typist.sound_per_char(Dialog.DefaultSound, 1, 1, " ^!.?,:/\\|*");
}
ParseDialog(__dialog_text[0]);

///Generates a dialog mid turn
///@param {string} text The text to draw
///@param {Array<Array<string,function>>} events The typist events ([event name, function])
function MidTurnDialog(text, events = [])
{
	forceinline
	__dialog_at_mid_turn = true;
	time++;
	array_foreach(events, function(_element, _index) { scribble_typists_add_event(_element[0], _element[1]); });
	__text_writer = scribble(text).wrap(Dialog.Width - 15, Dialog.Height - 15).starting_format(Dialog.DefaultFont, c_black).page(0);
}
//Internal check for whether the enemy is being attacked
__is_being_attacked = false;
//Whether the enemy can dodge
CanDodge = false;
__attack_time = 0;
//The duration of an attack
__attack_end_time = 60;
//Whether the damage will be drawn or not
DrawDamageText = false;
//The y-coordinate of the damage text (Reinitalized in Step)
DamageTextY = y;
//The damage inflicted to the enemy, it can be either a string or a real
__damage = 0;
//The color of the damage text
DamageTextColor = c_red;
//The function to execute when the enemy is being attacked (Only when CanDodge is false)
DamageEvent = method(undefined, COALITION_EMPTY_FUNCTION);
//The width of the HP bar
DamageBarWidth = 120;

//Interal enemy death variables
//Time elapsed of enemy death animation
__death_time = 0;
//Whether the enemy is currently dying
__is_dying = false;
//Whether the enemy has died
__died = false;

//Spare
//Whether the enemy can be spared
__spareable = false;
//Interal check for whether the enemy is being spared
__is_being_spared = false;
//Whether if failing to spare the enemy will trigger the next turn
__spare_end_begin_turn = false;
//Internal check for whether the enemy had been spared
__is_spared = false;
//The function to execute when being spared (Set to -1 if none, do NOT set it to an empty function)
SpareFunction = -1;

//Turn
//Whether the turn has begun
start = true;
//The time elapsed in the turn
time = -1;


__AttackFunctions = [];
__PreAttackFunctions = [];
__PostAttackFunctions = [];
__turn_determined = false;
__enemy_draw_surface = -1;
#region Functions
/**
	New way on creating attacks
	@param {real}		turn	The turn to assign the attack to
	@param {function}	attack	The attacks to store as a function
*/
function SetAttack(turn, attack) {
	forceinline
	__AttackFunctions[turn] = attack;
}
///Determine which turn is it currently based on a funciton that you can change for each enemy
DetermineTurn = method(undefined, function() {
	//Note that this line must be present at the end of the function or else it will throw an error
	return __current_turn;
});
function EndTurn()
{
	forceinline;
	__turn_has_ended = true;
}
/**
	Sets a function that executes before the attack starts
	@param {real}		turn		The turn of the function
	@param {function}	function	The function to execute
*/
function PreAttackFunction(turn, func) {
	forceinline
	__PreAttackFunctions[turn] = func;
}
/**
	Sets a function that executes after the attack ends
	@param {real}		turn		The turn of the function
	@param {function}	function	The function to execute
*/
function PostAttackFunction(turn, func) {
	forceinline
	__PostAttackFunctions[turn] = func;
}
/**
	The drawing function of the enemy
*/
function __EnemyDrawFunction()
{
	//Wiggling
	var enemy_sprite_count = array_length(__enemy_sprite),
		wiggle_method = __enemy_sprite_wiggle,
		FinalPosition = [0, 0], FinalSprites = [], FinalIndex = [];
	//This must be done to prevent slamming sprites to override the default sprites
	array_copy(FinalSprites, 0, __enemy_sprite, 0, enemy_sprite_count);
	array_copy(FinalIndex, 0, __enemy_sprite_index, 0, enemy_sprite_count);

	//Slamming
	if (SlammingEnabled)
	{
		if (__slamming)
		{
			var _slam_dir = __slam_direction / 90;
			if (__slam_timer++)
			{
				FinalSprites[SlamSpriteNumber] = __slam_sprites[_slam_dir];
				if (__slam_timer < 25)
					FinalIndex[SlamSpriteNumber] = __slam_sprite_target_indexes[_slam_dir][__slam_timer / 5];	
				else if __slam_timer == 25
					__slamming = false;
			}
		}
		else
		{
			__slam_timer = 0;
			array_copy(FinalSprites, 0, __enemy_sprite, 0, enemy_sprite_count);
			array_copy(FinalIndex, 0, __enemy_sprite_index, 0, enemy_sprite_count);
		}
	}

	//Draws the enemy sprites (Engine functions)
	for (var i = 0; i < enemy_sprite_count; ++i)
	{
		if (string_is_empty(__enemy_sprite_draw_method[i]))
		{
			draw_sprite_ext(FinalSprites[i], FinalIndex[i],
				x + __enemy_sprite_pos[i][0],
				y + __enemy_sprite_pos[i][1],
				__enemy_sprite_scale[i][0], __enemy_sprite_scale[i][1],
				0, c_white, image_alpha);
			break;
		}
		__CoalitionEngineError(array_length(wiggle_method[i]) < 5, "Amount of arguments supplied in the array '__enemy_sprite_wiggle' on the ", i, "th dimension is incorrect, expected 5 got ", array_length(__enemy_sprite_pos[i]));
		if (wiggle_method[i][0] == "sin")
			FinalPosition = [
					sin(__wiggle_timer * wiggle_method[i][1]) * wiggle_method[i][3],
					sin(__wiggle_timer * wiggle_method[i][2]) * wiggle_method[i][4]
				];
		else if (wiggle_method[i][0] == "cos")
			FinalPosition = [
					cos(__wiggle_timer * wiggle_method[i][1]) * wiggle_method[i][3],
					cos(__wiggle_timer * wiggle_method[i][2]) * wiggle_method[i][4]
				];
		if (__enemy_sprite_draw_method[i] == "ext")
			draw_sprite_ext(FinalSprites[i], FinalIndex[i],
				x + __enemy_sprite_pos[i][0] + FinalPosition[0],
				y + __enemy_sprite_pos[i][1] + FinalPosition[1],
				__enemy_sprite_scale[i][0], __enemy_sprite_scale[i][1],
				0, c_white, image_alpha);
		else if (__enemy_sprite_draw_method[i] == "pos")
		{
			__CoalitionEngineError(array_length(__enemy_sprite_pos[i]) < 8, "Amount of arguments supplied in the array '__enemy_sprite_pos' on the ", i, "th dimension is incorrect, expected 8 got ", array_length(__enemy_sprite_pos[i]));
			draw_sprite_pos(FinalSprites[i], FinalIndex[i],
				x + __enemy_sprite_pos[i][0] + FinalPosition[0],
				y + __enemy_sprite_pos[i][1] + FinalPosition[1],
				x + __enemy_sprite_pos[i][2] + FinalPosition[0],
				y + __enemy_sprite_pos[i][3] + FinalPosition[1],
				x + __enemy_sprite_pos[i][4],
				y + __enemy_sprite_pos[i][5],
				x + __enemy_sprite_pos[i][6],
				y + __enemy_sprite_pos[i][7],
				image_alpha);
		}
	}
	//Struct draw
	if (variable_instance_exists(id, "__Struct_Draw") && is_method(__Struct_Draw))
		__Struct_Draw();
}
///Removes the enemy from the battle
function __CoalitionRemoveEnemy(is_spared = false)
{
	forceinline
	if (instance_exists(oBattleController))
	{
		var surf = surface_create(640, 480);
		surface_copy(surf, 0, 0, __enemy_draw_surface);
		var enemy_slot = x / 160 - 1;
		with (oBattleController)
		{
			//Add Reward
			__Result.Gold += other.__gold_reward;
			__Result.Exp += other.__exp_reward;
			__enemies[enemy_slot] = noone;
			if (is_spared)
				array_push(__spared_enemies_surfaces, surf);
		}
	}
	instance_destroy();
}
function __InitalizeDust()
{
	forceinline
	var i = 0, n = array_length(__enemy_sprite);
	repeat (n)
	{
		__enemy_max_width = max(sprite_get_width(__enemy_sprite[i]) * __enemy_sprite_scale[i][0], __enemy_max_width);
		++i;
	}
	if (n > 0)
		__enemy_total_height = -array_last(__enemy_sprite_pos)[1] + (sprite_get_height(array_last(__enemy_sprite)) * 2 - sprite_get_yoffset(array_last(__enemy_sprite))) * array_last(__enemy_sprite_scale)[1];

	//Particles aren't used because if a lot of particles are created then the CPU will be abused
	//And the dust amount is on average at least a couple hundred, so drawing in arrays are better
	if (ContainsDust)
	{
		var max_width = __enemy_max_width, total_height = __enemy_total_height, _x = x, _y = y;
		with (__dust)
		{
			height = 0;
			amount = total_height * max_width / 6;
			speed = array_create_ext(amount, function() { return random_range(1, 3); });
			direction = array_create_ext(amount, function() { return random_range(55, 125); });
			life = array_create_ext(amount, function() { return irandom_range(60, 120); });
			image_alpha = array_create(amount, 1);
			image_angle = array_create_ext(amount, function() { return random(360); });
			rotate = array_create_ext(amount, function() { return random_range(1, -1); });
			i = 0;
			repeat (amount)
			{
				x[i] = random_range(-max_width, max_width) / 2 + _x;
				y[i] = _y - total_height + (i * 6 / max_width);
				i++;
			}
		}
	}
	DamageTextY = y - __enemy_total_height - 20;
}
#endregion