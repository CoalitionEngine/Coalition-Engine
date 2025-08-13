///Set whether the text is skippable in dialogs
function __CoalitionSetTextSkippable(_element, _parameter_array, _character_index)
{
	global.__CoalitionDialogEnableTextSkipping = _parameter_array[0];
}
///Sets current ememy sprite index (engine internal, fix soon)
function __CoalitionSetEnemySprite(_element, _parameter_array, _character_index)
{
	if (instance_exists(oBattleController))
	{
		//Enemy name, Enemy sprite number, target image index
		var enemy = asset_get_index(_parameter_array[0]);
		if (instance_exists(__enemies))
			enemy.__enemy_sprite_index[_parameter_array[1]] = _parameter_array[2];
	}
}
///Flashes the screen in dialog
function __CoalitionFlashScreen(_element, _parameter_array, _character_index)
{
	with (oGlobal)
		__fader_alpha = !__fader_alpha;
	if (_parameter_array[0])
		audio_play(snd_noise);
}
///A demostration on beginning an encounter in dialog
function sansfightstart()
{
	oOWPlayer.Encounter_Begin();
}
///Sets the overworld state to saving state
function __CoalitionToSaveState()
{
	with (oOWController)
	{
		__save_state = SAVE_STATE.CHOOSING;
		__dialog_exists = false;
		__dialog_typist.reset();
	}
}
///Ends the current dialog
function __CoalitionEndDialog(_element, _parameter_array, _character_index)
{
	oOWController.__dialog_exists = false;
}
///Sets the scribble text delay as frames instead of milliseconds
function __CoalitionSetFrameDelay(delay)
{
	return string_concat("[delay,", floor(delay / 60 * 1000), "]");
}
///Clears the text box (literally just [/page])
function __CoalitionClearTextbox()
{
	return "[/page]";
}
///Changes the current text typer voice (Both strings)
function __CoalitionChangeTextVoice(voice, pitch)
{
	return "[typistSoundPerChar," + voice + "," + pitch + "," + pitch + "," + " ]";
}
///Sets the followinjg text as an option
function __CoalitionSetOption(_element, _parameter_array, _character_index) {
	with (oOWController)
	{
		__dialog_at_option = true;
		var index = real(_parameter_array[0]),
		glyph_data = __text_writer.get_glyph_data(_character_index),
			left = glyph_data.left,
			middle = (glyph_data.top + glyph_data.bottom) * 0.5;
		__dialog_option_pos[# index, 0] = left;
		__dialog_option_pos[# index, 1] = middle;
		__dialog_option_amount = max(__dialog_option_amount, index + 1);
		if (ds_grid_width(__dialog_option_pos) <= __dialog_option_amount)
			ds_grid_resize(__dialog_option_pos, __dialog_option_amount, 2);
		__option_buffer = 20;
		__option = 0;
	}
}
///Formats text for option
function __CoalitionFormatOptionText(_element, _parameter_array, _character_index)
{
	var height = string_height_scribble("[zwsp]"),
		dialog_y = (__dialog_at_bottom ? 320 : 10) + 110,
		curBottom = __text_writer.get_glyph_data(_character_index).bottom,
		diff = dialog_y - curBottom - string_height_scribble("\n");
	with (oOWController)
	{
		__dialog_option_text_height = string(diff / height);
		__dialog_text = string_replace(__dialog_text, "[format_option]", "\n[scale," + __dialog_option_text_height + "][zwsp]\n[fdelay,30][scale,1]	");
		__text_writer.overwrite(__dialog_text);
	}
}
//Adds scribble typists events
scribble_typists_add_event("skippable", __CoalitionSetTextSkippable);
scribble_typists_add_event("set_sprite", __CoalitionSetEnemySprite);
scribble_typists_add_event("flash", __CoalitionFlashScreen);
scribble_typists_add_event("to_save", __CoalitionToSaveState);
scribble_typists_add_event("end", __CoalitionEndDialog);
scribble_typists_add_event("option", __CoalitionSetOption);
scribble_typists_add_event("format_option", __CoalitionFormatOptionText);
//Add scribble text macros
scribble_add_macro("fdelay", __CoalitionSetFrameDelay);
scribble_add_macro("frame_delay", __CoalitionSetFrameDelay);
scribble_add_macro("delay_frame", __CoalitionSetFrameDelay);
scribble_add_macro("clear", __CoalitionClearTextbox);
scribble_add_macro("voice", __CoalitionChangeTextVoice);