rollout cesiumFloater "Cesium ion Exporter" width:400 height:336
(
	label labelName "Name: (Required)" pos:[20,20] width:100 height:20 align:#left
	editText editName "" pos:[130,20] width:250 height:16 align:#left
	label labelDesc "Description:" pos:[20,60] width:100 height:20 align:#left
	editText editDesc "" pos:[130,60] width:250 height:60 align:#left
	label labelAttribution "Attribution:" pos:[20,140] width:100 height:20 align:#left
	editText editAttribution "" pos:[130,140] width:250 height:16 align:#left
	label labelType "Model Type:" pos:[20,180] width:120 height:20 align:#left
	dropDownList dropDownType "" pos:[160,180] width:220 height:20 items:#("3D Model", "3D Capture") selection:1 align:#left
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
				cesiumInstance.progressFilePath = (GetDir #temp + "\\progress"+ (cesiumInstance.uploadCounter as string) +".log")
				--cesiumInstance.uploadCounter += 1
				--exportFile filePath #noPrompt selectedOnly:exportSelected.checked
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
				local upload = "C#.exe" + " upload \"" + filePath + "\" \"" + editName.text + "\" \"" + editDesc.text + "\" \"" + editAttribution.text + "\" " + type + " " + textureFormat + " \"" + cesiumInstance.tokenLocation + "\" \"" + cesiumInstance.progressFilePath + "\""
				DestroyDialog cesiumfloater
				CreateDialog cesiumInstance.uploadWidget width:600 height:130
				cesiumInstance.uploadWidget.complete.text = "Cancel"
				HiddenDOSCommand upload startpath:cesiumInstance.SERVERDIRECTORY donotwait:true prompt:"Uploading..."
				fn progress = 
				(				
					sleep 1
					local running = true
					counter = 0;
					while(running) do 
					(
						sleep 0.5
						local progressFile = openFile cesiumInstance.progressFilePath mode:"r"
						if (progressFile != undefined) then
						(
							local progress = readDelimitedString progressFile "/"
							if (findString progress "Error" == undefined) then
							(
								local total = readLine progressFile
								cesiumInstance.uploadWidget.lbl1.text = "Uploading: " + progress + "/" + total
								cesiumInstance.uploadWidget.pb1.value = 100.0*(progress as integer)/(total as integer)
								if (progress == total) then
								(
									cesiumInstance.uploadWidget.complete.text = "Close"
									running = false
								)
							)
							else
							(
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
						else
						(
							counter += 1
							if (counter > 100) then running = false
						)
	
					)
				)
				MainThread = dotNetObject "system.componentModel.backgroundWorker"	
				sleep 1
				dotNet.addEventHandler MainThread "DoWork" progress
				MainThread.RunWorkerAsync()
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