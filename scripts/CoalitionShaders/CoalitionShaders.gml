///@return {real} The ID of the created shader effect
function AddShaderEffect(shader, surf = false)
{
	forceinline
	instance_check_create(oShaderController);
	return oShaderController.Main.Add(shader, surf);
}
///@func ShaderSetUniform(ID, name, value)
///@desc Sets the uniform_f values of a shader created using AddShaderEffect()
///@param {real} ID The ID of the shader (From AddShaderEffect())
///@param {string} name The name of the uniform to set the value of
///@param {real,array} value The value or array to set the uniform to
function ShaderSetUniform(ID, name, value)
{
	forceinline
	oShaderController.Main.SetUniform(ID, name, value);
}
///@func RemoveShaderEffect(ID)
///@desc Removes a shader effect added from AddShaderEffect()
///@param {real} ID The ID of the shader (From AddShaderEffect())
function RemoveShaderEffect(ID)
{
	forceinline
	oShaderController.Main.Remove(ID);
}