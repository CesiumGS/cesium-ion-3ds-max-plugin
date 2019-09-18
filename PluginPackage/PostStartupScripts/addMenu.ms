-- create a menu

cesiumMenuName = "Export to Cesium"
macroScript exportButton category: "mxs docs" tooltip:cesiumMenuName
(
	createDialog cesiumFloater height:340 width:400 modal:true
)
(
fn createMenu =
(
	local fileMenu = menuMan.findMenu "&File"
	local notFound = true
	local exportMenu
	for i = 1 to fileMenu.numItems() while notFound do
	(
		exportMenu = fileMenu.getItem(i)
		if exportMenu.getTitle() == "&Export" do notFound = false
	)
	if classOf exportMenu == MixinInterface do
	(
		exportMenu = exportMenu.getSubMenu()
		notFound = true
		for i = 1 to exportMenu.numItems() while notFound do
		(
			item = exportMenu.getItem(i)
			if item.getTitle() == ::cesiumMenuName do notFound = false
		)
		if notFound do
		(
			local myAction = menuMan.createActionItem "exportButton" "mxs docs"
			exportMenu.addItem myAction (exportMenu.numItems()+1)
			menuMan.updateMenuBar()
		)
	)
)
createMenu()
)
