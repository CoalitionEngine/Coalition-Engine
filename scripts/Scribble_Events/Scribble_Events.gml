///Set whether the text is skippable in dialogs
function textsetskippable(_element, _parameter_array, _character_index)
{
	global.TextSkipEnabled = _parameter_array[0];
}
///Sets current ememy sprite index (engine internal, fix soon)
function setsprite(_element, _parameter_array, _character_index)
{
	if instance_exists(oBattleController)
	{
		//Enemy name, Enemy sprite number, target image index
		var enemy = asset_get_index(_parameter_array[0]);
		if instance_exists(enemy)
			enemy.enemy_sprite_index[_parameter_array[1]] = _parameter_array[2];
	}
}
///Flashes the screen in dialog
function flash(_element, _parameter_array, _character_index)
{
	with oGlobal
		fader_alpha = !fader_alpha;
	if _parameter_array[0] audio_play(snd_noise);
}
///A demostration on beginning an encounter in dialog
function sansfightstart()
{
	oOWPlayer.Encounter_Begin();
}

function ToSaveState()
{
	with oOWController
	{
		save_state = SAVE_STATE.CHOOSING;
		dialog_exists = false;
		dialog_typist.reset();
	}
}
///Ends the current dialog
function enddialog(_element, _parameter_array, _character_index)
{
	oOWController.dialog_exists = false;
}