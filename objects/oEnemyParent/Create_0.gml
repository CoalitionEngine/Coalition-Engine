//Data
//Resets the camera scale
Camera.Scale(1);
//The name of the enemy
enemy_name = "";
//The names of the act options
enemy_act = [];
//The text displayed when the act is selected
enemy_act_text = [];
//The function to execute when the act is selected
enemy_act_function = [];
//The max HP of the enemy
enemy_hp_max = 100;
//The current amount of HP of the enemy
enemy_hp = 100;
//This is for animating the HP bar
_enemy_hp = 100;
//Whether the enemy will have their HP bar drawn
enemy_draw_hp_bar = true;
//The color of the background of the HP bar
enemy_hp_bar_bg_color = c_dkgray;
//The color of the foreground of the HP bar
enemy_hp_bar_color = c_lime;
//The amount of defense of the enemy
enemy_defense = 1;
//Internal check for whether the enemy is actually in the battle or not
__enemy_in_battle = true;
//Whether the enemy is a boss or not
is_boss = false;
//Rewards
__exp_reward = 0;
__gold_reward = 0;
//The current state of the enemy
__state = 0;
//Whether the battle will begin at a turn or not
begin_at_turn = false;
//The current turn of the enemy attack (Do not confuse with current turn in battle)
current_turn = 0;
//Internal check of whether the turn has ended for this enemy
__turn_has_ended = false;
//Whether the enemy will automatically be masked behind the board
auto_mask = false;
//Optional veriables for sprite drawing
enemy_sprites = [];
enemy_sprite_index = [];
enemy_sprite_scale = [];
enemy_sprite_draw_method = [];
enemy_total_height = 0;
enemy_max_width = 0;
enemy_sprite_pos = [];
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
	enemy_sprites[num] = sprite;
	enemy_sprite_index[num] = index;
	enemy_sprite_draw_method[num] = mode;
	enemy_sprite_pos[num] = pos;
	enemy_sprite_scale[num] = scale;
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
	enemy_sprite_wiggle[num] = [meth, x_mult, y_mult, x_rate, y_rate];
}
// Sining method, multiplier, multiplier, rate, rate
enemy_sprite_wiggle = [];
//Whether the enemy will have a wiggle aniamtion
wiggle = true;
//Internal timer for wigglging animation
__wiggle_timer = 0;
//Slamming (If needed)
SlammingEnabled = false;
SlamDirection = DIR.DOWN;
Slamming = false;
SlamTimer = 0;
SlamSprites = [];
SlamSpriteIndex = 0;
SlamSpriteTargetIndex = [];
SlamSpriteNumber = 1;
///Sets the sprites for the slam animation
///@param {real} dir The direction of the slam
///@param {Asset.GMSprite} sprite The sprite for slamming
///@param {Array<Real>} indexes The order of image indexes of the sprite of slamming to use for the animation
function SetSlamSprites(dir, sprite, indexes)
{
	forceinline;
	SlamSprites[dir / 90] = sprite;
	SlamSpriteTargetIndex[dir / 90] = indexes;
}
//The method of dodging of the enemy (If any)
dodge_method = method(undefined, COALITION_EMPTY_FUNCTION);

//Dust
ContainsDust = true;
__dust =
{
	__surface : -1,
	__surface_finalized : false,
	__finalized_surface : -1,
	__being_drawn : false
};
//The duration of the dusting animation (The duration of pause between dusting and result)
dust_animation_duration = 60;

//Dialog - Properties stated in documentation
dialog = {x, y};
with dialog
{
	width = 190;
	height = 85;
	dir = DIR.LEFT;
	color = c_white;
	color_outline = c_black;
	spike_sprite = sprSpeechBubbleSpike;
	corner_sprite = sprSpeechBubbleCorner;
}
dialog_text = [""];
dialog_at_mid_turn = false;
default_font = "";
default_sound = snd_txtDefault;
__dialog_text_typist = scribble_typist().in(0.5, 0);

///Sets the next text for enemy dialog
///@param {string} text The text to display
function dialog_init(text = "")
{
	forceinline
	__text_writer = scribble(text, "__Coalition_Enemy").wrap(dialog.width - 15, dialog.height - 15)
	.starting_format(default_font, c_black).page(0);
	__dialog_text_typist.sound_per_char(default_sound, 1, 1, " ^!.?,:/\\|*");
}
dialog_init(dialog_text[0]);

///Generates a dialog mid turn
///@param {string} text The text to draw
///@param {Array<Array<string,function>>} events The typist events ([event name, function])
function MidTurnDialog(text, events = [])
{
	forceinline
	dialog_at_mid_turn = true;
	time++;
	var i = 0;
	repeat array_length(events)
	{
		scribble_typists_add_event(events[i][0], events[i][1]);
		++i;
	}
	__text_writer = scribble(text).wrap(dialog.width - 15, dialog.height - 15).starting_format(default_font, c_black).page(0);
}
//Internal check for whether the enemy is being attacked
__is_being_attacked = false;
//Whether the enemy can dodge
is_dodge = false;
//Whether the attack is a miss (Being able to dodge does not mean it will be a miss)
is_miss = false;
__attack_time = 0;
//The duration of an attack
attack_end_time = 60;
//Whether the damage will be drawn or not
draw_damage = false;
//The y-coordinate of the damage text (Reinitalized in Step)
damage_y = y;
//The damage inflicted to the enemy, it can be either a string or a real
damage = 0;
//The color of the damage text
damage_color = c_red;
//The function to execute when the enemy is being attacked (Only when is_dodge is false)
damage_event = method(undefined, COALITION_EMPTY_FUNCTION);
//The width of the HP bar
bar_width = 120;

//Interal enemy death variables
//Time elapsed of enemy death animation
__death_time = 0;
//Whether the enemy is currently dying
__is_dying = false;
//Whether the enemy has died
__died = false;

//Spare
//Whether the enemy can be spared
enemy_is_spareable = true;
//Interal check for whether the enemy is being spared
__is_being_spared = false;
//Whether if failing to spare the enemy will trigger the next turn
spare_end_begin_turn = false;
//Internal check for whether the enemy had been spared
__is_spared = false;
//The function to execute when being spared (Set to -1 if none, do NOT set it to an empty function)
spare_function = -1;

//Turn
//Whether the turn has begun
start = true;
//The time elapsed in the turn
time = -1;

//The default bone color
base_bone_col = c_white;


AttackFunctions = [];
PreAttackFunctions = [];
PostAttackFunctions = [];

/**
	New way on creating attacks
	@param {real}		turn	The turn to assign the attack to
	@param {function}	attack	The attacks to store as a function
*/
function SetAttack(turn, attack) {
	forceinline
	AttackFunctions[turn] = attack;
}

///Determine which turn is it currently based on a funciton that you can change for each enemy
DetermineTurn = method(undefined, function() {
	//Note that this line must be present at the end of the function or else it will throw an error
	return current_turn;
});
__turn_determined = false;

/**
	Sets a function that executes before the attack starts
	@param {real}		turn		The turn of the function
	@param {function}	function	The function to execute
*/
function PreAttackFunction(turn, func) {
	forceinline
	PreAttackFunctions[turn] = func;
}
/**
	Sets a function that executes after the attack ends
	@param {real}		turn		The turn of the function
	@param {function}	function	The function to execute
*/
function PostAttackFunction(turn, func) {
	forceinline
	PostAttackFunctions[turn] = func;
}