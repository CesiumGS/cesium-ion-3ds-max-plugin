-- create a menu

cesiumMenuName = "Export to Cesium ion"
macroScript exportButton category: "mxs docs" tooltip:cesiumMenuName
(
	local filename = (GetDir #plugcfg_ln + "\\cesium_token")
	local tokenFile = openFile filename
	if tokenFile == undefined then
	(
		
		test = cesiumPlugin()
--		test.requestToken()
		tokenFile = createFile filename
		--TODO: Create Token
		close tokenFile
		free tokenFile
	)
	else
	(
		close tokenFile
		free tokenFile
		createDialog cesiumFloater height:280 width:400 modal:true
	)
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
)
createMenu()
)


struct cesiumPlugin
(
	CLIENT_ID = "53",
    ION_ADDRESS = "https://cesium.com",
    API_ADDRESS = "https://api.cesium.com",
	REDIRECT_ADDRESS = "localhost",
	REDIRECT_PORT = 10101,
	fn requestToken =
	(
		requestClass = dotNetClass "System.Net.WebRequest"
		PointManager = dotNetClass "System.Net.ServicePointManager"
--		type = dotNetObject "System.Net.SecurityProtocolType.Tls12"
--		val = dotnet.ValueToDotNetObject 3072 type
		PointManager.Expect100Continue = true
		setProperty PointManager "SecurityProtocol" 3072
--		PointManager.SecurityProtocol.setProperty() 
		redirectUri = "http%3A%2F%2Flocalhost%3A10101%2F"
--		redirectUri = dotNetObject "System.Uri" (redirectUri as string)
--		params = format "response_type=code&client_id=%&redirect_uri=%&scope=asset\%3Awrite&code_challenge=%&code_challenge_method=S256" CLIENT_ID redirectUri codechallenge
		params = stringstream ""
		format "response_type=code&client_id=%&redirect_uri=%&scope=assets\%3Awrite" CLIENT_ID redirectUri to:params
		address = StringStream ""
		format "%/ion/oauth?%" ION_ADDRESS (params as string) to:address
		address = address as string
		request = requestClass.Create(address)
		request.Method = "GET"
		request.Timeout = 5000

		response = request.getResponse()
		-- response is an HttpWebResponse
		responseStream = response.GetResponseStream()

		encodingClass = dotNetClass "System.Text.Encoding"
		encoding = encodingClass.GetEncoding "utf-8"

		readStream = dotNetObject "System.IO.StreamReader" responseStream encoding
		readStream.ReadToEnd()
		readStream.Close()
		response.Close()
	)
)
