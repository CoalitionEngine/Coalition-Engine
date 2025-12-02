function InitializeItem() {
	forceinline;
	#region Set basic item info
	ItemLibrarySetStruct(ITEM.PIE, "Pie", {
		Heal : global.MaxHP,
		ItemUseCount: 2
	});
	ItemLibrarySetStruct(ITEM.INOODLES, "INoodles", {
		Heal : 90,
	});
	ItemLibrarySetStruct(ITEM.STEAK, "Steak", {
		Heal : 60,
	});
	ItemLibrarySetStruct(ITEM.SNOWP, "SnowmanPiece", {
		Heal : 45,
	});
	ItemLibrarySetStruct(ITEM.LHERO, "LHero", {
		Heal : 40,
		ConsumeFunction : function() { global.__CoalitionPlayerAttackBoost += 4; }
	});
	ItemLibrarySetStruct(ITEM.SEATEA, "SeaTea", {
		Heal : 10,
		ConsumeFunction : function() {
			__speed_boost = global.__CoalitionPlayerSpeed;
			global.__CoalitionPlayerSpeed *= 2;
			__turns_passed = 0;
		},
		EffectAtTurnEnd : function() {
			if (++__turns_passed == 4)
				EffectExpire();
		},
		EffectRemove: function() {
			global.__CoalitionPlayerSpeed -= __speed_boost;
		}
	});
	#endregion
	Item_Set(ITEM.PIE, 0);
	Item_Set(ITEM.INOODLES, 1);
	Item_Set(ITEM.STEAK, 2);
	Item_Set(ITEM.SEATEA, 3);
	Item_Set(ITEM.LHERO, 4);
	Item_Set(ITEM.STICK, 5);
}