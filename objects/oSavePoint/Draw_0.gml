if collision_rectangle(x - 7, y - 7, x + 7, y + 7, oOWPlayer, 1, 1) &&
	oOWController.save_state == SAVE_STATE.NOT_SAVING && CheckConfirm()
{
	Collided = true;
	OverworldDialog("You are filled with...\n[delay,333]  DETERMINATION[pause][to_save]");
	oOWController.save_state = SAVE_STATE.DISPLAY_DIALOG;
	oOWController.menu_disable = true;
}
shader_set(shd_Bloom);
shader_set_uniform_f(bloomIntensity, dsin(global.timer * 3) * 0.2 + 0.8);
shader_set_uniform_f(bloomblurSize, 1 / display_get_width());
draw_self();
shader_reset();