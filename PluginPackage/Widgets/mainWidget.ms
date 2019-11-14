rollout cesiumFloater "Cesium ion Exporter" width:400 height:336
(
	label labelName "Name: (Required)" pos:[20,20] width:100 height:20 align:#left
	editText editName "" pos:[130,20] width:250 height:16 align:#left
	label labelDesc "Description:" pos:[20,60] width:100 height:20 align:#left
	editText editDesc "" pos:[130,60] width:250 height:60 align:#left
	label labelAttribution "Attribution:" pos:[20,140] width:100 height:20 align:#left
	editText editAttribution "" pos:[130,140] width:250 height:16 align:#left
	label labelType "Model Type:" pos:[20,180] width:120 height:20 align:#left
	dropDownList dropDownType "" pos:[160,180] width:220 height:20 items:#("3D Model", "3D Capture", "Single glTF") selection:1 align:#left
	checkbox useWebP "Use WebP images" pos:[20,210] width:200 height:20 align:#left
	checkbox exportSelected "Export only selected" pos:[20,230] width:200 height:20 align:#left
	button buttonUpload "Upload to Cesium ion" pos:[20,260] width:360 height:32 align:#left
	--button buttonLogout "Logout" pos:[20,270] width:360 height:32 align:#left
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
					if dropDownType.selected == "3D Model" then
					(
						type = "3D_MODEL"
					)
					else
					(
						type = "3D_CAPTURE"
					)
					local textureFormat
					if useWebP.checked then textureFormat = "WEBP" else textureFormat = "AUTO"
					local upload = "C#.exe" + " upload \"" + filePath + "\" \"" + editName.text + "\" \"" + editDesc.text + "\" \"" + editAttribution.text + "\" " + type + " " + textureFormat + " \"" + cesiumInstance.tokenLocation + "\" \"" + progressFilePath + "\""
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