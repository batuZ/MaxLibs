/*
	Edgefinder v 1.2
	havardsc@stud.ntnu.no
	
	Info and how to use: 
	http://folk.ntnu.no/havardsc/site/wordpress/?page_id=377
	
	I've used this script as the optimize edges funciton
	http://www.scriptspot.com/3ds-max/scripts/make-parallel-edges
*/
global edgeFinderGUI
(
	try(destroyDialog edgeFinderGUI)catch()
	
	local cCNumPoints
	local doCurveControl = false
	local cCFalloffCurve
	
	struct edgeFaceStruct
	(
		faces,
		edges
	)
	
	fn filterArray arrA arrB =
	(	
		for i in arrA do
		(
			local j = findItem arrB i
			if j > 0 then
				deleteItem arrB j
		)
		arrB
	)
	
	fn edgeConnect sel obj = 
	(
		local getEdgesFromFace = polyop.getFaceEdges
		local setEdgeSel = polyop.setEdgeSelection
		local connectEdges = obj.editablePoly.connectEdges
		local edges = #()
		
		progressStart "Creating jagged edges"
		progressUpdate 0
		local progress = 0
		local step = 100.0 / (sel as array).count
		
		with undo off
			with redraw off 
				for f in sel do
				(
					faceEdges = getEdgesFromFace obj f
					fCount = faceEdges.count
					if fCount > 3 do
					(
						startEdge = random 1 fCount
						unvalidEdges = #{
							if startEdge == 1 then faceEdges[fCount] else faceEdges[startEdge - 1],
							faceEdges[startEdge],
							if startEdge == fCount then faceEdges[1] else faceEdges[startEdge + 1]}
						validEdges = (faceEdges as bitArray - unvalidEdges) as array
						setEdgeSel obj #(validEdges[random 1 validEdges.count], faceEdges[startEdge])
						connectEdges()
						progressUpdate (progress += step)
					)
				)
		progressEnd()
		
	)
	
	fn getAngle obj f1 f2 = 
	(
		local n1 = polyop.getFaceNormal obj f1
		local n2 = polyop.getFaceNormal obj f2
		acos(dot n1 n2)
	)
	
	fn getCorners obj lowerLimit upperLimit = 
	(
		local corners = edgeFaceStruct faces:#() edges:#()
		local getFacesUsingEdge = polyop.getFacesUsingEdge
		with undo off
			with redraw off
			(
				for i = 1 to obj.edges.count do
				(
					local theFaces = (getFacesUsingEdge obj i) as array
					if theFaces.count > 1 then
					(
						local theAngle = (getAngle obj theFaces[1] theFaces[2])
						if (abs theAngle > lowerLimit and abs theAngle < upperLimit) then
						(
							join corners.faces theFaces
							append corners.edges i
						)
					)
				)
			)
		corners
	)
	
	fn optimizeMesh obj edges plDist =
	(
		progressStart "Optimizing corners"
		progressUpdate 0
		polyOp.setEdgeFlags obj #{} 0 mask:(bit.set 0 32 true)
		local step =  100.0 /  (edges as array).count
		local progress = 0
		
		local getEdgeFaces = polyop.getEdgeFaces
		local getEdgeVerts = polyop.getEdgeVerts
		local pOGetVert = polyop.getVert
		local pOgetFaceNormal = polyop.getFaceNormal
		local slice = polyop.slice
		local getEdgesByFlag = polyop.getEdgesByFlag
		local setEdgeFlags = polyop.setEdgeFlags

		while (edges as array).count > 0 do
		(
			polyOp.setEdgeFlags obj edges (bit.set 0 32 true)
			for i in edges do
			(
				local curfaces = (getEdgeFaces obj i) as array
				local curverts = getEdgeVerts obj i as array
				edgeMed = ((pOGetVert obj curverts[1]) + (pOGetVert obj curverts[2])) / 2
				for j = 1 to 2 do
				(
					local raynormal = normalize(cross ((pOGetVert obj curVerts[j]) - edgeMed) (pOgetFaceNormal obj curfaces[j]))
					local raypoint = edgeMed + plDist * raynormal
					slice obj #{curfaces[j]} (ray raypoint raynormal)
				)
			)
			local edges = (getEdgesByFlag obj (bit.set 0 32 true)) - edges
			setEdgeFlags obj edges 0 mask:(bit.set 0 32 true)
			progressUpdate  (progress += step)
		)
		progressEnd()
	)
	
	fn tessellateSelectedFaces obj tessellations edgeSize lowerLimit upperLimit faceFlag edgeFlag doOptimizeMesh =
	(
		local corners = getCorners obj lowerLimit upperLimit
		polyop.setFaceFlags obj corners.faces faceFlag
		polyop.setEdgeFlags obj corners.edges edgeFlag
		if doOptimizeMesh then 
			optimizeMesh obj (polyop.getEdgesByFlag obj edgeFlag) edgeSize
				
		for i = 1 to tessellations do 
			polyop.tessellateByFace obj (polyop.getFacesByFlag obj faceFlag)
	)
	
	fn colorizeEdges obj tessellations edgeSize randomizeEdges lowerLimit upperLimit faceFlag edgeFlag doOptimizeMesh doLinearFalloff doCC = 
	(
		with undo off
			with redraw off
			(
				polyop.setVertColor obj 0 obj.verts white
				tessellateSelectedFaces obj tessellations edgeSize lowerLimit upperLimit faceFlag edgeFlag doOptimizeMesh
				local faces = polyop.getFacesUsingEdge obj (polyop.getEdgesByFlag obj edgeFlag)
				local count = if doOptimizeMesh then count = tessellations else edgeSize as integer
				local coloredFaces = #()
				polyop.setFaceSelection obj faces
				if doLinearFalloff then
				(
					if doCC then
					(
						for i = 1 to 1 + 2 * count do
						(
							local verts = filterArray coloredFaces ((polyop.getVertsUsingFace obj (polyop.getFaceSelection obj)) as array)
							polyop.setVertColor obj 0 verts (cCFalloffCurve.curves[1].points[i].value.y * white)
							join coloredFaces verts
							obj.growSelection selLevel:#Face
						)
					)
					else
					(
						local colorStep = white/(1 + 2 * count)
						for i = 1 to 1 + 2 * count do --(floor edgeSize as integer) do
						(
							local verts = filterArray coloredFaces ((polyop.getVertsUsingFace obj (polyop.getFaceSelection obj)) as array)
							polyop.setVertColor obj 0 verts  ((i - 1) * colorStep)
							join coloredFaces verts
							obj.growSelection selLevel:#Face
						)
					)
					if randomizeEdges then 
							edgeConnect (polyop.getFaceSelection obj) obj
						polyop.setVertSelection obj (polyop.getVertsUsingFace obj (polyop.getFaceSelection obj))
				)
				else
				(
					for i = 1 to count do --(floor edgeSize as integer) do
					obj.growSelection selLevel:#Face
					if randomizeEdges then 
						edgeConnect (polyop.getFaceSelection obj) obj
					polyop.setVertSelection obj (polyop.getVertsUsingFace obj (polyop.getFaceSelection obj))
					obj.shrinkSelection selLevel:#vertex
					local edgeVerts = polyop.getVertSelection obj 
					polyop.setVertColor obj 0 edgeVerts black
					polyop.setVertColor obj 0 -edgeVerts white
				)
				print "Coloring done."
			)
	)
	
	fn flattenMapping obj =
	(
		polyop.setFaceSelection obj #all
		local wrapMod = (UVWunwrap())
		local angleThreshold = 45.0
		local normalList = #([1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1])
		local spacing = 0.001
		addmodifier obj wrapMod
		wrapMod.flattenMap angleThreshold normalList spacing true 0 true true 
		convertTo obj polyMeshObject
	)
	
	fn bakeVertexMap obj dir height width = 
	(
		obj.iNodeBakeProperties.removeAllBakeElements()
		local map = diffuseMap()
		map.outputSzX = width
		map.outputSzY = height
		map.fileType = dir
		map.fileName = fileNameFromPath map.fileType
		map.filterOn = true
		map.shadowsOn = false
		map.lightingOn = false
		map.enabled = true
		
		obj.iNodeBakeProperties.addBakeElement map
		obj.iNodeBakeProperties.bakeEnabled = true
		obj.iNodeBakeProperties.bakeChannel = 1

		print "Rendering..."
		render rendertype:#bakeSelected vfb:off progressBar:true outputSize:[height,width] quiet:true
		
		if (getFiles dir).count == 0 then 
			print "Baking failed..."
		else 
			print "Done!"
		
		map
	)

	rollout curveControlRoll "Falloff control"
	(
			CurveControl cCFalloff "Curve Control:" 
			height:200 
			width:400
			align:#right
			numCurves:1
			visible:true
			x_range:[0,1]
			y_range:[0,1]
			scrollValues:[0,0]
			enabled:true
			commandMode:#move_y
			rcmFlags:#()
			asPopup:false
			uiFlags:#(#drawBG, #drawGrid, #constrainY, #singleSelect, #ruler, #xValue) --, #upperToolbar)
		
		on curveControlRoll open do
		(
			cCFalloff.curves[1].numPoints = cCNumPoints
			cCFalloff.curves[1].name = "Falloff"
			cCFalloff.curves[1].color = red
			cCFalloff.curves[1].style = #solid
			cCFalloff.curves[1].width = 1
			local step = 1.0 / (cCFalloff.curves[1].numPoints - 1)
			for i = 0 to cCFalloff.curves[1].numPoints - 1 do
			(
				cCFalloff.curves[1].points[i + 1].value = [i * step, i * step]
			)
			zoom cCFalloff #all
			cCFalloffCurve = cCFalloff
		)
	)
		

	rollout edgeFinderGUI "Edge finder"
	(
		fn geometryFilter obj = superClassOf obj == GeometryClass
		
		group "Options"
		(
			label lblAnlges "Angles:" align:#left
			spinner spnLowerLim "Min" range:[0, 359, 80] type:#integer width:60 align:#left across:2
			spinner spnUpperLim "Max" range:[1, 360, 100] type:#integer width:60 align:#right  
			spinner spnTessellations "Tessellations" range:[1, 10, 3] type:#integer width:60 align:#right
			spinner spnEdgeSize "Edge size" range:[0.0, 50.0, 1.0] type:#worldunits width:60 align:#right
			spinner spnNoiseSlot "Material slot" range:[1,100,1] type:#integer width:60 align:#right
			checkBox cbKeepHP "Keep high poly mesh" checked:true
			checkBox cbPrepareMesh "Optimize edges" checked:true
			checkBox cbManipMesh "Generate jagged edges"
			checkBox cbFalloff "Falloff" checked:false across:2
			button btnEditFalloff "Edit falloff" height:15 enabled:false
			checkBox cbBakeMap "Bake edge map" checked:false
			checkBox cbAutoUnwrap "Auto unwrap (flatten map)" 
			checkBox cbMixWNoise "Mix with noise map" align:#left enabled:false
			spinner spnHeight "H" range:[1, 4096, 2048] type:#integer width:70 align:#left across:2 enabled:false
			spinner spnWidth "W" range:[1, 4096, 2048] type:#integer width:70 align:#right enabled:false
			editText eTDir "" width:120 across:2 align:#left enabled:false
			button btnDir "Dir" width:20 align:#right height:18 enabled:false
			checkBox cbShowMap "Show edge map on object" checked:true
			
		)
		pickbutton pBtnPickObject "Pick object" width:80 align:#center filter:geometryFilter autoDisplay:true
		button btnBake "Generate" width:80 align:#center
		label lblAbout "havardsc@stud.ntnu.no"

		on cbKeepHP changed val do
		(
			if not val then
			(
				cbBakeMap.checked = true
				btnDir.enabled = true
				spnHeight.enabled = true
				spnWidth.enabled = true
				cbShowMap.enabled = true
			)
		)
		
		on cbBakeMap changed val do
		(
			if val then
			(
				btnDir.enabled = true
				spnHeight.enabled = true
				spnWidth.enabled = true
				cbShowMap.enabled = true
				cbMixWNoise.enabled = true
			)
			else
			(
				btnDir.enabled = false
				spnHeight.enabled = false
				spnWidth.enabled = false
				cbShowMap.enabled = false
				cbShowMap.checked = false
				cbMixWNoise.enabled = false
			)
		)
		
		on cbFalloff changed val do
		(
			if val then
				btnEditFalloff.enabled = true
			else
				btnEditFalloff.enabled = false
		)
		
		on btnEditFalloff pressed do
		(
			cCNumPoints = 1 + 2 * spnTessellations.value
			doCurveControl = true
			createDialog curveControlRoll 450 250
		)
	
		on btnDir pressed do
		(
			try
			(
				eTDir.text = getSaveFileName "Save edge map" types:"BMP (*.bmp)|*.bmp|Targa (*.tga)|*.tga|JPEG (*.jpg)|*.jpg|Png (*.png)|*.png"
				eTDir.enabled = true
			)
			catch
				messageBox "Invalid save path"
		)
		
		on btnBake pressed do
		(

			undo on
			(
				if cbBakeMap.checked and eTDir.text == "" then
					messageBox "Select a proper path to save the map." 
				else if pBtnPickObject.object != undefined then
				(
					local obj = pBtnPickObject.object; if not (isKindOf pBtnPickObject.object polyMeshObject) then convertTo obj polyMeshObject
					local faceFlag = bit.set 0 30 true
					local edgeFlag = bit.set 0 30 true
					local map = undefined
					
					if cbAutoUnwrap.checked then
						flattenMapping obj
					
					local orig = copy obj
					local origName = obj.name
					obj.name = (uniquename (obj.name + "_highPoly"))
					orig.name = origName
						
					colorizeEdges obj spnTessellations.value spnEdgeSize.value cbManipMesh.checked spnLowerLim.value spnUpperLim.value faceFlag edgeFlag cbPrepareMesh.checked cbFalloff.checked doCurveControl
					
					meditmaterials[spnNoiseSlot.value] = standardMaterial()
					meditMaterials[spnNoiseSlot.value].diffuseMap = Vertex_Color()
					obj.material = meditMaterials[spnNoiseSlot.value]
					obj.showVertexColors = on
					
					if cbBakeMap.checked then
						map = bakeVertexMap obj eTDir.text spnHeight.value spnWidth.value
						
					if cbShowMap.checked and map != undefined then
					(
						meditMaterials[spnNoiseSlot.value].diffuseMap = bitmaptex filename:map.fileType
						obj.material = meditMaterials[spnNoiseSlot.value]
						orig.material = meditMaterials[spnNoiseSlot.value]
					--	orig.material.showInViewport = true
						obj.material.showInViewport = true
					)
					
					if cbMixWNoise.checked then
					(
						meditMaterials[spnNoiseSlot.value] = Noise()
						meditMaterials[spnNoiseSlot.value].size = 3
						meditMaterials[spnNoiseSlot.value].type = 1
						meditMaterials[spnNoiseSlot.value].thresholdLow = 0.5
						meditMaterials[spnNoiseSlot.value].output.RGB_Level = 5
						meditMaterials[spnNoiseSlot.value].map1 = BitmapTexture fileName:eTDir.text
					)
					
					if not cbShowMap.checked then
						obj.showVertexColors = off
					
					if not cbKeepHP.checked then
						delete obj
				)
				else
					messagebox "Pick an object first!"
			)
		)
	)
	createDialog edgeFinderGUI 170 410
)