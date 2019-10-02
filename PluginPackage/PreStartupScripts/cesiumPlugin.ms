struct cesiumPlugin
(
	SERVERGETTOKEN,
	CLIENT_ID = "56",
    ION_ADDRESS = "https://cesium.com",
    API_ADDRESS = "https://api.cesium.com",
	REDIRECT_ADDRESS = @"http://localhost:5000/",
	cesiumMenuName = "Export to Cesium ion",
	fn createMenu =
	(
		local fileMenu = menuMan.findMenu "&File"
		local notFound = true
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
				if item.getTitle() == ::cesiumMenuName then notFound = false
			)
			if notFound then
			(
				local myAction = menuMan.createActionItem "exportButton" "mxs docs"
				exportMenu.addItem myAction (exportMenu.numItems()+1)
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
			local serverPath = path + @"C#\C#.exe"
			local filename = (GetDir #plugcfg_ln + "\\cesium_token")
			SERVERGETTOKEN = serverpath + " gettoken " + CLIENT_ID + " " + REDIRECT_ADDRESS + " " + filename
			local tokenFile = openFile filename
			if tokenFile == undefined then
			(
				HiddenDOSCommand  SERVERGETTOKEN donotwait:true
			)
	)
)
cesiumInstance = cesiumPlugin()
cesiumInstance.init()