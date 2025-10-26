///@category Player Data
///@title Equipment
///@text These are functions for setting up player equipment

#region Functions
///@func RegisterWeapon(ItemID, Name, Value, [BarCount], [AttackAnimation])
///@desc Registers a weapon into the library
///@param {Enum.Item} ItemID			 The ID of the equipment
///@param {string} Name					 The name of the equipment (Be the same as the one in the localization file)
///@param {real} Value					 The attack of the equipment
///@param {real} [BarCount]				 The amount of bars that will appear in the battle aiming UI (Default 1)
///@param {function} [AttackAnimation]	 The attack animation during battle (Default just a slash)
function RegisterWeapon(ItemID, Name, Value, BarCount = 1, AttackAnimation = undefined) {
	global.__Coalition_Equipments.__equipment_list[$ Name] = new Equipment();
	with (global.__Coalition_Equipments.__equipment_list[$ Name])
	{
		id = ItemID;
		self.Type = EQUIPMENT_TYPE.WEAPON;
		self.BarCount = BarCount;
		self.__AttackAnimation = AttackAnimation ?? global.__Coalition_Equipments.__default_attack_animation;
		Attack = Value;
		ItemLibrarySetStruct(ItemID, Name, self);
		__InitializeDropText(Name);
	}
}
///@func RegisterArmor(ItemID, Name, Value, [Consumable], [Heal], [ConsumeEvent])
///@desc Registers an armor into the library
///@param {Enum.Item} ItemID			 The ID of the equipment
///@param {string} Name					 The name of the equipment (Be the same as the one in the localization file)
///@param {real} Value					 The defense of the equipment
///@param {real} [Consumable]			 Whether the armor can be consumed (i.e. Bandage, default false)
///@param {real} [Heal]					 The amount of HP to heal (Default 0)
///@param {function} [ConsumeEvent]		 The event to occur once consumed (Default none)
function RegisterArmor(ItemID, Name, Value, Consumable = false, Heal = 0, ConsumeEvent = COALITION_EMPTY_FUNCTION) {
	global.__Coalition_Equipments.__equipment_list[$ Name] = new Equipment();
	with (global.__Coalition_Equipments.__equipment_list[$ Name])
	{
		id = ItemID;
		self.Type = EQUIPMENT_TYPE.ARMOR;
		self.Consumable = Consumable;
		self.ConsumeEvent = ConsumeEvent;
		self.Heal = Heal;
		Defense = Value;
		ItemLibrarySetStruct(ItemID, Name, self);
		__InitializeDropText(Name);
	}
}
///@func Equipment_SetAttackBoost(EquipmentID, boost)
///@desc Sets the amount of Attack boosted by this equipment
///@param {Enum.Item} EquipmentID	 The ID of the equipment
///@param {real} boost				 The amount of Attack to boost
function Equipment_SetAttackBoost(EquipmentID, boost) {
	global.__CoalitionItemLibrary[| EquipmentID].AttackBoost = boost;
}
///@func Equipment_SetDefenseBoost(EquipmentID, boost)
///@desc Sets the amount of Defense boosted by this equipment
///@param {Enum.Item} EquipmentID	 The ID of the equipment
///@param {real} boost				 The amount of Defense to boost
function Equipment_SetDefenseBoost(EquipmentID, boost) {
	global.__CoalitionItemLibrary[| EquipmentID].DefenseBoost = boost;
}
///@func SetEquipmentInvBoost(EquipmentID, boost)
///@desc Sets the amount of Inv boosted by this equipment
///@param {Enum.Item} EquipmentID	 The ID of the equipment
///@param {real} boost				 The amount of Inv to boost
function SetEquipmentInvBoost(EquipmentID, boost) {
	global.__CoalitionItemLibrary[| EquipmentID].InvBoost = boost;
}
///@func Equipment_SetHealBoost(EquipmentID, boost)
///@desc Sets the amount of healing boosted by this equipment
///@param {Enum.Item} EquipmentID	 The ID of the equipment
///@param {real} boost				 The amount of healing to boost
function Equipment_SetHealBoost(EquipmentID, boost) {
	global.__CoalitionItemLibrary[| EquipmentID].HealBoost = boost;
}
///@func Equipment_SetEndTurnEvent(EquipmentID, event)
///@desc Sets the event to execute when a turn ends
///@param {Enum.Item} EquipmentID	 The ID of the equipment
///@param {function} event			 The event to execute
function Equipment_SetEndTurnEvent(EquipmentID, event) {
	global.__CoalitionItemLibrary[| EquipmentID].EndTurnEvent = event;
}
///@func Equipment_SetAttackAnimation(EquipmentID, event)
///@desc Sets the attack animation of the weapon
///@param {Enum.Item} EquipmentID	 The ID of the equipment
///@param {function} event			 The animation of the weapon (First two arguments will be the x and y coordinate of the attack)
function Equipment_SetAttackAnimation(EquipmentID, event) {
	global.__CoalitionItemLibrary[| EquipmentID].__AttackAnimation = event;
}
///@text ?> The following functions should only be called in `Equipment_SetAttackAnimation`

///@func SetAttackDamagePercentage(percent)
///@desc Sets the percentage of the damage to inflict on the enemy
///@param {real} percent	The percentage of the damage (Ranges from 0 to 1)
function SetAttackDamagePercentage(percent) { oBattleController.__AttackDamagePercentage = percent; }
///@func GetAttackAnimationTimer()
///@desc Gets the time elapsed in the attack aniamtion
///@return {real}
function GetAttackAnimationTimer() { return COALITION_DATA.AttackItem.__AttackAnimationTimer; }
///@func AttackAnimationLandAttack()
///@desc Causes the enemy to take damage during the attack aniamtion
function AttackAnimationLandAttack() { COALITION_DATA.AttackItem.__AttackAnimationLanded = true; }
///@func EndAttackAnimation()
///@desc Ends the attack animation and allows the turn to start
function EndAttackAnimation() { COALITION_DATA.AttackItem.__AttackAnimationEnded = true; }
///@func AttackIsCritical()
///@desc Gets whether the attack is a critical attack
///@return {bool}
function AttackIsCritical() { return oBattleController.__Aim.Attack.Crit; }

#endregion