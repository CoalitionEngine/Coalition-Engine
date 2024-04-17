surface_free(global.sur_list[| TEMPID + 1][0]);
ds_list_delete(global.sur_list, TEMPID + 1);
surface_free(global.sur_list[| TEMPID][0]);
ds_list_delete(global.sur_list, TEMPID);
with oCutScreen TEMPID -= 2;