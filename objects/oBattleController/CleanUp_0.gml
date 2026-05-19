///@desc Unloads everything
//Unload battle structs
delete __Result;
delete Effect;
delete Target;
delete __Aim.Attack;
delete __Aim;
delete Button;
delete UI;
//Unload battle assets
texturegroup_unload("texbattle");
audio_group_unload(audgrpbattle);
//Reset camera
TweenDestroy(all);
Camera.Init();