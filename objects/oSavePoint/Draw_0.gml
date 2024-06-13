shader_set(shd_Bloom);
shader_set_uniform_f(bloomIntensity, dsin(global.timer * 3) * 0.2 + 0.8);
shader_set_uniform_f(bloomblurSize, 1 / display_get_width());
draw_self();
shader_reset();