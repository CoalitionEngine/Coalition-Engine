texturegroup_unload("texoverworld");
audio_group_unload(audgrpoverworld);
Camera.SetPos(0, 0);
delete __CameraLockPositions;
ds_list_destroy(RoomNames);
ds_list_destroy(__cutscene_events);
if (__OverworldBGMStream)
	audio_destroy_stream(__OverworldBGM);
if (audio_exists(__OverworldAudio) && audio_is_playing(__OverworldAudio))
	audio_stop_sound(__OverworldAudio);