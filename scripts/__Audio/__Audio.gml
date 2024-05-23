/**
	Plays the audio with chosen volume and pitch
	@param {Asset.GMSound} soundid	The ID of the sound (i.e. snd_hurt)
	@param {bool} single			If the same sound is played, that sound will be stopped and this one will play instead (Default False)
	@param {bool} loops				Whether the audio loops
	@param {real} volume			The volume of the audio (Max 1, Min 0, Default 1)
	@param {real} pitch				The pitch of the audio (Default 1)
	@param {real} time				The time taken for the audio to change it's volume (In Miliseconds, Default 0)
	@param {real} position			The position to play the audio in seconds (Not 3D position, audio position)
*/
function audio_play(soundid, single = false, loops = false, volume = 1, pitch = 1, time = 0, position = 0)
{
	forceinline
	if single audio_stop_sound(soundid);
	var audio = audio_play_sound(soundid, 1, loops, volume, 0, pitch);
	audio_sound_gain(audio, volume, time);
	if position != 0 audio_sound_set_track_position(audio, position);
	return audio;
}

/**
	Sticks the audio to given time (in seconds, so you have to do divide frame by 60)
	@param {Asset.GMSound} Audio		The audio to stick
	@param {real} Time				The target time to set the audio with
	@param {real} Margin				The margin of error of the audio, Default 0.05 sec / 3 frames
*/
function AudioStickToTime(aud, time, margin = 3/60)
{
	forceinline
	if abs(audio_sound_get_track_position(aud) - time) >= margin
		audio_sound_set_track_position(aud, time);
}


///@desc Creates an array of audios from audio_create_stream(), arguments are all strings, no folder name and file format needed
///@return {Array<Asset.GMSound>}
function audio_create_stream_array()
{
	forceinline
	for(var i = 0, arr = []; i < argument_count; ++i)
	{
		//Only pushes the array if file exists
		var text = $"Music/{argument[i]}.ogg";
		array_push(arr, audio_create_stream(text));
	}
	return arr;
}
///@desc Destroys all audio that were streams in the array then remove the array
///@param {Array<Asset.GMSound>} array	The array of streamed audio to destroy
function audio_destroy_stream_array(arr)
{
	forceinline
	var i = 0;
	repeat array_length(arr) audio_stream_destroy(arr[i++]);
	arr = -1;
}

/**
	Transitions an audio to another using fade in/out
	@param {Asset.GMSound}	Inital audio	The playing audio to fade out
	@param {Asset.GMSound}	Target audio	The upcoming audio to fade in
	@param {real} Duration	The duration of the fading
	@param {bool} single	If the same sound is played, that sound will be stopped and this one will play instead (Default False)
	@param {bool} loops		Whether the audio loops
	@param {real} volume	The volume of the audio (Max 1, Min 0, Default 1)
	@param {real} pitch		The pitch of the audio (Default 1)
	@param {real} position	The position to play the audio in seconds (Not 3D position, audio position)
*/
function audio_transition(init_aud, target_aud, time, single = false, loop = false, volume = 1, pitch = 1, position = 0)
{
	forceinline
	if !audio_is_playing(init_aud) && __COALITION_VERBOSE
		show_debug_message("The audio is not playing");
	else audio_sound_gain(init_aud, 0, time);
	return audio_play(target_aud, single, loop, volume, pitch, time, position);
}