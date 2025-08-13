#macro __COALITION_SET_NOISE_SPRITE_TEXTURE if (!variable_instance_exists(id, "__NoiseVars"))\
	__NoiseVars = {\
		NoiseSprite: noise_sprite,\
		NoiseTexture: sprite_get_texture(noise_sprite, 0),\
		Noiseuvs: texture_get_uvs(NoiseTexture)\
	}
#macro __COALITION_NOISE_SHADER_SET_UNIFORMS texture_set_stage(Sampler, __NoiseVars.NoiseTexture);\
		shader_set_uniform_f(Level, NoiseFadeLevel);\
		shader_set_uniform_f(UV, __NoiseVars.Noiseuvs[0], __NoiseVars.Noiseuvs[1], texuvs[0], texuvs[1]);\
		shader_set_uniform_f(Rat, (__NoiseVars.Noiseuvs[2] - __NoiseVars.Noiseuvs[0]) / (texuvs[2] - texuvs[0]), (__NoiseVars.Noiseuvs[3] - __NoiseVars.Noiseuvs[1]) / (texuvs[3] - texuvs[1]))
///@func draw_noise_fade_sprite(sprite, subimg, x, y, time, duration, [noise_sprite])
///@desc Draws a sprite with a noise fade in (Will automatically convert to normal draw_sprite if the duration is reached)
///@param {Asset.GMSprite} sprite The sprite to draw
///@param {real} subimg The subimg of the sprite
///@param {real} x The x position of the sprite to draw
///@param {real} y The y position of the sprite to draw
///@param {real} time The time of the noise fade (The value of this needs to change constantly)
///@param {real} duration The total duration of the fade in
///@param {Asset.GMSprite} noise_sprite The noise sprite to use (It has to be a sprite of a noise)
function draw_noise_fade_sprite(sprite, subimg, x, y, time, duration, noise_sprite = sprNoiseRect) {
	aggressive_forceinline
	static UV = shader_get_uniform(shdNoiseFade, "mainuv"),
			Rat = shader_get_uniform(shdNoiseFade, "mainrat"),
			Level = shader_get_uniform(shdNoiseFade, "mainlev"),
			Sampler = shader_get_sampler_index(shdNoiseFade, "mainnoise");
	
	__COALITION_SET_NOISE_SPRITE_TEXTURE;
	if (time < duration)
	{
		var gettexture = sprite_get_texture(sprite, subimg),
			texuvs = texture_get_uvs(gettexture),
			NoiseFadeLevel = 1 - time / duration;
		shader_set(shdNoiseFade);
		__COALITION_NOISE_SHADER_SET_UNIFORMS;
		draw_sprite_ext(sprite, subimg, x, y, 1, 1, 0, c_white, 1 - NoiseFadeLevel);
		shader_reset();
	}
	else
		draw_sprite(sprite, subimg, x, y);
}
///@func draw_noise_fade_sprite_ext(sprite, subimg, x, y, xscale, yscale, rotation, color, time, duration, [noise_sprite])
///@desc Draws a sprite with a noise fade in (Will automatically convert to normal draw_sprite_ext if the duration is reached)
///@param {Asset.GMSprite} sprite The sprite to draw
///@param {real} subimg The subimg of the sprite
///@param {real} x The x position of the sprite to draw
///@param {real} y The y position of the sprite to draw
///@param {real} xscale The xscale of the sprite to draw
///@param {real} yscale The yscale of the sprite to draw
///@param {real} rot The rotation of the sprite to draw
///@param {Constant.Color} col The color of the sprite to draw
///@param {real} time The time of the noise fade (The value of this needs to change constantly)
///@param {real} duration The total duration of the fade in
///@param {Asset.GMSprite} noise_sprite The noise sprite to use (It has to be a sprite of a noise)
function draw_noise_fade_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, time, duration, noise_sprite = sprNoiseRect) {
	aggressive_forceinline
	static UV = shader_get_uniform(shdNoiseFade, "mainuv"),
			Rat = shader_get_uniform(shdNoiseFade, "mainrat"),
			Level = shader_get_uniform(shdNoiseFade, "mainlev"),
			Sampler = shader_get_sampler_index(shdNoiseFade, "mainnoise");
	
	__COALITION_SET_NOISE_SPRITE_TEXTURE;
	if (time < duration)
	{
		var NoiseFadeLevel = 1 - time / duration,
			gettexture = sprite_get_texture(sprite, subimg),
			texuvs = texture_get_uvs(gettexture);
		shader_set(shdNoiseFade);
		__COALITION_NOISE_SHADER_SET_UNIFORMS;
		draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, 1 - NoiseFadeLevel);
		shader_reset();
	}
	else
		draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, 1);
}