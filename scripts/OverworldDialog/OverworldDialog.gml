///@category Overworld
///@title Dialog

///@func OverworldDialog(text, [font], [char_sound], [top_bottom], [sprite], [index])
///@desc Creates a dialog box in the Overworld
///@param {string} text The text in the box
///@param {string} font The font of the text (Default is dt_mono)
///@param {Asset.GMSound} char_sound The sound of the text (Default snd_txt_typer)
///@param {bool} top_bottom Decide whether the box is up or down (Default up)
///@param {Asset.GMSprite} sprite The sprite of the talking character
///@param {real} index The index of the sprite
function OverworldDialog(text, font = "fnt_dt_mono", char_sound = snd_txtTyper, top_bottom = false, sprite = noone, index = 0)
{
	aggressive_forceinline
	var dis = 0;
	with oOWController
	{
		//Sets the character talking sprite if is given
		dialog_sprite = sprite;
		if sprite != noone
		{
			dis = 40;
			dialog_sprite_index = index;
		}
		dialog_option = false;
		dialog_font = font;
		dialog_typist = scribble_typist()
			.in(0.5, 0)
			.sound_per_char(char_sound, 1, 1, " ^!.?,:/\\|*");
		
		var dialog_width = 580, dialog_height = 150;
		__text_writer = scribble(text, "__Coalition_Overworld").starting_format(dialog_font, c_white).page(0);
		
		dialog_text = text;
		dialog_is_down = top_bottom;
		dialog_exists = true;
	}
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