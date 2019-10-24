struct cesiumPlugin
(
	SERVERGETTOKEN,
	SERVERDIRECTORY,
	CLIENT_ID = "62",
    ION_ADDRESS = "https://cesium.com",
    API_ADDRESS = "https://api.cesium.com",
	REDIRECT_ADDRESS = @"http://localhost:5000/",
	cesiumMenuName = "Export to Cesium ion",
	tokenLocation,
	progressFilePath,
	uploadCounter = 0,
	uploadWidget,
	fn createMenu =
	(
		local mainMenu = menuMan.getMainMenuBar()
		local notFound = true
		local fileMenu
		for i = 1 to mainMenu.numItems() while notFound do
		(
			fileMenu = mainMenu.getItem(i)
			if fileMenu.getTitle() == "&File" then notFound = false
		)
		local newMenu = false
		fileMenu = fileMenu.getSubMenu()
		if (notFound == false) then
		(
			notFound = true
			local exportMenu
			for i = 1 to fileMenu.numItems() while notFound do
			(
				exportMenu = fileMenu.getItem(i)
				if exportMenu.getTitle() == "&Export" then notFound = false
			)
			if classOf exportMenu == MixinInterface then
			(
				exportMenu = exportMenu.getSubMenu()
				notFound = true
				for i = 1 to exportMenu.numItems() while notFound do
				(
					item = exportMenu.getItem(i)
					if item.getTitle() == cesiumMenuName then notFound = false
				)
				if notFound then
				(
					local myAction = menuMan.createActionItem "exportButton" "mxs docs"
					exportMenu.addItem myAction (exportMenu.numItems()+1)
					menuMan.updateMenuBar()
				)
			)
			else
			(
				newMenu = true
			)
		)
		else
		(
			newMenu = true
		)
		if (newMenu) then
		(
			local menu = menuMan.findMenu "&Cesium ion"
			if (menu == undefined) then
			(
				menu = menuMan.createMenu "&Cesium ion"
				local myAction = menuMan.createActionItem "exportButton" "mxs docs"
				menu.addItem myAction -1
				subMenu = menuMan.createSubMenuItem "&Cesium ion" menu
				mainMenu.addItem subMenu (mainMenu.numItems())
				menuMan.updateMenuBar()
			)
		)
		
	),
	fn init =
	(
			local path = getSourceFileName()
			path = getFilenamePath path
			path = substring path 1 (path.count-1)
			path = getFilenamePath path
			SERVERDIRECTORY = path + @"C#\"
			tokenLocation = (GetDir #plugcfg_ln + "\\cesiumIonToken")
			SERVERGETTOKEN = "C#.exe" + " gettoken " + CLIENT_ID + " " + REDIRECT_ADDRESS + " \"" + tokenLocation + "\""
	)
)

cesiumInstance = cesiumPlugin()
cesiumInstance.init()