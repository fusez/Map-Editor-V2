GetOffsetModeName(mode) {
	new modename[3];
	switch(mode) {
		case OFFSET_MODE_X: {
			strunpack(modename, !"x");
		}
		case OFFSET_MODE_Y: {
			strunpack(modename, !"y");
		}
		case OFFSET_MODE_Z: {
			strunpack(modename, !"z");
		}
		case OFFSET_MODE_RX: {
			strunpack(modename, !"rx");
		}
		case OFFSET_MODE_RY: {
			strunpack(modename, !"ry");
		}
		case OFFSET_MODE_RZ: {
			strunpack(modename, !"rz");
		}
		default: {
			strunpack(modename, !"-");
		}
	}
	return modename;
}

ShowOffsetMode(playerid) {
	new text[21];
	format(text, sizeof text, "~r~editing %s offset", GetOffsetModeName(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE]));
	GameTextForPlayer(playerid, text, 2000, 4);
}

ShowOffsetUpdate(playerid, objectid) {
	new text[28];
	switch(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE]) {
		case OFFSET_MODE_X: {
			format(text, sizeof text, "~r~%s offset: ~w~%.4f", GetOffsetModeName(OFFSET_MODE_X), GetObjectAttachOffsetX(objectid) );
		}
		case OFFSET_MODE_Y: {
			format(text, sizeof text, "~r~%s offset: ~w~%.4f", GetOffsetModeName(OFFSET_MODE_Y), GetObjectAttachOffsetY(objectid) );
		}
		case OFFSET_MODE_Z: {
			format(text, sizeof text, "~r~%s offset: ~w~%.4f", GetOffsetModeName(OFFSET_MODE_Z), GetObjectAttachOffsetZ(objectid) );
		}
		case OFFSET_MODE_RX: {
			format(text, sizeof text, "~r~%s offset: ~w~%.4f", GetOffsetModeName(OFFSET_MODE_RX), GetObjectAttachOffsetRX(objectid) );
		}
		case OFFSET_MODE_RY: {
			format(text, sizeof text, "~r~%s offset: ~w~%.4f", GetOffsetModeName(OFFSET_MODE_RY), GetObjectAttachOffsetRY(objectid) );
		}
		case OFFSET_MODE_RZ: {
			format(text, sizeof text, "~r~%s offset: ~w~%.4f", GetOffsetModeName(OFFSET_MODE_RZ), GetObjectAttachOffsetRZ(objectid) );
		}
		default: {
		    return 0;
		}
	}
	GameTextForPlayer(playerid, text, 1000, 4);
	return 1;
}

ToggleOffset(playerid, bool:toggle) {
	if(toggle == g_PlayerData[playerid][PLAYER_DATA_OFFSET_TOGGLE]) {
		return 0;
	}

	g_PlayerData[playerid][PLAYER_DATA_OFFSET_TOGGLE] = toggle;

	if(toggle) {
		g_PlayerData[playerid][PLAYER_DATA_OFFSET_TIMERID] = SetTimerEx("OnOffsetUpdate", OFFSET_UPDATE_INTERVAL, true, "i", playerid);
		g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] = 0.0;

		GameTextForPlayer(playerid, "~w~offset editor ~g~toggled", 4000, 4);

		SendClientMessage(playerid, RGBA_ORANGE, "Offset Edit Keys:");
		SendClientMessage(playerid, RGBA_ORANGE, "Direction: {FFFFFF}+~k~~VEHICLE_TURRETRIGHT~ / -~k~~VEHICLE_TURRETLEFT~");
		SendClientMessage(playerid, RGBA_ORANGE, "Move Slower: {FFFFFF}~k~~SNEAK_ABOUT~ + Direction Key");
		SendClientMessage(playerid, RGBA_ORANGE, "Change Mode: {FFFFFF}~k~~PED_SPRINT~ + Direction Key");
		SendClientMessage(playerid, RGBA_ORANGE, " ");
	} else {
		KillTimer(g_PlayerData[playerid][PLAYER_DATA_OFFSET_TIMERID]);
		g_PlayerData[playerid][PLAYER_DATA_OFFSET_TIMERID] = INVALID_TIMER_ID;
		
		GameTextForPlayer(playerid, "~w~offset editor ~r~untoggled", 4000, 4);
	}
	return 1;
}

forward OnOffsetUpdate(playerid);
public OnOffsetUpdate(playerid) {
	new keys, ud, lr;
	GetPlayerKeys(playerid, keys, ud, lr);

	if(keys & KEY_SPRINT) {
		return 1;
	}

	if(keys & KEY_ANALOG_RIGHT) {
		if(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] < 0.0) {
			g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] = 0.0;
		}

		g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] += OFFSET_MULTIPLIER_ADD;
		if(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] > OFFSET_MULTIPLIER_LIMIT) {
		    g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] = OFFSET_MULTIPLIER_LIMIT;
		}
	} else if(keys & KEY_ANALOG_LEFT) {
		if(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] > 0.0) {
			g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] = 0.0;
		}

		g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] -= OFFSET_MULTIPLIER_ADD;
		if(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] < -OFFSET_MULTIPLIER_LIMIT) {
		    g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] = -OFFSET_MULTIPLIER_LIMIT;
		}
	} else {
		g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] = 0.0;
		return 1;
	}

	new objectid = GetPlayerEditObject(playerid);
	if(objectid == INVALID_OBJECT_ID) {
	    return ToggleOffset(playerid, false), 1;
	}

	new Float:move_amount;
	if(keys & KEY_WALK) {
        move_amount = g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] * OFFSET_MOVE_SLOW;
	} else {
		move_amount = g_PlayerData[playerid][PLAYER_DATA_OFFSET_MULTIPLIER] * OFFSET_MOVE_NORMAL;
	}

	switch(g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE]) {
		case OFFSET_MODE_X: {
			SetObjectAttachOffsetX(objectid, GetObjectAttachOffsetX(objectid) + move_amount);
		}
		case OFFSET_MODE_Y: {
			SetObjectAttachOffsetY(objectid, GetObjectAttachOffsetY(objectid) + move_amount);
		}
		case OFFSET_MODE_Z: {
			SetObjectAttachOffsetZ(objectid, GetObjectAttachOffsetZ(objectid) + move_amount);
		}
		case OFFSET_MODE_RX: {
			SetObjectAttachOffsetRX(objectid, fixrot( GetObjectAttachOffsetRX(objectid) + move_amount ) );
		}
		case OFFSET_MODE_RY: {
			SetObjectAttachOffsetRY(objectid, fixrot( GetObjectAttachOffsetRY(objectid) + move_amount ) );
		}
		case OFFSET_MODE_RZ: {
			SetObjectAttachOffsetRZ(objectid, fixrot( GetObjectAttachOffsetRZ(objectid) + move_amount ) );
		}
		default: {
		    return 1;
		}
	}

	ShowOffsetUpdate(playerid, objectid);
	ApplyObjectAttachData(objectid);
	return 1;
}
