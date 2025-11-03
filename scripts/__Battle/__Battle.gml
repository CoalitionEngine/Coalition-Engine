///@category Battle
///@title General Battle Functions
///@text Below are the functions that are used in battle, to call these functions, simply use `Battle.XXX()`

///@constructor
///@func __Battle()
///@desc Battle data
function __Battle() constructor
{
	__defined_states = {};
	///@method DefineMenuState(state, step, draw)
	///@desc Defines a state for the battle menu
	///@param {real} state The state to define (Preferably COALITION_BATTLE_CUSTOM_STATE)
	///@param {Function} step The function for step logic (Default empty function)
	///@param {Function} draw The function for draw logic (Default empty function)
	static DefineMenuState = function(state, Step = COALITION_EMPTY_FUNCTION, Draw = COALITION_EMPTY_FUNCTION)
	{
		forceinline
		__defined_states[$ state] = {Step, Draw};
		return Battle;
	}
	///@method StateGetButton(state)
	///@desc Gets the button that leads to the defined state
	///@param {real} state The state to check
	///@returns {real,undefined} The index of the button that leads to the state (undefined if the state is not linked)
	static StateGetButton = function(state)
	{
		var i = 0;
		repeat (array_length(oBattleController.Button.TargetState))
		{
			if (oBattleController.Button.TargetState[i] == state)
				return i;
			else
				i++;
		}
		return undefined;
	}
	///@method Turn([turn])
	///@desc Gets/Sets the turn of the battle
	///@param {real} turn The turn to set it to
	static Turn = function(turn = NaN) {
		forceinline
		if (!is_nan(turn))
		{
			oBattleController.__battle_turn = turn + 1;
			return self;
		}
		else
			return oBattleController.__battle_turn - 1;
	}
	///@method State([state])
	///@desc Gets/Sets the state of the battle
	///@param {real} state The state to set it to
	static State = function(state = NaN) {
		forceinline
		if (!is_nan(state))
		{
			oBattleController.__battle_state = state;
			return self;
		}
		else
			return oBattleController.__battle_state;
	}
	///@method MenuState([state])
	///@desc Gets/Sets the menu state of the battle menu
	///@param {real} state The state to set it to
	static MenuState = function(state = NaN) {
		forceinline
		if (!is_nan(state))
		{
			oBattleController.__menu_state = state;
			return self;
		}
		else
			return oBattleController.__menu_state;
	}
	///@method SetMenuDialog(text)
	///@desc Sets the menu dialog of the battle
	///@param {string} text The Menu text
	///@param {bool} no_asterisk Whether there is an asterisk in front of the dialog (Default false)
	///@param {bool} immediate Whether the menu dialog is applied instantly or will apply in the next iteration (Default true)
	static SetMenuDialog = function(text, no_asterisk = false, immediate = true) {
		forceinline
		with (oBattleController)
		{
			__menu_text = text;
			if (!no_asterisk)
				text = "* " + text;
			if (immediate)
				__text_writer.overwrite(__menu_text);
		}
		return self;
	}
	///@method SetBoardTarget(target)
	///@desc Sets the target board globally
	///@param {real} target The ID of the target board
	static SetBoardTarget = function(target)
	{
		forceinline
		TargetBoard = target;
		return self;
	}
	///@method SetSoulTarget(target)
	///@desc Sets the target soul globally
	///@param {real} target The ID of the target soul
	static SetSoulTarget = function(target)
	{
		forceinline
		TargetSoul = target;
		return self;
	}
	///@method EnemyDialog(enemy, turn, text)
	///@desc This sets the dialog of the enemy
	///@param {Asset.GMObject} enemy The enemy of the dialog is assigned to
	///@param {real} turn The turn of the dialog to set to
	///@param {string} text The text of the dialog
	static EnemyDialog = function(enemy, turn, text) {
		forceinline
		with (enemy)
		{
			if (!is_array(text))
				__dialog_text[turn] = text;
			else
				__dialog_text = text;
			ParseDialog(__dialog_text[oBattleController.__battle_turn]);
		}
		return self;
	}
	///@method SetButtonActivateTurn(button, activate)
	///@desc Sets whether the button will activate a turn
	///@param {real} button The button to set (0-> Fight; 1-> Act; etc.)
	///@param {bool} activate Whether the button will activate the turn or not
	static SetButtonActivateTurn = function(button, activate) {
		forceinline;
		if ((oBattleController.__button_choice_activate_turn & quick_pow(2, button)) != activate)
			oBattleController.__button_choice_activate_turn ^= quick_pow(2, button);
		return self;
	}
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