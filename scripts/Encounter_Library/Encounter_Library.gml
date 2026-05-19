///@function Encounter_Library
///@desc Initializes all encounters in the game, it is seperated from the intialization script to prevent future updates to overwrite the data
function Encounter_Library() {
	forceinline
	//Example on how to set up an encounter
	Enemy.SetEncounter(,, oEnemySansExample);
	Enemy.SetEncounter(,, new TestEnemy());
}
///@function Encounter_Animation_Data()
///@desc Initializes encounter animation data
function Encounter_Animation_Data() {
	function Encounter_Player_Alert_Step() {
		if (Encounter.Time() == 30)
		{
			Encounter.SetState(Encounter_Player_Flash_Step,, Encounter_Player_Default_GUI);
			Encounter.Time(0);
			__encounter_draw = __COALITION_ENCOUNTER_STATE_FLAG.BLACK_SCREEN;
		}
	}
	function Encounter_Player_Alert_Draw() {
		with (oOWPlayer)
			draw_sprite(sprEncounterExclaimation, 0, x, y - sprite_height);
	}
	function Encounter_Player_Flash_Step() {
		with (oOWPlayer)
		{
			var time = Encounter.Time();
			if (!(time % 5) && time < 20)
			{
				audio_play(snd_noise);
				__encounter_draw ^= __COALITION_ENCOUNTER_STATE_FLAG.DRAW_SOUL;
			}
			elif (time == 20)	//Soul moves to FIGHT button position
			{
				__encounter_draw = __COALITION_ENCOUNTER_STATE_FLAG.BLACK_SCREEN + __COALITION_ENCOUNTER_STATE_FLAG.DRAW_SOUL;
				audio_play(snd_encounter_soul_move);
				TweenFire(id, "", 0, false, 0, 30, "__encounter_soul_x>", 48, "__encounter_soul_y>", 454);
			}
			elif (time == 50)	//Prepare the fading screen
			{
				Encounter.SetState(Encounter_Player_Fade,, Encounter_Player_Default_GUI);
				Encounter.Time(0);
			}
		}
	}
	function Encounter_Player_Fade() {
		if (Encounter.Time() == 1)
		{
			Fader_Fade(1, 0, 20, 0, c_black);
			room_goto(room_battle);
		}
	}
	function Encounter_Player_Default_GUI() {
		with (oOWPlayer)
		{
			var _camScaleX = Camera.GetScale(1), _camScaleY = Camera.GetScale(2);
			if (__encounter_draw & __COALITION_ENCOUNTER_STATE_FLAG.BLACK_SCREEN)
				draw_clear(c_black);
			if (__encounter_draw & __COALITION_ENCOUNTER_STATE_FLAG.DRAW_PLAYER)
				draw_sprite_ext(sprite_index, image_index, (x - Camera.ViewX()) * _camScaleX, (y - Camera.ViewY() - sprite_get_height(sprite_index) / 2) * _camScaleY, _camScaleX, _camScaleY, image_angle, c_white, 1);
			if (__encounter_draw & __COALITION_ENCOUNTER_STATE_FLAG.DRAW_SOUL)
				draw_sprite_ext(sprSoul, 0, __encounter_soul_x, __encounter_soul_y, 1, 1, 0, c_red, 1);
		}
	}
	Encounter.SetInvokeEvent(function(exclaim, move) {
		with (oOWPlayer)
		{
			__encounter_draw = __COALITION_ENCOUNTER_STATE_FLAG.NONE;
			enum __COALITION_ENCOUNTER_STATE_FLAG {
				NONE = 0,
				BLACK_SCREEN = 1,
				DRAW_PLAYER = 2,
				DRAW_SOUL = 4,
			}
			//Gets the relative position of the player
			__encounter_soul_x = 	(x - Camera.ViewX()) * Camera.GetScale(1);
			__encounter_soul_y = 	(y - Camera.ViewY() - sprite_height / 2) * Camera.GetScale(2);
			var states = [
				[Encounter_Player_Alert_Step, Encounter_Player_Alert_Draw],
				[Encounter_Player_Flash_Step, undefined],
				[Encounter_Player_Fade, undefined]
			];
			var __encounter_state = 2 - move - exclaim;
			if (__encounter_state == 0)	
				audio_play(snd_warning);
	
			//Store current room data to return to
			global.__CurrentOverworldRoom = room;
			global.__CurrentOverworldSubRoom = oOWController.__OverworldSubRoom;
			global.__CurrentOverworldPosition = {x, y};
			global.__CurrentOverworldDirection = FacingDirection;
		}
		Encounter.SetState(states[__encounter_state][0], states[__encounter_state][1], Encounter_Player_Default_GUI);
	});
}

///This is a test enemy to showcase the EnemyData constructor function of creating an enemy
function TestEnemy() : EnemyData() constructor
{
	///@desc The create event of the enemy
	static Create = function()
	{
		audio_stop_all();
		Enemy.SetName(self, "Test");
		
		SetAttack(0, function() {
			if (time == 30)
				CreateBlaster(320, -100, 320, 150, -90, -90, 2, 2, 30, 30, 30);
		});
	};
	///@desc The step event of the enemy
	static Step = function() { };
	///@desc The draw event of the enemy (Executed at User Event 0, before auto masking)
	static Draw = function()
	{
		draw_sprite_ext(spr_sans_head, 0, x - lengthdir_y(93, global.timer), y + lengthdir_x(90, global.timer) - 85, 3, 3, global.timer, make_color_hsv(global.timer % 255, 255, 255), 1);
	};
}