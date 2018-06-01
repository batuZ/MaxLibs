--- Clean Tools -----

function getMaxFiles = 
(
	rootFolde = getsavepath caption:"select a folder";
	foldes = append #() (rootFolde+"\\");
	for itm in foldes do
	(
		newfoldes =	getDirectories (itm + "*.*");
		join foldes newfoldes;
		)
	files = #();
	for i=1 to foldes.count do
	(
		subPath = getfiles (foldes[i] + "*.max");
		join files subPath;
		)
	sort files;
	)

rollout cleanTools "清理工具" width:162 height:222
(
	checkbox 'chk1' "删灯" pos:[21,20] width:81 height:20 align:#left
	checkbox 'chk2' "删相机" pos:[21,52] width:78 height:20 align:#left
	checkbox 'chk3' "解冻" pos:[21,84] width:87 height:20 align:#left
	checkbox 'chk4' "解组" pos:[21,116] width:77 height:20 align:#left
	checkbox 'chk5' "un Hide All" pos:[21,148] width:72 height:20 align:#left
	button btn1 "开始" pos:[21,180] width:113 height:26 align:#left
	
	on btn1 pressed do 
	(
		files = getMaxFiles();
		for itm in files do
		(
			if  loadMaxFile itm do
			(
				if 'chk5'.checked do
				(
					max unhide all
					)
				if 'chk3'.checked do
				( 
					max unfreeze all 
					)
				if 'chk4'.checked do
				(
					max unfreeze all
					max unhide all
					max select all 
					max group explode
					)
				if 'chk1'.checked do
				(
					delete lights 
					)
				if 'chk2'.checked do
				( 
					delete cameras
					)
				
				 saveMaxFile (itm+@"_clean.max")
				)
			)
			messagebox("OK!")
		)
)createdialog cleanTools