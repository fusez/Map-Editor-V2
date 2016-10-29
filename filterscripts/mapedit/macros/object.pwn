#define GetObjectAttachType(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_IDTYPE])
	
#define SetObjectAttachType(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_IDTYPE] = %1)

#define GetObjectAttachID(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_ID])

#define SetObjectAttachID(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_ID] = %1)

//GetObjectAttachObject can be found as function

#define SetObjectAttachObject(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_IDTYPE] = ID_TYPE_OBJECT, g_ObjectData[%0-1][OBJECT_DATA_ATTACH_ID] = %1)

//GetObjectAttachVehicle can be found as function

#define SetObjectAttachVehicle(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_IDTYPE] = ID_TYPE_VEHICLE, g_ObjectData[%0-1][OBJECT_DATA_ATTACH_ID] = %1)
	
#define GetObjectAttachOffsetX(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_X])

#define SetObjectAttachOffsetX(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_X] = %1)

#define GetObjectAttachOffsetY(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Y])

#define SetObjectAttachOffsetY(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Y] = %1)
	
#define GetObjectAttachOffsetZ(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Z])
	
#define SetObjectAttachOffsetZ(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Z] = %1)
	
#define GetObjectAttachOffsetRX(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RX])
	
#define SetObjectAttachOffsetRX(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RX] = %1)
	
#define GetObjectAttachOffsetRY(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RY])
	
#define SetObjectAttachOffsetRY(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RY] = %1)
	
#define GetObjectAttachOffsetRZ(%0) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RZ])
	
#define SetObjectAttachOffsetRZ(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RZ] = %1)

#define GetObjectAttachOffsetPos(%0,%1,%2,%3) \
	(%1 = g_ObjectData[%0-1][OBJECT_DATA_ATTACH_X], %2 = g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Y], %3 = g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Z])
	
#define SetObjectAttachOffsetPos(%0,%1,%2,%3) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_X] = %1, g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Y] = %2, g_ObjectData[%0-1][OBJECT_DATA_ATTACH_Z] = %3)

#define GetObjectAttachOffsetRot(%0,%1,%2,%3) \
	(%1 = g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RX], %2 = g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RY], %3 = g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RZ])

#define SetObjectAttachOffsetRot(%0,%1,%2,%3) \
	(g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RX] = %1, g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RY] = %2, g_ObjectData[%0-1][OBJECT_DATA_ATTACH_RZ] = %3)
	
#define IsValidMaterialIndex(%0) \
	(%0 >= 0 && %0 < MAX_OBJECT_INDEX)
	
#define GetObjectMaterialIndexType(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_TYPE][%1])
	
#define SetObjectMaterialIndexType(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_TYPE][%1] = %2)
	
#define GetObjectTexture(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_TEXTURE][%1])

#define SetObjectTexture(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_TEXTURE][%1] = %2)
	
//GetObjectText can be found as function

#define SetObjectText(%0,%1,%2) \
	(strpack(g_ObjectText[%0-1][%1], %2, MAX_OBJECT_TEXT))

//GetObjectFont can be found as function

#define SetObjectFont(%0,%1,%2) \
	(strpack(g_ObjectFont[%0-1][%1], %2, MAX_FONT_NAME))

#define GetObjectMaterialSize(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_SIZE][%1])

#define SetObjectMaterialSize(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_SIZE][%1] = %2)

#define GetObjectFontSize(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_FONTSIZE][%1])

#define SetObjectFontSize(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_FONTSIZE][%1] = %2)

#define IsObjectTextBold(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_ISBOLD][%1])

#define SetObjectTextBold(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_ISBOLD][%1] = %2)

#define GetObjectFontColor(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_FONTCOLOR][%1])

#define SetObjectFontColor(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_FONTCOLOR][%1] = %2)

#define GetObjectColor(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_COLOR][%1])

#define SetObjectColor(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_COLOR][%1] = %2)

#define GetObjectTextAlignment(%0,%1) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_ALIGNMENT][%1])

#define SetObjectTextAlignment(%0,%1,%2) \
	(g_ObjectData[%0-1][OBJECT_DATA_MATINDEX_ALIGNMENT][%1] = %2)

//GetObjectComment can be found as function

#define SetObjectComment(%0,%1) \
	(strpack(g_ObjectData[%0-1][OBJECT_DATA_COMMENT], %1, MAX_COMMENT_LEN))
