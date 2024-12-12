///@category Overworld
///@title BGM
///@text These scripts are used for creating cutscenes in the overworld

///@func LoadBGM(bgm)
///@desc Loads the bgm into the system for playback
///@param {string,Asset.GMAudio} bgm The bgm to load, can be an audio file, or the name of the audio file, or the name of the path to the audio file
function LoadBGM(bgm)
{
	forceinline
	oOWController.BGMStream = false;
	if audio_exists(bgm)
		oOWController.BGM = bgm;
	else
	{
		if audio_exists(asset_get_index(bgm))
			oOWController.BGM = asset_get_index(bgm);
		else
		{
			oOWController.BGMStream = audio_create_stream(bgm);
			oOWController.BGMStream = true;
		}
	}
}
///@func PlayBGM()
///@desc Plays the stored BGM in the system
function PlayBGM()
{
	forceinline
	oOWController.Audio = audio_play(oOWController.BGM, true, true);
}
///@func StopBGM()
///@desc Stops the stored BGM in the system
function StopBGM()
{
	forceinline
	audio_stop_sound(oOWController.Audio);
}
///@func GetBGM()
///@desc Gets the bgm stored in the system
///@returns {Id.Sound} The bgm stored in system
function GetBGM()
{
	forceinline
	return oOWController.Audio;
}
///@text > You can use `GetBGM` to get the audio id of the bgm and do some audio effects like looping, fading etc using the audio_* functions.