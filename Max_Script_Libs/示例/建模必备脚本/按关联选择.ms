  if selection.count==0 then
	(
	PushPrompt "����ѡ������..."
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