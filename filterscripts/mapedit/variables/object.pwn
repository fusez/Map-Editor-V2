enum OBJECT_DATA {
	OBJECT_DATA_ATTACH_IDTYPE,
	OBJECT_DATA_ATTACH_ID,
	Float: OBJECT_DATA_ATTACH_X,
	Float: OBJECT_DATA_ATTACH_Y,
	Float: OBJECT_DATA_ATTACH_Z,
	Float: OBJECT_DATA_ATTACH_RX,
	Float: OBJECT_DATA_ATTACH_RY,
	Float: OBJECT_DATA_ATTACH_RZ,
	OBJECT_DATA_MATINDEX_TYPE			[MAX_OBJECT_INDEX],
	OBJECT_DATA_MATINDEX_TEXTURE		[MAX_OBJECT_INDEX],
	OBJECT_DATA_MATINDEX_SIZE			[MAX_OBJECT_INDEX],
	OBJECT_DATA_MATINDEX_FONTSIZE		[MAX_OBJECT_INDEX],
	bool: OBJECT_DATA_MATINDEX_ISBOLD	[MAX_OBJECT_INDEX],
	OBJECT_DATA_MATINDEX_COLOR			[MAX_OBJECT_INDEX],
	OBJECT_DATA_MATINDEX_FONTCOLOR		[MAX_OBJECT_INDEX],
	OBJECT_DATA_MATINDEX_ALIGNMENT		[MAX_OBJECT_INDEX],
	OBJECT_DATA_COMMENT					[MAX_COMMENT_LEN char]
}

new
	g_ObjectData[MAX_OBJECTS][OBJECT_DATA],
	g_ObjectText[MAX_OBJECTS][MAX_OBJECT_INDEX][MAX_OBJECT_TEXT char],
	g_ObjectFont[MAX_OBJECTS][MAX_OBJECT_INDEX][MAX_FONT_NAME char]
;
