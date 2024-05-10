var Main = MainOption, Sub = SubOption;
//Draw main option texts
surface_set_target(Main.Surf);
draw_set_font(fnt_dt_sans);
draw_set_halign(fa_left);
var i = 0;
repeat array_length(Main.Options)
{
	draw_set_color(State == i + 1 ? c_yellow : c_white);
	var BaseY = 40 + Main.DisplaceY + i * 70,
		BottomY = BaseY + string_height(Main.Options[i]) + 5,
		BaseX = 30 + Main.DisplaceX,
		RightX = BaseX + 200;
	if mouse_in_rectangle(BaseX, BaseY - 5, RightX, BottomY)
	{
		if State == DEBUG_STATE.MAIN draw_set_color(c_yellow);
		if mouse_check_button_pressed(mb_left)
		{
			State = i + 1;
			Main.Choice = i;
			LoadSubOptions(i);
			audio_stop_all();
			audio_play(snd_menu_confirm);
		}
		elif mouse_check_button_pressed(mb_right) && State == i + 1
		{
			State = DEBUG_STATE.MAIN;
			audio_play(snd_menu_confirm);
		}
	}
	draw_rectangle_width(BaseX, BaseY - 5, RightX, BottomY, 6, draw_get_color(),, 7);
	draw_text(BaseX + 10, BaseY, Main.Options[i]);
	draw_set_color(c_white);
	++i;
}
surface_reset_target();
//Main options box
draw_surface_part(Main.Surf, BaseX - 10, 20, 240, 440, BaseX - 10, 20);
draw_rectangle_width_background(BaseX - 10, 20, RightX + 10, 460, 6,,,, 0, 7);
surface_free(Main.Surf);

//Sub-options
if State != DEBUG_STATE.MAIN
{
	surface_set_target(Sub.Surf);
	var i = 0;
	repeat array_length(Sub.Options)
	{
		draw_set_color(c_white);
		var BaseY = 40 + Sub.DisplaceY + i * 70,
			BottomY = BaseY + string_height(Sub.Options[i]) + 5,
			BaseX = 270 + Sub.DisplaceX,
			RightX = BaseX + 200;
		if mouse_in_rectangle(BaseX, BaseY - 5, RightX, BottomY)
		{
			draw_set_color(c_yellow);
			if mouse_check_button_pressed(mb_left) SubOptionAction(i);
		}
		draw_rectangle_width(BaseX, BaseY - 5, RightX, BottomY, 6, draw_get_color(),, 7);
		draw_text(BaseX + 10, BaseY, string_limit(Sub.Options[i], 180));
		draw_set_color(c_white);
		++i;
	}
	surface_reset_target();
	//Sub-options box
	draw_surface_part(Sub.Surf, BaseX - 10, 20, 240, 440, BaseX - 10, 20);
	draw_rectangle_width_background(BaseX - 10, 20, RightX + 10, 460, 6,,,, 0, 7);
	surface_free(Sub.Surf);
	
	//Audio length
	if State == DEBUG_STATE.SOUNDS && Sub.Audio != -1
	{
		var curPos = audio_sound_get_track_position(Sub.Audio);
		draw_line_width(10, 10, curPos / Sub.AudioLength * 620 + 10, 10, 3);
		draw_set_halign(fa_right);
		var curPosMin = string(curPos div 60),
			curPosSec = string(round(curPos mod 60));
		//Zero-padding
		if curPosSec < 10 curPosSec = "0" + curPosSec;
		draw_set_font(fnt_dotum);
		draw_text(635, 15, curPosMin + ":" + curPosSec + "/" + Sub.AudioLengthMin + ":" + Sub.AudioLengthSec);
		draw_set_halign(fa_left);
	}
	
	//Draw sprites
	elif State == DEBUG_STATE.SPRITES
	{
		if sprite_exists(Sub.DrawSprite)
		{
			var offx = string(sprite_get_xoffset(Sub.DrawSprite)),
				offy = string(sprite_get_yoffset(Sub.DrawSprite)),
				sprwidth = sprite_get_width(Sub.DrawSprite),
				sprheight = sprite_get_height(Sub.DrawSprite),
				xscale = max(min(300 / sprwidth, 1), 100 / sprwidth),
				yscale = max(min(160 / sprheight, 1), 100 / sprheight),
				FinScale = min(xscale, yscale),
				nine = sprite_get_nineslice(Sub.DrawSprite);
			draw_sprite_ext(Sub.DrawSprite, 0, 430, 240, FinScale, FinScale, 0, c_white, 1);
			draw_set_font(fnt_mnc);
			draw_set_halign(fa_center);
			var text = "Scaled to: " + string(FinScale) + "x"
			if nine.enabled
				text += "\nNine slice is enabled,\nimage may be drawn incorrectly";
			draw_text(430, 410, text);
			draw_text(430, 20, "Origin: " + offx + ", " + offy);
			draw_set_halign(fa_left);
		}
	}
}