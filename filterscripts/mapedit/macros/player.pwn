#define SetPlayerEditVehicle(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_VEHICLE, g_PlayerData[%0][PLAYER_DATA_EDIT_ID] = %1)

#define SetPlayerEditPickup(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_PICKUP, g_PlayerData[%0][PLAYER_DATA_EDIT_ID] = %1)

#define SetPlayerEditActor(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_ACTOR, g_PlayerData[%0][PLAYER_DATA_EDIT_ID] = %1)

#define SetPlayerEditObject(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_OBJECT, g_PlayerData[%0][PLAYER_DATA_EDIT_ID] = %1)

#define SetPlayerEditAttached(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_ATTACH, g_PlayerData[%0][PLAYER_DATA_EDIT_ID] = %1)
