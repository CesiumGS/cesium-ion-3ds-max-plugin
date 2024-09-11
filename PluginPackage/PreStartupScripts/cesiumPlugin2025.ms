struct cesiumPlugin
(
    PLUGINDIRECTORY,
    VISITWEBSITE,
    SERVERGETTOKEN,
    SERVERDIRECTORY,
    CLIENT_ID = "62",
    REDIRECT_ADDRESS = @"http://localhost:5000/",
    cesiumMenuName = "Export to Cesium ion...",
    tokenLocation,
    progressFilePath,
    uploadCounter = 0,
    uploadWidget,
    fn init =
    (
            VISITWEBSITE = "C#.exe website";

            local path = getSourceFileName()
            path = getFilenamePath path
            path = substring path 1 (path.count-1)
            PLUGINDIRECTORY = getFilenamePath path
            SERVERDIRECTORY = PLUGINDIRECTORY + @"C#\"
            tokenLocation = (GetDir #plugcfg_ln + "\\cesiumIonToken")
            SERVERGETTOKEN = "C#.exe" + " gettoken " + CLIENT_ID + " " + REDIRECT_ADDRESS + " \"" + tokenLocation + "\""
            local tmpFiles = getFiles (GetDir #temp + "\\cesiumion*.fbx")
            for f in tmpFiles do (deleteFile f)
            tmpFiles = getFiles (GetDir #temp + "\\progress*.log")
            for f in tmpFiles do (deleteFile f)
    )
)

cesiumInstance = cesiumPlugin()
cesiumInstance.init()

-- create a menu

macroScript exportButton
    category: "mxs docs"
    buttonText: cesiumInstance.cesiumMenuName
    toolTip: "Publish the current 3ds Max file to your Cesium ion account."
(
    local tokenFile = openFile cesiumInstance.tokenLocation mode:"r"
    if tokenFile == undefined then
    (
        HiddenDOSCommand cesiumInstance.SERVERGETTOKEN startpath:cesiumInstance.SERVERDIRECTORY donotwait:true
    )
    else
    (
        close tokenFile
        free tokenFile
    )

    createDialog cesiumFloater modal:true
)

function menuCallback =
(
    local menuManager = callbacks.notificationParam()
    local mainMenuBar = menuManager.mainMenuBar

    -- tableId taken from Autodesk example at https://help.autodesk.com/view/MAXDEV/2025/ENU/?guid=packagexml_example
    local macroScriptTableId = 647394
    fileExportMenu = menuManager.GetMenuById("1731e4a6-edf2-4971-b2da-ec3925843f0e") -- type CuiMenu
    local macroScriptTestActionId = "exportButton`mxs docs" 
    fileExportMenu.CreateAction "31b1024d-8e15-432c-aa2d-13e314ff2386" macroScriptTableId macroScriptTestActionId
)
-- Register our menu creation callback so that it can be executed whenever the menu structure is evaluated.
callbacks.removeScripts id:#menuDemo
callbacks.addScript #cuiRegisterMenus menuCallback id:#menuDemo
