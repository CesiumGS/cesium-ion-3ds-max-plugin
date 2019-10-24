rollout uploadProgress "Uploading to Cesium ion..." width:600 height:130
(
	progressBar 'pb1' "ProgressBar" pos:[35,65] width:530 height:10 value:0 align:#left
	label 'lbl1' "Uploading: " pos:[35,20] width:530 height:32 align:#left
	button 'complete' "Cancel" pos:[470,90] width:100 height:30 align:#left
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