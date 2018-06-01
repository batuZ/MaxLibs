

fn getObjMat =
(
	objSel=getCurrentSelection()
	numobjSel=objSel.count
	local objPick
	objPick=pickObject prompt:"select the obj you want copy the material"
	local lwh
	local lwhMd=1
	for i=1 to numobjSel do objSel[i].material=objPick.material
	try lwh=[(objpick.modifiers[#uvw_mapping].length),(objpick.modifiers[#uvw_mapping].width),(objpick.modifiers[#uvw_mapping].height)] catch(lwhMd=0; print( "can't Get=>Copy the uvwMap modifier") )
     if lwhMd==1 do
	(	
		pG=objPick.modifiers[#uvw_mapping].gizmo.pos
		sG=objPick.modifiers[#uvw_mapping].gizmo.scale
		rG=objPick.modifiers[#uvw_mapping].gizmo.rotation
		gP=objPick.modifiers[#uvw_mapping].gizmo
		mP=objPick.modifiers[#uvw_mapping]
		----------------------
		addModifier objSel (Uvwmap length:lwh.x width:lwh.y height:lwh.z mapType:mp.mapType utile:mp.utile uflip:mp.uflip vtile:mp.vtile vflip:mp.vflip wtile:mp.wtile wflip:mp.wflip channel:mp.channel mapchannel:mp.mapchannel axis:mp.axis)
		redrawViews()
		objSel[1].modifiers[#uvw_mapping].gizmo.pos.z=pG.z
		objSel[1].modifiers[#uvw_mapping].gizmo.scale=sG
		objSel[1].modifiers[#uvw_mapping].gizmo.rotation=rG
	)
)
getObjMat()
