texturegroup_unload("texoverworld");
audio_group_unload(audgrpoverworld);
Camera.SetPos(0, 0, 0);
delete CameraLockPositions;
ds_list_destroy(RoomNames);
if BGMStream audio_destroy_stream(BGM);
audio_stop_sound(Audio);