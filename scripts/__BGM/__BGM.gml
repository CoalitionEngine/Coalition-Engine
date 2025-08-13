///@category Overworld
///@title BGM
///@text These scripts are used for creating cutscenes in the overworld

///@func LoadBGM(bgm)
///@desc Loads the bgm into the system for playback
///@param {string,Asset.GMAudio} bgm The bgm to load, can be an audio file, or the name of the audio file, or the name of the path to the audio file
function LoadBGM(bgm)
{
	forceinline
	oOWController.__OverworldBGMStream = false;
	if (audio_exists(bgm))
		oOWController.__OverworldBGM = bgm;
	else
	{
		if (audio_exists(asset_get_index(bgm)))
			oOWController.__OverworldBGM = asset_get_index(bgm);
		else
		{
			oOWController.__OverworldBGMStream = audio_create_stream(bgm);
			oOWController.__OverworldBGMStream = true;
		}
	}
}
///@func PlayBGM()
///@desc Plays the stored BGM in the system
function PlayBGM()
{
	forceinline
	oOWController.__OverworldAudio = audio_play(oOWController.__OverworldBGM, true, true);
}
///@func StopBGM()
///@desc Stops the stored BGM in the system
function StopBGM()
{
	forceinline
	audio_stop_sound(oOWController.__OverworldAudio);
}
///@func GetBGM()
///@desc Gets the bgm stored in the system
///@returns {Id.Sound} The bgm stored in system
function GetBGM()
{
	forceinline
	return oOWController.__OverworldAudio;
}
///@text > You can use `GetBGM` to get the audio id of the bgm and do some audio effects like looping, fading etc using the audio_* functions.