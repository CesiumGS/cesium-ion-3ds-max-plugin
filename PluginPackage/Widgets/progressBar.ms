rollout uploadProgress "Uploading..." width:600 height:130
(
	progressBar pb1 "ProgressBar" pos:[35,80] width:530 height:20 value:0 align:#left
	label lbl1 "Uploading: " pos:[35,20] width:505 height:32 align:#left
	button complete "Cancel" pos:[400,100] width:40 height:20 align:#left
	on complete pressed do
	(
		if complete.text == "Cancel" then
		(
			HiddenDOSCommand "taskkill /F /IM C#.exe"
		)
		DestroyDialog uploadProgress
	)
)
cesiumInstance.uploadWidget = uploadProgress