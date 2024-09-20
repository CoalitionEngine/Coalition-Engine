///@desc Turns, very trash, working on it
function end_turn() { forceinline; __turn_has_ended = true; }
//Dusting logic
if ContainsDust
{
	if !__died && __is_dying && __death_time >= 1 + attack_end_time {
		var total_height = enemy_total_height;
		with __dust
		{
			if !surface_exists(__surface) __surface = surface_create(640, 480);
			//Dust height adding
			if height < total_height
				height += total_height / other.dust_animation_duration * 6;
			var i = 0;
			//Only calculates 1/3 of the dust for randomization and less performance weight
			repeat array_length(x) / 3
			{
				if image_alpha[i] > 0 {
					x[i] += lengthdir_x(speed[i], direction[i]);
					y[i] += lengthdir_y(speed[i], direction[i]);
					image_alpha[i] -= 1 / life[i];
					image_angle[i] += rotate[i];
					if !__being_drawn __being_drawn = true;
				}
				i += 3;
			}
		}
	}
}

//Calculates the height and width of the enemy, then initalizes the dust particles (Will only run once, don't worry for lag)
if enemy_total_height == 0 || enemy_max_width == 0
{
	var i = 0;
	repeat(array_length(enemy_sprites))
	{
		enemy_max_width = max(sprite_get_width(enemy_sprites[i]) * enemy_sprite_scale[i][0],
								enemy_max_width);
		++i;
	}
	enemy_total_height = -array_last(enemy_sprite_pos)[1] + (sprite_get_height(array_last(enemy_sprites)) * 2 - sprite_get_yoffset(array_last(enemy_sprites))) * array_last(enemy_sprite_scale)[1];
	damage_y = y - enemy_total_height - 20;

	//Particles aren't used because if a lot of particles are created then the CPU will be abused
	//And the dust amount is on average at least a couple hundred, so drawing in arrays are better
	if ContainsDust {
		var max_width = enemy_max_width, total_height = enemy_total_height, _x = x, _y = y;
		with __dust
		{
			height = 0;
			amount = total_height * max_width / 6;
			speed = array_create_ext(amount, function() { return random_range(1, 3); });
			direction = array_create_ext(amount, function() { return random_range(55, 125); });
			life = array_create_ext(amount, function() { return irandom_range(60, 120); });
			image_alpha = array_create(amount, 1);
			image_angle = array_create_ext(amount, function() { return random(360); });
			rotate = array_create_ext(amount, function() { return random_range(1, -1); });
			i = 0;
			repeat amount
			{
				x[i] = random_range(-max_width, max_width) / 2 + _x;
				y[i] = _y - total_height + (i * 6 / max_width);
				i++;
			}
		}
	}
}
//Wiggle timer
__wiggle_timer = wiggle ? __wiggle_timer + 1 : 0;