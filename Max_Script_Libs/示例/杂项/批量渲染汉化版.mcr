-------------------------------------------------------------------------------
--   TO USE IT COPY THE FILE TO STARTUP DIRECTORY, RUN IT AND THEN ASSIGN IT TO A TOOLBAR
--   BY GOING TO CUSTOMIZE | MACRO SCRIPTS AND PICKING "Tools.BatchRender"
--   File:			BAT_REND.MS Ver3.00 		
--   Description:	A batch render utility with UI similar to the Render Scene dialog box
--   By:			Ravi Karra [Kinetix] 			ravi.karra@ktx.com
--
--	History:
--	5/4/98		Fixed a bug that throws "time type not defined" error when adding a file
--	5/5/98		Added "Add Directory" button to add a whole directory of max files to the list
--	6/26/98		Added functionality for specifying viewport to render ("Viewport" dropdown)
--	11/06/98	Added support for renderFields and fieldOrder(odd or even).
--				Also changed the "Files to be rendered" combobox to listbox
--  12/03/98	Changing it into a Macro button instead of a utility
--  12/06/98	Added progress bar display updated after each file is rendered 
--  12/06/98	Added error trapping, files with errors are added to "Error Files" dropdown
-- 	2/14/99		Added BrFloater Global
--	03/29/99	Added Help button
-------------------------------------------------------------------------------
macroScript BatchRender 
category:"MAX Script Tools"
tooltip:"Batch Renderer"
buttonText:"Batch Renderer"
( 
	global brFloater -- Added brFloater Global - FD
	global brHelpFloater, dlgHelpBatRend, help_str
	rollout brParams "Common Parameters"
	(
		local bmp, curFile, br_error_files=#()

		-- y offsets for group controls
		local 	yTO = 25, 
				yOS = yTO + 80, 
				yOp = yOS + 105, 
				yIO = yOp + 90, 
				yC  = yIO +290 
		
		-- An array to store the render details of all the files
		local file_data_array = #()
		
		-- An array to store the file names of all files to be rendered
		local file_name_array = #()
		
		-- A structure to represent the render details of a single file
		struct rdata (
				filename,
				camera,
	       		frame,
	       		framerange,
				fromframe,
				toframe,
				nthframe,
				timetype,
				outputwidth,
				outputheight,
				pixelaspect,
				videocolorcheck,
				renderhiddenobjects,
				superblack,
				force2sided,
				renderatmosphericeffects,
				renderfields,
				fieldorder,
				outputfile,
				outputdevice,
				vfb,
				netrender)
		
		-- A function used to modify file names containing '\' to "\\"
		fn replaceChar str oChar rChar = 
		(
			local tStr = ""
			for i=1 to str.count do
				tStr += (if str[i] == oChar then rChar else str[i])
			tStr
		)
		
		-- Checks to see if the given value is not null and undefined
		fn exists val =
		(
			if val == undefined or val == "" then 
				return false
			return true
		)
		
			
		group "输出时间:"
		(
			spinner spn_nthframe 	"每N帧: " pos:[260, yTO] range:[1, 99999, 1] type:#integer fieldwidth:50 enabled:false
			spinner spn_fromframe 	"" pos:[120, yTO+30] fieldwidth:50 range:[-10000, 10000, 0] type:#integer
			spinner spn_toframe 	"到" pos:[145, yTO+30] fieldwidth:50 range:[-10000, 10000, 100] type:#integer
			
			radioButtons rb_timetype columns:1  pos:[25, yTO] \
				labels:#(
					"单帧", 
					"活动时间段",
					"范围:")				 
		)
		
		group "输出大小"
		(
			spinner spn_width "宽度:  " pos:[20, yOS] range:[1, 10000, 640] type:#integer fieldwidth:65
			spinner spn_height "高度: " pos:[20, yOS+25] range:[1, 10000, 480] type:#integer fieldwidth:65
			
			button btn_320x240 "320x240" pos:[150, yOS] height:20 width:75
			button btn_256x243 "256x243" pos:[230, yOS] height:20 width:75
			button btn_512x486 "512x486" pos:[310, yOS] height:20 width:75
			button btn_640x480 "640x480" pos:[150, yOS+25] height:20 width:75
			button btn_720x486 "720x486" pos:[230, yOS+25] height:20 width:75
			button btn_800x600 "800x600" pos:[310, yOS+25] height:20 width:75
			spinner spn_pixelaspect "像素纵横比 : " pos:[260, yOS+50] range:[0.01, 10.0, 1] fieldwidth:65
		)
		
		group "渲染设置:"
		(
			checkbox chk_videocolorcheck 	"视频颜色检查" 			pos:[20, yOp]
			checkbox chk_renderhiddenobjs 	"渲染隐藏物体" 		pos:[160, yOp]
			checkbox chk_superblack 		"超级黑" 					pos:[320, yOp]
			checkbox chk_force2sided 		"强制双面" 				pos:[20, yOp+25]
			checkbox chk_renderatmoseffects "大气" 	pos:[160, yOp+20] checked:true
			checkbox chk_renderfields 		"渲染为场" 				pos:[320, yOp+25]
			label	 lbl_fo 				"Field Order:"					pos:[260, yOp+40] enabled:false
			radioButtons rb_fieldOrder 		"" 	labels:#("Odd", "Even")		pos:[320, yOp+40] enabled:false  
		)
		
		group "输入\输出:"
		(
			editText	et_outputfile 	 	"输出文件:......."	pos:[15, yIO] fieldWidth:265
			button      btn_outputfile 	 	"文件..."				pos:[360, yIO] width:60
			editText 	et_outputdevice 	"使用设备:." 		pos:[15, yIO+20] fieldWidth:265
			--button 	btn_outputdevice  	"设备..."			pos:[360, 288]width:60
			editText	et_camera			"相机:............" 	pos:[15, yIO+40] fieldWidth:265
			
			checkbox chk_vfb 			"Virtual Frame Buffer" pos:[20, yIO+65] checked:on
			checkbox chk_netrender 		"网络渲染" pos:[150, yIO+65]
			checkbox chk_unDispBmp 		"Close VFB after Rendering" pos:[250, yIO+65] checked:on
			
			button btn_AddFile 			"载入" 					pos:[320, yIO+100] width:78
			button btn_AddDir			"载入文件夹"  			pos:[320, yIO+125] width:78
			button btn_RemoveFile 		"移除" 				pos:[320, yIO+150] width:78
			button btn_removeAll 		"移除全部" 			pos:[320, yIO+175] width:78
			button btn_ApplyToAll		"应用到全部" 			pos:[320, yIO+201] width:78
			button btn_Up 				"/\\"					pos:[270, yIO+100] width:25 height:25 
			button btn_Down 			"\\/" 					pos:[270, yIO+200] width:25 height:25 
			listbox lb_FileNames		"所使用的渲染文件:" pos:[ 20, yIO+85 ] width:250 height:9 items:file_name_array
--			button btn_help				"Help"					pos:[320, yIO+230] width:78
			dropdownlist dd_errorFiles 	"错误文件:" 			pos:[ 20, yIO+230] width:250			 
		)
		
		label	lbl_view		"视图:" pos:[10, yC+5] width:45
		dropdownlist dd_view	"" pos:[55, yC] width:65 items:#("Active", "Back", "Bottom", "Front", "Left", "Perspective", "Right", "Top")
		button btn_LoadPresets 	"载入预设" pos:[120, yC] width:78
		button btn_SavePresets 	"保存预设" pos:[195, yC] width:78
		button btn_Render 		"Render" pos:[270, yC] width:78
		button btn_Cancel 		"Cancel" pos:[345, yC] width:78
		label  lbl_sep1			"________________________________________________________________________" pos:[0, yC+22]
		label  lbl_About		"广州凡拓培训中心冉老师汉化 " pos:[95, yC+42] 
		label  lbl_sep2			"________________________________________________________________________" pos:[0, yC+55]

		--------Common Functions:-----------------------------------------------------------
		--Gets the render details of a file from the dialog box controls
		fn GetRenderData fname =
		(
			if fname == undefined or fname == "" then return undefined
			local fdata = rdata \	
							filename:				fname \
							camera:					et_camera.text \
							outputwidth:			spn_width.value \
							outputheight:			spn_height.value \
							pixelaspect:			spn_pixelaspect.value \
							videocolorcheck:		chk_videocolorcheck.checked \
							renderhiddenobjects:	chk_renderhiddenobjs.checked \
							superblack:				chk_superblack.checked \
							force2sided:			chk_force2sided.checked \
							renderatmosphericeffects:chk_renderatmoseffects.checked \
							renderfields:			chk_renderfields.checked \
							fieldOrder:				rb_fieldOrder.state \
							outputfile:				et_outputfile.text \
							vfb:					chk_vfb.checked \
							netrender:				chk_netrender.checked
							
			fdata.timeType = rb_timeType.state
			case fdata.timeType of
			(
				1: fdata.frame = #current
				2: (
						fdata.framerange = #active
						fdata.nthframe 	 = spn_nthframe.value
					)
				3: (
						fdata.fromframe = spn_fromframe.value
						fdata.toframe 	= spn_toframe.value
						fdata.nthframe 	= spn_nthframe.value
					)	
			)
			return fdata	
		)
		
		--Sets the dialog box control values to render details of a file
		fn SetRenderData fname =
		(
			if fname == undefined or fname == "" then return undefined
			for fd in file_data_array do 
			(
				if fd.filename == fname then
				(
					et_camera.text 						= fd.camera
					spn_width.value 						= fd.outputwidth
					spn_height.value  					= fd.outputheight
					spn_pixelaspect.value 				= fd.pixelaspect
					chk_videocolorcheck.checked 			= fd.videocolorcheck
					chk_renderhiddenobjs.checked 		= fd.renderhiddenobjects
					chk_superblack.checked 				= fd.superblack
					chk_force2sided.checked 				= fd.force2sided
					chk_renderatmoseffects.checked 		= fd.renderatmosphericeffects
					chk_renderfields.checked = rb_fieldorder.enabled = lbl_fo.enabled = fd.renderfields
					rb_fieldorder.state					= fd.fieldorder
					et_outputfile.text 					= fd.outputfile
					chk_vfb.checked 						= fd.vfb
					chk_netrender.checked 				= fd.netrender
					
					rb_timeType.state = fd.timeType
					case fd.timeType of
					(
						1: spn_nthframe.enabled = false
						2: (
								spn_nthframe.enabled = true
								spn_nthframe.value 	= fd.nthframe
							)
						3: (
								spn_nthframe.enabled	= true
								spn_fromframe.value 	= fd.fromframe
								spn_toframe.value 	= fd.toframe
								spn_nthframe.value 	= fd.nthframe
							)
					)
					exit
				)
			)
		)
		
		-- Saves the render details of the current file into file_data_array
		fn SaveRenderData fname = 
		(
			if fname == undefined or fname == "" then return false
			local found = false
			local rd = GetRenderData fname
			for i =1 to file_data_array.count do 
			(
				if file_data_array[i].filename == fname then
				(
					file_data_array[i] = rd
					found = true
				)
			)
			if found == false then append file_data_array rd
		)
		
	
		-- Renders a file with the given render info
		fn RenderFile data = 
		(
			local rString = "render"
			if (exists data.camera) 	then rString += " camera:$'" 	+ data.camera + "'"
			if (exists data.frame) 		then rString += " frame:#" 		+ data.frame as string
			if (exists data.frameRange) then rString += " framerange:#" + data.frameRange
			if (exists data.fromframe) 	then rString += " fromframe:" 	+ data.fromframe as string
			if (exists data.toframe) 	then rString += " toframe:" 	+ data.toframe as string
			if (exists data.nthframe) 	then rString += " nthframe:" 	+ data.nthframe as string
			if (exists data.outputfile) then 
			(			
				rString += " outputfile:" 	+ "\""+ (replaceChar (data.outputfile as string) "\\" "\\\\") + "\""
			)
			rString += " outputwidth:" 				+ data.outputwidth as string
			rString += " outputheight:" 			+ data.outputheight as string
			rString += " pixelaspect:" 				+ data.pixelaspect as string
			rString += " videocolorcheck:" 			+ data.videocolorcheck as string
			rString += " renderhiddenobjects:" 		+ data.renderhiddenobjects as string
			rString += " superblack:" 				+ data.superblack as string
			rString += " force2sided:" 				+ data.force2sided as string
			rString += " renderatmosphericeffects:" + data.renderatmosphericeffects as string
			rString += " renderfields:" 			+ data.renderfields as string
			rString += " fieldOrder:" 				+ (if data.fieldOrder==1 then #odd else #even)as string
			rString += " vfb:" 						+ data.vfb as string	
			rString += " netrender:" 				+ data.netrender as string
			
			bmp = Execute (rString)	
		)
		
		-- Function is mainly used for reading render data from an ascii file
		-- Given a key, it's value is returned
		-- Eg: getKeyArg "videocolorcheck:false" videocolorcheck
		--		returns false 
		fn getKeyArg str key =
		(
			execStr = ""
			local i = findString str key
			if i == undefined then return undefined
			i += (key.count+1)
			while (i < str.count and str[i] != ",") do 
			(
				execStr += str[i]
				i += 1
			)
			if execStr[1] == "\"" then
			(
				execStr = (subString execStr 2 (execStr.count-2))
				return execStr  
			)
			return execute(execStr)
		)
		
		fn addFile f = 
		(
			if ((findItem file_name_array f) != 0) then
				MessageBox "Item Already exists"
			else
			(
				curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
				SaveRenderData f
				append file_name_array f
				lb_FileNames.items = file_name_array
			)
		)
		
		--------Time Output:-----------------------------------------------------------
		on brParams close do rp_opened = false

		on rb_timetype changed val do
		(
			spn_nthframe.enabled = (val > 1)			
		)
		
		on spn_fromframe changed val do
		(
			rb_timetype.state = 3
			spn_nthframe.enabled = true
		)
		
		on spn_toframe changed val do
		(
			rb_timetype.state = 3
			spn_nthframe.enabled = true
		)
		--------Output Size:-----------------------------------------------------------
		on btn_320x240 pressed do (spn_width.value = 320; spn_height.value = 240)
		on btn_256x243 pressed do (spn_width.value = 256; spn_height.value = 243)
		on btn_512x486 pressed do (spn_width.value = 512; spn_height.value = 486)
		on btn_640x480 pressed do (spn_width.value = 640; spn_height.value = 480)
		on btn_720x486 pressed do (spn_width.value = 720; spn_height.value = 486)
		on btn_800x600 pressed do (spn_width.value = 800; spn_height.value = 600)

		--------Options:-----------------------------------------------------------
		on chk_renderfields changed val do rb_fieldOrder.enabled = lbl_fo.enabled = val			
		
		--------Input/Output:-----------------------------------------------------------
		on btn_outputfile pressed do
		(			
			local f = (if (SelectSaveBitMap != undefined) then SelectSaveBitMap else getSaveFileName) caption:"Render Output File"
			--selectBitmap caption:"Render Output File"
			if f != undefined then et_outputfile.text = f
		)
		
		on btn_outputdevice pressed do
		(
			local f = getSaveFileName caption:"Render Output Device"
			if f != undefined then
			(
				et_outputdevice.text = f
			) 
		)
		
		on btn_AddFile pressed do
		(
			local f = getOpenFileName caption:"Open File to Render" types:"3D Studio MAX (*.max)|*.max|"
			SaveRenderData curFile
			if f != undefined then addFile f
			curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
			SetRenderData curFile
		)
		
		on btn_AddDir pressed do
		(
			local dir = getSavePath caption: "Select the directory"
			if dir == undefined do return false
			SaveRenderData curFile
			for f in getFiles (dir + "\\*.max") do
			(
				addFile f 
			) 
			curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
			SetRenderData curFile
		)
		
		on btn_RemoveFile pressed do
		(
			local s = lb_FileNames.selection
			if s != 0 and s <= file_name_array.count then
			(
				for f = 1 to file_data_array.count do
				(						
					if file_data_array[f].filename == file_name_array[s] then							
					(	
						if f > 1 then lb_FileNames.selection = f-1
						deleteItem file_data_array f
						exit
					) 
				)
				deleteItem file_name_array s
				lb_FileNames.items = file_name_array
			)	
			curFile = if lb_FileNames.selection != 0 then file_name_array[lb_FileNames.selection] else undefined
			SetRenderData curFile
		)
		
		on btn_RemoveAll pressed do
		(
			file_name_array = #()
			file_data_array = #()
			curFile = undefined
			lb_FileNames.items = file_name_array
		)
		
		on btn_ApplyToAll pressed do
		(
			SaveRenderData curFile
			local data = GetRenderData curFile
			for i=1 to file_data_array.count do
			(
				file_data_array[i].frame 					= data.frame
	       		file_data_array[i].framerange 				= data.framerange
				file_data_array[i].fromframe				= data.fromframe
				file_data_array[i].toframe					= data.toframe
				file_data_array[i].nthframe					= data.nthframe
				file_data_array[i].timetype					= data.timetype
				file_data_array[i].outputwidth				= data.outputwidth
				file_data_array[i].outputheight				= data.outputheight
				file_data_array[i].pixelaspect				= data.pixelaspect
				file_data_array[i].videocolorcheck			= data.videocolorcheck
				file_data_array[i].renderhiddenobjects		= data.renderhiddenobjects
				file_data_array[i].superblack				= data.superblack
				file_data_array[i].force2sided				= data.force2sided
				file_data_array[i].renderatmosphericeffects	= data.renderatmosphericeffects
				file_data_array[i].renderfields				= data.renderfields
				file_data_array[i].fieldOrder				= data.fieldOrder
			)
		)
		
		on btn_up pressed do
		(
			if lb_FileNames.selection > 1 then
			(
				SaveRenderData curFile
				lb_FileNames.selection -= 1
				curFile = file_name_array[lb_FileNames.selection]	
				SetRenderData curFile
			)	
		)
		
		on btn_down pressed do
		(
			if file_name_array.count==0 then return false
			if lb_FileNames.selection < file_name_array.count then
			(
				SaveRenderData curFile
				lb_FileNames.selection += 1
				curFile = file_name_array[lb_FileNames.selection]	
				SetRenderData curFile
			)		
		)
		
		on lb_FileNames selected val do
		(
			SaveRenderData curFile
			curFile = file_name_array[val]
			SetRenderData curFile
		) 
		
		on lb_FileNames entered val do
		(
			if val != undefined and val != "" then addFile val
		)
		---------------------------------------------------------------------------------
		on btn_LoadPresets pressed do
		(
			SaveRenderData curFile
			local n = getOpenFileName caption:"Open Render Data" types:"Batch Render Presets (*.brp)|*.brp|"
			if n != undefined then
			(
				file_name_array = #()
				file_data_array = #()
				local f = openFile n
				while (not (eof f)) do
				(
					local data = rdata ()
					local ln = readLine f
					data.filename 					= getKeyArg ln "filename"
					data.camera 					= getKeyArg ln "camera"
		       		data.frame 						= getKeyArg ln "frame"
		       		data.framerange					= getKeyArg ln "framerange"
					data.fromframe 					= getKeyArg ln "fromframe"
					data.toframe 					= getKeyArg ln "toframe"
					data.nthframe 					= getKeyArg ln "nthframe"
					data.timetype 					= getKeyArg ln "timetype"
					data.outputwidth 				= getKeyArg ln "outputwidth"
					data.outputheight 				= getKeyArg ln "outputheight"
					data.pixelaspect 				= getKeyArg ln "pixelaspect"
					data.videocolorcheck 			= getKeyArg ln "videocolorcheck"
					data.renderhiddenobjects 		= getKeyArg ln "renderhiddenobjects"
					data.superblack 				= getKeyArg ln "superblack"
					data.force2sided 				= getKeyArg ln "force2sided"
					data.renderatmosphericeffects	= getKeyArg ln "renderatmosphericeffects"
					data.renderfields 				= getKeyArg ln "renderfields"
					data.fieldorder 				= getKeyArg ln "fieldorder"
					data.outputfile 				= getKeyArg ln "outputfile"
					data.outputdevice 				= getKeyArg ln "outputdevice"
					data.vfb 						= getKeyArg ln "vfb"
					data.netrender 					= getKeyArg ln "netrender"
					
					if (data != undefined and data.filename != undefined) then
					(
						append file_data_array data
						append file_name_array data.filename
					)
				)
				close f
				lb_filenames.items = file_name_array
				if file_name_array.count > 0 then
				(
					curFile = file_name_array[1]
					SetRenderData curFile
				)
			)
		)

		on btn_SavePresets pressed do
		(
			SaveRenderData curFile
			local n = getSaveFileName caption:"Save Render Data" types:"Batch Render Presets (*.brp)|*.brp|"
			if n != undefined then
			(
				local f = CreateFile n
				for d in file_data_array do print d to:f
				close f					
			) 
		)

		on btn_Render pressed do
		(
			SaveRenderData curFile
			progressStart "Batch Rendering" 
			for i=1 to file_data_array.count do 
			(					
				if (getProgressCancel()) then exit
				try
				(
					if (loadMaxFile file_data_array[i].filename) then 
					(	
						max views redraw 
						case dd_view.items[dd_view.selection] of
						(
							"Back": max vpt back
							"Bottom": max vpt bottom
							"Front": max vpt front
							"Left": max vpt left
							"Perspective": vpt persp user
							"Right": max vpt Right
							"Top": max vpt Top														
						)
						RenderFile file_data_array[i]
						if chk_unDispBmp.checked then 
						(
							unDisplay bmp
							close bmp
						)
					)
				)
				catch
				(
					append br_error_files file_data_array[i].filename	
				)
				progressUpdate ((i*100)/file_data_array.count)
			)
			progressEnd()
			dd_errorFiles.items = br_error_files
		)
		
		on btn_Cancel pressed do
		(
			SaveRenderData curFile
			if brFloater == undefined then return false
			rp_opened = false			
			closeRolloutFloater brFloater
		)			
		
		on btn_help pressed do
		(
			--if brHelpFloater != undefined then return false
			local help_file = (getDir #scripts) + "\\macroscripts\\bat_rend_help.txt" 
			local hf = openFile help_file
			if hf == undefined then 
			(
				MessageBox (help_file + " file no found")
				return false
			)
			help_str = "rollout dlgHelpBatRend \"Batch Render Help\" \n(\n"
			local i=1
			while (not eof hf) do
			(
				help_str += ("\n label lbl" + (i as string) + " \"")
				help_str += replaceChar (readLine hf) "\"" "\\\""
				help_str += "\" align:#left \n"
				i+=1
			)
			help_str += ")\n"			 
			close hf
			execute help_str
			if dlgHelpBatRend != undefined then 
			(
				brHelpFloater = newRolloutFloater "Batch Render Help" 500 600 200 80
				addRollout dlgHelpBatRend brHelpFloater
			)
		)
	)
		
	fn open_floater = 
	(
		if rp_opened == undefined then rp_opened = false
		if rp_opened then return false
		If brFloater != undefined then CloseRolloutFloater brFloater
		brFloater = newRolloutFloater "Batch Render - Ver. 3.00  凡拓数码培训中心汉化版" 460 655 200 80			
		addRollout brParams brFloater		
		rp_opened = true
	)
	open_floater()	
)

