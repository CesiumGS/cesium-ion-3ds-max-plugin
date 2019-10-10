-- create a menu

macroScript exportButton category: "mxs docs" tooltip:cesiumInstance.cesiumMenuName
(
	local tokenFile = openFile cesiumInstance.tokenLocation
	if tokenFile == undefined then
	(
		HiddenDOSCommand cesiumInstance.SERVERGETTOKEN startpath:cesiumInstance.SERVERDIRECTORY donotwait:true
	)
	else
	(
		close tokenFile
		free tokenFile
		createDialog cesiumFloater height:300 width:400 modal:true
	)
)

cesiumInstance.createMenu()

