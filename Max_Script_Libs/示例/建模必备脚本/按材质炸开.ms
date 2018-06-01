--get all the mtl ids
	fn fl_conutTheMtlID obj =
	(
		faceCount = obj.getnumfaces() --get all the faces number
		tempFaces = 0
		mtlID = #()
		for i in 1 to faceCount where tempFaces < faceCount do
		(
			--start to count
			id = polyOp.getFaceMatID obj i
			if findItem mtlID id == 0 then
			( 	append mtlID id
				obj.EditablePoly.selectByMaterial id
				selectFaces = polyOp.getFaceSelection obj
				tempFaces += selectFaces.numberSet
			)
		)
		mtlID
	)
	--detach a EPoly by material ID
	fn fl_detachPolyByMtlID obj =
	(	--start function for detaching elements by id from an editable poly object
		mtl = obj.material
		mtlID = fl_conutTheMtlID obj
		tempName = obj.name
		for i in 1 to mtlID.count do --detach by material id
		(
			newName = uniquename (tempName + "_")
			obj.EditablePoly.selectByMaterial mtlID[i]
			selectFaces = polyOp.getFaceSelection obj
			polyop.detachFaces obj selectFaces asNode:true name:newName
			NewObj = getnodebyname newName
			NewObj.material = mtl[mtlID[i]]
			
			resetXForm NewObj 
			convertTo NewObj (Editable_Poly)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
		)
		delete obj
	)
	--detach a EPoly by material ID
	fn fl_detachMeshByMtlID obj =
	(	--start function for detaching elements by id from an editable mesh object
		convertTo obj (Editable_Poly)
		mtl = obj.material
		mtlID = fl_conutTheMtlID obj
		tempName = obj.name
		for i in 1 to mtlID.count do --detach by material id
		(
			newName = uniquename (tempName + "_")
			obj.EditablePoly.selectByMaterial mtlID[i]
			selectFaces = polyOp.getFaceSelection obj
			polyop.detachFaces obj selectFaces asNode:true name:newName
			NewObj = getnodebyname newName
			NewObj.material = mtl[mtlID[i]]
			
			resetXForm NewObj 
			convertTo NewObj (Editable_Mesh)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
		)
		delete obj
	)
	--main
	(	if selection.count != 0 then
		(	sel = getcurrentselection()
			for s in sel do
			if classof s.material == Multimaterial then
			(
				with redraw off
				undo on (
				if classof s == Editable_Poly then fl_detachPolyByMtlID s
				else if classof s == Editable_Mesh then
				(	
					fl_detachMeshByMtlID s
				)
				else ()
				) --end undo on
				max views redraw
			)
		)
		else messagebox "请选择要分离的物体,可多选!" title:"提示"
	)
