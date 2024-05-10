// References:
// https://www.deepskycolors.com/archive/2010/04/21/formulas-for-Photoshop-blending-modes.html
// https://github.com/jamieowen/glsl-blend
// https://www.ryanjuckett.com/photoshop-blend-modes-in-hlsl/

varying vec2 v_vTexcoord;

// It's generally a good idea not to do floating point comparisons with ==;
// it's safer to write an equality function/macro function but I'm not getting into that today

bool Equals(float val1, float val2) {
    return abs(val1 - val2) < 0.001;
}

uniform sampler2D samp_dst;

uniform int u_BlendMode;

#region Default blending modes
vec3 BlendModeNormal(vec3 src, vec3 dst) {
    return src;
}

vec3 BlendModeAdd(vec3 src, vec3 dst) {
    return src + dst;
}

vec3 BlendModeSubtract(vec3 src, vec3 dst) {
    return dst - src;
}
#endregion


#region Basic vector math blend modes
vec3 BlendModeDarken(vec3 src, vec3 dst) {
    return min(src, dst);
}

vec3 BlendModeLighten(vec3 src, vec3 dst) {
    return max(src, dst);
}

vec3 BlendModeMultiply(vec3 src, vec3 dst) {
    return src * dst;
}

vec3 BlendModeLinearBurn(vec3 src, vec3 dst) {
    return src + dst - 1.0;
}

vec3 BlendModeScreen(vec3 src, vec3 dst) {
    return 1.0 - ((1.0 - src) * (1.0 - dst));
}

vec3 BlendModeDifference(vec3 src, vec3 dst) {
    return abs(src - dst);
}

vec3 BlendModeExclusion(vec3 src, vec3 dst) {
    return src + dst - 2.0 * src * dst;
}
#endregion


#region Component-wise blend modes
vec3 BlendModeColorBurn(vec3 src, vec3 dst) {
    return 1.0 - ((1.0 - dst) / max(src, 0.001));
}

vec3 BlendModeColorDodge(vec3 src, vec3 dst) {
    return dst / max(1.0 - src, 0.001);
}

vec3 BlendModeOverlay(vec3 src, vec3 dst) {
    vec3 tmp;
    tmp.r = (dst.r > 0.5) ? (1.0 - (1.0 - 2.0 * (dst.r - 0.5)) * (1.0 - src.r)) : (2.0 * dst.r * src.r);
    tmp.g = (dst.g > 0.5) ? (1.0 - (1.0 - 2.0 * (dst.g - 0.5)) * (1.0 - src.g)) : (2.0 * dst.g * src.g);
    tmp.b = (dst.b > 0.5) ? (1.0 - (1.0 - 2.0 * (dst.b - 0.5)) * (1.0 - src.b)) : (2.0 * dst.b * src.b);
    
    return tmp;
}

vec3 BlendModeSoftLight(vec3 src, vec3 dst) {
    vec3 tmp;
    tmp.r = (src.r < 0.5) ? (2.0 * dst.r * src.r + pow(dst.r, 2.0) * (1.0 - 2.0 * src.r)) : (sqrt(dst.r) * (2.0 * src.r - 1.0) + 2.0 * dst.r * (1.0 - src.r));
    tmp.g = (src.g < 0.5) ? (2.0 * dst.g * src.g + pow(dst.g, 2.0) * (1.0 - 2.0 * src.g)) : (sqrt(dst.g) * (2.0 * src.g - 1.0) + 2.0 * dst.g * (1.0 - src.g));
    tmp.b = (src.b < 0.5) ? (2.0 * dst.b * src.b + pow(dst.b, 2.0) * (1.0 - 2.0 * src.b)) : (sqrt(dst.b) * (2.0 * src.b - 1.0) + 2.0 * dst.b * (1.0 - src.b));
    
    return tmp;
}
#endregion


#region Blend modes that are related to other blend modes
vec3 BlendModeLinearDodge(vec3 src, vec3 dst) {
    return src + dst;
}

vec3 BlendModeHardLight(vec3 src, vec3 dst) {
    return BlendModeOverlay(dst, src);
}

vec3 BlendModeVividLight(vec3 src, vec3 dst) {
    vec3 colorBurn = BlendModeColorBurn(dst, 2.0 * src);
    vec3 colorDodge = BlendModeColorDodge(dst, 2.0 * (src - 0.5));
    
    vec3 tmp;
    tmp.r = (src.r < 0.5) ? colorBurn.r : colorDodge.r;
    tmp.g = (src.g < 0.5) ? colorBurn.g : colorDodge.g;
    tmp.b = (src.b < 0.5) ? colorBurn.b : colorDodge.b;
    
    return tmp;
}

vec3 BlendModeLinearLight(vec3 src, vec3 dst) {
    vec3 linearBurn = BlendModeLinearBurn(dst, 2.0 * src);
    vec3 linearDodge = BlendModeLinearDodge(dst, 2.0 * (src - 0.5));
    
    vec3 tmp;
    tmp.r = (src.r < 0.5) ? linearBurn.r : linearDodge.r;
    tmp.g = (src.g < 0.5) ? linearBurn.g : linearDodge.g;
    tmp.b = (src.b < 0.5) ? linearBurn.b : linearDodge.b;
    
    return tmp;
}

vec3 BlendModePinLight(vec3 src, vec3 dst) {
    vec3 darken = BlendModeDarken(dst, 2.0 * src);
    vec3 lighten = BlendModeLighten(dst, 2.0 * (src - 0.5));
    
    vec3 tmp;
    tmp.r = (src.r < 0.5) ? darken.r : lighten.r;
    tmp.g = (src.g < 0.5) ? darken.g : lighten.g;
    tmp.b = (src.b < 0.5) ? darken.b : lighten.b;
    
    return tmp;
}
#endregion


#region Other color operations
float Color_GetLuminosity(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

vec3 Color_SetLuminosity(vec3 color, float luma) {
    color += vec3(luma - Color_GetLuminosity(color));
    
	// clip back into legal range
	luma = Color_GetLuminosity(color);
    float cMin = min(color.r, min(color.g, color.b));
    float cMax = max(color.r, max(color.g, color.b));
    
    if(cMin < 0.0) color = mix(vec3(luma), color, luma / (luma - cMin));
    if(cMax > 1.0) color = mix(vec3(luma), color, (1.0 - luma) / (cMax - luma));
    
    return color;
}

float Color_GetSaturation(vec3 color) {
	return max(color.r, max(color.g, color.b)) - min(color.r, min(color.g, color.b));
}

vec3 Color_SetSaturation_MMM(vec3 cSorted, float s) {
	if(cSorted.z > cSorted.x) {
		cSorted.y = (((cSorted.y - cSorted.x) * s) / (cSorted.z - cSorted.x));
		cSorted.z = s;
	} else {
		cSorted.y = 0.0;
		cSorted.z = 0.0;
	}
    
	cSorted.x = 0.0;
    
	return cSorted;
}

vec3 Color_SetSaturation(vec3 color, float s) {
	if (color.r <= color.g && color.r <= color.b) {
		if (color.g <= color.b) color.rgb = Color_SetSaturation_MMM(color.rgb, s);
		else color.rbg = Color_SetSaturation_MMM(color.rbg, s);
	} else if (color.g <= color.r && color.g <= color.b) {
		if (color.r <= color.b) color.grb = Color_SetSaturation_MMM(color.grb, s);
		else color.gbr = Color_SetSaturation_MMM(color.gbr, s);
	} else {
		if (color.r <= color.g) color.brg = Color_SetSaturation_MMM(color.brg, s);
		else color.bgr = Color_SetSaturation_MMM(color.bgr, s);
	}
    
	return color;
}

vec3 BlendModeHue(vec3 src, vec3 dst) {
    // Hue: src
    // Sat: dst
    // Lum: dst
    
    vec3 tmp;
    tmp = src;
    tmp = Color_SetSaturation(tmp, Color_GetSaturation(dst));
    tmp = Color_SetLuminosity(tmp, Color_GetLuminosity(dst));
    
    return tmp;
}

vec3 BlendModeSaturation(vec3 src, vec3 dst) {
    // Hue: dst
    // Sat: src
    // Lum: dst
    
    vec3 tmp;
    tmp = dst;
    tmp = Color_SetSaturation(tmp, Color_GetSaturation(src));
    tmp = Color_SetLuminosity(tmp, Color_GetLuminosity(dst));
    
    return tmp;
}

vec3 BlendModeLuminosity(vec3 src, vec3 dst) {
    // Hue: dst
    // Sat: dst
    // Lum: src
    
    vec3 tmp;
    tmp = dst;
    tmp = Color_SetLuminosity(tmp, Color_GetLuminosity(src));
    
    return tmp;
}

vec3 BlendModeColor(vec3 src, vec3 dst) {
    // Hue: src
    // Sat: src
    // Lum: dst
    
    vec3 tmp;
    tmp = src;
    tmp = Color_SetLuminosity(tmp, Color_GetLuminosity(dst));
    
    return tmp;
}

vec3 BlendModeDarkerColor(vec3 src, vec3 dst) {
    return (Color_GetLuminosity(src) < Color_GetLuminosity(dst)) ? src : dst;
}

vec3 BlendModeLighterColor(vec3 src, vec3 dst) {
    return (Color_GetLuminosity(src) >= Color_GetLuminosity(dst)) ? src : dst;
}
#endregion


#region I don't have access to a version of Photoshop that can do these
vec3 BlendModeAverage(vec3 src, vec3 dst) {
    return (src + dst) / 2.0;
}

vec3 BlendModeReflect(vec3 src, vec3 dst) {
    return (dst * dst / max(1.0 - src, 0.001));
}

vec3 BlendModeGlow(vec3 src, vec3 dst) {
    return BlendModeAverage(dst, src);
}

vec3 BlendModeHardMix(vec3 src, vec3 dst) {
    vec3 sum = BlendModeAdd(src, dst);
    
    return floor(sum);
}

vec3 BlendModeNegation(vec3 src, vec3 dst) {
    return 1.0 - abs(1.0 - src - dst);
}

vec3 BlendModePhoenix(vec3 src, vec3 dst) {
    return min(src, dst) - max(src, dst) + 1.0;
}

vec3 BlendModeSubstract(vec3 src, vec3 dst) {
    return src + dst - 1.0;
}
#endregion

void main() {
    vec4 src_color = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 dst_color = texture2D(samp_dst, v_vTexcoord);
    
    vec3 blended_color;
    if (src_color.a < 0.1) {
        blended_color = dst_color.rgb;
    } else {
        
        // Default blend modes
        if (u_BlendMode == 0) {
            blended_color = BlendModeNormal(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 1) {
            blended_color = BlendModeAdd(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 2) {
            blended_color = BlendModeSubtract(src_color.rgb, dst_color.rgb);
        }
        
        
        // Basic vector math blend modes
        if (u_BlendMode == 3) {
            blended_color = BlendModeDarken(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 4) {
            blended_color = BlendModeLighten(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 5) {
            blended_color = BlendModeMultiply(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 6) {
            blended_color = BlendModeLinearBurn(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 7) {
            blended_color = BlendModeScreen(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 8) {
            blended_color = BlendModeDifference(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 9) {
            blended_color = BlendModeExclusion(src_color.rgb, dst_color.rgb);
        }
        
        
        // Component-wise blend modes
        if (u_BlendMode == 10) {
            blended_color = BlendModeColorBurn(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 11) {
            blended_color = BlendModeColorDodge(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 12) {
            blended_color = BlendModeOverlay(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 13) {
            blended_color = BlendModeSoftLight(src_color.rgb, dst_color.rgb);
        }
        
        
        // Blend modes that are related to other blend modes
        if (u_BlendMode == 14) {
            blended_color = BlendModeLinearDodge(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 15) {
            blended_color = BlendModeHardLight(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 16) {
            blended_color = BlendModeVividLight(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 17) {
            blended_color = BlendModeLinearLight(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 18) {
            blended_color = BlendModePinLight(src_color.rgb, dst_color.rgb);
        }
        
        
        // Other color operations
        if (u_BlendMode == 19) {
            blended_color = BlendModeHue(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 20) {
            blended_color = BlendModeSaturation(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 21) {
            blended_color = BlendModeLuminosity(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 22) {
            blended_color = BlendModeColor(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 23) {
            blended_color = BlendModeDarkerColor(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 24) {
            blended_color = BlendModeLighterColor(src_color.rgb, dst_color.rgb);
        }
        
        // I don't have access to a version of Photoshop that can do these
        
        if (u_BlendMode == 25) {
            blended_color = BlendModeAverage(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 26) {
            blended_color = BlendModeReflect(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 27) {
            blended_color = BlendModeGlow(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 28) {
            blended_color = BlendModeHardMix(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 29) {
            blended_color = BlendModeNegation(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 30) {
            blended_color = BlendModePhoenix(src_color.rgb, dst_color.rgb);
        } else if (u_BlendMode == 31) {
            blended_color = BlendModeSubstract(src_color.rgb, dst_color.rgb);
        }
        
    }
    
    // the final blending
    src_color.rgb = blended_color;
    
    //src_color = min(max(src_color, vec4(0.0), vec4(1.0)));
    //dst_color = min(max(dst_color, vec4(0.0), vec4(1.0)));
    src_color = clamp(src_color, vec4(0.0), vec4(1.0));
    dst_color = clamp(dst_color, vec4(0.0), vec4(1.0));
    
    gl_FragColor = src_color * src_color.a + dst_color * (1.0 - src_color.a);
}