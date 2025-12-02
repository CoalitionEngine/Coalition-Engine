var ItemCount = Item_Count(),
	CellCount = Cell.Count();
__COALITION_DEFINE_INPUT_LOCAL_VAR;
draw_set_font(fnt_dt_sans);
#region Save UI
if (__save_state != SAVE_STATE.NOT_SAVING && struct_exists(Overworld.__defined_save_states, __save_state))
	Overworld.__defined_save_states[$ __save_state].Draw();
#endregion
#region Menu Overworld
//Don't draw if the box is out of bounds
if (__menu_ui_x > -140)
{
	//Draws all of the UI at once due to menu lerping (Condition should be defined by user)
	struct_foreach(Overworld.__defined_states, function(_name, _value) {
		_value.Draw();
	});
	// Drawing the soul over everything
	draw_sprite_ext(sprSoulMenu, 0, __menu_soul_pos.x, __menu_soul_pos.y, 1, 1, 0, c_red, __menu_soul_alpha);
}
#endregion
#region Dialog
// Check if a Overworld Dialog is occuring and the screen is not flashed due to encounter animation
if (__dialog_exists && !(oOWPlayer.__encounter_draw & __COALITION_ENCOUNTER_STATE_FLAG.BLACK_SCREEN))
{
	//Dialog Box drawing
	var dialog_box_y = __dialog_at_bottom ? 320 : 10;
	draw_rectangle_width_background(30, dialog_box_y, 610, dialog_box_y + 150);
	
	//Dialog Text drawing
	var dis = 0;
	//Draws sprite for dialog if the given sprite exists
	if (__dialog_sprite != noone)
	{
		dis = 110;
		var spr_w = sprite_get_width(__dialog_sprite),
			spr_h = sprite_get_height(__dialog_sprite),
			sprite_dis_x = sprite_get_xoffset(__dialog_sprite),
			sprite_dis_y = sprite_get_yoffset(__dialog_sprite);
		draw_sprite_ext(__dialog_sprite, __dialog_sprite_index, 95 - spr_w / 2 + sprite_dis_x, dialog_box_y + 80 - spr_h / 2 + sprite_dis_y, 80 /spr_w, 80 / spr_h, 0, c_white, 1);
	}
	//Draws dialog texts
	__text_writer.draw(30 + 25 + dis, dialog_box_y + 25, __dialog_typist);
	
	//Check if the dialog is currently an option and draw if question is asked and buffer time has expired
	if (__dialog_at_option && __dialog_typist.get_state() == 1 && !__option_buffer)
		draw_sprite_ext(sprSoul, 0, 36 + dis + __dialog_option_pos[# __option, 0], dialog_box_y + 20 + __dialog_option_pos[# __option, 1], 1, 1, 90, c_red, 1);
}
#endregion
#region Debugger
if (ALLOW_DEBUG)
	DrawDebugUI();
#endregion