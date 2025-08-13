///@category Soul
///@title Shield
///@text Below are the functions that are related to the green soul shield

///@constructor
///@func __Shield()
///@desc Shield data
function __Shield() constructor
{
	///@method Add(color, hit_color, input_keys)
	///@desc Adds a shield
	///@param {Constant.Color} Color The color of the shield
	///@param {Constant.Color} Hit_Color The color of the tip of the shield when colliding with an arrow
	///@param {Array<Constant.VirtualKeys>,Array<real>,Array<bool>} Input_keys the array of keys to check (right, up, left, down)
	///@return {Id.Instance<oGreenShield>} The created shield
	static Add = function(col, hit_col, input)
	{
		var curSoul = COALITION_CURRENT_SOUL;
		with (curSoul.__GreenShieldData)
		{
			ds_list_add(Color, col);
			ds_list_add(HitColor, hit_col);
			ds_list_add(Alpha, 1);
			ds_list_add(Distance, 18);
			ds_list_add(Angle, 0);
			ds_list_add(TargetAngle, 0);
			ds_list_add(RotateDirection, false);
			ds_grid_resize(Input, Amount + 1, 4);
			var i = 0;
			repeat (4)
			{
				Input[# Amount, i] = input[i];
				++i;
			}
			var shield = instance_create_depth(curSoul.x, curSoul.y, curSoul.depth, oGreenShield);
			shield.ID = Amount++;
			ds_list_add(List, shield);
			return shield;
		}
	}
	///@method Remove(ID)
	///@desc Removes a shield
	///@param {real} ID The id of the shield
	///@return {Struct.__Shield}
	static Remove = function(ID)
	{
		with (COALITION_CURRENT_SOUL.__GreenShieldData)
		{
			ds_list_delete(Color, ID);
			ds_list_delete(HitColor, ID);
			ds_list_delete(Alpha, ID);
			ds_list_delete(Distance, ID);
			ds_list_delete(Angle, ID);
			ds_list_delete(TargetAngle, ID);
			ds_list_delete(RotateDirection, ID);
			instance_destroy(List[| ID]);
			ds_list_delete(List, ID);
			ds_grid_resize(Input, Amount - 1, 4);
			var i = 0;
			repeat (4)
				Input[# ID, i] = noone;
			var temp = ds_grid_create(--Amount, 4);
			for (var i = 0, k = 0; i < Amount; ++i) {
				var ii = 0;
				if (Input[# k, 0] != noone)
				{
					repeat (4)
						temp[# i, ii] = Input[# k, ii++];
					k++;
				}
			}
			ds_grid_resize(Input, Amount, 4);
			ds_grid_clear(Input, noone);
			ds_grid_copy(Input, temp);
			ds_grid_destroy(temp);
		}
		return self;
	}
	///@desc Gets the remaining rotating angle of the shield
	///@param {real} ID The ID of the shield
	///@return {real} The remaining angle
	static __RemainingRotateAngle = function(ID)
	{
		forceinline
		with (COALITION_CURRENT_SOUL.__GreenShieldData)
			return min((TargetAngle[| ID] - Angle[| ID] + 360) % 360, (360 - TargetAngle[| ID] + Angle[| ID]) % 360);
	}
	///@desc Applies the rotation for the shield
	///@param {real} ID The ID of the shield
	///@param {real} dir The direction to rotate to
	///@return {real} The remaining angle
	static __ApplyRotate = function(ID, dir)
	{
		forceinline
		with (COALITION_CURRENT_SOUL.__GreenShieldData)
		{
			TargetAngle[| ID] = (dir * 90) % 360;
			RotateDirection[| ID] = ((TargetAngle[| ID] - Angle[| ID] + 360) % 360) < ((360 - TargetAngle[| ID] + Angle[| ID]) % 360);
		}
	}
}