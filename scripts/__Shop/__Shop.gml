///@category Shop
///@title Shop

///@constructor
///@func __Shop()
///@desc Shop functions
function __Shop() constructor {
	//Internal variable init
	static __options = ["Buy", "Sell", "Talk", "Exit"];
	static __info_surface = undefined;
	__info_surface ??= surface_create(210, 230);
	
	__state = 0;
	//Menu, Buy, Sell, Talk
	__choice = array_create(4, 0);
	__info_box_y = 240;
	__typist = scribble_typist().in(0.5, 0).sound_per_char(snd_txtDefault, 1, 1," ^!.?,:/\\|*");
	__text = scribble("", "__Coalition_Shop");
	__in_dialog = false;
	__choice_displacement = 0;
	Background = {};
	Shopkeeper = [];
	Music = undefined;
	
	static __default__sprite_struct = {
			sprite_index : undefined,
			image_index : 0,
			x : 0,
			y : 0,
			image_angle : 0,
			image_blend : c_white,
			image_alpha : 1,
			image_xscale : 1,
			image_yscale : 1,
		};
	
	///@method Reset()
	///@desc Resets the information of the shop to the default options
	///@return {Struct.__Shop}
	static Reset = function()
	{
		forceinline;
		Background = __default__sprite_struct;
		Shopkeeper = [];
		Text = "";
		TalkOptions = [];
		TalkDialog = [];
		BuyableItems = [];
		Music = undefined;
		__MusicID = undefined;
		__MusicStream = undefined;
		AllowSell = true;
		AllowTalk = true;
		CancelBuyEvent = method(undefined, COALITION_EMPTY_FUNCTION);
		//Initalize texts
		ReloadTexts();
		
		__TempText = "";
		__text = scribble(Text).wrap(360).starting_format("fnt_dt_sans", c_white);
		__state = 0;
		//Menu, Buy, Sell, Talk, Confirm Buy/Sell
		__choice = array_create(5, 0);
		__info_box_y = 240;
		__in_dialog = false;
		__info_surface = surface_create(210, 230);
		__choice_displacement = 0;
		draw_set_align();
		return Shop;
	}
	///@method AddItem(item, name, price, desc)
	///@desc Adds an item to the shop
	///@param {real} item The item to add
	///@param {string} name The name of the item displayed in the shop (Default original)
	///@param {real} price The price of the item
	///@param {string} desc The description of the item displayed in the shop
	///@return {Struct.__Shop}
	static AddItem = function(item, name = global.ItemLibrary[| item].name, price, desc)
	{
		array_push(BuyableItems, { name, price, desc, id: item });
		return Shop;
	}
	///@method AddDialog(question, answer)
	///@param {string} question The question of the dialog
	///@param {string} answer The answer of the dialog
	///@return {Struct.__Shop}
	static AddDialog = function(question, answer)
	{
		array_push(TalkOptions, question);
		array_push(TalkDialog, answer);
		return Shop;
	}
	///@method PlayMusic()
	///@desc Plays the shop music
	///@return {Struct.__Shop}
	static PlayMusic = function()
	{
		audio_stop_all();
		if is_string(Music)
		{
			__MusicStream = audio_create_stream(Music);
			__MusicID = audio_play(__MusicStream, false, true);
		}
		else if !is_undefined(Music) __MusicID = audio_play(Music, false, true);
		return Shop;
	}
	///@method AddShopkeeper(sprite, [index], [x], [y], [image_xscale], [image_yscale], [image_angle], [image_blend], [image_alpha])
	///@desc Adds a shopkeeper to the shop
	///@param {Asset.GMSprite} sprite The sprite of the shopkeeper
	///@param {real} index The image index of the shopkeeper
	///@param {real} x The x coordinate of the shopkeeper
	///@param {real} y The y coordinate of the shopkeeper
	///@param {real} image_xscale The image_xscale of the shopkeeper
	///@param {real} image_yscale The image_yscale of the shopkeeper
	///@param {real} image_angle The image_angle of the shopkeeper
	///@param {real} image_blend The image_blend of the shopkeeper
	///@param {real} image_alpha The image_alpha of the shopkeeper
	///@return {Struct} The shopkeeper struct for setting
	static AddShopkeeper = function(sprite_index, image_index = 0, x = 320, y = 240, image_xscale = 1, image_yscale = 1, image_angle = 0, image_blend = c_white, image_alpha = 1)
	{
		forceinline;
		array_push(Shopkeeper, {
			sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle,
			image_blend, image_alpha,
			state : 0,
			state_drawing_functions : [
				///Default drawing function
				function() {
					draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
				}
			]
		});
		return array_last(Shopkeeper);
	}
	///@method SetShopkeeperDrawingState(state, func)
	///@desc Sets the drawing event of the shopkeeper. For more information, check the tutorial 'How to make a Shop' for more details
	///@param {real} slot The id of the shopkeeper
	///@param {real} state The state of the darwing event
	///@param {function} func The function of drawing (i.e. draw_sprite_ext(sprite_index, image_index,...))
	///@return {Struct.__Shop}
	static SetShopkeeperDrawingState = function(slot, state, func)
	{
		Shopkeeper[slot].state_drawing_functions[state] = func;
		return Shop;
	}
	///@method ShopkeeperState([slot], [state])
	///@desc Gets/Sets the state of a shopkeeper
	///@param {real} slot The ID of the shopkeeper
	///@param {real} state The state to set it to
	///@return {real,Struct.__Shop} Either the state of the Shop struct itself
	static ShopkeeperState = function(slot = 0, state = undefined)
	{
		if is_undefined(state) return Shopkeeper[slot].state;
		else
		{
			Shopkeeper[slot].state = state;
			return Shop;
		}
	}
	///@method SetBackground(sprite, [index])
	///@desc Sets the background of the shop
	///@param {Asset.GMSprite} sprite The sprite of the shopkeeper
	///@param {real} index The image index of the shopkeeper
	///@return {Struct.__Shop}
	static SetBackground = function(sprite, index = 0)
	{
		forceinline;
		with Background
		{
			sprite_index = sprite;
			image_index = index;
		};
		return Shop;
	}
	///@method SetText(text)
	///@desc Sets the text in the dialog box
	///@param {string} text The text for the dialog box
	///@return {Struct.__Shop}
	static SetText = function(text)
	{
		forceinline
		Text = text;
		__text.overwrite(text);
		return Shop;
	}
	///@method StartDialog(text)
	///@desc Function to start a dialog
	///@param {string} text The dialog to display
	///@return {Struct.__Shop}
	static StartDialog = function(text)
	{
		__in_dialog = true;
		__text.overwrite(text);
		__typist.reset();
		return Shop;
	}
	///@method __Process()
	///@desc Internal shop processing logic
	///@return {undefined}
	static __Process = function()
	{
		var input_horizontal = PRESS_HORIZONTAL,
			input_vertical = PRESS_VERTICAL,
			press_confirm = PRESS_CONFIRM,
			press_cancel = PRESS_CANCEL,
			box_y_target = 240;
		static __target_state = [SHOP_STATE.BUY, SHOP_STATE.SELL, SHOP_STATE.TALK_CHOOSE, SHOP_STATE.LEAVING];
		///Resets menu state to default
		static __reset_state = function()
		{
			audio_play(snd_menu_confirm);
			__state = SHOP_STATE.MENU;
			__choice = [__choice[0], 0, 0, 0, 0];
			__choice_displacement = 0;
			if string_width(__TempText) != 0
			{
				SetText(__TempText);
				__TempText = "";
			}
		}
		
		//Dialog
		if __in_dialog
		{
			//Skip text
			if press_cancel __typist.skip_to_pause();
			//End dialog
			elif press_confirm && __typist.get_state() == 1
			{
				var i = 0;
				repeat array_length(Shopkeeper) Shopkeeper[i++].state = 0;
				__text.overwrite(Text);
				__typist.reset();
				__in_dialog = false;
			}
		}
		elif __state == SHOP_STATE.MENU
		{
			//Movement
			if input_vertical != 0
			{
				audio_play(snd_menu_switch);
				__choice[0] = posmod(__choice[0] + input_vertical, 4);
			}
			//Confirm -> Change state
			elif press_confirm
			{
				audio_play(snd_menu_confirm);
				__state = __target_state[__choice[0]];
				if __state == SHOP_STATE.SELL && Item_Count() == 0
				{
					audio_play(snd_damage);
					__state = SHOP_STATE.MENU;
				}
			}
		}
		elif __state == SHOP_STATE.BUY
		{
			box_y_target = 80;
			//Exit
			if __choice[1] == -1
			{
				box_y_target = 240;
				if press_confirm __reset_state();
				//Exit to first option or last option
				if input_vertical != 0
				{
					audio_play(snd_menu_switch);
					__choice[1] = sign(input_vertical) ? 0 : min(array_length(BuyableItems) - 1, 3);
				}
			}
			else
			{
				//Movement
				if input_vertical != 0
				{
					audio_play(snd_menu_switch);
					__choice[1] += input_vertical;
					//Go to exit button
					if __choice[1] == array_length(BuyableItems) __choice[1] = -1;
				}
				//Buy item -> Go to confirm buying state
				elif press_confirm
				{
					audio_play(snd_menu_confirm);
					__state = SHOP_STATE.CONFIRM_BUY;
					//Reset typist and set tempoary display text
					__typist.reset().skip();
					if string_width(__TempText) == 0 __TempText = Text;
					SetText(lexicon_text("Shop.ItemBuyText", BuyableItems[__choice[1]].price));
				}
			}
			//Cancel
			if press_cancel __reset_state();
		}
		elif __state == SHOP_STATE.CONFIRM_BUY
		{
			box_y_target = 80;
			//Change choices
			if input_vertical != 0
			{
				audio_play(snd_menu_switch);
				__choice[4] ^= 1;
			}
			//Confirm choice
			elif press_confirm
			{
				//No
				if __choice[4] == 1
				{
					__state = SHOP_STATE.BUY;
					__choice[4] = 0;
					CancelBuyEvent();
					SetText(__TempText);
				}
				//Yes
				else
				{
					__state = SHOP_STATE.BUY;
					var __item_bought = BuyableItems[__choice[1]];
					//Sufficient money
					if COALITION_DATA.Gold >= __item_bought.price
					{
						Item_Set(__item_bought.id);
						COALITION_DATA.Gold -= __item_bought.price;
						SetText(__TempText);
					}
					else //If not
					{
						if string_width(__TempText) == 0 __TempText = Text;
						SetText(InsufficientGText);
					}
				}
			}
			//Go back
			elif press_cancel
			{
				__state = SHOP_STATE.BUY;
				__choice[4] = 0;
				CancelBuyEvent();
				SetText(__TempText);
			}
		}
		elif __state == SHOP_STATE.SELL
		{
			//Exit
			if __choice[2] == -1
			{
				if press_confirm __reset_state();
				//Exit to first option or last option
				if input_vertical != 0
				{
					audio_play(snd_menu_switch);
					__choice[2] = sign(input_vertical) ? 0 : min(Item_Count() - 1, 3);
				}
			}
			//Move
			else if input_vertical != 0
			{
				audio_play(snd_menu_switch);
				//Shift item list
				__choice[2] += input_vertical;
				if __choice[2] >= 4
				{
					if __choice[2] + __choice_displacement != Item_Count()
					{
						__choice[2] = 3;
						__choice_displacement++;
					}
					else __choice[2] = -1;
				}
				else if __choice[2] == -1 && __choice[2] + __choice_displacement != -1
				{
					__choice[2] = 0;
					__choice_displacement--;
				}
				else if __choice[2] == Item_Count() __choice[2] = -1;
			}
			//Sell the item -> Confirm sell
			elif press_confirm
			{
				audio_play(snd_menu_confirm);
				__state = SHOP_STATE.CONFIRM_SELL;
				//Set tempoary text
				__typist.reset().skip();
				if string_width(__TempText) == 0 __TempText = Text;
					SetText(lexicon_text("Shop.ItemSellText", global.ItemLibrary[| global.item[__choice[1]]].price));
			}
			elif press_cancel __reset_state();
		}
		elif __state == SHOP_STATE.CONFIRM_SELL
		{
			box_y_target = 80;
			//Movement
			if input_vertical != 0
			{
				audio_play(snd_menu_switch);
				__choice[4] ^= 1;
			}
			//Confirm choice
			elif press_confirm
			{
				//No
				if __choice[4] == 1
				{
					__state = SHOP_STATE.SELL;
					__choice[4] = 0;
					SetText(__TempText);
				}
				//Yes
				else
				{
					var item = __choice_displacement + __choice[2];
					COALITION_DATA.Gold += global.ItemLibrary[| global.item[item]].price;
					Item_Remove(item);
					//Prevent crash
					if item == Item_Count() &&__choice_displacement > 0 __choice_displacement--;
					//Change choice if needed
					if __choice[2] >= Item_Count() __choice[2]--;
					__state = SHOP_STATE.SELL;
					__choice[4] = 0;
					//Empty inventory
					if Item_Count() == 0 __reset_state();
				}
			}
			//Exit
			elif press_cancel
			{
				__state = SHOP_STATE.SELL;
				__choice[4] = 0;
				SetText(__TempText);
			}
		}
		elif __state == SHOP_STATE.TALK_CHOOSE
		{
			//Exit
			if __choice[3] == -1
			{
				if press_confirm __reset_state();
				//Exit to first option or last option
				if input_vertical != 0
				{
					audio_play(snd_menu_switch);
					__choice[3] = sign(input_vertical) ? 0 : min(array_length(TalkOptions) - 1, 3);
				}
			}
			else
			{
				//Movement
				if input_vertical != 0
				{
					audio_play(snd_menu_switch);
					__choice[3] += input_vertical;
					//Go to exit
					if __choice[3] == array_length(TalkOptions) __choice[3] = -1;
				}
				elif press_confirm StartDialog(TalkDialog[__choice[3]]);
			}
			if press_cancel __reset_state();
		}
		//Info box y lerping
		__info_box_y = decay(__info_box_y, box_y_target, 0.2);
	}
	///@method __Draw()
	///@desc Internal shop ui drwaing function
	///@return {undefined}
	static __Draw = function()
	{
		static Base = Shop;
		var ShopkeeperCount = array_length(Shopkeeper);
		#region Background and Shopkeeper
		with Background
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		var i = 0;
		repeat ShopkeeperCount
		{
			with Shopkeeper[i]
				state_drawing_functions[state]();
			++i;
		}
		#endregion
		#region Box
		draw_sprite_ext(sprPixel, 0, 0, 240, 640, 240, 0, c_white, 1);
		if !__in_dialog
		{
			draw_sprite_ext(sprPixel, 0, 5, 245, 415, 230, 0, c_black, 1);
			draw_sprite_ext(sprPixel, 0, 425, 245, 210, 230, 0, c_black, 1);
			if ShopkeeperCount > 1
			{
				var i = 0;
				repeat ShopkeeperCount
					draw_sprite_ext(sprPixel, 0, 420 / i++, 240, 5, 240, 0, c_white, 1);
			}
		}
		else draw_sprite_ext(sprPixel, 0, 5, 245, 630, 230, 0, c_black, 1);
		#endregion
		#region Options
		//Draw dialog
		if __in_dialog __text.wrap(620).draw(20, 260, __typist);
		else if __state == SHOP_STATE.MENU || __state == SHOP_STATE.BUY || __state == SHOP_STATE.CONFIRM_BUY
		{
			var i = 0;
			if __state == SHOP_STATE.MENU
			{
				//Options
				repeat array_length(__options)
				{
					draw_text(480, 260 + i * 40, __options[i]);
					++i;
				}
				//Dialog
				__text.wrap(360).draw(20, 260, __typist);
				draw_sprite_ext(sprSoul, 0, 460, 276 + __choice[0] * 40, 1, 1, 0, c_red, 1);
			}
			else
			{
				//Buyable items
				repeat min(4, array_length(BuyableItems))
				{
					var item = global.ItemLibrary[| BuyableItems[i]];
					var price = string(BuyableItems[i].price) + "G";
					draw_set_halign(fa_right);
					draw_text_transformed(115, 260 + i * 40, price, min(1, 60 / string_width(price)), 1, 0);
					draw_set_halign(fa_left);
					draw_text_transformed(120, 260 + i * 40, "-", 1.5, 1, 0);
					var CurItemName = BuyableItems[i].name;
					draw_text_transformed(140, 260 + i * 40, CurItemName, min(1, 250 / string_width(CurItemName)), 1, 0);
					++i;
				}
				//Misc text
				draw_text(60, 420, "Exit");
				__text.wrap(160).draw(460, 260, __typist);
				//Choosing item
				if __state == SHOP_STATE.BUY
				{
					var SoulY = __choice[1] == -1 ? 436 : 276 + __choice[1] * 40;
					draw_sprite_ext(sprSoul, 0, 40, SoulY, 1, 1, 0, c_red, 1);
				}
				else //Choosing choice
				{
					draw_text(480, 340, "Yes\nNo");
					var __str_height = string_height("Yes");
					draw_sprite_ext(sprSoul, 0, 450, 338 + (__choice[4] == 0 ? __str_height / 2 : __str_height * 1.5), 1, 1, 0, c_red, 1);
				}
			}
			//Item Info
			if __info_box_y != 240
			{
				//Info Box
				var InfoBoxY = min(__info_box_y + 5, 240),
					InfoBoxScale = max(235 - __info_box_y, 0);
				draw_sprite_ext(sprPixel, 0, 420, __info_box_y, 220, 240 - __info_box_y, 0, c_white, 1);
				draw_sprite_ext(sprPixel, 0, 425, InfoBoxY, 210, InfoBoxScale, 0, c_black, 1);
				//Info text and surface
				if __choice[1] != -1
				{
					surface_set_target(__info_surface);
					draw_sprite_ext(sprPixel, 0, 0, 0, 210, 230, 0, c_black, 1);
					draw_text(10, 10, BuyableItems[__choice[1]].desc);
					surface_reset_target();
					draw_surface_part(__info_surface, 0, 0, 210, InfoBoxScale, 425, InfoBoxY);
				}
			}
		}
		else if __state == SHOP_STATE.SELL || __state == SHOP_STATE.CONFIRM_SELL
		{
			var i = 0, k = __choice_displacement, item_count = Item_Count();
			//Inventory items
			repeat min(4, item_count)
			{
				var item = global.ItemLibrary[| global.item[k]];
				var price = string(item.price) + "G";
				draw_set_halign(fa_right);
				draw_text_transformed(115, 260 + i * 40, price, min(1, 60 / string_width(price)), 1, 0);
				draw_set_halign(fa_left);
				draw_text_transformed(120, 260 + i * 40, "-", 1.5, 1, 0);
				draw_text_transformed(140, 260 + i * 40, item.name, min(1, 250 / string_width(item.name)), 1, 0);
				++i;
				++k;
			}
			draw_text(60, 420, "Exit");
			//Choosing item
			if __state == SHOP_STATE.SELL
			{
				var SoulY = __choice[2] == -1 ? 436 : 276 + __choice[2] * 40;
				draw_sprite_ext(sprSoul, 0, 40, SoulY, 1, 1, 0, c_red, 1);
			}
			else //Choosing choice
			{
				__text.wrap(160).draw(460, 260, __typist);
				draw_text(480, 340, "Yes\nNo");
				var __str_height = string_height("Yes");
				draw_sprite_ext(sprSoul, 0, 450, 338 + (__choice[4] == 0 ? __str_height / 2 : __str_height * 1.5), 1, 1, 0, c_red, 1);
			}
		}
		else if __state == SHOP_STATE.TALK_CHOOSE || __state == SHOP_STATE.TALKING
		{
			//Avalible talking dialog
			var i = 0;
			repeat min(4, array_length(TalkOptions))
			{
				draw_text_transformed(60, 260 + i * 40, TalkOptions[i], min(1, 350 / string_width(TalkOptions[i])), 1, 0);
				++i;
			}
			draw_text(60, 420, "Exit");
			//Choosing option
			if __state == SHOP_STATE.TALK_CHOOSE
			{
				var SoulY = __choice[3] == -1 ? 436 : 276 + __choice[1] * 40;
				draw_sprite_ext(sprSoul, 0, 40, SoulY, 1, 1, 0, c_red, 1);
			}
		}
		#endregion
		#region Data
		if !__in_dialog
		{
			draw_text(460, 420, string(Player.Gold()) + "G");
			draw_text(560, 420, string(Item_Count()) + "/8");
		}
		#endregion
	}
	///@method __CleanUp()
	///@desc Internal shop clean up function
	///@return {undefined}
	static __CleanUp = function()
	{
		delete Background;
		delete Shopkeeper;
		surface_free(__info_surface);
	}
}

enum SHOP_STATE
{
	MENU,
	BUY,
	CONFIRM_BUY,
	SELL,
	CONFIRM_SELL,
	TALK_CHOOSE,
	TALKING,
	LEAVING,
}