

	(
	Shapes_to_Process = selection as array
		Detached_Splines = #()
	for i = 1 to Shapes_to_Process.count do
		(
		Original_shape=Shapes_to_Process[i]
		if Original_shape.category != #shape then Converttosplineshape Original_shape				
	
		for pns = 1 to numSplines Original_shape do																
		(			tmp_shape = splineShape name:("Detached_Spline"+ pns as string); tmp_shape.adaptive=true; tmp_shape.wirecolor=random black white 
					tmp_spline = addNewSpline tmp_shape
					nk = numknots Original_shape pns 											

			for pnk = 1 to nk do															
				(				
					knot_pos1=getknotpoint  Original_shape pns pnk
					in_vec_pos1=getInVec  	Original_shape pns pnk
					out_vec_pos1=getOutvec  Original_shape pns pnk		
					addknot tmp_shape tmp_spline #beziercorner #curve knot_pos1 in_vec_pos1 out_vec_pos1
					if pnk==nk and isClosed Original_shape pns then close tmp_shape 1
					
				)-- number knots in spline
				updateshape tmp_shape
				append Detached_Splines tmp_shape
								
		)-- number splines in shape
		delete Original_shape
		)-- selection count
 		--set1= selectionsets ["Detached_Splines" + prefix_no as string ] = Detached_Splines; prefix_no+=1
	) 
 ( enableSceneRedraw(); redrawViews() )