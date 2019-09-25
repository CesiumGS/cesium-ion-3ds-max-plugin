-- create a menu

macroScript exportButton category: "mxs docs" tooltip:cesiumInstance.cesiumMenuName
(
	local filename = (GetDir #plugcfg_ln + "\\cesium_token")
	local tokenFile = openFile filename
	if tokenFile == undefined then
	(
		cesiumInstance.SERVER.GetToken @"https://cesium.com/ion/oauth" "code" cesiumInstance.CLIENT_ID cesiumInstance.REDIRECT_ADDRESS "assets:write" filename
	)
	else
	(
		close tokenFile
		free tokenFile
		createDialog cesiumFloater height:280 width:400 modal:true
	)
)

cesiumInstance.createMenu()

