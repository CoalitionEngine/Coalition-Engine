///@category Battle
///@title General Battle Functions
///@text Below are the functions that are used in battle, to call these functions, simply use `Battle.XXX()`

///@constructor
///@func __Battle()
///@desc Battle data
function __Battle() constructor
{
	///@method Turn([turn])
	///@desc Gets/Sets the turn of the battle
	///@param {real} turn The turn to set it to
	static Turn = function(turn = NaN) {
		forceinline
		if !is_nan(turn)
			oBattleController.battle_turn = turn + 1;
		else return oBattleController.battle_turn - 1;
	}
	///@method State([state])
	///@desc Gets/Sets the State of the battle
	///@param {real} state The state to set it to
	static State = function(state = NaN) {
		forceinline
		if !is_nan(state)
			oBattleController.battle_state = state;
		else return oBattleController.battle_state;
	}
	///@method SetMenuDialog(text)
	///@desc Sets the menu dialog of the battle
	///@param {string} text The Menu text
	///@param {bool} no_asterisk Whether there is an asterisk in front of the dialog (Default false)
	static SetMenuDialog = function(text, no_asterisk = false) {
		forceinline
		with oBattleController
		{
			__menu_text = text;
			if !no_asterisk text = "* " + text;
			__text_writer = scribble(text, "__Coalition_Battle").starting_format(DefaultFontNB, c_white).page(0);
		}
	}
	///@method SetBoardTarget(target)
	///@desc Sets the target board globally
	///@param {real} target The ID of the target board
	static SetBoardTarget = function(target)
	{
		forceinline
		TargetBoard = target;
	}
	///@method SetSoulTarget(target)
	///@desc Sets the target soul globally
	///@param {real} target The ID of the target soul
	static SetSoulTarget = function(target)
	{
		forceinline
		TargetSoul = target;
	}
	///@method EnemyDialog(enemy, turn, text)
	///@desc This sets the dialog of the enemy
	///@param {Asset.GMObject} enemy The enemy of the dialog is assigned to
	///@param {real} turn The turn of the dialog to set to
	///@param {string} text The text of the dialog
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

///@func ButtonSprites([file_name], [format], [width], [height])
///@desc Sets the sprite of the buttons with external images
///@param {string} FileName Folder name of the sprites (Default Normal)
///@param {string} Format Format of the sprites (Default .png)
///@param {real} width The width of the button (Default 55)
///@param {real} height The height of the button (Default 21)
function ButtonSprites(fname = "Normal", format = ".png", width = 55, height = 21)
{
	forceinline
	static ButtonNames = ["Fight", "Act", "Item", "Mercy"];
	for (var i = 0, buttons = array_create(4); i < 4; ++i) {
		buttons[i] = sprite_add("./Sprites/Buttons/" + fname + "/" + ButtonNames[i] + format, 2, 0, 0, width, height);
	}
	oBattleController.Button.Sprites = buttons;
}
///@text > You can use imported images for changing button sprites as well

///@func DrawSpeechBubble(x, y, width, height, color, direction, [color_line], [spike_sprite], [corner_sprite])
///@desc Draws the speech bubble
///@param {real} x The x coordinate of the spike of the bubble
///@param {real} y The y coordinate of the spike of the bubble
///@param {real} width The width of the speech bubble
///@param {real} height The height of the speech bubble
///@param {real} color The color of filling of the bubble
///@param {real} direction The direction of the bubble
///@param {Constant.Color} color_line The color of the outline of the speech bubble (Default c_black)
///@param {Asset.GMSprite} spike_sprite The sprite of the spike of the speech bubble
///@param {Asset.GMSprite} corner_sprite The sprite of the corner of the speech bubble
function DrawSpeechBubble(x, y, width, height, color, dir, line_color = c_black, spike_sprite = sprSpeechBubbleSpike, corner_sprite = sprSpeechBubbleCorner)
{
	aggressive_forceinline
	static SpikeScaleAngle = [[-1, 1, 0], [-1, 1, 90], [1, 1, 0], [1, 1, 90]];
	//UDLR
	var SpikeSprite = sprSpeechBubbleSpike,
		SpikeWidth = sprite_get_width(spike_sprite),
		SpikeHeight = sprite_get_height(spike_sprite),
		CornerSprite = sprSpeechBubbleCorner,
		CornerWidth = sprite_get_width(corner_sprite),
		CornerHeight = sprite_get_height(corner_sprite),
		CornerPosition = [y - height, y, x, x + width];
	for (var i = 0; i < 4; ++i)
		draw_sprite_ext(CornerSprite, 0, CornerPosition[2 + (i % 2)], CornerPosition[i >= 2],
							(i % 2 ? -1 : 1), (i < 2 ? 1 : -1), 0, c_white, 1);
	var prev_col = draw_get_color();
	draw_set_color(line_color);
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
					SpikeScaleAngle[FinalDirection][2], c_white, 1);
	//Fill inside
	draw_set_color(color);
	draw_rectangle(CornerPosition[2] + CornerWidth, CornerPosition[0] + 1,
					CornerPosition[3] - CornerWidth, CornerPosition[1] - 2, false);
	draw_rectangle(CornerPosition[2] + 1, CornerPosition[0] + CornerHeight,
					CornerPosition[3] - 2, CornerPosition[1] - CornerHeight, false);
	draw_set_color(prev_col);
}