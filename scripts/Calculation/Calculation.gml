/**
	Returns a Positive Quotient of the 2 values, do not confuse this with a % b
	@param {real} a The number to be divided
	@param {real} b The number to divide
*/
function posmod(a, b)
{
	forceinline
	var value = a % b;
	while (value < 0 && b > 0) || (value > 0 && b < 0) value += b;
	return value;
}

///Rotate the coordinates by the angle
function point_xy(p_x, p_y)
{
	forceinline
	var angle = image_angle;
	
	point_x = lengthdir_x(p_x - x, angle) + lengthdir_y(p_y - y, -angle) + x;
	point_y = lengthdir_x(p_y - y, angle) - lengthdir_y(p_x - x, -angle) + y;
}

///Calculating the legnthdir_xy position of the points
function point_xy_array(p_x, p_y)
{
	forceinline
	var angle = image_angle;
	
	return [lengthdir_x(p_x - x, angle) + lengthdir_y(p_y - y, -angle) + x,
	lengthdir_x(p_y - y, angle) - lengthdir_y(p_x - x, -angle) + y];
}

///Returns the lengthdir_x/y values in a Vector2 (stupidly useless)
function lengthdir_xy(length, dir) constructor
{
	forceinline
	return new Vector2(lengthdir_x(length, dir), lengthdir_y(length, dir));
}

/**
	Returns the summation of an array from a to b
	@param {array} array	The name of the array
	@param {real}  begin	The slot to begin
	@param {real}  end		The slot to end
*/
function Sigma(arr, n, k)
{
	forceinline
	for(var i = n, value = 0; i <= k; ++i)
		value += arr[i];
	return value;
}

/**
	Checks if the value is equal to the other given values
	@param {Any} var	The variable to checl
	@param {Any} val	The values to check for
*/
function is_val()
{
	forceinline
	var arr = [], i = 1;
	repeat argument_count - 1 array_push(arr, argument[i++]);
	return array_contains(arr, argument[0]);
}

/**
	Multiplies all indexes of the array with given number
	@param {Array} Array	The array to multiply
	@param {real} Multiply	The amount to multiply
*/
function array_multiply(arr, num)
{
	forceinline
	var i = 0;
	repeat array_length(arr) arr[i++] *= num;
	return arr;
}

/**
	Check whether the valuye contains the bit
	@param {real} Value	The value to check from
	@param {real} Bit	The bit to check
*/
function is_bit(val, bit)
{
	forceinline
	return (val & bit) != 0;
}

/*
	This is faster than the game maker built-in power()
	@param {real} x		The number to change
	@param {real} n		How many times to multiply x by itself
*/
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

///Checks whether two structs are equal (Does not support static variables)
///@param {struct}	a	The index of the first struct
///@param {struct}	b	The index of the struct struct
function struct_equals(struct_a, struct_b)
{
	aggressive_forceinline
	var struct_a_names = struct_get_names(struct_a),
		struct_b_names = struct_get_names(struct_a),
		a_count = struct_names_count(struct_a),
		i = 0, val_a, val_b;
	//Must not be equal when they have different amount of names
	if a_count != struct_names_count(struct_b) return false;
	//Compare values
	repeat a_count
	{
		val_a = struct_a[$ struct_a_names[i]];
		val_b = struct_b[$ struct_b_names[i]];
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