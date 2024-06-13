///@category Special Scripts
///@title Calculation

///@func posmod(a, b)
///@desc Returns a Positive Quotient of the 2 values, do not confuse this with a % b
///@param {real} a The number to be divided
///@param {real} b The number to divide
///@return {real} The quotient
function posmod(a, b)
{
	forceinline
	var value = a % b;
	while (value < 0 && b > 0) || (value > 0 && b < 0) value += b;
	return value;
}

///@func smootherstep(a, b, value)
///@desc Interpolates between a and b, base on value. With smoothing using Perlin's method instead of Hermite's.
///@param {Real} a The first value
///@param {Real} b The second value
///@param {Real} value The amount to interpolate
///@return {Real}
function smootherstep(a, b, value)
{
	forceinline
	value = clamp((value - a) / (b - a), 0, 1);
	return value * value * value * (value * (6 * value - 15) + 10);
}

///@func delta_lerp(a, b, value)
///@desc Applies lerping with consideration of delta time
///@param {Real} a The first value
///@param {Real} b The second value
///@param {Real} value The amount to interpolate
///@return {Real}
function delta_lerp(a, b, value)
{
	forceinline
	return (a - b) * quick_pow(value, delta_time / 1000000 * fps) + b;
}

///@func decay(a, b, decay)
///@desc Expotential decay function
///@param {Real} a The first value
///@param {Real} b The second value
///@param {Real} decay The decay value
///@return {real}
function decay(a, b, decay = 16)
{
	forceinline
	return b + (a - b) * exp(-decay * (COALITION_DELTA_TIME ? delta_time / 1000000 : 1) * fps);
}

///@func point_xy(point_x, point_y)
///@desc Rotate the coordinates by the angle
///@return {undefined} Creates two variables
function point_xy(p_x, p_y)
{
	forceinline
	var angle = image_angle;
	
	point_x = lengthdir_x(p_x - x, angle) + lengthdir_y(p_y - y, -angle) + x;
	point_y = lengthdir_x(p_y - y, angle) - lengthdir_y(p_x - x, -angle) + y;
}
///@func point_xy_array(point_x, point_y)
///@desc Rotate the coordinates by the angle and return them as an array
///@return {Array<Real>} The array of the rotated points
function point_xy_array(p_x, p_y)
{
	forceinline
	var angle = image_angle;
	
	return [lengthdir_x(p_x - x, angle) + lengthdir_y(p_y - y, -angle) + x,
	lengthdir_x(p_y - y, angle) - lengthdir_y(p_x - x, -angle) + y];
}

///@func Sigma(array, begin, end)
///@desc Returns the summation of an array from a to b
///@param {array} array The name of the array
///@param {real} begin The slot to begin
///@param {real} end The slot to end
///@return {real}
function Sigma(arr, n, k)
{
	forceinline
	for(var i = n, value = 0; i <= k; ++i)
		value += arr[i];
	return value;
}

///@func is_val(value, ...)
///@desc Checks if the value is equal to the other given values
///@param {Any} var The variable to check
///@param {Any} val The values to check for
///@return {bool}
function is_val()
{
	forceinline
	var i = 1;
	repeat argument_count - 1 if argument[0] == argument[i++] return true;
}

///@func array_multiply(array, scalar)
///@desc Multiplies all indexes of the array with given number
///@param {Array} Array The array to multiply
///@param {real} Multiply The amount to multiply
///@return {Array<Real>}
function array_multiply(arr, num)
{
	forceinline
	var i = 0;
	repeat array_length(arr) arr[i++] *= num;
	return arr;
}

///@func is_bit(value, bit)
///@desc Check whether the value contains the bit
///@param {real} Value The value to check from
///@param {real} Bit The bit to check
///@return {bool}
function is_bit(val, bit)
{
	forceinline
	return (val & bit) != 0;
}

///@func quick_pow(x, n)
///@desc This is faster than the game maker built-in power()
///@param {real} x The number to change
///@param {real} n How many times to multiply x by itself
///@return {real}
function quick_pow(x, n)
{
	forceinline
	var ret = 1, pow = x;
	while n
	{
		if (n & 1) ret *= pow;
		pow *= pow;
		n = n >> 1;
	}
	return ret;
}
///@func struct_equals(struct_a, struct_b)
///@desc Checks whether two structs are equal (Does not support static variables)
///@param {struct} a The index of the first struct
///@param {struct} b The index of the struct struct
function struct_equals(struct_a, struct_b)
{
	aggressive_forceinline
	var struct_a_names = struct_get_names(struct_a),
		struct_b_names = struct_get_names(struct_a),
		a_count = struct_names_count(struct_a),
		i = 0, val_a, val_b, hash;
	//Must not be equal when they have different amount of names
	if a_count != struct_names_count(struct_b) return false;
	//Compare values
	repeat a_count
	{
		hash = variable_get_hash(struct_a_names[i]);
		val_a = struct_get_from_hash(struct_a, hash);
		val_b = struct_get_from_hash(struct_b, hash);
		if is_array(val_a)
		{
			if !array_equals(val_a, val_b) return false;
		}
		else if is_struct(val_a)
		{
			if !struct_equals(val_a, val_b) return false;
		}
		else if val_a != val_b
		{
			//Check for obscure variable types
			if !(is_nan(val_a) && is_nan(val_b)) return false;
		}
		++i;
	}
	return true;
}