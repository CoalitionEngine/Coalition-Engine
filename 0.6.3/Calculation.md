# Calculation

### `posmod(a, b)`
---
 Returns: `real`. The quotient

Returns a Positive Quotient of the 2 values, do not confuse this with a % b

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`a` |`Real` |The number to be divided |
|`b` |`Real` |The number to divide |

### `point_xy(point_x, point_y)`
---
 Returns: `undefined`. Creates two variables

Rotate the coordinates by the angle

### `point_xy_array(point_x, point_y)`
---
 Returns: `Array<Real>`. The array of the rotated points

Rotate the coordinates by the angle and return them as an array

### `Sigma(array, begin, end)`
---
 Returns: `real`

Returns the summation of an array from a to b

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`array` |`Array` |The name of the array |
|`begin` |`Real` |The slot to begin |
|`end` |`Real` |The slot to end |

### `is_val(value, ...)`
---
 Returns: `bool`

Checks if the value is equal to the other given values

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`var` |`Any` |The variable to check |
|`val` |`Any` |The values to check for |

### `array_multiply(array, scalar)`
---
 Returns: `Array<Real>`

Multiplies all indexes of the array with given number

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Array` |`Array` |The array to multiply |
|`Multiply` |`Real` |The amount to multiply |

### `is_bit(value, bit)`
---
 Returns: `bool`

Check whether the value contains the bit

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Value` |`Real` |The value to check from |
|`Bit` |`Real` |The bit to check |

### `quick_pow(x, n)`
---
 Returns: `real`

This is faster than the game maker built-in power()

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The number to change |
|`n` |`Real` |How many times to multiply x by itself |

### `struct_equals(struct_a, struct_b)`
---
 Returns: `undefined`

Checks whether two structs are equal (Does not support static variables)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`a` |`Struct` |The index of the first struct |
|`b` |`Struct` |The index of the struct struct |
































