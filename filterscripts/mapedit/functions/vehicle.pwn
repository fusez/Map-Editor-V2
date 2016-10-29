DuplicateVehicle(vehicleid) {
	new
		modelid = GetVehicleModel(vehicleid),
		Float:x,
		Float:y,
		Float:z,
		Float:r,
		color1 = GetVehicleColor1(vehicleid),
		color2 = GetVehicleColor2(vehicleid),
		new_vehicleid
	;

	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, r);

	new_vehicleid = CreateVehicle(modelid, x, y, z, r, color1, color2, -1);
	if(new_vehicleid == INVALID_VEHICLE_ID) {
	    return INVALID_VEHICLE_ID;
	}

	for(new slot; slot < MAX_COMPONENT_SLOTS; slot ++) {
	    new componentid = GetVehicleComponentInSlot(vehicleid, slot);
	    if(componentid != 0) {
	        AddVehicleComponent(new_vehicleid, componentid);
	    }
	}

	return new_vehicleid;
}

IsVehicleOccupied(vehicleid, seat) {
	for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
		if(IsPlayerConnected(playerid) && GetPlayerVehicleID(playerid) == vehicleid && GetPlayerVehicleSeat(playerid) == seat) {
			return 1;
		}
	}
	return 0;
}

GetVehicleComment(vehicleid, bool:packed = false) {
	new comment[MAX_COMMENT_LEN];
	if(packed) {
		strpack(comment, g_VehicleData[vehicleid-1][VEHICLE_DATA_COMMENT], MAX_COMMENT_LEN);
	} else {
		strunpack(comment, g_VehicleData[vehicleid-1][VEHICLE_DATA_COMMENT], MAX_COMMENT_LEN);
	}
	return comment;
}

FindVehicles(result[], result_size, search[], search_size, offset) {
	new
		matches_found,
		matches_saved,
		search_int = -1
	;

	sscanf(search, "i", search_int);

	if(!ispacked(search)) {
	    strpack(search, search, search_size);
	}

	for(new vehicleid = 1, max_vehicleid = GetVehiclePoolSize(); vehicleid <= max_vehicleid; vehicleid ++) {
		if(!IsValidVehicle(vehicleid)) {
			continue;
		}

		if(
			isempty(search) ||
			search_int == vehicleid ||
			search_int == GetVehicleModel(vehicleid) ||
			strfind(GetVehicleComment(vehicleid, true), search, true) != -1
		){
			if(matches_found ++ < offset) {
				continue;
			}

			result[matches_saved] = vehicleid;

			if(++ matches_saved >= result_size) {
				break;
			}
		}
	}
	return matches_saved;
}
