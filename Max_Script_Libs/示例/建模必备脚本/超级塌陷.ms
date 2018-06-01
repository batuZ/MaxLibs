-------------------------------------------------------------------------------
-- attachSelectedObjects.ms
-- By Neil Blevins (neil@soulburn3d.com)
-- v 1.08
-- Created On: 05/17/05
-- Modified On: 08/21/09
-- tested using Max 2009
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- sLib.ms
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes your current selection and attaches the objects together. Works on
-- geometry and splines.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Tutorial:
-- Make 5 spheres. Select them. Run the script. Now you have one object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.01 Defined ui as new function.
--
-- v 1.02 Added some new code to more cleanly open and close the UI.
--
-- v 1.03 If all selected objects are meshes, the result will now be a mesh
-- instead of a poly.
--
-- v 1.04 Added autodetect mode, which automatically guesses what's in your
-- selection and chooses the correct mode.
--
-- v 1.05 Replaced the Close button with a Help button. Use the X button to 
-- Close the Floater. Added ability to center pivot of resulting mesh.
--
-- v 1.06 Fixed bug that can cause a crash when not using auto-detect mode.
--
-- v 1.07 You can now successfully cancel out of a large attach operation.
--
-- v 1.08 Now uses a divide and conquer algorithm to attach objects that my 
-- friend Zeboxx suggested which can cause the script to attach lots of objects
-- much quicker.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global attachSelectedObjects
global attachSelectedObjectsDefaults
global attachSelectedObjectsUI

global aSOCloseOpenUI

global aSOGeometry
global aSOSpline
global aSOSelectionAllGeometryOrRendSplines

global aSODo
global aSOApply
global aSOHelp
global aSOLoadDef
global aSOSaveDef

global aSODefineUI
global aSORollout
global aSOFloater

-- Includes

include "$scripts\SoulburnScripts\lib\sLib.ms"

-- Variables

aSOModeValue = 3
aSOShowWarningValue = false
aSOCenterPivotValue = true
aSOPosValue = [400,400]

-- Functions

fn attachSelectedObjects aSOMode aSOShowWarning aSOCenterPivot = 
	(
	undo "attachSelectedObjects" on
		(
		objs = for i in selection collect i
		if objs.count < 2 then MessageBox "Please select 2 objects or more." title:"attachSelectedObjects"
		else
			(
			if aSOShowWarning == true then
				(
				if (queryBox "Attach Selected Objects?" title:"attachSelectedObjects") == true then 
					(
					if aSOMode == 1 then aSOGeometry objs aSOCenterPivot
					else if aSOMode == 2 then aSOSpline objs aSOCenterPivot
					else if aSOMode == 3 then 
						(
						if (aSOSelectionAllGeometryOrRendSplines objs) == true then aSOGeometry objs aSOCenterPivot
						else if (sLibSelectionAllShapes objs) == true then aSOSpline objs aSOCenterPivot
						else (MessageBox "Your selection contains a mix of object types. Either select all geometry, or select all splines and then run this script again." title:"attachSelectedObjects")
						)
					)
				)
			else 
				(
				if aSOMode == 1 then aSOGeometry objs aSOCenterPivot
				else if aSOMode == 2 then aSOSpline objs aSOCenterPivot
				else if aSOMode == 3 then 
					(
					if (aSOSelectionAllGeometryOrRendSplines objs) == true then aSOGeometry objs aSOCenterPivot
					else if (sLibSelectionAllShapes objs) == true then aSOSpline objs aSOCenterPivot
					else (MessageBox "Your selection contains a mix of object types. Either select all geometry, or select all splines and then run this script again." title:"attachSelectedObjects")
					)
				)
			)
		)
	)
	
fn attachSelectedObjectsDefaults = 
	(
	aSOLoadDef()
	attachSelectedObjects aSOModeValue aSOShowWarningValue aSOCenterPivotValue
	)

fn attachSelectedObjectsUI = 
	(
	aSOLoadDef()
	aSOCloseOpenUI aSOPosValue
	)

fn aSOCloseOpenUI pos = 
	(
	if aSOFloater != undefined then CloseRolloutFloater aSOFloater
	aSODefineUI()
	aSOFloater = newRolloutFloater "attachSelectedObjects v1.08" 187 161 pos.x pos.y
	addRollout aSORollout aSOFloater
	)

fn aSOGeometry objs centerPivot = 
	(
	if (aSOSelectionAllGeometryOrRendSplines objs) == false then 
		(
		MessageBox "Not all of the selected objects are geometry. Please choose a different selection or run this script in a different mode." title:"attachSelectedObjects"
		)
	else
		(
		disableSceneRedraw()
		try
			(
			-- Are objects all Meshes?
			MakeMesh = true
			for i in objs do if classof i != Editable_mesh then MakeMesh = false
			
			-- Convert Objects
			for o in objs do (if (classOf o != Editable_Poly) do (convertToPoly o))
			InstanceMgr.MakeObjectsUnique objs #individual
	
			-- Prep Progressbar
			progressStart "attachSelectedObjects"
			escapeEnable = false
			numOfItems = objs.count
			currentIteration = 0
	
			-- Start process
			while (objs.count > 1) do 
				(
				for i = objs.count to 2 by -2 do 
					(
					if getProgressCancel() == true then exit
					currentIteration += 1
					m = ((currentIteration as float)/(numOfItems as float))*100
					attachTo = objs[i]
					attachTo.EditablePoly.attach objs[i-1] attachTo
					deleteItem objs (i-1)
					progressUpdate m
					)
				)
			progressEnd()
			
			-- Convert
			if MakeMesh == true then convertTo objs[1] TriMeshGeometry
			else convertTo objs[1] PolyMeshObject
			if centerPivot == true then objs[1].pivot = [(objs[1].max.x+objs[1].min.x)/2, (objs[1].max.y+objs[1].min.y)/2, (objs[1].max.z+objs[1].min.z)/2]
			)
		catch (MessageBox "An error has occured when trying to attach one of the objects. You may want to undo." title:"attachSelectedObjects")
		enableSceneRedraw()
		completeRedraw()
		)
	)

fn aSOSpline objs centerPivot = 
	(
	if (sLibSelectionAllShapes objs) == false then 
		(
		MessageBox "Not all of the selected objects are splines. Please choose a different selection or run this script in a different mode." title:"attachSelectedObjects"
		)
	else
		(
		firstObj = objs[1]
		disableSceneRedraw()
		try
			(
			-- Convert First Object
			convertTo firstObj SplineShape
	
			-- Prep Progressbar
			progressStart "attachSelectedObjects"
			escapeEnable = false
			numOfItems = objs.count
			currentIteration = 0
	
			-- Start process
			for i = 2 to numOfItems do
				(
				if getProgressCancel() == true then exit
				convertTo objs[i] SplineShape
				currentIteration += 1
				m = ((currentIteration as float)/(numOfItems as float))*100
				addandweld firstObj objs[i] -1
				progressUpdate m
				)
			progressEnd()
			
			-- Convert
			if centerPivot == true then firstObj.pivot = [(firstObj.max.x+firstObj.min.x)/2, (firstObj.max.y+firstObj.min.y)/2, (firstObj.max.z+firstObj.min.z)/2]
			)
		catch (MessageBox "An error has occured when trying to attach one of the objects. You may want to undo." title:"attachSelectedObjects")
		enableSceneRedraw()
		completeRedraw()
		)
	)
	
fn aSOSelectionAllGeometryOrRendSplines a = 
	(
	result = true
	if a.count == 0 then return false
	else
		(
		result = true
		for i in a do
			(
			if (sLibGeometryFilter i) == false then 
				(
				if (sLibShapeFilter i) == true and i.displayRenderMesh == true then result = true
				else 
					(
					result = false
					exit
					)
				)
			)
		return result
		)
	)

fn aSODo = 
	(
	attachSelectedObjects aSOModeValue aSOShowWarningValue aSOCenterPivotValue
	if aSOFloater != undefined then CloseRolloutFloater aSOFloater
	)

fn aSOApply = 
	(
	attachSelectedObjects aSOModeValue aSOShowWarningValue aSOCenterPivotValue
	)
	
fn aSOHelp = 
	(
	sLibSSPrintHelp "attachSelectedObjects"
	)
	
fn aSOLoadDef = 
	(
	presetDir = ((getdir #plugcfg) + "\\SoulburnScripts\\presets\\")
	aSOInputFilename = presetDir + "attachSelectedObjects.ini"
	if (sLibFileExist aSOInputFilename == true) then
		(
		aSOModeValue = execute (getINISetting aSOInputFilename "attachSelectedObjects" "aSOModeValue")
		aSOShowWarningValue = execute (getINISetting aSOInputFilename "attachSelectedObjects" "aSOShowWarningValue")
		aSOCenterPivotValue = execute (getINISetting aSOInputFilename "attachSelectedObjects" "aSOCenterPivotValue")
		aSOPosValue = execute (getINISetting aSOInputFilename "attachSelectedObjects" "aSOPosValue")
		
		if aSOModeValue == OK then aSOModeValue = 3
		if aSOShowWarningValue == OK then aSOShowWarningValue = false
		if aSOCenterPivotValue == OK then aSOCenterPivotValue = false
		if aSOPosValue == OK then aSOPosValue = [400,400]
		)
	else
		(
		aSOModeValue = 3
		aSOShowWarningValue = false
		aSOCenterPivotValue = true
		aSOPosValue = [400,400]
		)
	)
	
fn aSOSaveDef = 
	(
	presetDir = ((getdir #plugcfg) + "\\SoulburnScripts\\presets\\")
	if (getDirectories presetDir).count == 0 then makeDir presetDir
	aSOOutputFilename = presetDir + "attachSelectedObjects.ini"
	if (sLibFileExist aSOOutputFilename == true) then deleteFile aSOOutputFilename
	setINISetting aSOOutputFilename "attachSelectedObjects" "aSOModeValue" (aSOModeValue as string)
	setINISetting aSOOutputFilename "attachSelectedObjects" "aSOShowWarningValue" (aSOShowWarningValue as string)
	setINISetting aSOOutputFilename "attachSelectedObjects" "aSOCenterPivotValue" (aSOCenterPivotValue as string)
	setINISetting aSOOutputFilename "attachSelectedObjects" "aSOPosValue" (aSOFloater.pos as string)
	)

-- UI

fn aSODefineUI = 
	(
	rollout aSORollout "attachSelectedObjects"
		(
		label label1 "Mode:" pos:[10,10]
		dropdownlist aSOModeDropdown "" items:#("Geometry", "Spline", "Auto Detect") selection:aSOModeValue pos:[47,7] width:112
		on aSOModeDropdown selected i do aSOModeValue = i	

		checkbox aSOShowWarningCheckbox "Show Warning?" checked:aSOShowWarningValue align:#left
		checkbox aSOCenterPivotCheckbox "Center Pivot?" checked:aSOCenterPivotValue align:#left

		on aSOShowWarningCheckbox changed state do aSOShowWarningValue = state
		on aSOCenterPivotCheckbox changed state do aSOCenterPivotValue = state

		button aSODoButton "Do" width:70 toolTip:"Do It and Close UI" pos:[15,78]
		on aSODoButton pressed do aSODo()
		button aSOApplyButton "Apply" width:70 toolTip:"Do It and Keep UI Open" pos:[87,78]
		on aSOApplyButton pressed do aSOApply()
		button aSOHelpButton "Help" width:70 toolTip:"Help" pos:[15,102]
		on aSOHelpButton pressed do aSOHelp()
		button aSOSaveDefButton "SaveDef" width:70 toolTip:"Save Current Settings as Default" pos:[87,102]
		on aSOSaveDefButton pressed do aSOSaveDef()
		)
	)
)
-------------------------------------------------------------------------------