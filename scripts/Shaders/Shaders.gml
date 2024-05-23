//All shader related functions goes here
room_instance_add(room_first, 0, 0, oShaderController);
/**
	Adds a shader effect, returning the shader ID stored in the controller for
	declaring params and removing the effect
	@param {Asset.GMShader}	shader		The shader to add
	@param {bool} surf					Whether the shader will be applied on a
										new application_surface or not (Default false)
*/
function AddShaderEffect(shader, surf = false)
{
	forceinline
	return oShaderController.Main.Add(shader, surf);
}
/**
	Sets the uniform_f values of a shader created using AddShaderEffect()
	@param {real} ID			The ID of the shader (From AddShaderEffect())
	@param {string} name		The name of the uniform to set the value of
	@param {real,array} value	The value or array to set the uniform to
*/
function ShaderSetUniform(ID, name, value)
{
	forceinline
	oShaderController.Main.SetUniform(ID, name, value);
}
/**
	Removes a shader effect added from AddShaderEffect()
	@param {real} ID	The ID of the shader (From AddShaderEffect())
*/
function RemoveShaderEffect(ID)
{
	forceinline
	oShaderController.Main.Remove(ID);
}
function __Shader() constructor
{
	///Initalizes the shader variables
	static Init = function()
	{
		aggressive_forceinline
		with oShaderController
		{
			//[shader, shader...]
			ShaderList = [];
			//[$ param name] = value
			ShaderParams = [{}];
			//Whether the shader will be applied on a new application_surface or not (Default false)
			ShaderApplyToSurface = [];
			SurfaceList = [];
		}
	}
	///Cleans the shader struct of shader parameters
	static Clean = function()
	{
		aggressive_forceinline
		with oShaderController
		{
			var i = 0;
			repeat array_length(ShaderParams)
			{
				if array_length(SurfaceList) > 0 && surface_exists(SurfaceList[i]) surface_free(SurfaceList[i]);
				delete ShaderParams[i++];
			}
		}
	}
	/**
		Adds a shader effect, returning the shader ID stored in the controller for
		declaring params and removing the effect
		@param {Asset.GMShader}	shader		The shader to add
		@param {bool} surf					Whether the shader will be applied on a
											new application_surface or not (Default false)
	*/
	static Add = function(shader, surf = false)
	{
		aggressive_forceinline
		with oShaderController
		{
			array_push(ShaderList, shader);
			array_push(SurfaceList, surf ? surface_create(640, 480) : -1);
			array_push(ShaderApplyToSurface, surf);
			return array_length(ShaderList) - 1;
		}
	}
	/**
		Sets the uniform_f values of a shader created using .Add()
		@param {real} ID			The ID of the shader (From .Add())
		@param {string} name		The name of the uniform to set the value of
		@param {real,array} value	The value or array to set the uniform to
	*/
	static SetUniform = function(ID, name, value)
	{
		aggressive_forceinline
		oShaderController.ShaderParams[ID][$ name] = value;
	}
	/**
		Removes a shader effect added from .Add()
		@param {real} ID	The ID of the shader (From .Add())
	*/
	static Remove = function(ID)
	{
		aggressive_forceinline
		delete oShaderController.ShaderParams[ID];
		array_delete(oShaderController.ShaderList, ID, 1);
	}
}

///@desc Blurs the screen
///@param {real} duration	The duration to blur
///@param {real} amount		The amount to blur 
function Blur_Screen(duration, amount)
{
	forceinline
	with instance_create_depth(0, 0, -1000, blur_shader)
	{
		self.duration = duration;	//sets duration
		var_blur_amount = amount;	//sets blur amount
		TweenFire(self, "o", 0, false, 0, duration, "var_blur_amount>", 0);
		return self;
	}
}