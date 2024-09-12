//Data
Camera.Scale(1, 1);
enemy_name = "";
enemy_act = [];
enemy_act_text = [];
enemy_act_function = [];
enemy_hp_max = 100;
enemy_hp = 100;
//This is for animating the Hp bar
_enemy_hp = 100;
enemy_draw_hp_bar = true;
enemy_defense = 1;
__enemy_in_battle = true;
is_boss = false;
__exp_reward = 0;
__gold_reward = 0;
state = 0;
begin_at_turn = false;
current_turn = 0;
__turn_has_ended = false;
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
wiggle = true;
wiggle_timer = 0;
//Slamming (If needed)
SlammingEnabled = false;
SlamDirection = DIR.DOWN;
Slamming = false;
SlamTimer = 0;
SlamSprites = [];
SlamSpriteIndex = 0;
SlamSpriteTargetIndex = [];
SlamSpriteNumber = 1;

dodge_method = method(undefined, COALITION_EMPTY_FUNCTION);

//Dust
ContainsDust = 1;
__dust_surface = -1;
__dust_being_drawn = false;
dust_speed = 60;

//Dialog
dialog = {x, y};
with dialog
{
	width = 190;
	height = 85;
	dir = DIR.LEFT;
	color = c_white;
}
dialog_text = [""];
dialog_at_mid_turn = false;
default_font = "";
default_sound = snd_txtDefault;
__dialog_text_typist = scribble_typist().in(0.5, 0);

function dialog_init(text = "")
{
	forceinline
	__text_writer = scribble(text, "__Coalition_Enemy")
	.wrap(dialog.width - 15, dialog.height - 15)
	.starting_format(default_font, c_black)
	.page(0);
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
//Under Attack
is_being_attacked = false;
is_dodge = false;
is_miss = false;
attack_time = 0;
attack_end_time = 60;
draw_damage = false;
damage_y = y - enemy_total_height / 2 - 60;
damage = 0;
damage_color = c_red;
damage_event = method(undefined, COALITION_EMPTY_FUNCTION);
damage_typist = scribble_typist().in(0, 0);
bar_width = 120;

//Death
__death_time = 0;
__is_dying = false;
__died = false;

//Spare
enemy_is_spareable = true;
is_being_spared = false;
spare_end_begin_turn = false;
is_spared = false;
spare_function = -1;

//Turn
start = true;
time = -1;
target_turn = 0;

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

/**
	Determine which turn is it currently based on a funciton that you can change for each enemy
*/
DetermineTurn = method(undefined, function() {
	//Note that this line must be present at the end of the function or else it will throw an error
	return current_turn;
});

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