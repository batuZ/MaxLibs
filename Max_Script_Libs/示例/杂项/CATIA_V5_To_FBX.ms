resetmaxfile #noPrompt
rootFolde = getsavepath caption:"DataSourcePath"
saveRoot = getsavepath caption:"TagetPath"
foldes = append #() (rootFolde+"\\")
for itm in foldes do
(
	newfoldes =	getDirectories (itm + "*.*")
	join foldes newfoldes
	)
files = #()
for i=1 to foldes.count do
(
	subPathFBX = getfiles (foldes[i] + "*.cgr")
	join files subPathFBX
	subPathTXT = getfiles (foldes[i] + "*.CATPart")
	join files subPathTXT
	)
sort files
for i = 1 to files.count do
(
	thisFile = files[i]
	importFile thisFile #noPrompt
	
-- 	max select all --resetName+ID
-- 	s=1
-- 	for itm in selection do
-- 	(
-- 		itm.name = "reset"+ s as string
-- 		s = s+1
-- 		)
	
	newPath = saveRoot + (substring thisFile (rootFolde.count+1) -1)
	makeDir (getFilenamePath newPath)
	savePath = getFilenamePath newPath + getFilenameFile newPath + ".fbx"
	max select all
	exportFile savePath #noPrompt selectedonly:true
    resetmaxfile #noPrompt
	)
	messagebox("OK!")