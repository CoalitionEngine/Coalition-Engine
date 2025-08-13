///@desc Unloads everything
delete __Result;
delete Effect;
delete Target;
delete __Aim.Attack;
delete __Aim;
delete Button;
delete UI;
texturegroup_unload("texbattle");
audio_group_unload(audgrpbattle);
scribble_flush_everything();