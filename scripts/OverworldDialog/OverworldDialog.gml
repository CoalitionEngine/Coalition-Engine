///@category Overworld
///@title Dialog

///@func Overworld_CreateDialog(text, [font], [char_sound], [top_bottom], [sprite], [index])
///@desc Creates a dialog box in the Overworld
///@param {string} text The text in the box
///@param {string} font The font of the text (Default is dt_mono)
///@param {Asset.GMSound} char_sound The sound of the text (Default snd_txt_typer)
///@param {bool} top_bottom Decide whether the box is up or down (Default up)
///@param {Asset.GMSprite} sprite The sprite of the talking character
///@param {real} index The index of the sprite
function Overworld_CreateDialog(text, font = "fnt_dt_mono", char_sound = snd_txtTyper, top_bottom = false, sprite = noone, index = 0)
{
	aggressive_forceinline
	global.__CoalitionDialogEnableTextSkipping = true;
	var dis = 0;
	with (oOWController)
	{
		//Sets the character talking sprite if is given
		Overworld_DialogSprite(sprite, index);
		__dialog_at_option = false;
		__dialog_typist = scribble_typist()
			.in(0.5, 0)
			.sound_per_char(char_sound, 1, 1, " ^!.?,:/\\|*");
		
		__text_writer = scribble(text, "__Coalition_Overworld").starting_format(font, c_white).page(0);
		
		__dialog_text = text;
		__dialog_at_bottom = top_bottom;
		__dialog_exists = true;
	}
}
///@func Overworld_SetOptionEvents(option_1, option_2)
///@desc Sets events of each function
///@param {function} option_1 Functions for the first option
///@param {function} option_2 Functions for the second option
function Overworld_SetOptionEvents(option_1, option_2)
{
	forceinline
	var i = 0;
	repeat (argument_count)
	{
		oOWController.__option_events[i] = argument[i];
		++i;
	}
}
///@desc Checks whether a dialog exists in the overworld
function Overworld_DialogExists() {
	forceinline
	return oOWController.__dialog_exists;
}
///@desc Checks whether a dialog is at a point of an option
function Overworld_DialogAtOption() {
	forceinline
	return oOWController.__dialog_at_option;
}
///@desc Gets/Sets the sprite and index of the sprite displayed in during a dialog
///@param {GMAsset.Sprite} sprite	The sprite to set
///@param {real} index				The index of the sprite
function Overworld_DialogSprite(sprite, index = 0) {
	forceinline
	if (!is_undefined(sprite))
	{
		oOWController.__dialog_sprite = sprite;
		oOWController.__dialog_sprite_index = index;
	}
	else
		return oOWController.__dialog_sprite;
}
///@text ## Text formatting
///Since the text writer in this engine is based on [Scribble](https://github.com/JujuAdams/Scribble), the text formatting also follows the format of Scribble.
///Here are the list of command tags that are exclusive on this engine, for furhter information, you should read the documentation of Scribble.
///These command tags are defined in (System)/Scripts/Scribble_Events
///
///| Command Tag | Behaviour |
///| ------ | ------ |
///| `[skippable]` | Whether the current text can be skipped or not |
///| `[end]` | Forcefully end the current overworld dialog |
///| `[SpriteSet]` | Changes the sprite of the enemy if you are using the built in enemy drawing system |
///| `[flash]` | Flashes the screen to black/flash back |
///| `[to_save]` | Sets the current overworld state to saving (Only call this in Save Points) |
///| `[format_option]` | Formats the following text for option |
///| `[option,<option_number>]` | Sets the following text as the defined option |
///
///The following are text macros that acts as a shortcut for already built-in functions
///
///| Macros | Behaviour |
///| ------ | ------ |
///| `[fdelay,<frames>]` | Delays the typewriter by the given number of frames, not milliseconds as set in [delay] |
///| `[frame_delay,<frames>]` | Same as above |
///| `[delay_frame,<frames>]` | Same as above |
///| `[clear]` | Clears the current textbox |
///| `[voice,<sound>,<pitch>]` | Changes the current voice per character |