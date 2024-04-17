live;
//Adds the soul to the global soul list
array_push(BattleSoulList, id);
SoulListID = array_length(BattleSoulList) - 1;
if instance_exists(oBoard)
	depth = oBoard.depth - oBattleController.depth - 1;
image_speed = 0;
Blend = c_red;
image_blend = Blend;
draw_angle = 0;

dir = DIR.DOWN;

follow_board = false;
global.inv = 0;
global.assign_inv = 60;		// Sets the inv time for soul
global.deadable = true;		//Sets whether the soul can die
//Set soul effect
EffectS = part_system_create();
part_system_depth(EffectS, depth);
EffectT = part_type_create();
part_type_sprite(EffectT, sprite_index, 0, 0, 0);
part_type_life(EffectT, 1/0.035,1/0.035);
part_type_size(EffectT, 1, 1, 0.15, 0);
part_type_alpha2(EffectT, 1, 0)

mode = SOUL_MODE.RED;

move_x = 0;
move_y = 0;

///@param {bool} Horizontal	Enable horzontal movement (Default true)
///@param {bool} Vertical	Enable vertical movement (Default true)
function BasicMovement(hor = true, ver = true) {
	var h_spd = CHECK_HORIZONTAL,
		v_spd = CHECK_VERTICAL,
		move_spd = global.spd / (HOLD_CANCEL + 1),
		_angle = image_angle;
	move_x = h_spd * move_spd;
	move_y = v_spd * move_spd;
	//draw board in syurface, then mask using that sprite
	if moveable
	{
		if instance_exists(oBoardCover)
		{
			move_and_collide(lengthdir_x(move_x, _angle), lengthdir_y(move_y, _angle - 90), oBoardCover, move_spd * 10);
		}
		else if !oBoard.VertexMode
		{
			//if !oBoard.VertexMode
			{
				var fin_dir = dcos(_angle);
				if hor
					x += move_x * fin_dir;
				if ver
					y += move_y * fin_dir;
			}
		}
		else
		{
			var Displace = global.diagonal_speed ? new Vector2(move_x, move_y) : new Vector2(sign(move_x * point_distance(0, 0, move_x, move_y)), sign(move_y * point_distance(0, 0, move_x, move_y)));
			var curCenter = new Vector2(x, y);
			var NexCenter = new Vector2(x, y).Add(Displace);
			var vertexes = oBoard.Vertex;
			var i = 0;
			//DoBoxRestriction
			var Normals = array_create(array_length(oBoard.Vertex) / 2);
			repeat array_length(oBoard.Vertex) / 2
			{
				var VectorA = new Vector2(oBoard.Vertex[i], oBoard.Vertex[i + 1]);
				var VectorB = new Vector2(oBoard.Vertex[(i + 2) % array_length(oBoard.Vertex)], oBoard.Vertex[(i + 3) % array_length(oBoard.Vertex)]);
				var Normal = (VectorB.Subtract(VectorA)).Rotated(90);
				var Center = (VectorA.Add(VectorB)).Divide(new Vector2(2));
				var Along = (VectorB.Subtract(VectorA)).Divide(new Vector2(2));
				var del1 = curCenter.Subtract(Center);
				var del2 = NexCenter.Subtract(Center);
					
				var Distance = Along.Magnitude();
				Normal.Normalize();
				Along.Normalize();
					
				var DirDelta1 = Along.Project(Along, del1);
				var DirDelta2 = Along.Project(Along, del2);
					
				if abs(DirDelta1) > Distance + 0.2 && abs(DirDelta2) > Distance + 0.2
				{
					i += 2;
					continue;
				}
					
				var Dis1 = Normal.Project(Normal, del1);
				var Dis2 = Normal.Project(Normal, del2);
					
				if Dis1 < 0
				{
					Dis1 = -Dis1;
					Dis2 = -Dis2;
					Normal = Normal.Negate();
				}
					
				if Dis2 < 8
				{
					Dis2 = 8;
					Along = Along.Multiply(new Vector2(DirDelta2));
					Normal = Normal.Multiply(new Vector2(Dis2));
					NexCenter = Center.Add(Along);
					NexCenter = NexCenter.Add(new Vector2(Dis2));
				}
					
				i += 2;
			}
			//Apply Center
			x = NexCenter.x;
			y = NexCenter.y;
		}
	}
}

//Blue soul variables
fall_spd = 0;
fall_grav = 0;

on_ground = false;
on_ceil = false;
on_platform = false;

slam = false;

moveable = true;

allow_outside = false;

timer = 0;

//Green soul variables
GreenCircle = true;
globalvar Shield;
Shield = new __Shield();
GreenShield = {};
with GreenShield
{
	Angle = ds_list_create();
	TargetAngle = ds_list_create();
	Distance = ds_list_create();
	Alpha = ds_list_create();
	Color = ds_list_create();
	HitColor = ds_list_create();
	RotateDirection = ds_list_create();
	Input = ds_grid_create(1, 4);
	Amount = 0;
	Auto = false;
	ParticleSystem = part_system_create();
	ParticleType = part_type_create();
	part_type_life(ParticleType, 10, 30);
	part_type_direction(ParticleType, 0, 360, 0, 0);
	part_type_speed(ParticleType, 2, 4, 0, 0);
	part_type_alpha2(ParticleType, 1, 0);
	part_type_sprite(ParticleType, sprPixel, 0, 0, 0);
	ResetAngleOnTurnEnd = false;
	//List of shields
	List = ds_list_create();
}
Shield.Add(c_blue, c_red, [
	vk_right,
	vk_up,
	vk_left,
	vk_down
]);
Shield.Add(c_red, c_yellow, [
	ord("D"),
	ord("W"),
	ord("A"),
	ord("S")
]);
Shield.Remove(1);

//Purple soul variables
Purple = {};
with Purple
{
	Mode = 0;
	VLineAmount = 3;
	CurrentVLine = 1;
	HLineAmount = 3;
	CurrentHLine = 1;
	ForceAlpha = 0;
	XTarget = 320;
	YTarget = 320;
	LerpSpeed = 0.3;
	BoxLerpSpeed = 0.08;
}