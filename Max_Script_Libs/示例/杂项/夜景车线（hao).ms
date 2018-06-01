rollout aa "夜景车线" 
(local obj_line 
 local obj_plane
 local lines=#()

pickbutton pickplane "选择片" align:#center width:80
pickbutton pickspline "选择线" align:#center width:80
button run_obj "生成灯线" align:#center width:80
group "path deform"
( spinner numlines "线数量"  range:[0,100,2] type:#integer 
 
 spinner linepercent "percent"  range:[0,10000,0] type:#float scale:0.5
 spinner linestretch "stretch" range:[0,10000,0] type:#float scale:0.01
 spinner linerotation "rotation" range:[0,10000,0] type:#float scale:0.5
 spinner linetwist "twist"  range:[0,10000,0] type:#float scale:0.5
 button move_obj "move to object"
 )
 
group  "path axis"
(
radiobuttons radion_xyz  "axis"  labels:#("x","y","z")
button delete_bu "delete" align:#center width:80
)

on pickplane picked obj do (pickplane.text=obj.name ;obj_plane=obj)
on pickspline picked obj do (pickspline.text=obj.name ;obj_line=obj)
fn gan obj=
(lines=for i=1 to numlines.value collect ( instance obj)
for i=1 to lines.count do 
(
 addmodifier lines[i] (SpacePathDeform ())
lines[i].modifiers[#Path_Deform_Binding].path=obj_line
lines[i].modifiers[#Path_Deform_Binding].Percent_along_path =linepercent.value+100*i/(lines.count)
lines[i].modifiers[#Path_Deform_Binding].stretch =linestretch.value
lines[i].modifiers[#Path_Deform_Binding].rotation =linerotation.value
lines[i].modifiers[#Path_Deform_Binding].twist =linetwist.value

)
)

on numlines changed val do 
 (--for i=1 to lines.count do (delete lines[i];lines=#())
 delete lines
 lines=#()
for i=1 to val do (append lines ( instance obj_plane))
 for i=1 to lines.count do 
(
 addmodifier lines[i] (SpacePathDeform ())
lines[i].modifiers[#Path_Deform_Binding].path=obj_line
lines[i].modifiers[#Path_Deform_Binding].Percent_along_path =linepercent.value+100*i/(lines.count)
lines[i].modifiers[#Path_Deform_Binding].stretch =linestretch.value
lines[i].modifiers[#Path_Deform_Binding].rotation =linerotation.value
lines[i].modifiers[#Path_Deform_Binding].twist =linetwist.value
for i=1 to lines.count do lines[i].transform=obj_line.transform
)
)
on radion_xyz changed val do (for i=1 to lines.count do lines[i].modifiers[#Path_Deform_Binding].axis = (val-1)) 
on linepercent changed val do (for i=1 to lines.count do lines[i].modifiers[#Path_Deform_Binding].Percent_along_path = linepercent.value+100*i/(lines.count) )
on linestretch changed val do (for i=1 to lines.count do lines[i].modifiers[#Path_Deform_Binding].stretch = val )
on linerotation changed val do (for i=1 to lines.count do lines[i].modifiers[#Path_Deform_Binding].rotation = val )

on linetwist changed val do (for i=1 to lines.count do lines[i].modifiers[#Path_Deform_Binding].twist = val )

on delete_bu pressed do  (delete lines ;lines=#())

on move_obj pressed do (for i=1 to lines.count do lines[i].transform=obj_line.transform )


on run_obj pressed do (gan obj_plane)
)


if rof !=undefined do closerolloutfloater rof
rof=newrolloutfloater "夜景车线"  150 400
addrollout aa rof 	