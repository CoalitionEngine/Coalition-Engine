//Apply bloom shader, you may remove this
shader_set(shd_Bloom);
shader_set_uniform_f(__bloomIntensity, dsin(global.timer * 3) * 0.2 + 0.8);
shader_set_uniform_f(__bloomblurSize, 1 / display_get_width());
draw_self();
shader_reset();