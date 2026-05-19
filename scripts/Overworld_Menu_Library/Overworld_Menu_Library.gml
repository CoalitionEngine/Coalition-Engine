function InitializeOverworldStates() {
	forceinline;
	//Define overworld menu states
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.IDLE, function() {
		__COALITION_DEFINE_INPUT_LOCAL_VAR;
		// Soul positioning and lerping
		__menu_soul_pos_target = new Vector2(__menu_ui_x + 34, 205 + (36 * __menu_choices[OVERWORLD_MENU_STATE.IDLE]));
		if (input_vertical != 0)
		{
			__menu_choices[OVERWORLD_MENU_STATE.IDLE] = posmod(__menu_choices[OVERWORLD_MENU_STATE.IDLE] + input_vertical, 3);
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			__menu_state = __menu_choices[OVERWORLD_MENU_STATE.IDLE] + 1;
			audio_play(snd_menu_confirm);
			//Return immediately if there are no items
			if (__menu_state == OVERWORLD_MENU_STATE.ITEM && !Item_Count())
			{
				__menu_state = OVERWORLD_MENU_STATE.IDLE;
				audio_stop_sound(snd_menu_confirm);
			}
		}
		elif (input_menu || input_cancel) // This closes the menu
			__ExitMenu();
	},
	function() {
		if (__menu_ui_x <= -135)
			exit;
		// Position and side elements
		var ui_box_x = __menu_ui_x + 6,
			ui_box_y = __MenuAtTop() ? 45 : 328;
		// Box Drawing
		draw_rectangle_width_background(ui_box_x, ui_box_y, ui_box_x + 130 - 1, ui_box_y + 98 - 1, 5);
	
		// String var declaration
		var lv =		string(Player.LV()),
			hp =		string(Player.HP()),
			max_hp =	string(Player.HPMax());

		// String drawing
		draw_set_color(c_white);
		ui_box_x += 12;
		draw_text(ui_box_x, ui_box_y + 3, Player.Name());


		draw_set_font(fnt_cot);
		draw_text(ui_box_x, ui_box_y + 36, "LV  " + lv);
		draw_text(ui_box_x, ui_box_y + 54, "HP  " + hp + "/" + max_hp);

		// Toby Fox method because the number in Gold is not aligned correctly with spaces
		var ui_num_x = ui_box_x + string_width("LV  ");
		draw_text(ui_box_x, ui_box_y + 72, "G");
		draw_text(ui_num_x, ui_box_y + 72, Player.Gold());
		// Position and side elements for the box
		ui_box_x = __menu_ui_x + 6;
	
		// Box Drawing
		draw_rectangle_width_background(ui_box_x, 174, ui_box_x + 130 - 1, 174 + 136 - 1);

		// Menu Label
		var exist_check = [Item_Count(), 1, Cell.Count()];
		draw_set_font(fnt_dt_sans);
		for (var i = 0; i < 3; ++i)
		{
			// Check if the menu exists or not to proceed color
			draw_set_color(__menu_label_colors[i][bool(exist_check[i])]);
			draw_text(ui_box_x + 46, 174 + 15 + i * 36, __menu_label_texts[i]);
		}
		draw_set_color(c_white);
	});
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.ITEM, function() {
		__COALITION_DEFINE_INPUT_LOCAL_VAR;
		// Soul positioning and lerping
		__menu_soul_pos_target = new Vector2(217, 97 + (32 * __menu_choices[OVERWORLD_MENU_STATE.ITEM]));
		if (input_vertical != 0) // Choosing item
		{
			__menu_choices[OVERWORLD_MENU_STATE.ITEM] = posmod(__menu_choices[OVERWORLD_MENU_STATE.ITEM] + input_vertical, Item_Count());
			audio_play(snd_menu_switch);
		}
		if (input_confirm) // Choosing what to do with the item
		{
			__menu_state = OVERWORLD_MENU_STATE.ITEM_INTERACTING;
			audio_play(snd_menu_confirm);
		}
		elif (input_cancel) // Go back to menu idle mode
		{
			__menu_state = OVERWORLD_MENU_STATE.IDLE;
			__menu_choices[OVERWORLD_MENU_STATE.ITEM] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	},
	function() {
		if (__menu_ui_y[OVERWORLD_MENU_STATE.ITEM] > -500)
		{
			var ui_box_y = __menu_ui_y[OVERWORLD_MENU_STATE.ITEM] + 6;
			// Box Drawing
			draw_rectangle_width_background(194, ui_box_y, 194 + 334 - 1, ui_box_y + 350 - 1,,,,, 0.8);
	
			// Item text drawing
			var i = 0;
			repeat (Item_Count())
			{
				draw_text(232, ui_box_y + 23 + i * 32, global.__CoalitionUserItems[i].__GetName());
				++i;
			}

			// Item function
			for (var i = 0; i < 3; i++)
				draw_text(i == 0 ? 234 : (i == 1 ? 330 : 444), ui_box_y + 303, __menu_item_texts[i]);
		}
	});
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.ITEM_INTERACTING, function() {
		__COALITION_DEFINE_INPUT_LOCAL_VAR;
		__menu_soul_pos_target = new Vector2(__item_interact_positions[__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING]], 377);
		
		if (input_horizontal != 0)
		{
			__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] = posmod(__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] + input_horizontal, 3);
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			__menu_state = OVERWORLD_MENU_STATE.ITEM_DONE;
			var item_use_text = ["", global.__CoalitionUserItems[__menu_choices[OVERWORLD_MENU_STATE.ITEM]].Description, global.__CoalitionUserItems[__menu_choices[OVERWORLD_MENU_STATE.ITEM]].DropText];
			if (__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] == 0) // USE
			{
				Item_Use(global.__CoalitionUserItems[__menu_choices[OVERWORLD_MENU_STATE.ITEM]]);
				item_use_text[0] = healing_text;
			}
			elif (__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] == 2) // DROP
			{
				Item_Remove(__menu_choices[OVERWORLD_MENU_STATE.ITEM]);
				audio_play(snd_menu_confirm);
				Overworld_CreateDialog(item_use_text[2], "fnt_dt_mono", snd_txtTyper, !__MenuAtTop());
			}
			var itemActText = item_use_text[__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING]];
			if (!string_is_empty(itemActText))
				Overworld_CreateDialog(itemActText, "fnt_dt_mono", snd_txtTyper, !__MenuAtTop());
			else
				__ExitMenu();
			//Reset item choice if it is not INFO
			if (__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] != 1)
				__menu_choices[OVERWORLD_MENU_STATE.ITEM] = 0;
		}
		elif (input_cancel)
		{
			__menu_state = OVERWORLD_MENU_STATE.ITEM;
			__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] = 0;
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();	
	}, Overworld.__defined_states[$ OVERWORLD_MENU_STATE.ITEM].Draw);
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.ITEM_DONE, function() {
		//When the item USE/DROP dialog ends, update menu state
		if (!Overworld_DialogExists())
		{
			__menu_choices[OVERWORLD_MENU_STATE.ITEM_INTERACTING] = 0;
			__menu_state = !Item_Count() ? OVERWORLD_MENU_STATE.IDLE : OVERWORLD_MENU_STATE.ITEM;
		}
	});
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.STAT, function() {
		__COALITION_DEFINE_INPUT_LOCAL_VAR;
		//Sets soul to be invisible when STAT is visible
		__menu_soul_alpha_target = 0;
		menu_soul_target = new Vector2(__menu_ui_x + 34, 241);
		if (input_cancel) // Go back to menu idle mode
		{
			__menu_state = OVERWORLD_MENU_STATE.IDLE;
			__menu_choices[OVERWORLD_MENU_STATE.ITEM] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	},
	function() {
		if (__menu_ui_y[OVERWORLD_MENU_STATE.STAT] > -480)
		{
			// String var declaration
			var lv =		string(Player.LV()),
				hp =		string(Player.HP()),
				max_hp =	string(Player.HPMax()),
				ui_box_y = __menu_ui_y[OVERWORLD_MENU_STATE.STAT] + 6;
				
			// Box Drawing
			draw_rectangle_width_background(194, ui_box_y, 194 + 334 - 1, ui_box_y + 406 - 1,,,,, 0.8);
	
			// Stat text drawing
			draw_set_font(fnt_dt_sans);
			draw_set_color(c_white);
			draw_text(216, ui_box_y + 27, string_concat("\"", Player.Name(), "\""));
			draw_text(216, ui_box_y + 87, string_concat("LV ", lv));
			draw_text(216, ui_box_y + 119, string_concat("HP ", hp, " / ", max_hp));
			draw_text(216, ui_box_y + 183, string_concat("AT ", global.__CoalitionPlayerBaseAttack, " (", global.player_attack, ")"));
			draw_text(216, ui_box_y + 215, string_concat("DF ", global.__CoalitionPlayerBaseDefense, " (", global.player_defense, ")"));
			draw_text(384, ui_box_y + 183, string_concat("EXP: " ,Player.Exp()));
			draw_text(384, ui_box_y + 215, string_concat("NEXT: ", Player.GetExpNext()));
			draw_text(216, ui_box_y + 273, string_concat("WEAPON: ", COALITION_DATA.AttackItem));
			draw_text(216, ui_box_y + 305, string_concat("ARMOR: ", COALITION_DATA.DefenseItem));
			draw_text(216, ui_box_y + 347, string_concat("GOLD: ", Player.Gold()));
		}
	});
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.CELL, function() {
		__COALITION_DEFINE_INPUT_LOCAL_VAR;
		// Soul positioning and lerping
		__menu_soul_pos_target = new Vector2(217, 97 + 32 * __menu_choices[OVERWORLD_MENU_STATE.CELL]);
		if (input_vertical != 0) // Choosing option
		{
			__menu_choices[OVERWORLD_MENU_STATE.CELL] = posmod(__menu_choices[OVERWORLD_MENU_STATE.CELL] + input_vertical, Cell.Count());
			audio_play(snd_menu_switch);
		}
		if (input_confirm) // Confirming the option in CELL state
		{
			if (!Cell.IsBox(__menu_choices[OVERWORLD_MENU_STATE.CELL])) // If the option isn't a box
			{
				__menu_state = OVERWORLD_MENU_STATE.CELL_DONE;
				Overworld_CreateDialog(Cell.Text(__menu_choices[OVERWORLD_MENU_STATE.CELL]), "fnt_dt_mono", snd_txtTyper, !__MenuAtTop());
				global.__CoalitionUserCells[__menu_choices[OVERWORLD_MENU_STATE.CELL]].func();
				global.__CoalitionUserCells[__menu_choices[OVERWORLD_MENU_STATE.CELL]].call_count++;
				audio_play(snd_phone_call);
			}
			else // If it is a box
			{
				__menu_state = OVERWORLD_MENU_STATE.BOX_MODE;
				__box_id = Cell.GetBoxID(__menu_choices[OVERWORLD_MENU_STATE.CELL]);
				__menu_soul_pos_target = new Vector2(60, 70);
				audio_play(snd_phone_box);
			}
		}
		elif (input_cancel) // Go back to menu idle mode
		{
			__menu_state = OVERWORLD_MENU_STATE.IDLE;
			__menu_choices[OVERWORLD_MENU_STATE.CELL] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	},
	function() {
		if (__menu_ui_y[OVERWORLD_MENU_STATE.CELL] > -500)
		{
			var ui_box_y = __menu_ui_y[OVERWORLD_MENU_STATE.CELL] + 6;
	
			// Box Drawing
			draw_rectangle_width_background(194, ui_box_y, 194 + 334 - 1, ui_box_y + 258 - 1,,,,, 0.8);
		
			// Cell text drawing
			for (var i = 0; i < Cell.Count(); ++i)
				draw_text(232, ui_box_y + 23 + i * 32, Cell.GetName(i));
		}
	});
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.CELL_DONE, function() {
		// Check if the phone call dialog is still ongoing or not if the cell is not a box
		if (!Cell.IsBox(__menu_choices[OVERWORLD_MENU_STATE.CELL]))
		{
			__menu_soul_alpha_target = 0;
			__menu_soul_pos_target = new Vector2(__menu_ui_x + 34, 209);
			if (!Overworld_DialogExists()) // Close the menu and return to CELL state
				__menu_state = OVERWORLD_MENU_STATE.CELL;
		}
	});
	Overworld.DefineMenuState(OVERWORLD_MENU_STATE.BOX_MODE, function() {
		__COALITION_DEFINE_INPUT_LOCAL_VAR;
		__menu_soul_pos_target = new Vector2(60 + __box_state * 300, 85 + __box_choice[__box_state] * 35);
		if (input_horizontal != 0) // Moving between 2 sides during box mode
		{
			//Swap states
			__box_state = (__box_state == BOX_STATE.INVENTORY) ? BOX_STATE.BOX : BOX_STATE.INVENTORY;
			//Apply choice clamping
			__box_choice[__box_state] = clamp(__box_choice[!__box_state], 0, __box_state ? 10 : 7);
		}
		if (input_vertical != 0)
		{
			__box_choice[__box_state] = posmod(__box_choice[__box_state] + input_vertical, __box_state == BOX_STATE.INVENTORY ? 8 : 10); 
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			//Store item to box
			if (__box_state == BOX_STATE.INVENTORY && __box_choice[0] < Item_Count())
			{
				global.__CoalitionBox[$ __box_id][Box.GetFirstEmptySlot(__box_id)] = global.__CoalitionUserItems[__box_choice[0]];
				Item_Remove(__box_choice[0]);
			}
			//Retrieve item from box
			elif (__box_state == BOX_STATE.BOX && __box_choice[1] < 10 && global.__CoalitionBox[$ __box_id][__box_choice[1]] != 0 && Item_Count() < 8)
			{
				global.__CoalitionUserItems[Item_Count()] = global.__CoalitionBox[$ __box_id][__box_choice[1]];
				global.__CoalitionBox[$ __box_id][__box_choice[1]] = 0;
				Box.Shift(__box_id);
			}
		}
		if (input_cancel) // When the box is no longer real
		{
			__box_choice = array_create(2, 0); // Reset box option
			__menu_state = OVERWORLD_MENU_STATE.CELL;
		}
	},
	function() {
		if (__menu_state != OVERWORLD_MENU_STATE.BOX_MODE)
			exit;
		oOWPlayer.Movable = false;
		//Box UI drawing
		draw_rectangle_width_background(20, 20, 620, 460);
		draw_set_color(c_white);
		draw_line_width(320, 90, 320, 390, 5);
		draw_set_font(fnt_dt_sans);
		draw_set_halign(fa_center);
		//Box Text drawing
		draw_text(170, 35, "INVENTORY");
		draw_text(470, 35, "BOX");
		draw_text(320, 410, "Press [X] to Finish");
		draw_set_halign(fa_left);
		//Draw item names
		for (var i = 0; i < Item_Count(); ++i)
			draw_text(80, 70 + i * 35, global.__CoalitionUserItems[i].__GetName());
		//Draw red lines for empty slots
		for (var i = Item_Count(); i < 8; ++i)
			draw_line_width_color(95, 85 + i * 35, 245, 85 + i * 35, 2, c_red, c_red);
		//Item Text / line drawing
		var i = 0, curBoxItemCount = Box.ItemCount(__box_id);
		repeat (10)
		{
			if (i < curBoxItemCount)
				draw_text(380, 70 + i * 35, global.__CoalitionBox[$ __box_id][i].__GetName());
			else
				draw_line_width_color(395, 85 + i * 35, 545, 85 + i * 35, 2, c_red, c_red);
			++i;
		}
	});
	
	Overworld.DefineSaveState(SAVE_STATE.CHOOSING, function() {
		//Change choices
		if (PRESS_HORIZONTAL != 0)
		{
			audio_play(snd_menu_switch);
			__save_choice ^= true;
		}
		//Confirm choices
		if (PRESS_CONFIRM && __wait_time > 5)
		{
			__wait_time = 0;
			if (!__save_choice) //Saving
			{
				Overworld.__save_function();
				__save_state = SAVE_STATE.FINISHED;
				audio_play(snd_save);
			}
			else
				ExitSave();
		}
	},
	function() {
		__wait_time++;
		oOWPlayer.Movable = false;
		//Box UI drawing, using int over vars are better
		draw_rectangle_width_background(108, 118, 108 + 424, 118 + 174);
		//If saving is finshed, the text will be yellow
		draw_set_color(__save_state == SAVE_STATE.FINISHED ? c_yellow : c_white);
		draw_set_halign(fa_left);
		draw_text(140, 140, Player.Name());
		draw_text(295, 140, string_concat("LV ", Player.LV()));
		var time = global.timer,
			second = time div 60,
			minute = string(second div 60);
		second = string(second % 60);
		//Zeropadding
		second = string_length(second) == 1 ? "0" + second : second;
		draw_text(423, 140, minute + ":" + second);
		draw_text(140, 180, RoomNames[| __OverworldSubRoom]);
		
		//Soul alpha sin-ing
		var SoulAlpha = abs(dsin(global.timer)) + 0.3;
		draw_sprite_ext(sprSoul, 0, 151 + __save_choice * 180, 255, 1, 1, 90, c_red, SoulAlpha);
		draw_text(170, 240, "Save");
		draw_text(350, 240, "Return");
	});
	Overworld.DefineSaveState(SAVE_STATE.FINISHED, function() {
		if (PRESS_CONFIRM && __wait_time > 0)
			ExitSave();
	},
	function() {
		Overworld.__defined_save_states[$ SAVE_STATE.CHOOSING].Draw();
		
		__wait_time++;
		oOWPlayer.Movable = false;
		//Box UI drawing, using int over vars are better
		draw_rectangle_width_background(108, 118, 108 + 424, 118 + 174);
		//If saving is finshed, the text will be yellow
		draw_set_color(__save_state == SAVE_STATE.FINISHED ? c_yellow : c_white);
		draw_set_halign(fa_left);
		draw_text(140, 140, Player.Name());
		draw_text(295, 140, string_concat("LV ", Player.LV()));
		var time = global.timer,
			second = time div 60,
			minute = string(second div 60);
		second = string(second % 60);
		//Zeropadding
		second = string_length(second) == 1 ? "0" + second : second;
		draw_text(423, 140, minute + ":" + second);
		draw_text(140, 180, RoomNames[| __OverworldSubRoom]);
		
		draw_set_halign(fa_center);
		draw_text(240, 240, "File Saved.");
	});
}

function __Overworld() constructor {
	__defined_states = {};
	__defined_save_states = {};
	//Default function
	__save_function = function() {
		var name_list = __CoalitionInitalize.__hash_name_list,
			default_variables = [
			Player.Name(), global.MaxHP, global.HP, Player.LV(),
			Player.Gold(), Player.Exp(), COALITION_DATA.AttackItem,
			COALITION_DATA.DefenseItem, COALITION_DATA.Kills, global.__CoalitionBox,
			global.__CoalitionUserItems, global.__CoalitionUserCells
		];
		var i = 0;
		repeat (array_length(name_list))
		{
			struct_set_from_hash(COALITION_SAVE_FILE, variable_get_hash(name_list[i]), default_variables[i]);
			++i;
		}
		SaveData("Data.dat", COALITION_SAVE_FILE);
	};
	///@method DefineMenuState(state, step, draw)
	///@desc Defines a state for the overworld menu
	///@param {real} state The state to define
	///@param {Function} step The function for step logic (Default empty function)
	///@param {Function} draw The function for draw logic (Default empty function)
	static DefineMenuState = function(state, Step = COALITION_EMPTY_FUNCTION, Draw = COALITION_EMPTY_FUNCTION)
	{
		forceinline
		__defined_states[$ state] = {Step, Draw};
		return self;
	}
	///@method DefineSaveState(state, step, draw)
	///@desc Defines a state for the save menu
	///@param {real} state The state to define
	///@param {Function} step The function for step logic (Default empty function)
	///@param {Function} draw The function for draw logic (Default empty function)
	static DefineSaveState = function(state, Step = COALITION_EMPTY_FUNCTION, Draw = COALITION_EMPTY_FUNCTION)
	{
		forceinline
		__defined_save_states[$ state] = {Step, Draw};
		return self;
	}
	///@method DefineSaveFunction(func)
	///@desc Defines the function to execute when user saves
	///@param {function} func The function to execute
	static DefineSaveFunction = function(func) {
		forceinline
		__save_function = func;
	}
}
#macro __COALITION_DEFINE_INPUT_LOCAL_VAR	var input_vertical =   PRESS_VERTICAL,\
												input_menu =       PRESS_MENU,\
												input_confirm =    PRESS_CONFIRM,\
												input_cancel =     PRESS_CANCEL,\
												input_horizontal = PRESS_HORIZONTAL