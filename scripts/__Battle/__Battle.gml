///Battle data
function __Battle() constructor
{
	///Gets/Sets the turn of the battle
	///@param {real} turn The turn to set it to
	static Turn = function(turn = NaN) {
		if !is_nan(turn)
			oBattleController.battle_turn = turn + 1;
		else return oBattleController.battle_turn - 1;
	}
	///Gets/Sets the State of the battle
	///@param {real} state	The state to set it to
	static State = function(state = NaN) {
		if !is_nan(state)
			oBattleController.battle_state = state;
		else return oBattleController.battle_state;
	}
	///Sets the menu dialog of the battle
	///@param {string} text The Menu text
	static SetMenuDialog = function(text) {
		forceinline
		with oBattleController
			__text_writer = scribble("* " + text).page(0);
	}
	///Sets the target board globally
	///@param {real} target	The ID of the target board
	static SetBoardTarget = function(target)
	{
		forceinline
		TargetBoard = target;
	}
	///Sets the target soul globally
	///@param {real} target	The ID of the target soul
	static SetSoulTarget = function(target)
	{
		forceinline
		TargetSoul = target;
	}
	/**
		This sets the dialog of the enemy
		@param {Asset.GMObject}	enemy	The enemy of the dialog is assigned to
		@param {real}	turn	The turn of the dialog to set to
		@param {string} text	The text of the dialog
	*/
	static EnemyDialog = function(enemy, turn, text) {
		forceinline
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
	forceinline
	static ButtonNames = ["Fight", "Act", "Item", "Mercy"];
	for (var i = 0, buttons; i < 4; ++i) {
		buttons[i] = sprite_add("./Sprites/Buttons/" + fname + "/" + ButtonNames[i] + format, 2, 0, 0, 55, 21);
	}
	with oBattleController.Button
		Sprites = buttons;
}
///Draws the speech bubble
function DrawSpeechBubble(x, y, width, height, color, dir)
{
	aggressive_forceinline
	static SpikeSprite = sprSpeechBubbleSpike,
		SpikeWidth = sprite_get_width(SpikeSprite),
		SpikeHeight = sprite_get_height(SpikeSprite),
		CornerSprite = sprSpeechBubbleCorner,
		CornerWidth = sprite_get_width(CornerSprite),
		CornerHeight = sprite_get_height(CornerSprite),
		SpikeScaleAngle = [
			[-1, 1, 0],
			[-1, 1, 90],
			[1, 1, 0],
			[1, 1, 90],
		];
	//UDLR
	var CornerPosition = [y - height, y, x, x + width];
	for (var i = 0; i < 4; ++i) {
		draw_sprite_ext(CornerSprite, 0, CornerPosition[2 + (i % 2)], CornerPosition[i >= 2],
							(i % 2 ? -1 : 1), (i < 2 ? 1 : -1), 0, color, 1);
	}
	draw_set_color(c_black);
	draw_line_width(CornerPosition[2] + CornerWidth - 1, CornerPosition[0],
					CornerPosition[3] - CornerWidth, CornerPosition[0], 1);
	draw_line_width(CornerPosition[2] + CornerWidth - 1, CornerPosition[1] - 1,
					CornerPosition[3] - CornerWidth - 1, CornerPosition[1] - 1, 1);
	draw_line_width(CornerPosition[2], CornerPosition[0] + CornerHeight - 1,
					CornerPosition[2], CornerPosition[1] - CornerHeight, 1);
	draw_line_width(CornerPosition[3] - 1, CornerPosition[0] + CornerHeight - 1,
					CornerPosition[3] - 1, CornerPosition[1] - CornerHeight - 1, 1);
	var SpikePosition = [
			CornerPosition[3], CornerPosition[1] - SpikeHeight - 10,
			CornerPosition[2] + SpikeWidth + 10, CornerPosition[0],
			CornerPosition[2], CornerPosition[1] - SpikeHeight - 10,
			CornerPosition[3] - SpikeWidth - 10, CornerPosition[1],
		],
		FinalDirection = dir;
	draw_sprite_ext(SpikeSprite, 0, SpikePosition[FinalDirection * 2], SpikePosition[FinalDirection * 2 + 1],
					SpikeScaleAngle[FinalDirection][0], SpikeScaleAngle[FinalDirection][1],
					SpikeScaleAngle[FinalDirection][2], color, 1);
	//Fill ins
	draw_set_color(color);
	draw_rectangle(CornerPosition[2] + CornerWidth, CornerPosition[0] + 1,
					CornerPosition[3] - CornerWidth, CornerPosition[1] - 2, 0);
	draw_rectangle(CornerPosition[2] + 1, CornerPosition[0] + CornerHeight,
					CornerPosition[3] - 2, CornerPosition[1] - CornerHeight, 0);
	draw_set_color(c_white);
}