#define GetVehicleColors(%0,%1,%2) \
	(%1 = g_VehicleData[%0-1][VEHICLE_DATA_COLOR_1], %2 = g_VehicleData[%0-1][VEHICLE_DATA_COLOR_2])
	
#define SetVehicleColors(%0,%1,%2) \
	(g_VehicleData[%0-1][VEHICLE_DATA_COLOR_1] = %1, g_VehicleData[%0-1][VEHICLE_DATA_COLOR_2] = %2)
	
#define GetVehicleColor1(%0) \
	(g_VehicleData[%0-1][VEHICLE_DATA_COLOR_1])
	
#define SetVehicleColor1(%0,%1) \
	(g_VehicleData[%0-1][VEHICLE_DATA_COLOR_1] = %1)
	
#define GetVehicleColor2(%0) \
	(g_VehicleData[%0-1][VEHICLE_DATA_COLOR_2])

#define SetVehicleColor2(%0,%1) \
	(g_VehicleData[%0-1][VEHICLE_DATA_COLOR_2] = %1)

#define GetVehiclePaintjob(%0) \
	(g_VehicleData[%0-1][VEHICLE_DATA_PAINTJOB])

#define SetVehiclePaintjob(%0,%1) \
	(g_VehicleData[%0-1][VEHICLE_DATA_PAINTJOB] = %1)

#define IsVehicleModTeleported(%0) \
	(g_VehicleData[%0-1][VEHICLE_DATA_MODTP_TOGGLE])

#define SetVehicleModTeleported(%0,%1) \
	(g_VehicleData[%0-1][VEHICLE_DATA_MODTP_TOGGLE] = %1)

#define GetVehicleModTeleportPos(%0) \
	( GetVehiclePos(%0, g_VehicleData[%0-1][VEHICLE_DATA_MODTP_X], g_VehicleData[%0-1][VEHICLE_DATA_MODTP_Y], g_VehicleData[%0-1][VEHICLE_DATA_MODTP_Z]) )

#define SetVehicleModTeleportPos(%0) \
	( SetVehiclePos(%0, g_VehicleData[%0-1][VEHICLE_DATA_MODTP_X], g_VehicleData[%0-1][VEHICLE_DATA_MODTP_Y], g_VehicleData[%0-1][VEHICLE_DATA_MODTP_Z]) )

#define GetVehicleModTeleportAngle(%0) \
	( GetVehicleZAngle(%0, g_VehicleData[%0-1][VEHICLE_DATA_MODTP_A]) )

#define SetVehicleModTeleportAngle(%0) \
	( SetVehicleZAngle(%0, g_VehicleData[%0-1][VEHICLE_DATA_MODTP_A]) )

//GetVehicleComment can be found as function

#define SetVehicleComment(%0,%1) \
	( strpack(g_VehicleData[%0-1][VEHICLE_DATA_COMMENT], %1, MAX_COMMENT_LEN) )
