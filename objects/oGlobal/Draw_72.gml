///desc Update 3D camera
//why this exists lmao, camera angle is broken when enabled
if MainCamera.enable_z
{
	var camera = view_camera[0],
		_camAngX = camAngleX + camAngleXShake,
		_camAngY = camAngleY + camAngleYShake,
		_camW = camera_get_view_width(camera),
		_camH = camera_get_view_height(camera),
		_camX = camera_get_view_x(camera) + 640 / (2 * camera_scale_x),
		_camY = camera_get_view_y(camera) + 480 / (2 * camera_scale_y),
		_camDist = camDist / camera_scale_x,
		_camTar = camera_target;
	if instance_exists(_camTar)
	{
		_camX = _camTar.x - camera_x;
		_camY = _camTar.y - camera_y;
	}
	var _viewMat = matrix_build_lookat(
		_camX + (dcos(_camAngX) * dcos(_camAngY)) * _camDist,
		_camY + (dsin(_camAngY)) * _camDist,
		(dsin(_camAngX) * dcos(_camAngY)) * _camDist,
		_camX + camXDisplace, _camY + camYDisplace, 0, 0, 1, 0),
		_projMat = matrix_build_projection_perspective_fov(camFov, camAsp, 1, 1000);

	camera_set_view_mat(camera, _viewMat);
	camera_set_proj_mat(camera, _projMat);

	camera_apply(camera);
	
	if camAngleXShake != 0 camAngleXShake *= 0.8;
	if camAngleYShake != 0 camAngleYShake *= 0.8;
	if abs(camAngleXShake) < 0.2 camAngleXShake = 0;
	if abs(camAngleYShake) < 0.2 camAngleYShake = 0;
}