/**
	Returns a Positive Quotient of the 2 values, do not confuse this with a % b
	@param {real} a The number to be divided
	@param {real} b The number to divide
*/
function posmod(a, b)
{
	gml_pragma("forceinline");
	var value = a % b;
	while (value < 0 and b > 0) or (value > 0 and b < 0) value += b;
	return value;
}

///Calculating the legnthdir_xy position of the points
function point_xy(p_x, p_y)
{
	gml_pragma("forceinline");
	var angle = image_angle;
	
	point_x = lengthdir_x(p_x - x, angle) + lengthdir_y(p_y - y, -angle) + x;
	point_y = lengthdir_x(p_y - y, angle) - lengthdir_y(p_x - x, -angle) + y;
}

///Calculating the legnthdir_xy position of the points
function point_xy_array(p_x, p_y)
{
	gml_pragma("forceinline");
	var angle = image_angle;
	
	return [lengthdir_x(p_x - x, angle) + lengthdir_y(p_y - y, -angle) + x,
	lengthdir_x(p_y - y, angle) - lengthdir_y(p_x - x, -angle) + y];
}

///Returns the lengthdir_x/y values in a Vector2 (stupidly useless)
function lengthdir_xy(length, dir) constructor
{
	gml_pragma("forceinline");
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
	gml_pragma("forceinline");
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
	gml_pragma("forceinline");
	//for (var i = 1; i < argument_count; ++i)
	//{
	//	if argument[0] == argument[i]
	//	{
	//		return true;
	//	}
	//}
	//return false;
	//If you encounter an error saying array_contains don't exist, use the above method instead
	var arr = [], i = 1;
	repeat argument_count - 1
		array_push(arr, argument[i++]);
	return array_contains(arr, argument[0]);
}

/**
	Multiplies all indexes of the array with given number
	@param {Array} Array	The array to multiply
	@param {real} Multiply	The amount to multiply
*/
function array_multiply(arr, num)
{
	gml_pragma("forceinline");
	var i = 0, n = array_length(arr);
	repeat n
		arr[i++] *= num;
	return arr;
}

/**
	Check whether the valuye contains the bit
	@param {real} Value	The value to check from
	@param {real} Bit	The bit to check
*/
function is_bit(val, bit)
{
	gml_pragma("forceinline");
	return (val & bit) != 0;
}

/*
	This is faster than the game maker built-in power()
	@param {real} x		The number to change
	@param {real} n		How many times to multiply x by itself
*/
function quick_pow(x, n)
{
	gml_pragma("forceinline");
	var ret = 1, pow = x;
	while n
	{
		if (n & 1) ret *= pow;
		pow *= pow;
		n = n >> 1;
	}
	return ret;
}