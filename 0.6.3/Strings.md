# Strings

## `string_to_array(string)` Returns: *Array\<String\>*
Converts a string to an array

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`string` |string |The string to convert the array to |

## `array_to_string(array)` Returns: *string*
Converts a array to a string

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`array` |Array\<string\> |The array to convert the string to |

## `string_replace_unicode(string)` Returns: *string*
replaces all Unicode escapes in a string with corresponding characters

## `chr_from_hex(string)` Returns: *string*

## `dec_to_hex(decimal, digits)` Returns: *string*
Returns a given value as a string of hexadecimal digits.
Hexadecimal strings can be padded to a minimum length.
Note: If the given value is negative, it will
be converted using its two's complement form.

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`dec` |real |integer |
|`len` |real |minimum number of digits |

## `buffer_read_utf8(buffer)` Returns: *real*
Reads a utf8 string from a buffer

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`buffer` |Id.Buffer |The buffer to read from |

## `string_lower_buffer(string)` Returns: *string*
Lowers a string using the buffer method, this is faster than the built-in string_lower()

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`string` |string |The string to lower the cases of |
