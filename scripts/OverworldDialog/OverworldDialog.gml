/**
	Creates a dialog box in the Overworld
	@param {string} text				The text in the box
	@param {string} font				The font of the text (Default is dt_mono)
	@param {Asset.GMSound}  char_sound	The sound of the text (Default snd_txt_typer)
	@param {bool} top_bottom			Decide whether the box is up or down (Default up)
	@param {Asset.GMSprite} sprite		The sprite of the talking character
	@param {real} index					The index of the sprite
*/
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
		__text_writer = scribble(text).page(0);
		
		dialog_text = text;
		dialog_is_down = top_bottom;
		dialog_exists = true;
	}
}