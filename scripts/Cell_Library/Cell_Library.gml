function InitializeCell() {
	forceinline;
	//Safety check
	Cell_LibrarySet("OWBox", "this text should not appear");
	Cell_LibrarySet("Phone", "test phone text 1",,, function() {
		if (Cell.GetCallCount(0) == 0)	
			Cell.Text(0, "new text");
	});
	Cell_LibrarySet("Dimensional Box A",, true, 1);
	Cell_LibrarySet("Dimensional Box B",, true, 2);
	Cell_Set(0, 1); //Phone
	Cell_Set(1, 2); //DB 1
}