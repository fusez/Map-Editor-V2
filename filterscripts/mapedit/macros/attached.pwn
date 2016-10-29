#define IsValidAttachedIndex(%0) \
	(%0 >= 0 && %0 < MAX_ATTACHED_INDEX)

#define IsPlayerAttachedToggled(%0,%1) \
	(%1 >= 0 && %1 < MAX_ATTACHED_INDEX && g_PlayerData[%0][PLAYER_DATA_ATTACHED_TOGGLE][%1])

#define TogglePlayerAttached(%0,%1,%2) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_TOGGLE][%1] = %2)

#define GetPlayerAttachedModel(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_MODEL][%1])

#define SetPlayerAttachedModel(%0,%1,%2) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_MODEL][%1] = %2)

#define GetPlayerAttachedBone(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_BONE][%1])

#define SetPlayerAttachedBone(%0,%1,%2) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_BONE][%1] = %2)

#define GetPlayerAttachedOffset(%0,%1,%2,%3,%4) \
	(%2 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_X][%1], %3 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_Y][%1], %4 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_Z][%1])

#define SetPlayerAttachedOffset(%0,%1,%2,%3,%4) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_X][%1] = %2, g_PlayerData[%0][PLAYER_DATA_ATTACHED_Y][%1] = %3, g_PlayerData[%0][PLAYER_DATA_ATTACHED_Z][%1] = %4)

#define GetPlayerAttachedRot(%0,%1,%2,%3,%4) \
	(%2 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_RX][%1], %3 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_RY][%1], %4 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_RZ][%1])

#define SetPlayerAttachedRot(%0,%1,%2,%3,%4) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_RX][%1] = %2, g_PlayerData[%0][PLAYER_DATA_ATTACHED_RY][%1] = %3, g_PlayerData[%0][PLAYER_DATA_ATTACHED_RZ][%1] = %4)

#define GetPlayerAttachedScale(%0,%1,%2,%3,%4) \
	(%2 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_SX][%1], %3 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_SY][%1], %4 = g_PlayerData[%0][PLAYER_DATA_ATTACHED_SZ][%1])

#define SetPlayerAttachedScale(%0,%1,%2,%3,%4) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_SX][%1] = %2, g_PlayerData[%0][PLAYER_DATA_ATTACHED_SY][%1] = %3, g_PlayerData[%0][PLAYER_DATA_ATTACHED_SZ][%1] = %4)

#define GetPlayerAttachedColor1(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_COLOR1][%1])

#define SetPlayerAttachedColor1(%0,%1,%2) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_COLOR1][%1] = %2)

#define GetPlayerAttachedColor2(%0,%1) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_COLOR2][%1])

#define SetPlayerAttachedColor2(%0,%1,%2) \
	(g_PlayerData[%0][PLAYER_DATA_ATTACHED_COLOR2][%1] = %2)
