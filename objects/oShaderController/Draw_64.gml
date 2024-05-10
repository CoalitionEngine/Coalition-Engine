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
		if is_array(ShaderParams[i][$ ParamNames[j]])
			shader_set_uniform_f_array(shader_get_uniform(ShaderList[i], ParamNames[j]), ShaderParams[i][$ ParamNames[j]]);
		else shader_set_uniform_f(shader_get_uniform(ShaderList[i], ParamNames[j]), ShaderParams[i][$ ParamNames[j]]);
		++j;
	}
	var IsDrawnToSurf = ShaderApplyToSurface[i];
	//Copy the app surface if needed, if no then draw the surface directly
	if IsDrawnToSurf
	{
		if !surface_exists(SurfaceList[i]) SurfaceList[i] = surface_create(640, 480);
		surface_set_target(SurfaceList[i]);
		draw_surface(application_surface, 0, 0);
		surface_reset_target();
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