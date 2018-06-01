rollout 复制粘贴物体 "复制粘贴物体" width:179 height:44
(
	button btn4 "复制模型" pos:[7,6] width:75 height:27
	button btn5 "粘贴模型" pos:[97,6] width:71 height:28
	on btn4 pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
		
		if $ != undefined do 
			saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
		)
	on btn5 pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
		mergemaxfile (thecopypastedir + thecopypastefile) #select --this merges ("pastes") and selects objects from file
		)
)
createdialog 复制粘贴物体 style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
