///Resets the board state to default
///@param {bool} angle_div	Whether the angle of the board be fixed between -90 < x < 90 or not
function ResetBoard(anglediv = true) {
	gml_pragma("forceinline");
	Board.SetSize();
	if anglediv oBoard.image_angle %= 90;
	Board.SetAngle();
	Board.SetPos();
}

///Sets the box angle, size and position to the default settings for green soul
function Set_GreenBox()
{
	gml_pragma("forceinline");
	Board.SetAngle();
	Board.SetSize(42, 42, 42, 42, 20);
	Board.SetPos(320, 240, 20);
}

///Deals damage to the soul
///@param {real} dmg	The Damage to Yellow HP (Default 1)
///@param {real} kr		The Damage to Purple KR (Default 1)
function Soul_Hurt(dmg = global.damage, kr = global.krdamage)
{
	gml_pragma("forceinline");
	if !global.inv and can_hurt
	{
		audio_play(snd_hurt);
		global.inv = global.assign_inv + global.player_inv_boost;
		global.hp -= dmg;
		if global.hp > 1 global.kr += kr;
		if hit_destroy instance_destroy();
	}
}

/**
	Slams the soul to the respective direction and other extra functions
	@param {real} direction			Which direction the soul will fall in
	@param {real} fall				The speed of the fall (Optional)
	@param {bool} hurt				Whether the slam damages the player (Optional)
	@param {Asset.GMObject} target	The target enemy to set the slam to (For sprite anim) (Default all)
*/
function Slam(Direction, move = 20, hurt = false, target_enemy = oEnemyParent)
{
	gml_pragma("forceinline");
	Direction = posmod(Direction, 360);
	with target_enemy
	{
		if SlammingEnabled
		{
			Slamming = true;
			SlamDirection = Direction;
		}
	}
	SoulSetMode(SOUL_MODE.BLUE);
	global.slam_power = move;
	global.slam_damage = hurt;
	with BattleSoulList[TargetSoul]
	{
		dir = Direction;
		image_angle = posmod(Direction + 90, 360);
		fall_spd = move;
		slam = 1;
	}
}

///Begins the drawing of board masking
///@param {bool} sprite					Whether a sprite used for masking
///@param {Asset.GMObject,Array} board	Which board to mask in
function Battle_Masking_Start(spr = false, board = undefined) {
	gml_pragma("forceinline");
	board ??= BattleBoardList[TargetBoard];
	if oGlobal.MainCamera.enable_z exit;
	if instance_exists(board) and depth >= board.depth
	{
		var shader = spr ? shdClipMaskSpr : shdClipMask;
		shader_set(shader);
		var u_mask = shader_get_sampler_index(shader, "u_mask");
		texture_set_stage(u_mask, surface_get_texture(board.surface));
		var u_rect = shader_get_uniform(shader, "u_rect"),
			window_width = 640, window_height = 480;
		shader_set_uniform_f(u_rect, 0, 0, window_width, window_height);
	}
}

///Ends the masked drawing
///@param {Asset.GMObject,Array} board	Which board that was used to mask in
function Battle_Masking_End(board = undefined) {
	gml_pragma("forceinline");
	board ??= BattleBoardList[TargetBoard];
	if oGlobal.MainCamera.enable_z exit;
	if instance_exists(board) shader_reset();
}

///Battle data
function __Battle() constructor
{
	///Gets/Sets the turn of the battle
	///@param {real} turn The turn to set it to
	static Turn = function(turn = infinity) {
		if turn != infinity
			oBattleController.battle_turn = turn + 1;
		else return oBattleController.battle_turn - 1;
	}
	///Gets/Sets the State of the battle
	///@param {real} state	The state to set it to
	static State = function(state = infinity) {
		if state != infinity
			oBattleController.battle_state = state;
		else return oBattleController.battle_state;
	}
	///Sets the menu dialog of the battle
	///@param {string} text The Menu text
	static SetMenuDialog = function(text) {
		with oBattleController
		{
			__text_writer = scribble("* " + text);
			if __text_writer.get_page() != 0 __text_writer.page(0);
		}
	}
	///Sets the target board globally
	///@param {real} target	The ID of the target board
	static SetBoardTarget = function(target)
	{
		TargetBoard = target;
	}
	///Sets the target soul globally
	///@param {real} target	The ID of the target soul
	static SetSoulTarget = function(target)
	{
		TargetSoul = target;
	}
	/**
		This sets the dialog of the enemy
		@param {Asset.GMObject}	enemy	The enemy of the dialog is assigned to
		@param {real}	turn	The turn of the dialog to set to
		@param {string} text	The text of the dialog
	*/
	static EnemyDialog = function(enemy, turn, text) {
		with enemy
		{
			if !is_array(text) dialog_text[turn] = text;
			else dialog_text = text;
			dialog_init(dialog_text[oBattleController.battle_turn]);
		}
	}
}

///Sets the sprite of the buttons with external images
///@param {string} FileName	Folder name of the sprites (Default Normal)
///@param {string} Format	Format of the sprites (Default .png)
function ButtonSprites(fname = "Normal", format = ".png")
{
	for (var i = 0, buttons, ButtonNames = ["Fight", "Act", "Item", "Mercy"]; i < 4; ++i) {
		buttons[i] = sprite_add("./Sprites/Buttons/"+ fname + "/" + ButtonNames[i] + format, 2, 0, 0, 55, 21);
	}
	with oBattleController
	{
		Button.Sprites = buttons;
	}
}