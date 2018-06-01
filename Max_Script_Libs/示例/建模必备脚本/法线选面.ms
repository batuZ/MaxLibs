global entropy = 0, originNum = 0.999
global key = 0
global AlexSel = #{}
global allFaces = FacesCollect = #()
global AlexRollout
try destroyDialog AlexRollout catch()

rollout AlexRollout "AlexTools" width:116 height:245
(
	GroupBox grp14 "选择面" pos:[11,10] width:93 height:136
	radiobuttons rdo13 "" pos:[24,32] width:74 height:48 labels:#("上", "下", "左", "右", "前", "后") default:0 columns:2
	checkbox chk1 "保持选择" pos:[25,91] width:74 height:18

	button btn02 "点清除" pos:[11,157] width:93 height:22
	button btn01 "轴居中" pos:[11,181] width:93 height:22
	button btn03 "精简视口" pos:[11,205] width:93 height:22
	progressBar AlexPB "ProgressBar" pos:[11,149] width:93 height:5 color:[0,255,255]
	spinner spn1 "容差:" pos:[29,116] width:64 height:16 range:[0,100,0] type:#integer

	fn selectFace stat =
	(
			try
			(
				local tempAlexSel = #{}
				local tempNormal = [0,0,0]
				local FCC
				
				if subObjectLevel != 4 do subObjectLevel = 4
				
				allFaces = for i=1 to $.faces.count collect i				
				
				AlexPB.value = 0
				
				if (classof $) == Editable_Poly do 
				(
					if (((polyop.getFaceSelection $) + AlexSel) as array).count != (AlexSel as array).count then key = 0 else key = 1
					
					if ((polyop.getFaceSelection $) as array).count == 0 then 
					(					
						key = 0
						FacesCollect = allFaces
					)
					else
						if key == 0 do	(FacesCollect = (polyop.getFaceSelection $) as array; key = 1)
				)

				if (classof $) == PolyMeshObject do
				(
					if (((EditPolyMod.getSelection $.Edit_Poly #face) + AlexSel) as array).count != (AlexSel as array).count then key = 0 else key = 1

					if ((EditPolyMod.getSelection $.Edit_Poly #face) as array).count == 0 then 
					(					
						key = 0
						FacesCollect = allFaces
					)
					else
						if key == 0 do (FacesCollect = (EditPolyMod.getSelection $.Edit_Poly #face) as array; key = 1)
				)
				
				FCC = FacesCollect.count
				
				if (classof $) == Editable_Poly do
				(
					case stat of
					(
						1:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(polyop.getFaceNormal $ FacesCollect[i]) > (originNum-entropy) and (polyop.getFaceNormal $ FacesCollect[i])[3] > (originNum-entropy) collect FacesCollect[i])
						2:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(polyop.getFaceNormal $ FacesCollect[i]) > (originNum-entropy) and (polyop.getFaceNormal $ FacesCollect[i])[3] < -(originNum-entropy) collect FacesCollect[i])
						3:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(polyop.getFaceNormal $ FacesCollect[i]) > (originNum-entropy) and (polyop.getFaceNormal $ FacesCollect[i])[1] > (originNum-entropy) collect FacesCollect[i])
						4:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(polyop.getFaceNormal $ FacesCollect[i]) > (originNum-entropy) and (polyop.getFaceNormal $ FacesCollect[i])[1] < -(originNum-entropy) collect FacesCollect[i])
						5:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(polyop.getFaceNormal $ FacesCollect[i]) > (originNum-entropy) and (polyop.getFaceNormal $ FacesCollect[i])[2] > (originNum-entropy) collect FacesCollect[i])
						6:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(polyop.getFaceNormal $ FacesCollect[i]) > (originNum-entropy) and (polyop.getFaceNormal $ FacesCollect[i])[2] < -(originNum-entropy) collect FacesCollect[i])
					)
					
					if chk1.checked == false do AlexSel = #{}
					
					AlexSel += (tempAlexSel as bitarray)
					
					polyop.setFaceSelection $ AlexSel
					
					AlexPB.value = 0
					redrawViews()
				)
				
				if (classof $) == PolyMeshObject do
				(
					case stat of
					(
						1:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i]) > (originNum-entropy) and (EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i])[3] > (originNum-entropy) collect FacesCollect[i])
						2:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i]) > (originNum-entropy) and (EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i])[3] < -(originNum-entropy) collect FacesCollect[i])
						3:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i]) > (originNum-entropy) and (EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i])[1] > (originNum-entropy) collect FacesCollect[i])
						4:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i]) > (originNum-entropy) and (EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i])[1] < -(originNum-entropy) collect FacesCollect[i])
						5:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i]) > (originNum-entropy) and (EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i])[2] > (originNum-entropy) collect FacesCollect[i])
						6:  tempAlexSel = (for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length(EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i]) > (originNum-entropy) and (EditPolyMod.getFaceNormal $.Edit_Poly FacesCollect[i])[2] < -(originNum-entropy) collect FacesCollect[i])
					)
					
					if chk1.checked == false do AlexSel = #{}
					AlexSel += (tempAlexSel as bitarray)
					
					EditPolyMod.SetSelection $.Edit_Poly #Face #{}
					EditPolyMod.select $.Edit_Poly #face AlexSel
				
					AlexPB.value = 0	
					redrawViews()
				)
				
			)
			catch()
	)
	
	on AlexRollout open do
	(
	/*	try
		(
			AlexPB.value = 0
			subobjectLevel = 4
			
			if (classof $) == Editable_Poly do 
				polyop.setFaceSelection $ (for i=1 to FCC where (AlexPB.value = 100 * i.index / FCC)>-1 and length(polyop.getFaceNormal $ i)>(originNum-entropy) and (polyop.getFaceNormal $ i)[3] > (originNum-entropy) collect i)
			
			if (classof $) == PolyMeshObject do
			(
				$.Edit_Poly.SetSelection #Face #{}
	
				$.Edit_Poly.select #face ((for i=1 to FCC where (AlexPB.value = 100 * i / FCC)>-1 and length($.Edit_Poly.getFaceNormal i)>(originNum-entropy) and ($.Edit_Poly.getFaceNormal i)[3] > (originNum-entropy) collect i) as bitarray)
			)	
			
			AlexPB.value = 0
			redrawViews()
		)
		catch()*/
	)
	on rdo13 changed stat do
	(
		selectFace stat
	)
	on btn02 pressed do with undo on
	(
		try
		(
			local SelVerts = DelVerts = #{}
			
			AlexPB.value = 0
	
			if (classof $) == PolyMeshObject do
			(
				SelVerts = $.Edit_Poly.GetSelection #Vertex
	
				SelVerts = SelVerts as array
				
				DelVerts = (for i = 1 to SelVerts.count where (AlexPB.value = 100 * i / SelVerts.count)>-1 and (($.Edit_Poly.GetVertexEdgeCount SelVerts[i]) == 2) collect SelVerts[i]) as bitarray
				
				$.Edit_Poly.SetSelection #Vertex #{}
				
				$.Edit_Poly.Select #Vertex DelVerts
				$.Edit_Poly.ButtonOp #RemoveVertex
	
				SelVerts = SelVerts as bitarray
				
				$.Edit_Poly.SetSelection #Vertex #{}
				$.Edit_Poly.Select #Vertex ((SelVerts - DelVerts) as bitarray)
			)
	
			if (classof $) == Editable_Poly do
			(
				SelVerts = PolyOp.GetVertSelection $
				
				SelVerts = SelVerts as array
				
				DelVerts = (for i = 1 to SelVerts.count where (AlexPB.value = 100 * i / SelVerts.count)>-1 and (((polyop.getEdgesUsingVert $ SelVerts[i]) as array).count == 2) collect SelVerts[i]) as bitarray
	
				polyop.setVertSelection $ DelVerts
				$.Remove selLevel:#Vertex
	
				SelVerts = SelVerts as bitarray
				
				polyop.setVertSelection $ (SelVerts - DelVerts)
			)
	
			AlexPB.value = 0
		)
		catch()
	)
	on btn01 pressed do
	(
		CenterPivot $ 
	)
	on btn03 pressed do
	(
		status = not timeSlider.isVisible()
	
		if status == true then btn03.caption = "精简视口" else btn03.caption = "完整视口"
		
		maxOps.trackBar.visible = status		-- Show/Hide TrackBar
		timeSlider.setVisible status			-- Show/Hide TimeSlider
		cui.commandPanelOpen = status			-- Show/Hide CommandPanel
		statusPanel.visible = status 			-- Show/Hide StatusPanel
	)
	on spn1 changed val do
	(
		entropy = spn1.value * 10.^(-2)
		selectFace rdo13.state 
	)
	on spn1 entered a text do
		(
	
	)
	on spn1 buttondown do
		(
	)
	on spn1 buttonup do
		(
	)
	on AlexRollout close  do
	(
		entropy = 0
		originNum = 0.990
		key = 0
		AlexSel = #{}
		allFaces = FacesCollect = #()
	)
)
createDialog AlexRollout
