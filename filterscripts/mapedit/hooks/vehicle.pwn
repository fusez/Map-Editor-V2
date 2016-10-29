stock hook_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren = 0) {
	new vehicleid = CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren);
	if(vehicleid != INVALID_VEHICLE_ID) {
		new modelname[MAX_VEHMODEL_NAME];
	    if(GetVehicleModelName(vehicletype, modelname, MAX_VEHMODEL_NAME)) {
			SetVehicleComment(vehicleid, modelname);
		}

		SetVehicleColors(vehicleid, color1, color2);

		SetVehiclePaintjob(vehicleid, INVALID_PAINTJOB_ID);
	}
	return vehicleid;
}
#if defined _ALS_CreateVehicle
	#undef CreateVehicle
#else
	#define _ALS_CreateVehicle
#endif
#define CreateVehicle hook_CreateVehicle

stock hook_DestroyVehicle(vehicleid) {
	new success = DestroyVehicle(vehicleid);
	if(success) {
		for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
			if(!IsPlayerConnected(playerid)) {
			    continue;
			}

			if(GetPlayerEditVehicle(playerid) == vehicleid) {
			    SetPlayerEditVehicle(playerid, INVALID_VEHICLE_ID);
			}
			
			for(new listitem; listitem < g_VehicleBrowserData[playerid][BROWSER_DATA_PAGESIZE]; listitem ++) {
				if(g_VehicleBrowserData[playerid][BROWSER_DATA_ITEM][listitem] == vehicleid) {
				    g_VehicleBrowserData[playerid][BROWSER_DATA_ITEM][listitem] = INVALID_VEHICLE_ID;
				}
			}
		}
		
		for(new objectid = 1; objectid <= MAX_OBJECTS; objectid ++) {
			if(IsValidObject(objectid) && GetObjectAttachVehicle(objectid) == vehicleid) {
			    DestroyObject(objectid);
			}
		}
	}
	return success;
}
#if defined _ALS_DestroyVehicle
	#undef DestroyVehicle
#else
	#define _ALS_DestroyVehicle
#endif
#define DestroyVehicle hook_DestroyVehicle
