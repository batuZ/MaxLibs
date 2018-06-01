if SweepForm!=undefined do SweepForm.Close()
(

fn updateSweep shapefile =
		  (
			selShapes = for obj in selection collect obj
			if selShapes.count>0 then(
				mergeMAXFile shapefile #useSceneMtlDups #mergeDups #select #noRedraw quiet:true
				format ("Filename: " + (getFileNameFile shapefile) + "\n")
				newobj = for obj in selection where superclassof obj == shape collect obj
				newobj = newobj[1]
				sw = sweep CustomShape:1 PivotAlignment:6 SmoothPath:off MirrorXZPlane:off GenerateMappingCoords:on
				sw.shapes[1] = newobj
				for x in selShapes do(
					objSweepMod = x.modifiers[#Sweep]
					if objSweepMod !=undefined  then (
						if objSweepMod.shapes[1]!=undefined do (
							SweepShape = for i in refs.dependentNodes objSweepMod.shapes[1] where superclassof i == shape collect i
							if isValidNode SweepShape[1] do delete SweepShape[1]
						)
						objSweepMod.CustomShape = 1
						objSweepMod.shapes[1] = newobj
					)else if superclassof x == shape do addmodifier x (sw)
				)
				newobj.steps=2
				newobj.wirecolor = color 255 255 255
				newobj.render_renderable = false
				newobj.optimize = true
				newobj.adaptive = false
				newobj.pos=selShapes[1].pos
-- 				if not keyboard.shiftPressed then delete newobj
				select selShapes
				gc light:true
			   )
		  )

local IniFile = "$UserScripts\TrackScripts\SweepProfile.ini"

fn createIniFile =
	(
		newFile = createFile IniFile
		format "[Preferences]\n" to:newFile
		format "Location=%\n" [40,40] to:newFile
		format "Size=%\n" [250,560] to:newFile
		flush newFile
		close newFile
	)

fn SweepFormClose form e =
	(
		setIniSetting IniFile "Preferences" "Location" ([form.Location.x,form.Location.y] as string)
		setIniSetting IniFile "Preferences" "Size" ([form.width,form.height] as string)
		(dotnetclass "system.gc").collect()
		gc light:true
	)

local maxfiles = getFiles "$UserScripts\TrackScripts\Section\*.max"
-- join maxfiles (getFiles "$UserScripts\TrackScripts\Section\Profile\*.max")
local AddRange=#()

if not doesFileExist IniFile do createIniFile()

local Location = execute (getIniSetting IniFile "Preferences" "Location")
local Size = execute (getIniSetting IniFile "Preferences" "Size")

	SweepForm = dotNetObject "MaxCustomControls.MaxForm"
	SweepForm.Size = dotNetObject "System.Drawing.Size" Size.x Size.y
	SweepForm.Text = "Sweep Profile v0.6"

	dotnet.addeventhandler SweepForm "FormClosed" SweepFormClose
FLP=dotNetobject  "System.Windows.Forms.FlowLayoutPanel"
FLP.AutoScroll=true
FLP.Dock=FLP.Dock.Fill
FLP.ForeColor=FLP.BackColor.White

	infoLabel = dotNetObject "System.Windows.Forms.Label"
	infoLabel.TextAlign=infoLabel.TextAlign.MiddleCenter
	infoLabel.Dock = infoLabel.Dock.Bottom
	infoLabel.BorderStyle=infoLabel.BorderStyle.Fixed3D

fn onClick sender arg =
(
	if sender.Tag != undefined and doesFileExist sender.Tag do(
		infoLabel.text = (getFilenameFile sender.Tag)
		updateSweep sender.Tag
	)
)


for k=1 to maxfiles.count do
	(
	local img = undefined
	btLabel = dotNetObject "System.Windows.Forms.Label"
	btLabel.text = (getFilenameFile maxfiles[k])
	btLabel.TextAlign=btLabel.TextAlign.BottomCenter
	btLabel.BackColor=btLabel.BackColor.White
	btLabel.ForeColor=btLabel.BackColor.Black
	btLabel.Dock = btLabel.Dock.Bottom
	btLabel.Size=dotnetobject "System.Drawing.Size" 50 15
	bt = dotNetobject "System.Windows.Forms.Button"
	bt.FlatStyle=bt.FlatStyle.Flat
	bt.Size=dotnetobject "System.Drawing.Size" 50 50
	case of
		(
			(doesFileExist (img = getFilenamePath maxfiles[k] + getFilenameFile maxfiles[k] + ".bmp")):
			(
				dnImage =  (DotNetObject "System.Drawing.Bitmap" img)
				bt.BackgroundImage  = DotNetObject "System.Drawing.Bitmap" dnImage bt.Size
				dnImage.Dispose()
			)
			((doesFileExist (img = getFilenamePath maxfiles[k] + getFilenameFile maxfiles[k] + ".jpg"))):
			(
				dnImage =  (DotNetObject "System.Drawing.Bitmap" img)
				bt.BackgroundImage  = DotNetObject "System.Drawing.Bitmap" dnImage bt.Size
				dnImage.Dispose()
			)
			(doesFileExist (img = maxfiles[k] + ".bmp")):
			(
				dnImage =  (DotNetObject "System.Drawing.Bitmap" img)
				bt.BackgroundImage  = DotNetObject "System.Drawing.Bitmap" dnImage bt.Size
				dnImage.Dispose()
			)
			(doesFileExist (img = maxfiles[k] + ".jpg")):
			(
				dnImage =  (DotNetObject "System.Drawing.Bitmap" img)
				bt.BackgroundImage  = DotNetObject "System.Drawing.Bitmap" dnImage bt.Size
				dnImage.Dispose()
			)
		)
	bt.Dock = bt.Dock.Top
	bt.ImageAlign=bt.ImageAlign.TopCenter
	bt.Size=dotnetobject "System.Drawing.Size" 50 65

	bt.tag = maxfiles[k]
	bt.Controls.Add btLabel
	dotnet.addeventhandler bt "Click" onClick
	append AddRange bt
	)
	FLP.Controls.AddRange AddRange

LinkLabel=dotNetObject "System.Windows.Forms.LinkLabel"
LinkLabel.Text="3d-kstudio.com"
LinkLabel.LinkColor=(dotnetclass "System.Drawing.Color").fromname "ControlText"
LinkLabel.AutoSize=true
LinkLabel.Dock=LinkLabel.Dock.Right
LinkLabel.Padding=dotnetobject "Padding" 0 2 20 0
LinkLabel.LinkBehavior=LinkLabel.LinkBehavior.HoverUnderline

fn LinkClicked = ShellLaunch "http://3d-kstudio.com/scripts/trackscripts" ""
dotNet.addEventHandler LinkLabel "Click" LinkClicked
infoLabel.Controls.Add LinkLabel

SweepForm.Controls.Add FLP
SweepForm.Controls.Add infoLabel
SweepForm.StartPosition=SweepForm.StartPosition.Manual
SweepForm.Location = dotNetObject "System.Drawing.Point" Location.x Location.y
SweepForm.ShowModeless()
-- clearListener()
)
