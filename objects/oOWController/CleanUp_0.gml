texturegroup_unload("texoverworld");
audio_group_unload(audgrpoverworld);
Camera.SetPos(0, 0, 0);
ds_list_destroy(CameraLockPositions);
ds_list_destroy(RoomNames);