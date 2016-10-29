DefaultPlayerData(playerid) {
	g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_NONE;
	g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] = INVALID_OBJECT_ID;
	g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT] = INVALID_OBJECT_ID;
	g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD] = PlayerText:INVALID_TEXT_DRAW;

	for(new browserid; browserid < MAX_BROWSERS; browserid ++) {
		UpdateBrowserItems(playerid, browserid);
	}
	
	for(new index; index < MAX_ATTACHED_INDEX; index ++) {
		DefaultPlayerAttachedData(playerid, index);
		RemovePlayerAttachedObject(playerid, index);
	}
}

RefreshPlayerMoveObject(playerid, idtype, id) {
	new Float:x, Float:y, Float:z, Float:a;

	switch(idtype) {
		case ID_TYPE_VEHICLE: {
			GetVehiclePos(id, x, y, z); GetVehicleZAngle(id, a);
		}
		case ID_TYPE_PICKUP: {
			GetPickupPos(id, x, y, z);
		}
		case ID_TYPE_ACTOR: {
		    GetActorPos(id, x, y, z); GetActorFacingAngle(id, a);
		}
		default: {
		    return INVALID_OBJECT_ID;
		}
	}
	
	new objectid = g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT];
	if(objectid == INVALID_OBJECT_ID) {
		objectid = CreatePlayerObject(playerid, 19300, x, y, z, 0.0, 0.0, a);
		g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT] = objectid;
	} else {
	    SetPlayerObjectPos(playerid, objectid, x, y, z);
		SetPlayerObjectRot(playerid, objectid, 0.0, 0.0, a);
	}
	return objectid;
}

DestroyPlayerMoveObject(playerid) {
	if(g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT] != INVALID_OBJECT_ID) {
		DestroyPlayerObject(playerid, g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT]);
		g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT] = INVALID_OBJECT_ID;
	}
}

GetPlayerEditVehicle(playerid) {
	if(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] == ID_TYPE_VEHICLE) {
		return g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
	}
	return INVALID_VEHICLE_ID;
}

GetPlayerEditPickup(playerid) {
	if(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] == ID_TYPE_PICKUP) {
	    return g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
	}
	return INVALID_PICKUP_ID;
}

GetPlayerEditActor(playerid) {
	if(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] == ID_TYPE_ACTOR) {
	    return g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
	}
	return INVALID_ACTOR_ID;
}

GetPlayerEditObject(playerid){
	if(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] == ID_TYPE_OBJECT) {
		return g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
	}
	return INVALID_OBJECT_ID;
}

GetPlayerEditAttached(playerid) {
	if(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] == ID_TYPE_ATTACH) {
		return g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
	}
	return INVALID_ATTACHED_INDEX;
}
