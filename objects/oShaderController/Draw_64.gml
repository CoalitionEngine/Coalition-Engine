var ShaderAmount = array_length(ShaderList), i = 0;
//Don't process any code if shader list is empty
if ShaderAmount == 0 exit;

repeat ShaderAmount
{
	//Set the shader
	shader_set(ShaderList[i]);
	//Apply parameters
	var ParamNames = variable_struct_get_names(ShaderParams[i]), j = 0;
	repeat array_length(ParamNames)
	{
		var CurParamName = struct_get_from_hash(ShaderParams[i], variable_get_hash(ParamNames[j]));
		if is_array(CurParamName)
			shader_set_uniform_f_array(shader_get_uniform(ShaderList[i], ParamNames[j]), CurParamName);
		else shader_set_uniform_f(shader_get_uniform(ShaderList[i], ParamNames[j]), CurParamName);
		++j;
	}
	var IsDrawnToSurf = ShaderApplyToSurface[i];
	//Copy the app surface if needed, if no then draw the surface directly
	if IsDrawnToSurf
	{
		if !surface_exists(SurfaceList[i]) SurfaceList[i] = surface_create(640, 480);
		surface_copy(SurfaceList[i], 0, 0, application_surface);
	}
	else draw_surface(application_surface, 0, 0);
	//Reset the shader
	shader_reset();
	
	if IsDrawnToSurf
	{
		draw_sprite_ext(sprPixel, 0, 0, 0, 640, 480, 0, c_black, 1);
		draw_surface(SurfaceList[i], 0, 0);
	}
	++i;
}