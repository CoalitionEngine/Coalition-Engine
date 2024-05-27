# Data mainipulation
You can freely change the encoding/decoding method
Be sure to keep it consistent

## `SetTempData(name, value)`
---
 Returns: `undefined`

Saves tempoary data

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`name` |string |The name of the slot to be saved |
|`value` |Any |The value of the slot to be saved |








## `GetTempData(name)`
---
 Returns: `undefined`

Get tempoary data

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`name` |string |The name of the slot to be aquired |








## `SaveData(filename, struct, [function])`
---
 Returns: `undefined`

Saves all data from global.TempData into a TempData.dat file

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |string |The file name of the file to store the data with |
|`struct` |struct|Id.dsmap |The struct/ds_map to save |
|`function` |function |The custom function for encoding (Input: string, Output: string) |





























## `LoadData(filename, [function])`
---
 Returns: `undefined`

Loads the saved data from the given file name

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |string |The file name of the file to read the data with |
|`function` |function |The custom function for decoding (Input: string, Output: string) |

















































