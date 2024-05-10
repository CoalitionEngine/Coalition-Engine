//Credits
if is_val(menu_state, INTRO_MENU_STATE.SETTINGS, INTRO_MENU_STATE.FIRST_TIME, INTRO_MENU_STATE.MENU)
{
	var credit_text = "UNDERTALE (C) TOBY FOX 2015-" + string(current_year);
		credit_text += "\nCoalition Engine " + __COALITION_ENGINE_VERSION + " by Cheetos Bakery";
	draw_text_scribble(320, 476, "[c_gray][fa_center][fa_bottom][fnt_cot]" + credit_text);
}