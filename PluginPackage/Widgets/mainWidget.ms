rollout cesiumFloater "Cesium ion Exporter" width:400
(
    local geometricCompressionTooltip = "\"None\" is used to disable geometry compression. \"Draco\" uses Draco Compression to create a smaller tileset with better streaming performance. 3D Tiles produced with this option require a host that supports the KHR_draco_mesh_compression glTF extension. All official Cesium clients are supported. \"Meshopt\" geometric compression is optimized for runtime performance. 3D Tiles produced with this option require a client, such as CesiumJS, that supports the EXT_meshopt_compression glTF extension."
    local modelTypeTooltip = "Choose 3D Capture for models that originated from a 3D scan, LIDAR, or photogrammetry process, otherwise choose 3D Model. To host a model on Cesium ion as glTF, without tiling it into 3D Tiles, choose 3D Model (convert to glTF)."
    local ktxTooltip = "KTX v2.0 is an image container format that supports Basis Universal supercompression. Use KTX2 Compression to create a smaller tileset with better streaming performance."

    button buttonCesium "Visit Website" width:288 height:61 tooltip:"https://cesium.com/ion" images:#(cesiumInstance.PLUGINDIRECTORY + "/ion_logo_white.png", cesiumInstance.PLUGINDIRECTORY + "/ion_logo_mask.png", 1, 1, 1, 1, 1)
    editText editName "Name (Required):" tooltip:"A name for the ion asset you are uploading."
    editText editDescription "Description:" height:60 tooltip:"An optional description."
    editText editAttribution "Attribution:" height:60 tooltip:"Any attribution you would like to appear when this asset is loaded into client visualization engines."
    label labelType "Model Type:" align:#left across:2 tooltip:modelTypeTooltip
    dropDownList dropDownType "" selection:2 align:#left items:#("3D Capture / Reality Model / Photogrammetry", "3D Model", "3D Model (convert to glTF)") tooltip:modelTypeTooltip
    label geometricCompression "Geometric Compression:" align:#left across:2 tooltip:geometricCompressionTooltip
    dropDownList geometricCompressionType "" selection:2 align:#left items:#("None", "Draco", "MeshOpt") tooltip:geometricCompressionTooltip
    checkbox useKtx2 "KTX2 Compression" tooltip:ktxTooltip
    checkbox exportSelected "Export Only Selected" tooltip:"Export only the selected models. Uncheck to export all models in the scene."
    button buttonUpload "Upload to Cesium ion" width:360 height:32 tooltip:"Press to send the selected objects to your account on Cesium ion."

    on cesiumFloater open do
    (
        editName.text = maxFileName

        local index = findString editName.text ".max"
        if (index != undefined) then
        (
            editName.text = substring editName.text 1 (index - 1)
        )

        local titleIndex = fileProperties.findProperty #summary "Title"
        if (titleIndex > 0) then
        (
            editName.text = fileProperties.getPropertyValue #summary titleIndex
        )

        -- Attribution --
        local authorIndex = fileProperties.findProperty #summary "Author"
        if (authorIndex > 0) then
        (
            if (editAttribution.text != "") then editAttribution.text += "\n"
            editAttribution.text += "Author: " + (fileProperties.getPropertyValue #summary authorIndex)
        )

        local companyIndex = fileProperties.findProperty #contents "Company"
        if (companyIndex > 0) then
        (
            if (editAttribution.text != "") then editAttribution.text += "\n"
            editAttribution.text += "Company: " + (fileProperties.getPropertyValue #contents companyIndex)
        )

        local managerIndex = fileProperties.findProperty #contents "Manager"
        if (managerIndex > 0) then
        (
            if (editAttribution.text != "") then editAttribution.text += "\n"
            editAttribution.text += "Manager: " + (fileProperties.getPropertyValue #contents managerIndex)
        )

        -- Description --
        local subjectIndex = fileProperties.findProperty #summary "Subject"
        if (subjectIndex > 0) then
        (
            if (editDescription.text != "") then editDescription.text += "\n"
            editDescription.text += "Subject: " + (fileProperties.getPropertyValue #summary subjectIndex)
        )

        local categoryIndex = fileProperties.findProperty #summary "Category"
        if (categoryIndex > 0) then
        (
            if (editDescription.text != "") then editDescription.text += "\n"
            editDescription.text += "Category: " + (fileProperties.getPropertyValue #summary categoryIndex)
        )

        local keywordsIndex = fileProperties.findProperty #summary "Keywords"
        if (keywordsIndex > 0) then
        (
            if (editDescription.text != "") then editDescription.text += "\n"
            editDescription.text += "Keywords: " + (fileProperties.getPropertyValue #summary keywordsIndex)
        )

        local commentsIndex = fileProperties.findProperty #summary "Comments"
        if (commentsIndex > 0) then
        (
            if (editDescription.text != "") then editDescription.text += "\n"
            editDescription.text += "Comments: " + (fileProperties.getPropertyValue #summary commentsIndex)
        )
    )

    on buttonCesium pressed do
    (
        local command = cesiumInstance.VISITWEBSITE + " https://cesium.com/ion"
        HiddenDOSCommand command startpath:cesiumInstance.SERVERDIRECTORY
    )

    on buttonUpload pressed  do
    (
        if editName.text == "" then
        (
            createDialog nameRequiredFloater height:100 width:200 modal:true
        )
        else
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
                local filePath = (GetDir #temp + "\\cesiumion" + (cesiumInstance.uploadCounter as string) + ".fbx")
                local progressFilePath = (GetDir #temp + "\\progress"+ (cesiumInstance.uploadCounter as string) +".log")
                local toClose = createFile progressFilePath
                local logFileCreated = (toClose != undefined)
                close toClose
                free toClose
                cesiumInstance.uploadCounter += 1
                FbxExporterSetParam "EmbedTextures" true
                if ((exportFile filePath #noPrompt selectedOnly:exportSelected.checked) and logFileCreated) then
                (
                    local type
                    local sourceType
                    if dropDownType.selection == 1 then
                    (
                        type = "3DTILES"
                        sourceType = "3D_CAPTURE"
                    )
                    if dropDownType.selection == 2 then
                    (
                        type = "3DTILES"
                        sourceType = "3D_MODEL"
                    )
                    if dropDownType.selection == 3 then
                    (   type = "GLTF"
                        sourceType = "3D_MODEL"
                    )

                    local textureFormat
                    if useKtx2.checked then textureFormat = "KTX2" else textureFormat = "AUTO"

                    local geometricCompression
                    if geometricCompressionType.selection == 1 then
                    (
                        geometricCompression = "NONE"
                    )
                    if geometricCompressionType.selection == 2 then
                    (
                        geometricCompression = "DRACO"
                    )
                    if geometricCompressionType.selection == 3 then
                    (   
                        geometricCompression = "MESHOPT"
                    )

                    -- As description and attribution can have multiple lines, C# will break is \n is in the string.
                    -- Replace it with a token here and replace it back in C# server.cs.
                    local newLine = "\n"
                    local newLineReplacement = "__\\n__"
                    local description = substituteString editDescription.text newLine newLineReplacement
                    local attribution = substituteString editAttribution.text newLine newLineReplacement

                    local upload = "C#.exe" + " upload \"" + filePath + "\" \"" + editName.text + "\" \"" + description + "\" \"" + attribution + "\" " + type + " " + sourceType + " " + textureFormat + " " + geometricCompression + " \"" + cesiumInstance.tokenLocation + "\" \"" + progressFilePath + "\""
                    DestroyDialog cesiumfloater
                    CreateDialog cesiumInstance.uploadWidget width:600 height:130
                    cesiumInstance.uploadWidget.complete.text = "Cancel"
                    HiddenDOSCommand upload startpath:cesiumInstance.SERVERDIRECTORY donotwait:true prompt:"Uploading to Cesium ion..."
                    fn progress =
                    (
                        local progressFilePath = cesiumInstance.progressFilePath
                        do
                        (
                            local progressFile = openFile progressFilePath mode:"r"
                            if (progressFile != undefined) then
                            (
                                local check = eof progressFile
                                close progressFile
                                free progressFile
                            )
                        )
                        while check

                        local running = true
                        local counter = 0;
                        local sleepTime = 0.1
                        local progress = 0
                        local speedAverage = 0.0
                        local numAverageFrames = 50
                        local recordedFrames = 0.0
                        while(running) do
                        (
                            sleep sleepTime
                            local progressFile = openFile progressFilePath mode:"r"
                            if (progressFile != undefined) then
                            (
                                local progressTmp = progress
                                progress = readDelimitedString progressFile "/"
                                if (findString progress "Error" == undefined) then
                                (
                                    local total = readLine progressFile
                                    progress = progress as integer
                                    total = total as integer
                                    cesiumInstance.uploadWidget.pb1.value = 100.0*progress/total
                                    local currentSpeed = (progress - progressTmp) / 1024 / sleepTime

                                    if (recordedFrames < numAverageFrames) then
                                    (
                                        recordedFrames += 1.0
                                    )
                                    speedAverage = speedAverage * ((recordedFrames - 1) / recordedFrames) + currentSpeed * (1 / recordedFrames)

                                    cesiumInstance.uploadWidget.lbl1.text = "Uploading: " + (progress / 1024) as string + " KiB / " + (total / 1024) as string + " KiB\n " + speedAverage as string + " KiB/sec"
                                    if (progress == total) then
                                    (
                                        cesiumInstance.uploadWidget.lbl1.text = "Upload Finished"
                                        cesiumInstance.uploadWidget.complete.text = "Close"
                                        running = false
                                    )
                                )
                                else
                                (
                                    cesiumInstance.uploadWidget.lbl1.text = "Upload Failed. Log location: " +  progressFilePath
                                    cesiumInstance.uploadWidget.complete.text = "Close"
                                    running = false
                                )
                                if cesiumInstance.uploadWidget.inDialog == false then
                                (
                                    running = false
                                )
                                close progressFile
                                free progressFile
                            )

                        )
                    )
                    MainThread = dotNetObject "system.componentModel.backgroundWorker"
                    dotNet.addEventHandler MainThread "DoWork" progress
                    cesiumInstance.progressFilePath = progressFilePath
                    MainThread.RunWorkerAsync()
                )
            )
        )
    )
	
	fn updateOptionsVisibility =
    (
        if dropDownType.selection == 1 then
        (
            geometricCompression.visible = true
            geometricCompressionType.visible = true
            useKtx2.visible = true
        )
        else
        (
            geometricCompression.visible = false
            geometricCompressionType.visible = false
            useKtx2.visible = false
        )
    )

    on dropDownType selected selectionIndex do
    (
        updateOptionsVisibility()
    )

    on cesiumFloater open do
    (
        -- Initialize visibility based on current selection
        updateOptionsVisibility()
    )

    /*on buttonLogout pressed  do
    (
        gc()
        local filename = (GetDir #plugcfg_ln + "\\cesium_token")
        deleteFile filename
        DestroyDialog cesiumFloater
    )*/
)
