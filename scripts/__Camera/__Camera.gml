///@category Global Functions
///@title Camera
///@text These are the functions to control the camera properties.

///@constructor
///@func __Camera()
///@desc Camera data
function __Camera() constructor
{
	///@method Init()
	///@desc Initalizes the camera variables
	static Init = function()
	{
		aggressive_forceinline
		oGlobal.MainCamera = {};
		with oGlobal.MainCamera
		{
			x = 0;
			y = 0;
			Scale = array_create(2, 1);
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
	}
	///@method Scale(scale_x, scale_y, [duration], [ease])
	///@desc Sets the scale of the Camera
	///@param {real} x_scale The X scale of the camera
	///@param {real} y_scale The Y scale of the camera
	///@param {real} duration The anim duration of the scaling
	///@param {function,string} ease The easing of the animation
	static Scale = function(sx, sy, duration = 0, ease = "")
	{
		forceinline
		with oGlobal.MainCamera
		{
			if duration == 0 Scale = [sx, sy];
			else
			TweenFire("~", ease, "$", duration, TPArray(Scale, 0), Scale[0], sx,
												TPArray(Scale, 1), Scale[1], sy);
		}
	}
	///@method SetPos(x, y)
	///@desc Sets the X and Y position of the Camera
	///@param {real} x The x position
	///@param {real} y The y position
	static SetPos = function(_x, _y)
	{
		forceinline
		with oGlobal.MainCamera
		{
			x = _x;
			y = _y;
		}
	}
	///@method MoveTo(x, y, duration, [delay], [ease])
	///@desc Moves the camera to the given coordinates
	///@param {real} x The x position
	///@param {real} y The y position
	///@param {real} duration The anim duration of the movement
	///@param {real} delay The anim delay of the movement
	///@param {function,string} ease The easing of the animation
	static MoveTo = function(x, y, duration, delay = 0, ease = "")
	{
		forceinline
		with oGlobal.MainCamera TweenFire(self, ease, 0, 0, delay, duration, "x>", x, "y>", y);
	}
	///@method RotateTo([start], target, duration, [ease], [delay])
	///@desc Rotates the camera
	///@param {real} start The start angle of the camera
	///@param {real} target The target angle of the camera
	///@param {real} duration The time taken for the camera to rotate
	///@param {function,string} Easing The ease of the rotation
	///@param {real} delay The delay of the animation
	static RotateTo = function(start = oGlobal.MainCamera.angle, target, duration, ease = "", delay = 0)
	{
		forceinline
		if duration == 0 oGlobal.MainCamera.angle = target;
		else TweenFire(oGlobal.MainCamera, ease, 0, 0, delay, duration, "angle", start, target);
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
	///@param {real} height	The height of the camera
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
	///@param {real,string} value 0/none -> both (In array) 1/"x" -> x 2/"y" -> y
	///@return {Array<Real>,Real}
	static GetScale = function(val = 0)
	{
		switch val
		{
			case 0: return oGlobal.MainCamera.Scale;
			case 1: case "x": return oGlobal.MainCamera.Scale[0];
			case 2: case "y": return oGlobal.MainCamera.Scale[1];
		}
	}
	///@method GetAspect([val])
	///@desc Gets the aspect of the view
	///@param {real} value 0/none/"width"/"w" -> width 1/"height"/"h" -> height 2/"ratio"/"r" -> ratio
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
	}///Gets the position of the camera
	///@method GetPos([val])
	///@desc Gets the position of the camera
	///@param {real} value 0/"x" -> x 1/"y" -> y
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