  if selection.count==0 then
	(
	PushPrompt "请先选择物体..."
	)
	else
(
sel=#()
  if selection[1]!=undefined then
  mtl = selection[1].material 
  if mtl != undefined then
  for i in objects where i.isHidden == false and i.material == mtl do append sel i
  if sel.count != 0 then select sel  
)
