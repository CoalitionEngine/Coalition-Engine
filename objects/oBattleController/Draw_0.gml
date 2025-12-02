var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;
with (oBoard)
	__DrawBackground();
with (oVertexBoard)
	__DrawBackground();
draw_set_font(__DefaultFontAsset);
draw_set_color(c_white);
//Renders spared enemies
var i = 0, _spared_surf = __spared_enemies_surfaces;
repeat (array_length(_spared_surf))
	draw_surface(_spared_surf[i++], 0, 0);
// Text Functions
if (__battle_state == BATTLE_STATE.MENU)
{
	if (__menu_state == BATTLE_MENU_STATE.BUTTON_SELECTION || __menu_state == BATTLE_MENU_STATE.UNDEFINED)
	{
		//Initalize menu text typer
		__text_writer.draw(52, 272, __menu_text_typist);
		//Set the skip function of the menu text typer
		if (input_cancel && global.__CoalitionDialogEnableTextSkipping && !__menu_text_typist.get_paused())
			__menu_text_typist.skip_to_pause();
		if (__menu_text_typist.get_paused() && input_confirm)
			__menu_text_typist.unpause();
		//Proceed page
		if (__menu_text_typist.get_state() == 1 && __text_writer.get_page() < (__text_writer.get_page_count() - 1))
			__text_writer.page(__text_writer.get_page() + 1);
		//Begin turn if the dialog ended
		if (__menu_state == BATTLE_MENU_STATE.UNDEFINED && __menu_text_typist.get_state() == 1 && input_confirm)
		{
			struct_set_from_hash(__input_functions, __press_con_hash, false);
			Battle.SetMenuDialog(__menu_text, !__has_asterisk);
			__begin_turn();
		}
	}
	else if (struct_exists(Battle.__defined_states, __menu_state))
		Battle.__defined_states[$ __menu_state].Draw();
}
//Battle result text drawing
else if (__battle_state == BATTLE_STATE.RESULT)
{
	if (!global.__BossFight)
	{
		__battle_end_text_writer.draw(52, 272, __battle_end_text_typist);

		if (input_cancel)
		{
			__battle_end_text_writer.page(__battle_end_text_writer.get_page_count() - 1);
			__battle_end_text_typist.skip_to_pause();
		}
		if (__battle_end_text_typist.get_paused() && input_confirm)
			__battle_end_text_typist.unpause();
		if (__battle_end_text_typist.get_state() == 1 && __battle_end_text_writer.get_page() < (__battle_end_text_writer.get_page_count() - 1))
			__battle_end_text_writer.page(__battle_end_text_writer.get_page() + 1);
		if (__battle_end_text_typist.get_state() == 1 && input_confirm)
			__ExitFight();
	}
	else if (oGlobal.__fader_alpha == 1)
		__ExitFight();
}

#region Debug
DrawDebugUI();
#endregion
#region Render
//Order of drawing needs to be changed if only either is beneath while the other is not
struct_foreach(Battle.__defined_buttons, function(_name, _value) {
	if (oBattleController.UI.BeneathBoard || _value.BeneathBoard)
		_value.Draw();
});
Battle_Masking_Start();
struct_foreach(Battle.__defined_buttons, function(_name, _value) {
	with (_value)
		if (BeneathBoard)
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, 1);
});
with (oBoard)
	if (!VertexMode)
		draw_surface(__frame_surf, 0, 0);
Battle_Masking_End();
__DrawUI();
if (UI.BeneathBoard)
{
	Battle_Masking_Start();
	__DrawUI(c_black);
	Battle_Masking_End();
	with (oBoard)
		if (!VertexMode)
			draw_surface(__frame_surf, 0, 0);
}
struct_foreach(Battle.__defined_buttons, function(_name, _value) {
	if (oBattleController.UI.BeneathBoard || !_value.BeneathBoard)
		_value.Draw();
});
//Renders the bullets on screen
__RenderBullets();
#endregion
//Debug timer
if (global.__CoalitionDebug && __battle_state == BATTLE_STATE.IN_TURN)
{
	draw_set_color(c_white);
	draw_set_halign(fa_right);
	var i = 0, str = "";
	repeat (instance_number(oEnemyParent))
		str += string_concat("Time: ", instance_find(oEnemyParent, i++).time, "\n");
	draw_text(640, 10, str);
	draw_set_halign(fa_left);
}