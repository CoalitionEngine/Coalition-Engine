///@desc Effect
audio_play(snd_ding);
part_type_orientation(EffectT, image_angle + draw_angle, image_angle + draw_angle, 0, 0, 0);
part_particles_create_color(EffectS, x, y, EffectT, Blend, 1);
