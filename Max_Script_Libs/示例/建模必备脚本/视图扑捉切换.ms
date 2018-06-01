(
	callbacks.removeScripts id:#wtVPTSnap
	
	global ViewportAutoSnap
	
	fn ViewportAutoSnap =
	(
		vpt = viewport.getType()
		
		if vpt == #view_persp_user or vpt == #view_iso_user or vpt == #view_camera or vpt == #view_spot then
			snapMode.type = #3D
		else			
			snapMode.type = #2_5D
	)
	
	callbacks.addScript #viewportChange "ViewportAutoSnap()" id:#wtVPTSnap
)