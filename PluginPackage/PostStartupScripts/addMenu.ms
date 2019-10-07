-- create a menu

macroScript exportButton category: "mxs docs" tooltip:cesiumInstance.cesiumMenuName
(
	local path = getSourceFileName()
	path = getFilenamePath path
	path = substring path 1 (path.count-1)
	path = getFilenamePath path
	local serverPath = path + @"C#\C#.exe"
	local filename = (GetDir #plugcfg_ln + "\\cesiumIonToken")
	cesiumInstance.SERVERGETTOKEN = serverpath + " gettoken " + cesiumInstance.CLIENT_ID + " " + cesiumInstance.REDIRECT_ADDRESS + " \"" + filename + "\""
	local tokenFile = openFile filename
	if tokenFile == undefined then
	(
		HiddenDOSCommand  cesiumInstance.SERVERGETTOKEN donotwait:false
	)
	else
	(
		close tokenFile
		free tokenFile
		createDialog cesiumFloater height:400 width:400 modal:true
	)
)

cesiumInstance.createMenu()

