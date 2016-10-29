#define IsValidPickup(%0) \
	(%0 >= 0 && %0 < MAX_PICKUPS && g_PickupData[%0][PICKUP_DATA_ISVALID])

#define SetPickupValid(%0,%1) \
	(g_PickupData[%0][PICKUP_DATA_ISVALID] = %1)

#define GetPickupModel(%0) \
	(g_PickupData[%0][PICKUP_DATA_MODEL])

#define SetPickupModel(%0,%1) \
	(g_PickupData[%0][PICKUP_DATA_MODEL] = %1)

#define GetPickupPos(%0,%1,%2,%3) \
	(%1 = g_PickupData[%0][PICKUP_DATA_X], %2 = g_PickupData[%0][PICKUP_DATA_Y], %3 = g_PickupData[%0][PICKUP_DATA_Z])

#define SetPickupPos(%0,%1,%2,%3) \
	(g_PickupData[%0][PICKUP_DATA_X] = %1, g_PickupData[%0][PICKUP_DATA_Y] = %2, g_PickupData[%0][PICKUP_DATA_Z] = %3)

//GetPickupComment can be found as function

#define SetPickupComment(%0,%1) \
	(strpack(g_PickupData[%0][PICKUP_DATA_COMMENT], %1, MAX_COMMENT_LEN))
