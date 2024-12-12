Camera.Scale(1, 1);
audio_stop_all();
draw_set_align();
enum DEBUG_STATE
{
	MAIN = 0,
	ROOMS = 1,
	SOUNDS = 2,
	SPRITES = 3,
}
State = 0;

//List of main options
MainOption = {};
with MainOption
{
	Options =
	[
		"Rooms",
		"Sounds",
		"Sprites",
	];
	Surf = -1;
	DisplaceX = 0;
	DisplaceY = 0;
	DisplaceXTarget = 0;
	DisplaceYTarget = 0;
	Choice = -1;
	Lerp = 0;
	var MainOptionMaxHeight = 440;
	TotalHeight = 70 * array_length(Options);
	MaxY = -max(0, TotalHeight - MainOptionMaxHeight);
}
SubOption = {};
with SubOption
{
	Surf = -1;
}

//Load rooms
RoomList = [room_get_name(room_first)];
var Rooms = room_first;
while room_next(Rooms) != -1
{
	Rooms = room_next(Rooms);
	array_push(RoomList, room_get_name(Rooms));
}
//Load sounds
audio_group_load(audgrpoverworld);
audio_group_load(audgrpbattle);
AudioList = [];
var i = 0;
while audio_exists(i)
{
	array_push(AudioList, audio_get_name(i));
	++i;
}
var file_name = file_find_first("Music/*.ogg", fa_none);
while string_width(file_name) != 0
{
    array_push(AudioList, file_name);
    file_name = file_find_next();
}
file_find_close();
array_sort(AudioList, true);
//Load sprites
SpriteList = [];
i = 0;
while sprite_exists(i)
{
	array_push(SpriteList, sprite_get_name(i));
	++i;
}
array_sort(SpriteList, true);

function LoadSubOptions(listnum)
{
	static Lists =
		[
			RoomList,
			AudioList,
			SpriteList,
		];
	
	//Sub-options
	with SubOption
	{
		Options = Lists[listnum];
		DisplaceX = 0;
		DisplaceY = 0;
		DisplaceXTarget = 0;
		DisplaceYTarget = 0;
		Choice = -1;
		Lerp = 0;
		static SubOptionMaxHeight = 440;
		TotalHeight = 70 * array_length(Options);
		MaxY = -max(0, TotalHeight - SubOptionMaxHeight);
		DrawSprite = -1;
		Stream = -1;
		Audio = -1;
		AudioLength = -1;
	}
}

function SubOptionAction(index)
{
	audio_stop_sound(SubOption.Audio);
	switch State
	{
		case DEBUG_STATE.ROOMS:
			room_goto(asset_get_index(RoomList[index]));
			break;
		case DEBUG_STATE.SOUNDS:
			var curAudio = AudioList[index];
			with SubOption
			{
				if string_ends_with(curAudio, ".ogg")
				{
					Stream = audio_create_stream("Music/" + string(curAudio));
					Audio = audio_play(Stream);
				}
				else Audio = audio_play(asset_get_index(curAudio));
				AudioLength = audio_sound_length(Audio);
				AudioLengthMin = string(AudioLength div 60);
				AudioLengthSec = string(round(AudioLength mod 60));
				if AudioLengthSec < 10 AudioLengthSec = "0" + AudioLengthSec;
			}
			break;
		case DEBUG_STATE.SPRITES:
			MainOption.DisplaceXTarget = -260;
			SubOption.DisplaceXTarget = -250;
			SubOption.DrawSprite = asset_get_index(SpriteList[index]);
			break;
		
	}
}