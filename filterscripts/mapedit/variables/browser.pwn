enum BROWSER_DATA {
	BROWSER_DATA_ITEM[MAX_BROWSER_PAGESIZE], // Stored ID'S
	BROWSER_DATA_SEARCH[MAX_BROWSER_SEARCHLEN char], // Searching for Keyword
	BROWSER_DATA_PAGE, // Page Number
	BROWSER_DATA_PAGESIZE // Number of Stored ID'S
}

new
	g_ObjectBrowserData[MAX_PLAYERS][BROWSER_DATA], // object ids
	g_ObjectModelBrowserData[MAX_PLAYERS][BROWSER_DATA], // object, pickup, attachment models
	g_ObjectTextureBrowserData[MAX_PLAYERS][BROWSER_DATA], // object textures
	g_ObjectColorBrowserData[MAX_PLAYERS][BROWSER_DATA], // object, attachment colors
	g_ObjectFontBrowserData[MAX_PLAYERS][BROWSER_DATA], // fonts for object texting
	g_VehicleBrowserData[MAX_PLAYERS][BROWSER_DATA], // vehicle ids
	g_VehicleModelBrowserData[MAX_PLAYERS][BROWSER_DATA], // vehicle models
	g_VehicleColorBrowserData[MAX_PLAYERS][BROWSER_DATA], // vehicle colors
	g_PickupBrowserData[MAX_PLAYERS][BROWSER_DATA], // pickup ids
	g_ActorBrowserData[MAX_PLAYERS][BROWSER_DATA], // actor ids
	g_ActorModelBrowserData[MAX_PLAYERS][BROWSER_DATA], // actor skins
	g_ActorAnimBrowserData[MAX_PLAYERS][BROWSER_DATA] // actor animations
;
