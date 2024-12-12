shader_set(shd_Bloom);
shader_set_uniform_f(bloomIntensity, Bloom); //0 = off, 1 = a bit, 80 = extremely intense
shader_set_uniform_f(bloomblurSize, 1/512);
draw_surface(application_surface, 0, 0);
shader_reset();


//shader_set_uniform_f(bloomblurSize, ((window_mouse_get_x()-250)/1000)); // usually something like 1/512 (0.001)