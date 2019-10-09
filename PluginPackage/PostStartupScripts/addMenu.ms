-- create a menu

macroScript exportButton category: "mxs docs" tooltip:cesiumInstance.cesiumMenuName
(
	local filename = (GetDir #plugcfg_ln + "\\cesiumIonToken")
	local tokenFile = openFile filename
	if tokenFile == undefined then
	(
		HiddenDOSCommand cesiumInstance.SERVERGETTOKEN startpath:cesiumInstance.SERVERDIRECTORY donotwait:true
	)
	else
	(
		close tokenFile
		free tokenFile
		createDialog cesiumFloater height:280 width:400 modal:true
	)
)

cesiumInstance.createMenu()

