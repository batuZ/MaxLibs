  if selection.count==0 then
	(
	PushPrompt "请先选择物体..."
	)
	else

	(
	
		local arSelInstancesNodes = #()
		on isenabled return (selection.count == 1) and (InstanceMgr.canMakeObjectsUnique (selection as array))
		on execute do 
			(
				InstanceMgr.getinstances selection[1]  &arSelInstancesNodes
				Select arSelInstancesNodes
				arSelInstancesNodes = #()
			)
	)