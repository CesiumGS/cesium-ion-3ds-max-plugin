rollout cesiumFloater "Cesium ion Exporter" width:400
(
	button buttonCesium "Visit Website" width:360 height:61 images:#(cesiumInstance.PLUGINDIRECTORY + "/ion_color_black.bmp", undefined, 1, 1, 1, 1, 1)
	label labelName "Name (Required):" align:#left across:2
	editText editName "" align:#left
	label labelDesc "Description:" align:#left across:2
	editText editDesc "" height:60 align:#left
	label labelAttribution "Attribution:" align:#left across:2
	editText editAttribution "" align:#left
	label labelType "Model Type:" align:#left across:2
	dropDownList dropDownType "" items:#("3D Capture", "3D Model (tile as 3D tiles)", "3D Model (convert to glTF)") selection:2 align:#left
	checkbox useWebP "Use WebP images" align:#left
	checkbox exportSelected "Export only selected" align:#left
	button buttonUpload "Upload to Cesium ion" width:360 height:32
	--button buttonLogout "Logout" width:360 height:32
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
					(	type = "GLTF"
						sourceType = "3D_MODEL"
					)

					local textureFormat
					if useWebP.checked then textureFormat = "WEBP" else textureFormat = "AUTO"
					local upload = "C#.exe" + " upload \"" + filePath + "\" \"" + editName.text + "\" \"" + editDesc.text + "\" \"" + editAttribution.text + "\" " + type + " " + sourceType + " " + textureFormat + " \"" + cesiumInstance.tokenLocation + "\" \"" + progressFilePath + "\""
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
									local speedKiB = (progress - progressTmp) / 1024 / sleepTime
									cesiumInstance.uploadWidget.lbl1.text = "Uploading: " + (progress / 1024) as string + " KiB / " + (total / 1024) as string + " KiB\n " + speedKiB as string + " KiB/sec"
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
	/*on buttonLogout pressed  do
	(
		gc()
		local filename = (GetDir #plugcfg_ln + "\\cesium_token")
		deleteFile filename
		DestroyDialog cesiumFloater
	)*/
)