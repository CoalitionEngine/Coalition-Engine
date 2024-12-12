///@category Global Functions
///@title Camera
///@text These are the functions to control the camera properties.
///
///Some functions are combined with the built-in camera_get_view* functions, if you are using YYC,
///the functions will be compiled in the same way.
///
///?> A camera controls what you see on the screen.

///@constructor
///@func __Camera()
///@desc Camera data, to call these functions, simply use `Camera.XXX()`
function __Camera() constructor
{
	///@method Init()
	///@desc Initalizes the camera variables, can be used to reset all variables of the camera
	///@return {Struct.__Camera}
	static Init = function()
	{
		aggressive_forceinline
		if !variable_instance_exists(oGlobal, "MainCamera") oGlobal.MainCamera = {};
		with oGlobal.MainCamera
		{
			x = 0;
			y = 0;
			scale = new Vector2(1);
			view_width = 640;
			view_height = 480;
			shake_i = 0;
			decrease_i = 1;
			angle = 0;
			target = noone;
			previous_target = noone;
			//Camera angle will not matter when z is enabled
			enable_z = false;
			//Set up 3D camera
			camDist	= -240;
			camFov	= 90;
			camAsp	= view_width / view_height;
			camXDisplace = 0;
			camYDisplace = 0;
			//Z Rotation
			camAngleXRaw = 90;
			camAngleYRaw = 0;
			camAngleX = camAngleXRaw;
			camAngleY = camAngleYRaw;
			camAngleXShake = 0;
			camAngleYShake = 0;
		}
		return self;
	}
	///@method Shake(amount, [decrease])
	///@desc Shakes the Camera
	///@param {real} Amount The amount in pixels to shake
	///@param {real} Decrease The amount of intensity to decrease after each frame
	///@return {Struct.__Camera}
	static Shake = function(amount, decrease = 1)
	{
		forceinline
		with oGlobal.MainCamera
		{
			shake_i = ceil(amount);
			decrease_i = ceil(decrease);
			if enable_z
			{
				camAngleXShake = amount / 2;
				camAngleYShake = -amount / 2;
			}
		}
		return self;
	}
	///@method Scale(scale_x, scale_y, [duration], [ease])
	///@desc Sets the scale of the Camera
	///@param {real} x_scale The X scale of the camera
	///@param {real} y_scale The Y scale of the camera
	///@param {real} duration The anim duration of the scaling
	///@param {function,string} ease The easing of the animation
	///@return {Struct.__Camera}
	static Scale = function(sx, sy = sx, duration = 0, ease = "")
	{
		forceinline
		with oGlobal.MainCamera
		{
			if duration == 0 scale = new Vector2(sx, sy);
			else
			TweenFire(scale, ease, "$", duration, "x>", sx, "y>", sy);
		}
		return self;
	}
	///@method SetPos(x, y)
	///@desc Sets the X and Y position of the Camera
	///@param {real} x The x position
	///@param {real} y The y position
	///@return {Struct.__Camera}
	static SetPos = function(_x, _y)
	{
		forceinline
		with oGlobal.MainCamera
		{
			x = _x;
			y = _y;
		}
		return self;
	}
	///@method MoveTo(x, y, duration, [delay], [ease])
	///@desc Moves the camera to the given coordinates
	///@param {real} x The x position
	///@param {real} y The y position
	///@param {real} duration The anim duration of the movement
	///@param {real} delay The anim delay of the movement
	///@param {function,string} ease The easing of the animation
	///@return {Struct.__Camera}
	static MoveTo = function(x, y, duration, delay = 0, ease = "")
	{
		forceinline
		with oGlobal.MainCamera TweenFire(self, ease, 0, 0, delay, duration, "x>", x, "y>", y);
		return self;
	}
	///@method RotateTo([start], target, duration, [ease], [delay])
	///@desc Rotates the camera
	///@param {real} start The start angle of the camera
	///@param {real} target The target angle of the camera
	///@param {real} duration The time taken for the camera to rotate
	///@param {function,string} Easing The ease of the rotation
	///@param {real} delay The delay of the animation
	///@return {Struct.__Camera}
	static RotateTo = function(start = oGlobal.MainCamera.angle, target, duration, ease = "", delay = 0)
	{
		forceinline
		if duration == 0 oGlobal.MainCamera.angle = target;
		else TweenFire(oGlobal.MainCamera, ease, 0, 0, delay, duration, "angle", start, target);
		return self;
	}
	///@method ViewX()
	///@desc Gets the x position of the current view
	///@return {real}
	static ViewX = function()
	{
		forceinline
		return camera_get_view_x(view_camera[0]);
	}
	///@method ViewY()
	///@desc Gets the y position of the current view
	///@return {real}
	static ViewY = function()
	{
		forceinline
		return camera_get_view_y(view_camera[0]);
	}
	///@method ViewWidth()
	///@desc Gets the width of the current view
	///@return {real}
	static ViewWidth = function()
	{
		forceinline
		return camera_get_view_width(view_camera[0]);
	}
	///@method ViewHeight()
	///@desc Gets the height of the current view
	///@return {real}
	static ViewHeight = function()
	{
		forceinline
		return camera_get_view_height(view_camera[0]);
	}
	///@method SetAspect(width, height)
	///@desc Sets the width and height of the camera
	///@param {real} width The width of the camera
	///@param {real} height The height of the camera
	///@return {undefined}
	static SetAspect = function(width, height)
	{
		forceinline
		with oGlobal.MainCamera
		{
			view_width = width;
			view_height = height;
		}
	}
	///@method GetScale([val])
	///@desc Gets the scale of the camera
	///@param {real,string} value none/`0` -> [x position, y position] `1`/`"x"` -> x position `2`/`"y"` -> y position
	///@return {Array<Real>,Real}
	static GetScale = function(val = 0)
	{
		switch val
		{
			case 0: return oGlobal.MainCamera.scale;
			case 1: case "x": return oGlobal.MainCamera.scale.x;
			case 2: case "y": return oGlobal.MainCamera.scale.y;
		}
	}
	///@method GetAspect([val])
	///@desc Gets the aspect of the view
	///@param {real} value none/`0`/`"width"`/`"w"` -> width `1`/`"height"`/`"h"` -> height `2`/`"ratio"`/`"r"` -> ratio
	///@return {Array<Real>,Real}
	static GetAspect = function(val = 0)
	{
		switch val
		{
			case 0: case "width":	case "w": return oGlobal.MainCamera.view_width;
			case 1: case "height":  case "h": return oGlobal.MainCamera.view_height;
			case 2: case "ratio":	case "r":
				return oGlobal.MainCamera.view_width / oGlobal.MainCamera.view_height;
		}
	}
	///Gets the position of the camera
	///@method GetPos([val])
	///@desc Gets the position of the camera
	///@param {real} value `0`/`"x"` -> x `1`/`"y"` -> y
	///@return {Array<Real>,Real}
	static GetPos = function(val = 0)
	{
		switch val
		{
			case 0: case "x": return oGlobal.MainCamera.x;
			case 1: case "y": return oGlobal.MainCamera.y;
		}
	}
	///@method GetAngle()
	///@desc Gets the angle of the camera
	///@return {Real}
	static GetAngle = function()
	{
		forceinline
		return oGlobal.MainCamera.angle;
	}
}
///@text
///?> The camera functions support fluent interface, meaning that you can use `Camera.Init().Shake(5, 5).RotateTo(, 180);` as a valid statement.