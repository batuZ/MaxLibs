


(	
	rollout CleanSplineRollout "Clean Spline"
	(
		group "Parameters"
		(
			spinner threshold_spinner "Threshold" align:#center range:[0.0,180.0,0.1] type:#float
			button delete_button "Delete" width:60
			button cancel_but "Cancel" width:60 across:2
			button ok_but "Close" width:60 across:1
		)
		
		local threshold = threshold_spinner.value
		local vertices_array = #()
		local spline_selected = 0
		local num_splines = 0
		local ok_pressed = false
		local cancel_pressed = false
		local old_selection_vertices = #()
		local arr_old_selecion_vertices = #()
		
		fn remember_vertices_selection shape =
		(
			for i=1 to (numSplines shape) do
			(
				old_selection_vertices = copy (getKnotSelection spline_selected i) #noMap
				append arr_old_selecion_vertices old_selection_vertices
			)
		)
		
		fn recall_vertices_selection shape =
		(
			for i=1 to (numSplines shape) do
				setKnotSelection shape i arr_old_selecion_vertices[i] keep:false
		)
		
		fn deleteVertices shape spline vertices_to_delete_arr = 
		(
			for k=1 to vertices_to_delete_arr.count do
			(
				deleteKnot shape spline vertices_to_delete_arr[k]
				if k < vertices_to_delete_arr.count then
					if vertices_to_delete_arr[k+1] != 1 then
						vertices_to_delete_arr[k+1] = (vertices_to_delete_arr[k+1]) - k
			)
			format "vertex array in deletion % spline %\n" vertices_to_delete_arr spline 
		)
		
		fn collect_straight_vertices = 
		(
			--undo "optimize spline" on
			if num_splines > 0 then --check if there is at least one spline in shape
			(
				for i=1 to num_splines do
				(
					vertices_array = #()
					setKnotSelection spline_selected i vertices_array keep:false
					num_vertices = numKnots spline_selected i
					if num_vertices > 2 then --check if there is more than 2 vertices
					(
						for j=1 to (num_vertices-2) do
						(
							--here we need positions of three vertices
							vertex_pos_1 = getKnotPoint spline_selected i j
							vertex_pos_2 = getKnotPoint spline_selected i (j+1)
							vertex_pos_3 = getKnotPoint spline_selected i (j+2)
							--now check the angles between vertices 2 and 3 with center in vertex 1
							v1 = vertex_pos_3 - vertex_pos_2
							v2 = vertex_pos_1 - vertex_pos_2
							--angle from super-function 'dot'
							theAngle = acos(dot (normalize v1) (normalize v2))
							theAngle = abs theAngle
							print theAngle
							--if the angle == 180.0 then we can delete vertex2
							--but due to the maxscript functionality we can't delete several vertices at once
							--so by the moment we can only select these vertices
							if ((theAngle >= (180.0 - threshold)) or (theAngle <= threshold)) then
								append vertices_array (j+1)
							--if spline is closed we need two iterations 
							if (isClosed spline_selected i) and (j==(num_vertices-2)) then
							(
								vertex_pos_1 = getKnotPoint spline_selected i (j+1)
								vertex_pos_2 = getKnotPoint spline_selected i (j+2)
								vertex_pos_3 = getKnotPoint spline_selected i 1
								v1 = vertex_pos_3 - vertex_pos_2
								v2 = vertex_pos_1 - vertex_pos_2
								theAngle = acos(dot (normalize v1) (normalize v2))
								if  ((theAngle >= (180.0 - threshold)) or (theAngle <= threshold)) then
									append vertices_array (j+2)
								--for checking first vertex in spline
								vertex_pos_1 = getKnotPoint spline_selected i (j+2)
								vertex_pos_2 = getKnotPoint spline_selected i 1
								vertex_pos_3 = getKnotPoint spline_selected i 2
								v1 = vertex_pos_3 - vertex_pos_2
								v2 = vertex_pos_1 - vertex_pos_2
								theAngle = acos(dot (normalize v1) (normalize v2))
								if ((theAngle >= (180.0 - threshold)) or (theAngle <= threshold)) then
									append vertices_array 1
							)
						)
						setKnotSelection spline_selected i vertices_array keep:true
						format "vertex array before deletion % spline %\n" vertices_array i

						updateshape spline_selected
					)			
				)
			)
		)

		on CleanSplineRollout open do
		(
			spline_selected = selection[1]
			num_splines = numSplines spline_selected
			--threshold = threshold_spinner.value
			remember_vertices_selection spline_selected
			collect_straight_vertices()
		)
		
		on delete_button pressed do
		(
			undo "Delete selected vertices" on
			(
				for i=1 to num_splines do
					deleteVertices spline_selected i (getKnotSelection spline_selected i)
				updateshape spline_selected
				for i=1 to num_splines do
					setKnotSelection spline_selected i #() keep:false
			)
			destroyDialog CleanSplineRollout 
		)

		
		on cancel_but pressed do --on cancel button return selection to initial state
		(
			recall_vertices_selection spline_selected
			cancel_pressed = true
			destroyDialog CleanSplineRollout --and close dialogbox
		)
		
		
		on ok_but pressed do
		(
			ok_pressed = true -- on ok button check the flag and close dialogbox
			destroyDialog CleanSplineRollout 
		)
		
		on StraightSplineRollout close do
		(
		)
		
		on threshold_spinner changed val do
		(
			threshold = val
			collect_straight_vertices()
		)
	)--rollout
	
	on isEnabled return
	(
		selection.count == 1 and (classof selection[1] == SplineShape or classof selection[1] == Line) and selection[1].modifiers.count == 0
	)
	
	on execute do
	(	if CleanSplineRollout != undefined do
			createDialog CleanSplineRollout modal:false escapeEnable:false		
	)-- on execute
)--macroscript