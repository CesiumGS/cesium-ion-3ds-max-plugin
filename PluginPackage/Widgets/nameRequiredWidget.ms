rollout nameRequiredFloater "Name Required" width:100 height:100
(
    label labelWarning "Name is required" pos:[20,25] width:100 height:20 align:#center
    button buttonclose "Close" pos:[20,50] width:160 height:30 align:#left
    on buttonclose pressed  do
    (
            DestroyDialog nameRequiredFloater
    )
)
