## Shaders
All engine exclusive shader related functions goes here

### `AddShaderEffect(shader, [surface])`
---
 Returns: `real`

Adds a shader effect, returning the shader ID stored in the controller for
declaring params and removing the effect

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`shader` |Asset.GMShader |The shader to add |
|`surf` |bool |Whether the shader will be applied on a new application_surface or not (Default false) |

**Returns:** The ID of the created shader effect

### `ShaderSetUniform(ID, name, value)`
---
 Returns: `undefined`

Sets the uniform_f values of a shader created using AddShaderEffect()

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |real |The ID of the shader (From AddShaderEffect()) |
|`name` |string |The name of the uniform to set the value of |
|`value` |real,array |The value or array to set the uniform to |






### `RemoveShaderEffect(ID)`
---
 Returns: `undefined`

Removes a shader effect added from AddShaderEffect()

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |real |The ID of the shader (From AddShaderEffect()) |






### `__Shader()` (*constructor*)

The shader constructor functions

**Methods**
#### `.Init()` Returns: `undefined`

Initalizes the shader variables

#### `.Clean()` Returns: `undefined`

Cleans the shader struct of shader parameters

#### `.Add(shader, [surface])` Returns: `real`

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`shader` |Asset.GMShader |The shader to add |
|`surf` |bool |Whether the shader will be applied on a new application_surface or not (Default false) |

**Returns:** The ID of the created shader effect

#### `.SetUniform(ID, name, value)` Returns: `undefined`

Sets the uniform_f values of a shader created using .Add()

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |real |The ID of the shader (From .Add()) |
|`name` |string |The name of the uniform to set the value of |
|`value` |real,array |The value or array to set the uniform to |






#### `.Remove(ID)` Returns: `Id.Instance<blur_shader>`

Removes a shader effect added from .Add()

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |real |The ID of the shader (From .Add()) |

### `Blue_Screen(duration, amount)`
---
 Returns: {rv}

Blurs the screen

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`duration` |real |The duration to blur |
|`amount` |real |The amount to blur |

**Returns:** The created blur_shader object
