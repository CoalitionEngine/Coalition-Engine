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
var i = 0;
repeat (array_length(__spared_enemies_surfaces))
	draw_surface(__spared_enemies_surfaces[i++], 0, 0);
// Text Functions
if (__battle_state == BATTLE_STATE.MENU)
{
	if (__menu_state == MENU_STATE.BUTTON_SELECTION || __menu_state == MENU_STATE.UNDEFINED)
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
		if (__menu_state == MENU_STATE.UNDEFINED && __menu_text_typist.get_state() == 1 && input_confirm)
		{
			struct_set_from_hash(global.__input_functions, global.__press_con_hash, false);
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

#region Buttons
if (!is_struct(Button)) exit;
with (Button)
{
	var _button_spr =	Sprites,
		_button_pos =	Position,
		_button_alpha = Alpha,
		_button_scale = Scale,
		_button_color = Color,
		_button_angle = Angle;
}
var i = 0, n = array_length(_button_spr);

if (Button.BackgroundCover)
{
	shader_set(shdBlackMask); //Prevent background covers the buttons
	repeat (n) // Button initialize
	{
		// Check if the button is chosen
		var select = (__menu_button_choice == i) && __menu_state >= 0;
		// Draw the button by array order
		draw_sprite_ext(_button_spr[i], select, _button_pos[i * 2], _button_pos[i * 2 + 1], _button_scale[i], _button_scale[i], _button_angle[i], merge_color(c_white, c_black, .5 - _button_alpha[i] / 2)	, 1);
	}
	shader_reset();
}
repeat (n)
{
	var select = (__menu_button_choice == i) && __menu_state >= 0;
	draw_sprite_ext(_button_spr[i], select, _button_pos[i * 2], _button_pos[i * 2 + 1], _button_scale[i], _button_scale[i], _button_angle[i], _button_color[i], 1);

	// Animation - Color updating in real-time because yes
	if (__menu_state < 0) // If the menu state is over
	{
		var final_alpha = min(Button.AlphaTarget[1], Button.OverrideAlpha[i]);
		_button_scale[i] += (Button.ScaleTarget[0] - _button_scale[i]) / 6;
		_button_alpha[i] += (final_alpha - _button_alpha[i]) / 6;
	}
	++i;
}
//Draws a rectangle to cover the button in the board if needed
if (Button.BeneathBoard)
{
	Battle_Masking_Start();
	draw_sprite_ext(sprPixel, 0, 23, 432, 617, 48, 0, c_black, 1);
	Battle_Masking_End();
}
#endregion

#region UI (Name - Lv - Hp - Kr)
__DrawUI();
#endregion
//Draws a rectangle to cover the hp bar in the board if needed
if (UI.BeneathBoard)
{
	Battle_Masking_Start();
	__DrawUI(c_black);
	Battle_Masking_End();
}
//Renders the bullets on screen
__RenderBullets();
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