stock hook_CreateObject(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, Float:DrawDistance = 0.0) {
	new objectid = CreateObject(modelid, X, Y, Z, rX, rY, rZ, DrawDistance);
	if(objectid != INVALID_OBJECT_ID) {
	    new modelname[MAX_OBJMODEL_NAME];
		if(GetObjectModelName(modelid, modelname, MAX_OBJMODEL_NAME)) {
			SetObjectComment(objectid, modelname);
		}
		
		SetObjectAttachType(objectid, ID_TYPE_NONE);
	    SetObjectAttachOffsetPos(objectid, 0.0, 0.0, 0.0);
	    SetObjectAttachOffsetRot(objectid, 0.0, 0.0, 0.0);

		for(new materialindex; materialindex < MAX_OBJECT_INDEX; materialindex ++) {
			DefaultObjectMaterialIndexData(objectid, materialindex);
		}
	}
	return objectid;
}
#if defined _ALS_CreateObject
	#undef CreateObject
#else
	#define _ALS_CreateObject
#endif
#define CreateObject hook_CreateObject

stock hook_DestroyObject(objectid) {
	if(IsValidObject(objectid)) {
		for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
			if(!IsPlayerConnected(playerid)) {
			    continue;
			}

			if(GetPlayerEditObject(playerid) == objectid) {
			    SetPlayerEditObject(playerid, INVALID_OBJECT_ID);
			}
			
			if(g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] == objectid) {
				g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] = INVALID_OBJECT_ID;
			}
			
			if(g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT] == objectid) {
			    g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT] = INVALID_OBJECT_ID;
			}

			for(new listitem; listitem < g_ObjectBrowserData[playerid][BROWSER_DATA_PAGESIZE]; listitem ++) {
				if(g_ObjectBrowserData[playerid][BROWSER_DATA_ITEM][listitem] == objectid) {
				    g_ObjectBrowserData[playerid][BROWSER_DATA_ITEM][listitem] = INVALID_OBJECT_ID;
				}
			}
		}
		
		for(new loop_objectid = 1; loop_objectid <= MAX_OBJECTS; loop_objectid ++) {
		    if(IsValidObject(loop_objectid) && GetObjectAttachObject(loop_objectid) == objectid) {
		        hook_DestroyObject(loop_objectid);
		    }
		}
	}
    DestroyObject(objectid);
}
#if defined _ALS_DestroyObject
	#undef DestroyObject
#else
	#define _ALS_DestroyObject
#endif
#define DestroyObject hook_DestroyObject
