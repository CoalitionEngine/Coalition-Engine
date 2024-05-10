shader_set(shdGaussianBlur);
shader_set_uniform_f(uni_size, 640, 480, var_blur_amount);
draw_surface(application_surface, 0, 0);
shader_reset();
