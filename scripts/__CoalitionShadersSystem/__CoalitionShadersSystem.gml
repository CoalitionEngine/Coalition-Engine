///@category Special Scripts
///@title Shaders
///@text All engine exclusive shader related functions goes here
//room_instance_add(room_first, 0, 0, oShaderController);

///@func AddShaderEffect(shader, [surface])
///@desc Adds a shader effect, returning the shader ID stored in the controller for
///declaring params and removing the effect
///@param {Asset.GMShader} shader The shader to add
///@param {bool} surf Whether the shader will be applied on a new application_surface or not (Default false)
///@constructor
///@func __Shader()
///@desc The shader constructor functions
function __Shader() constructor
{
	///@method Init()
	///@desc Initalizes the shader variables
	///@return {undefined}
	static Init = function()
	{
		aggressive_forceinline
		with (oShaderController)
		{
			//[shader, shader...]
			ShaderList = [];
			//[$ param name] = value
			ShaderParams = [{}];
			//Whether the shader will be applied on a new application_surface or not (Default false)
			ShaderApplyToSurface = [];
			SurfaceList = [];
		}
		return self;
	}
	///@method Clean()
	///@desc Cleans the shader struct of shader parameters
	///@return {undefined}
	static Clean = function()
	{
		aggressive_forceinline
		with (oShaderController)
		{
			var i = 0;
			repeat (array_length(ShaderParams))
			{
				if (array_length(SurfaceList) > 0 && surface_exists(SurfaceList[i])) surface_free(SurfaceList[i]);
				delete ShaderParams[i++];
			}
		}
	}
	///@method Add(shader, [surface])
	///@decs Adds a shader effect, returning the shader ID stored in the controller for declaring params and removing the effect
	///@param {Asset.GMShader} shader The shader to add
	///@param {bool} surf Whether the shader will be applied on a new application_surface or not (Default false)
	///@return {real} The ID of the created shader effect
	static Add = function(shader, surf = false)
	{
		aggressive_forceinline
		with (oShaderController)
		{
			array_push(ShaderList, shader);
			array_push(SurfaceList, surf ? surface_create(640, 480) : -1);
			array_push(ShaderApplyToSurface, surf);
			return array_length(ShaderList) - 1;
		}
	}
	///@method SetUniform(ID, name, value)
	///@desc Sets the uniform_f values of a shader created using .Add()
	///@param {real} ID The ID of the shader (From .Add())
	///@param {string} name 	The name of the uniform to set the value of
	///@param {real,array} value The value or array to set the uniform to
	///@return {undefined}
	static SetUniform = function(ID, name, value)
	{
		aggressive_forceinline
		struct_set_from_hash(oShaderController.ShaderParams[ID], variable_get_hash(name), value);
	}
	///@method Remove(ID)
	///@desc Removes a shader effect added from .Add()
	///@param {real} ID The ID of the shader (From .Add())
	///@return {undefined}
	static Remove = function(ID)
	{
		aggressive_forceinline
		delete oShaderController.ShaderParams[ID];
		array_delete(oShaderController.ShaderList, ID, 1);
	}
}