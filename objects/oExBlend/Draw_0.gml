if (keyboard_check_pressed(vk_left)) {
    mode = (mode + array_length(mode_names) - 1) % array_length(mode_names);
}
if (keyboard_check_pressed(vk_right)) {
    mode = (mode + 1) % array_length(mode_names);
}

draw_clear(c_black);

var surface_src = surface_create(640, 480);
surface_set_target(surface_src);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(sprSoul, 0, mouse_x, mouse_y, 1, 1, 0, c_blue, 1);
surface_reset_target();

draw_surface(surface_src, 0, 0);

var surface_dest = surface_create(640, 480);
surface_set_target(surface_dest);
draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_red, 1);
draw_sprite(sprGameOver, 0, 320, 240);
surface_reset_target();

shader_set(shdExBlending);
shader_set_uniform_i(shader_get_uniform(shdExBlending, "u_BlendMode"), self.mode);
texture_set_stage(shader_get_sampler_index(shdExBlending, "samp_dst"), surface_get_texture(surface_dest));
draw_surface(surface_src, 0, 0);
shader_reset();

surface_free(surface_src);
surface_free(surface_dest);