/*
	You can freely change the encoding/decoding method
	Be sure to keep it consistent
*/


///Deletes the current data of the game
function Delete_Datas()
{
	file_delete("Data.dat");
}

///Saves tempoary data
///@param {string} name The name of the slot to be saved
///@param value The value of the slot to be saved
function SetTempData(name, value)
{
	global.TempData[$ name] = value;
}

///Get tempoary data
///@param {string} name The name of the slot to be aquired
function GetTempData(name)
{
	return struct_get(global.TempData, name);
}

///Saves all data from global.TempData into a TempData.dat file
///@param {string} filename			The file name of the file to store the data with
///@param {struct|Id.dsmap} struct	The struct/ds_map to save
///@param {function} function		The custom function for encoding (Input: string, Output: string)
function SaveData(fname = "TempData.dat", struct = global.TempData, func = undefined)
{
	aggressive_forceinline
	//Check whether it is a map (Legacy)
	if !is_struct(struct) && ds_exists(struct, ds_type_map) struct = ds_map_to_struct(struct);
	if struct_empty(struct)
	{
		print("Coalition Engine: Warning! Cannot save empty data");
		exit;
	}
	//Creates a tempoary struct
	var __temp_struct = {};
	//Stores the struct as ds map to save into the temp struct with the struct as key
	__temp_struct[$ json_stringify(struct)] = struct;
	var json_file = json_stringify(__temp_struct),
		target_buffer = buffer_create(1, buffer_grow, 1);
	//Layer 1 of encoding: base64
	json_file = base64_encode(json_file);
	//Layer 2 of encoding: String reversing
	json_file = string_reverse(json_file);
	//Layer 3 of encoding: User defined encoding method
	if func != undefined json_file = func(json_file);
	//Writing the final json into the buffer and then write it into the file
	buffer_write(target_buffer, buffer_text, json_file);
	buffer_save(target_buffer, fname);
	delete __temp_struct;
}

///Loads the saved data from the given file name
///@param {string} filename		The file name of the file to read the data with
///@param {function} function	The custom function for decoding (Input: string, Output: string)
function LoadData(fname = "TempData.dat", func = undefined)
{
	aggressive_forceinline
	//If file doesn't exist, exit
	if !file_exists(fname) return {};
	//Loads the buffer
	var target_buffer = buffer_load(fname);
	buffer_seek(target_buffer, buffer_seek_start, 0);
	var json_file = buffer_read(target_buffer, buffer_text);
	//Decrypt layer 3: User defined dncoding method
	if func != undefined json_file = func(json_file);
	//Decrypt Layer 2: String reversing
	json_file = string_reverse(json_file);
	//Decrypt Layer 1: base64
	json_file = base64_decode(json_file);
	var __temp_struct = json_parse(json_file),
		name = struct_get_names(__temp_struct)[0],
		vals = __temp_struct[$ name];
	name = json_parse(name);
	//In normal circumstances, the name should be the same as the value
	//It will only be different when the player modifies it
	//This displays a custom error function to tell the players they messed up big time
	if !struct_equals(name, vals)
	{
		if DEBUG
		{
			print(name);
			print(vals);
		}
		exception_unhandled_handler(function(ex)
		{
			window_set_caption("Code Error");
			show_message(
			@"
___________________________________________
############################################################################################
ERROR in
action number 1
of Other Event: Game Start
for object oGlobal:

 at gml_Script_LoadData
############################################################################################
You dirty cheater ;)");
		});
		show_error("", true);
	}
	return vals;
}
