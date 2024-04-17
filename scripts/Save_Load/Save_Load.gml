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
	global.TempData[? name] = value;
}

///Get tempoary data
///@param {string} name The name of the slot to be aquired
function GetTempData(name)
{
	return global.TempData[? name];
}

///Saves all data from global.TempData into a TempData.dat file
///@param {string} filename		The file name of the file to store the data with
function SaveData(fname = "TempData.dat", map = global.TempData)
{
	//You can change this, don't set this value too low or else it may corrupt the save
	static ByteDigits = 12;
	var keys = ds_map_keys_to_array(map), i = 0, str = "", DataType = 0;
	//Don't save if there is no data to save
	if array_length(keys) == 0 exit;
	/*
		Data type table:
		0 -> String
		1 -> Real
		2 -> Array
		
		Support of other types of data will be implemented soon
	*/
	var File = file_text_open_write(fname), i = 0, RNGSeed = quick_pow(2, irandom_range(6, 8)),
		ByteArr = buffer_create(1, buffer_grow, 1);
	//Store RNG Seed of the byte encryption
	file_text_write_real(File, RNGSeed);
	file_text_writeln(File);
	//Add brackets to key and values and store the type of data stored
	repeat array_length(keys)
	{
		var curDat = map[? keys[i]];
		if is_string(curDat) DataType = 0;
		else if is_real(curDat) DataType = 1;
		else if is_array(curDat) DataType = 2;
		str += string("{0}:({1}{2})", keys[i], DataType, curDat);
		++i;
	}
	i = 1;
	//Convert the strings of data to byte values to encrypt via byte shifting then store them in a list
    repeat string_length(str)
    {
		var Byte = string_byte_at(str, i);
		Byte = string((Byte << RNGSeed) >> 256);
		//This ds list is for data encryption purposes in the future, please don't remove this yet
		//ds_list_add(ByteArr, Byte);
		buffer_write(ByteArr, buffer_text, Byte + "\n");
		++i;
    }
	i = 0;
	//Write each byte to the file
	//repeat ds_list_size(ByteArr)
	//{
	//	file_text_write_string(File, ByteArr[| i++]);
	//	file_text_writeln(File);
	//}
	buffer_seek(ByteArr, buffer_seek_start, 0);
	file_text_write_string(File, buffer_read(ByteArr, buffer_text));
	//Clean up
	file_text_close(File);
	//ds_list_destroy(ByteArr);
}

///Reads all data from global.TempData into a TempData.dat file
///@param {string} filename		The file name of the file to read the data with
function LoadData(fname = "TempData.dat", map = global.TempData)
{
	if !ds_exists(map, ds_type_map) map = ds_map_create();
	//You can change this, don't set this value too low or else it may corrupt the save
	//This value should be the same as the value set in the SaveData()
	static ByteDigits = 12;
	//Reads the RNG seed and then reads thee next line, which is all data
    var str = "", tmpfullstr, tmpkeystr, tmpvalstr, index = 1,
		File = file_text_open_read(fname), RNGSeed = file_text_read_real(File), i = 0;
	file_text_readln(File);
	//The full string of all byte data
	//Loops through each byte data to shift them back to the correct byte
	while !file_text_eof(File)
	{
		var ReadString = file_text_read_string(File);
		if ReadString == "" break;
		var Byte = (real(ReadString) << 256) >> RNGSeed;
		//Convert byte to string
		str += chr(Byte);
		file_text_readln(File);
	}
	file_text_close(File);
	//Convert string to data
	//Assume string is "Test:(0'Value')
	var CutSpace = 0;
	while true
	{
		//Breaks when no more brackets exist
		var NearestBrac = string_pos(")", str);
		if NearestBrac == 1 || str == "" break;
		var EndPos = NearestBrac - 1;
		//Return "Test:(0'Value'"
		tmpfullstr = string_copy(str, 1, EndPos);
		print("Full str: ", tmpfullstr);
		var NearestColon = string_pos(":", tmpfullstr);
		//Return "Test"
		tmpkeystr = string_copy(tmpfullstr, 1, NearestColon - 1);
		print("key str: ", tmpkeystr);
		//Return "Value"
		tmpvalstr = string_copy(tmpfullstr, NearestColon + 3, string_length(tmpfullstr) - NearestColon - 2);
		print("val str: ", tmpvalstr);
		//Retrieve the type of data and assign the value to the data set
		switch real(string_char_at(tmpfullstr, NearestColon + 2))
		{
			case 0: map[? tmpkeystr] = tmpvalstr; break;
			case 1: map[? tmpkeystr] = real(tmpvalstr); break;
			case 2:
				var Amount = 0, StrLen = string_length(tmpvalstr), i = 0, IsString = [], BeginIndexes = [];
				//Remove the brackets of the array
				tmpvalstr = string_copy(tmpvalstr, 2, StrLen - 2);
				tmpvalstr = string_trim(tmpvalstr);
				StrLen -= 2;
				//Iterate with each digit of the array string to prevent detecting
				//a ',' in a string in the array
				repeat StrLen
				{
					if string_char_at(tmpvalstr, i) == "\""
					{
						array_push(IsString, i);
						++i;
						while string_char_at(tmpvalstr, i) != "\""
						{
							i++;
							if i >= StrLen break;
						}
					}
					if string_char_at(tmpvalstr, i) == ","
					{
						Amount++;
						array_push(BeginIndexes, i);
					}
					++i;
				}
				//If there exist a comma, there are 1 + the number of commas of values in the array
				if Amount > 0
				{
					Amount++;
					array_push(BeginIndexes, string_length(tmpvalstr) + 1);
				}
				var arr = [], i = 0, index = 1;
				if Amount == 0 && tmpvalstr != ""
					arr = [string_copy(tmpvalstr, 2, string_length(tmpvalstr) - 2)];
				repeat Amount
				{
					var Val = string_copy(tmpvalstr, index, BeginIndexes[i] - index);
					if Val != ""
					{
						array_push(arr, string_char_at(Val, 1) == "\"" ? Val : real(Val));
					}
					index = BeginIndexes[i] + 1;
					++i;
				}
				map[? tmpkeystr] = arr;
				break;
		}
		//Trim out the collected data
		str = string_delete(str, 1, NearestBrac);
		print("Trimmed: ", str);
	}
	return map;
}
