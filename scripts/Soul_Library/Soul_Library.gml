function InitializeSoulModes() {
	///@desc Basic movement for the soul
	///@param {bool} Horizontal	Enable horzontal movement (Default true)
	///@param {bool} Vertical	Enable vertical movement (Default true)
	function BasicMovement(hor = true, ver = true) {
		with (oSoul)
		{
			var move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1),
				_angle = image_angle;
			__move_x = __h_spd * move_spd;
			__move_y = __v_spd * move_spd;
			if (Movable)
			{
				if (hor)
					x += lengthdir_x(__move_x, _angle);
				if (ver)
					y += lengthdir_x(__move_y, _angle);
			}
		}
	}
	Soul.DefineSoulMode(SOUL_MODE.RED, c_red, BasicMovement);
	Soul.DefineSoulMode(SOUL_MODE.ORANGE, c_orange, function() {
		__COALITION_SOUL_DEFINE_LOCAL_VAR
		if (Movable)
		{
			//Movement particle
			if !(global.timer % 5)
				TrailEffect(25,,,,,,,, c_orange);
			//Movement
			MoveDirection = InputDirection(MoveDirection, INPUT_CLUSTER.NAVIGATION);
			var FinalAngle = MoveDirection + image_angle;
			x += lengthdir_x(move_spd, FinalAngle);
			y += lengthdir_y(move_spd, FinalAngle);
		}
	});
	Soul.DefineSoulMode(SOUL_MODE.YELLOW, c_yellow, function() {
		BasicMovement();
		//Shooting the bullet
		if (__yellow_soul_timer == 0)
		{
			if (PRESS_CONFIRM)
			{
				with instance_create_depth(x, y, 0, oYellowBullet)
				{
					image_angle = other.image_angle;
					__has_trail = other.YellowShootTrail;
				}
				//The delay until you can shoot the next bullet
				__yellow_soul_timer = YellowShootBuffer;
			}
		}
		else
			__yellow_soul_timer--;
	},,, function() { ExtraAngle = 180; });
	Soul.DefineSoulMode(SOUL_MODE.GREEN, c_lime, function() {
		__COALITION_SOUL_DEFINE_LOCAL_VAR
		//Disable green shields when not in turn
		if (Battle.State() == BATTLE_STATE.IN_TURN)
			instance_activate_object(oGreenShield);
		else
			instance_deactivate_object(oGreenShield);
		x = board.x;
		y = board.y;
		var X = x, Y = y;
		with (__GreenShieldData)
		{
			for (var i = 0, shield; i < Amount; ++i)
			{
				shield = List[| i];
				shield.Auto = Auto;
				shield.image_angle = Angle[| i] - 90;
				shield.image_alpha = Alpha[| i];
				shield.image_blend = Color[| i];
				shield.HitColor = HitColor[| i];
				shield.x = X + lengthdir_x(Distance[| i], Angle[| i]);
				shield.y = Y + lengthdir_y(Distance[| i], Angle[| i]);
				//Auto rotate
				if (Auto)
				{
					var min_len = infinity, nearest_arr = noone;
					with (oGreenArr)
					{
						min_len = min(min_len, __DistanceToTarget);
						if (min_len == __DistanceToTarget)
							nearest_arr = id;
					}
					if (nearest_arr != noone)
						Shield.__ApplyRotate(nearest_arr.Color, round(nearest_arr.__TargetDirection / 90));
				}
				//Rotation
				for (var ii = 0; ii < 4; ++ii)
				{
					if (is_bool(Input[# i, ii]))
					{
						if (Input[# i, ii])
							Shield.__ApplyRotate(i, ii);
					}
					else if (is_real(Input[# i, ii]))
						if (keyboard_check_pressed(Input[# i, ii]))
							Shield.__ApplyRotate(i, ii);
				}
				Angle[| i] += Shield.__RemainingRotateAngle(i) * (RotateDirection[| i] ? 0.16 : -0.16);
				Angle[| i] = posmod(Angle[| i], 360);
			}
		}
	},
	function() {
		//The green circle of green soul
		if (DrawGreenShieldCircle)
		{
			draw_set_circle_precision(16);
			draw_circle_colour(x - 0.5, y - 0.5, 30, c_green, c_green, 1);
		}
		//Draws the shield and arrows with addictive blending
		gpu_push_state();
		gpu_set_blendmode(bm_max);
		with (oGreenArr)
			draw_self();
		with (oGreenShield)
			draw_sprite_ext(sprite_index, 0, x, y, 1, 1, image_angle, image_blend, image_alpha);
		gpu_pop_state();
	});
	Soul.DefineSoulMode(SOUL_MODE.PURPLE, c_purple, function() {
		__COALITION_SOUL_DEFINE_LOCAL_VAR
		//Switch between horizontal and vertical
		var soul = self;
		image_angle = board_angle;
		with (PurpleSoulData)
		{
			if (keyboard_check_pressed(vk_space) && AllowVertical)
			{
				Mode = Mode == 1 ? 0 : 1;
				soul.x = __target_x;
				soul.y = __target_y;
				ForceAlpha = 1;
			}
			var board_width =	board.right + board.left - 30,
				board_height =	board.up + board.down - 30,
				_h_line_count = HLineAmount,
				_v_line_count = VLineAmount,
				_first_line_x = board_x - lengthdir_x(board_width / 2, board_angle) + lengthdir_y(board_height / 2, board_angle),
				_first_line_y = board_y - lengthdir_x(board_height / 2, board_angle) - lengthdir_y(board_width / 2, board_angle);
			if (!Mode)
			{
				var _delta_x = lengthdir_x(board_height / (_h_line_count - 1), board_angle - 90),
					_delta_y = lengthdir_y(board_height / (_h_line_count - 1), board_angle - 90),
					_input_ver = PRESS_VERTICAL;
				__target_x = _first_line_x + lengthdir_x(board_width / 2 + __line_x, board_angle) + CurrentHLine * _delta_x;
				__target_y = _first_line_y + lengthdir_y(board_width / 2 + __line_x, board_angle) + CurrentHLine * _delta_y;
				if (_input_ver != 0)
					CurrentHLine = clamp(CurrentHLine + _input_ver, 0, HLineAmount - 1);
			}
			else
			{
				var _delta_x = lengthdir_x(board_width / (_v_line_count - 1), board_angle),
					_delta_y = lengthdir_y(board_width / (_v_line_count - 1), board_angle),
					_input_hor = PRESS_HORIZONTAL;
				__target_x = _first_line_x + lengthdir_y(board_height / 2 + __line_y, board_angle) + CurrentVLine * _delta_x;
				__target_y = _first_line_y + lengthdir_x(board_height / 2 + __line_y, board_angle) + CurrentVLine * _delta_y;
				if (_input_hor != 0)
					CurrentVLine = clamp(CurrentVLine + _input_hor, 0, VLineAmount - 1);
			}
			soul.x = decay(soul.x, __target_x, LerpSpeed);
			soul.y = decay(soul.y, __target_y, LerpSpeed);
		}
		//Movement method
		var move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1);
		__move_x = __h_spd * move_spd;
		__move_y = __v_spd * move_spd;
		if (Movable)
		{
			if (!PurpleSoulData.Mode)
			{
				var _dx = lengthdir_x(__move_x, board_angle), _dy = lengthdir_y(__move_x, board_angle);
				PurpleSoulData.__line_x = clamp(PurpleSoulData.__line_x + _dx * (sign(dcos(board_angle)) >= 0 ? 1 : -1), -board_width / 2, board_width / 2);
			}
			else
			{
				var _dy = lengthdir_x(__move_y, board_angle), _dx = lengthdir_y(__move_y, board_angle);
				PurpleSoulData.__line_y = clamp(PurpleSoulData.__line_y + _dy * (sign(dsin(board_angle)) >= 0 ? 1 : -1), -board_height / 2, board_height / 2);
			}
			x += _dx;
			y += _dy;
			PurpleSoulData.__target_x += _dx;
			PurpleSoulData.__target_y += _dy;
		}
	},
	function() {
		var board =			BattleBoardList[min(__SoulListID, array_length(BattleBoardList) - 1)],
			board_x	=		board.__true_x,
			board_y	=		board.__true_y,
			b_up =			board.up - 15,
			b_down =		board.down - 15,
			b_left =		board.left - 15,
			b_right =		board.right,
			board_width =	board.right + board.left - 30,
			board_height =	board.up + board.down - 30,
			_v_line_count = PurpleSoulData.VLineAmount,
			_h_line_count = PurpleSoulData.HLineAmount;
		//Horizontal lines
		with (PurpleSoulData)
		{
			draw_set_alpha(Mode == 0 ? 1 : 0.3);
			draw_set_color(c_purple);
			var _angle = board.image_angle,
				_first_line_x = board_x - lengthdir_x(board_width / 2, _angle) + lengthdir_y(board_height / 2, _angle),
				_first_line_y = board_y - lengthdir_x(board_height / 2, _angle) - lengthdir_y(board_width / 2, _angle),
				_delta_x = lengthdir_x(board_height / (_h_line_count - 1), _angle - 90),
				_delta_y = lengthdir_y(board_height / (_h_line_count - 1), _angle - 90),
				_length_x = lengthdir_x(board_width, _angle),
				_length_y = lengthdir_y(board_width, _angle);
			for (var i = 0; i < _h_line_count; ++i)
			{
				var _cur_line_x = _first_line_x + i * _delta_x,
					_cur_line_y = _first_line_y + i * _delta_y;
				draw_line(_cur_line_x, _cur_line_y, _cur_line_x + _length_x, _cur_line_y + _length_y);
			}
			if (AllowVertical)
			{
				//Vertical lines
				draw_set_alpha(Mode == 1 ? 1 : 0.3);
				var _delta_x = lengthdir_x(board_width / (_v_line_count - 1), _angle),
					_delta_y = lengthdir_y(board_width / (_v_line_count - 1), _angle),
					_length_x = lengthdir_x(board_height, _angle - 90),
					_length_y = lengthdir_y(board_height, _angle - 90);
				for (var i = 0; i < _h_line_count; ++i)
				{
					var _cur_line_x = _first_line_x + i * _delta_x,
						_cur_line_y = _first_line_y + i * _delta_y;
					draw_line(_cur_line_x, _cur_line_y, _cur_line_x + _length_x, _cur_line_y + _length_y);
				}
				//Fading effect when line changes
				ForceAlpha = decay(ForceAlpha, 0, AlphaLerpSpeed);
				Battle_Masking_Start();
				draw_sprite_ext(sprPixelBig, 0, board_x, board_y, board_width / 2, board_height / 2, _angle, c_purple, ForceAlpha);
				Battle_Masking_End();
			}
			draw_set_color(c_white);
			draw_set_alpha(1);
		}
	});
	Soul.DefineSoulMode(SOUL_MODE.BLUE, c_blue, function() {
		__COALITION_SOUL_DEFINE_LOCAL_VAR
		//If the board assigned to the soul is a vertex board, use the alternate method
		if (BattleBoardList[TargetSoul].VertexMode)
		{
			__BlueSoulProcess(
				!read_bit(__PointInside, MoveDirection / 90),
				!read_bit(__PointInside, (MoveDirection / 90 + 2) % 4)
			);
			return;
		}
		//If the board assigned to the soul is not a vertex board, process normally
		//Reassign the input checking for blue soul because the diagonal movement does not apply to it
		__h_spd = InputOpposing(INPUT_VERB.LEFT, INPUT_VERB.RIGHT);
		__v_spd = InputOpposing(INPUT_VERB.UP, INPUT_VERB.DOWN);
		MoveDirection %= 360;
		image_angle = (MoveDirection + 90) % 360;

		var _angle = image_angle,
			_dist = point_distance(board_x, board_y, x, y),
			_dir = point_direction(board_x, board_y, x, y) - board_dir,
			r_x = lengthdir_x(_dist, _dir) + board_x,
			r_y = lengthdir_y(_dist, _dir) + board_y,
			displace_x = lengthdir_x(x_offset + board.FrameThickness / 2, _angle - 90),
			displace_y = lengthdir_y(y_offset + board.FrameThickness / 2, _angle - 90),
			//Store board vertices into vectors for checking (Rotated board is a parallelogram)
				
			TL = new Vector2(-board.left, -board.up).Rotated(board_angle),
			TR = new Vector2(board.right, -board.up).Rotated(board_angle),
			BL = new Vector2(-board.left, board.down).Rotated(board_angle),
			BR = new Vector2(board.right, board.down).Rotated(board_angle);
			var board_vertices =
			[
				board_x + TL.x, board_y + TL.y,
				board_x + TR.x, board_y + TR.y,
				board_x + BR.x, board_y + BR.y,
				board_x + BL.x, board_y + BL.y,
			];
		__BlueSoulProcess(
			!point_in_parallelogram(r_x + displace_x, r_y + displace_y, board_vertices),
			!point_in_parallelogram(r_x - displace_x, r_y - displace_y, board_vertices)
			);
	},, true);
}
#macro __COALITION_SOUL_DEFINE_LOCAL_VAR	var move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1),\
												x_offset = sprite_width / 2,\
												y_offset = sprite_height / 2,\
												check_board = instance_exists(oBoard);\
											if (check_board)\ // When the board is real XD
											{\
												var board			= BattleBoardList[min(__SoulListID, array_length(BattleBoardList) - 1)],\
													board_x			= board.x,\
													board_y			= board.y,\
													board_angle		= posmod(board.image_angle, 360),\
													board_dir		= board_angle div 90,\
													board_top_limit		= board_y - board.up + y_offset,\
													board_bottom_limit	= board_y + board.down - y_offset,\
													board_left_limit	= board_x - board.left + x_offset,\
													board_right_limit	= board_x + board.right - x_offset;\
											}