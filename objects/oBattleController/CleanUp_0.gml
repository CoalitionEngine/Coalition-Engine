///@desc Unloads everything
delete Result;
delete Effect;
delete Target;
delete Aim.Attack;
delete Aim;
delete Button;
delete ui;
texturegroup_unload("texbattle");
audio_group_unload(audgrpbattle);
__menu_text_typist.reset();