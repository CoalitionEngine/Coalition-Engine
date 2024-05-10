function __init_global() {
	gml_pragma( "global", "__init_global();");

	// set any global defaults
	layer_force_draw_depth(true,0);		// force all layers to draw at depth 0
	draw_set_colour( c_black );
}

function __init_view() {
	enum e__VW
	{
		XView,
		YView,
		WView,
		HView,
		Angle,
		HBorder,
		VBorder,
		HSpeed,
		VSpeed,
		Object,
		Visible,
		XPort,
		YPort,
		WPort,
		HPort,
		Camera,
		SurfaceID,
	};


}


function __view_get(__prop, __index) {
	var __res = -1;

	switch(__prop)
	{
	case e__VW.XView: var __cam = view_get_camera(__index); __res = camera_get_view_x(__cam); break;
	case e__VW.YView: var __cam = view_get_camera(__index); __res = camera_get_view_y(__cam); break;
	case e__VW.WView: var __cam = view_get_camera(__index); __res = camera_get_view_width(__cam); break;
	case e__VW.HView: var __cam = view_get_camera(__index); __res = camera_get_view_height(__cam); break;
	case e__VW.Angle: var __cam = view_get_camera(__index); __res = camera_get_view_angle(__cam); break;
	case e__VW.HBorder: var __cam = view_get_camera(__index); __res = camera_get_view_border_x(__cam); break;
	case e__VW.VBorder: var __cam = view_get_camera(__index); __res = camera_get_view_border_y(__cam); break;
	case e__VW.HSpeed: var __cam = view_get_camera(__index); __res = camera_get_view_speed_x(__cam); break;
	case e__VW.VSpeed: var __cam = view_get_camera(__index); __res = camera_get_view_speed_y(__cam); break;
	case e__VW.Object: var __cam = view_get_camera(__index); __res = camera_get_view_target(__cam); break;
	case e__VW.Visible: __res = view_get_visible(__index); break;
	case e__VW.XPort: __res = view_get_xport(__index); break;
	case e__VW.YPort: __res = view_get_yport(__index); break;
	case e__VW.WPort: __res = view_get_wport(__index); break;
	case e__VW.HPort: __res = view_get_hport(__index); break;
	case e__VW.Camera: __res = view_get_camera(__index); break;
	case e__VW.SurfaceID: __res = view_get_surface_id(__index); break;
	default: break;
	};

	return __res;


}


function __view_set(__prop, __index, __val) {

	__view_set_internal(__prop, __index, __val);

	var __res = __view_get(__prop, __index);

	return __res;


}

function __view_set_internal(__prop, __index, __val) {

	switch(__prop)
	{
	case e__VW.XView: var __cam = view_get_camera(__index); camera_set_view_pos(__cam, __val, camera_get_view_y(__cam)); break;
	case e__VW.YView: var __cam = view_get_camera(__index); camera_set_view_pos(__cam, camera_get_view_x(__cam), __val); break;
	case e__VW.WView: var __cam = view_get_camera(__index); camera_set_view_size(__cam, __val, camera_get_view_height(__cam)); break;
	case e__VW.HView: var __cam = view_get_camera(__index); camera_set_view_size(__cam, camera_get_view_width(__cam), __val); break;
	case e__VW.Angle: var __cam = view_get_camera(__index); camera_set_view_angle(__cam, __val); break;
	case e__VW.HBorder: var __cam = view_get_camera(__index); camera_set_view_border(__cam, __val, camera_get_view_border_y(__cam)); break;
	case e__VW.VBorder: var __cam = view_get_camera(__index); camera_set_view_border(__cam, camera_get_view_border_x(__cam), __val); break;
	case e__VW.HSpeed: var __cam = view_get_camera(__index); camera_set_view_speed(__cam, __val, camera_get_view_speed_y(__cam)); break;
	case e__VW.VSpeed: var __cam = view_get_camera(__index); camera_set_view_speed(__cam, camera_get_view_speed_x(__cam), __val); break;
	case e__VW.Object: var __cam = view_get_camera(__index); camera_set_view_target(__cam, __val); break;
	case e__VW.Visible: __res = view_set_visible(__index, __val); break;
	case e__VW.XPort: __res = view_set_xport(__index, __val); break;
	case e__VW.YPort: __res = view_set_yport(__index, __val); break;
	case e__VW.WPort: __res = view_set_wport(__index, __val); break;
	case e__VW.HPort: __res = view_set_hport(__index, __val); break;
	case e__VW.Camera: __res = view_set_camera(__index, __val); break;
	case e__VW.SurfaceID: __res = view_set_surface_id(__index, __val); break;
	default: break;
	};

	return 0;


}
