///@desc Effect
audio_play(snd_ding);
part_type_orientation(__SoulEffectType, image_angle + ExtraAngle, image_angle + ExtraAngle, 0, 0, 0);
part_particles_create_color(__SoulEffectSystem, x, y, __SoulEffectType, Blend, 1);
