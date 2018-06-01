--**********常用工具总集合**********

if main != undefined then CloseRolloutFloater main
try
(
		if "3008-4-1" > localtime then
		(
--创建面板
Main = newRolloutFloater "★新工具合集V2006.01.03★" 400 600
(
	rollout graph "随机" --随机分组
	(
		checkbox random_x_state "" across:2
		spinner random_x "模型X轴移动：" range:[-99999,99999,0] type:#integer align:#right enabled:false visible:true
		checkbox random_y_state "" across:2
		spinner random_y "模型Y轴移动：" range:[-99999,99999,0] type:#integer align:#right enabled:false visible:true
		checkbox random_z_state "" across:2
		spinner random_z "模型Z轴移动：" range:[-99999,99999,0] type:#integer align:#right enabled:false visible:true
		on random_x_state changed state do
		(
			random_x.enabled = state
			if random_x.enabled == false then random_x.value = 0
		)
		on random_y_state changed state do
		(
			random_y.enabled = state
			if random_y.enabled == false then random_y.value = 0
		)
		on random_z_state changed state do
		(
			random_z.enabled = state
			if random_z.enabled == false then random_z.value = 0
		)
		
		group "物体"--物体分类
		(
			
			button random_obj "随机选择物体" pos:[10,87] width:145 height:20--选择随机物体
			button help_random_obj "★" pos:[155,87] width:20 height:20
			button random_move_obj "随机移动物体" pos:[210,87] width:145 height:20--随机移动物体
			button help_random_move_obj "★" pos:[355,87] width:20 height:20
			button random_subobj "随机选择子物体" pos:[10,117] width:145 height:20--随机选择子物体
			button help_random_subobj "★" pos:[155,117] width:20 height:20
		)
		group "组"--组分类
		(
			button random_move_group "随机移动组" pos:[10,167] width:145 height:20--随机移动组
			button help_random_move_group "★" pos:[155,167] width:20 height:20
		)
		on random_obj pressed do--选择随机物体
		(
			try
			(
			random_obj_v = #()
			for obj in $ do
			(
				if random 0 1 == 0 then append random_obj_v obj
			)
			undo on
			if random_obj_v.count != 0 then select random_obj_v
			)
			catch ()
		)
		on help_random_obj pressed do--选择随机物体 帮助
		(
		 messagebox "可以在选中的物体中随机选择若干个物体！" title:"随机选物体"
		)
		on random_move_obj pressed do--随机移动物体
		(
			try
			(
			for s1 in $ do
			(
				rx = random -random_x.value random_x.value ; ry = random -random_y.value random_y.value ; rz = random -random_z.value random_z.value
				move s1 [rx,ry,rz]
			)
			)
			catch ()
		)
		on help_random_move_obj pressed do
		(
		messagebox "可以把选中的物体随机移动！" title:"随机移动物体"
		)
		on random_move_group pressed do
		(
			try
			(
			for s1 in $group* do
			(
				rx = random -random_x.value random_x.value ; ry = random -random_y.value random_y.value ; rz = random -random_z.value random_z.value
				move s1 [rx,ry,rz]				
			)
			)
			catch ()
		)
		on help_random_move_group pressed do
		(
		messagebox "可以把选中的组随机移动！\n本程序还有问题，目前只对Group开头的起作用。" title:"随机移动组"
		)
		on random_subobj pressed do
		(
		try
		(
		a = #()
		for i in polyop.getfaceselection $ do if random 0 1 == 0 then append a i
		polyop.setfaceselection $ a
		)
		catch ()
		)
		on help_random_subobj pressed do
		(
		messagebox "可以在Poly的面层级中，从选择的面中随机选取面！" title:"随机选择子物体"
		)
	)
	addrollout graph main
	rollout graph "创建"--创建分组
	(
		group "灯光"--灯光分类
		(
			checkbox create_light01_mul_state "" across:2
			spinner create_light01_mul "四十五度TDlight强度：" range:[-99999,99999,0.4] align:#right enabled:false visible:true
			checkbox create_light02_mul_state "" across:2
			spinner create_light02_mul "Omnilight强度：" range:[-99999,99999,0.1] align:#right enabled:false visible:true
			checkbox create_light03_mul_state "" across:2
			spinner create_light03_mul "平行光FTDlight强度：" range:[-99999,99999,0.3] align:#right enabled:false visible:true
			checkbox create_light04_mul_state "" across:2
			spinner create_light04_mul "底光DTDlight强度：" range:[-99999,99999,0.8] align:#right enabled:false visible:true
			button create_global_light "全局光" pos:[10,112] width:145 height:20--全局光
			button help_create_global_light "★" pos:[155,112] width:20 height:20
		)
		on create_light01_mul_state changed state do
		(
			create_light01_mul.enabled = state
			if create_light01_mul.enabled == false then create_light01_mul.value = 0.4
		)
		on create_light02_mul_state changed state do
		(
			create_light02_mul.enabled = state
			if create_light02_mul.enabled == false then create_light02_mul.value = 0.1
		)
		on create_light03_mul_state changed state do
		(
			create_light03_mul.enabled = state
			if create_light03_mul.enabled == false then create_light03_mul.value = 0.3
		)
		on create_light04_mul_state changed state do
		(
			create_light04_mul.enabled = state
			if create_light04_mul.enabled == false then create_light04_mul.value = 0.8
		)
		on create_global_light pressed do--全局光
		(
			try
(
--物体坐标和
ccc = $.max.y - $.min.y
bbb = $.max.x - $.min.x
aaa = $.max.z - $.min.z

ccc1 = ( $.max.y + $.min.y ) / 2
bbb1 = ( $.max.x + $.min.x ) / 2
aaa1 = ( $.max.z + $.min.z ) / 2 - ( $.max.z -  $.min.z ) / 2
--取最大边
if ccc > bbb then
(
	if ccc > aaa then cankao_v = ccc else cankao_v = aaa
)
else
(
	if bbb > aaa then cankao_v = bbb else cankao_v = aaa
)

box length:ccc width:bbb height:aaa pos:[bbb1,ccc1,aaa1] name:"模型对位"
select $模型对位
)
catch ()
		if $ == undefined then cankao = 20000 else cankao = cankao_v * 4
		try ( if $ == undefined then cankao_zb = [0,0,0] else cankao_zb = $.pos ) catch (  )
		try
		(
		select $模型对位
		max delete
		)
		catch ()
		SphereGizmo radius:cankao name:"ZBH渲染简模全局光大小"
--开始创建灯光omni
omnilight rgb:(color 220 220 220) multiplier:create_light02_mul.value castshadows:on mapbias:0.01 mapsize:2000 name:"渲染简模omni01"
instance $渲染简模omni01 isselected:on name:"渲染简模omni02"
instance $渲染简模omni01 isselected:on name:"渲染简模omni03"
instance $渲染简模omni01 isselected:on name:"渲染简模omni04"
instance $渲染简模omni01 isselected:on name:"渲染简模omni05"
instance $渲染简模omni01 isselected:on name:"渲染简模omni06"
instance $渲染简模omni01 isselected:on name:"渲染简模omni07"
instance $渲染简模omni01 isselected:on name:"渲染简模omni08"
--绑定omni
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni01.pos.controller[#X_Position] "Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni01.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni01.pos.controller[#Y_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni02.pos.controller[#Y_Position] "Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni02.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni02.pos.controller[#X_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni03.pos.controller[#Y_Position] "Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni03.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni03.pos.controller[#X_Position] "-Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni04.pos.controller[#Y_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni04.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni04.pos.controller[#X_Position] "-Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni05.pos.controller[#Y_Position] "-Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni05.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni05.pos.controller[#X_Position] "-Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni06.pos.controller[#X_Position] "-Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni06.pos.controller[#Y_Position] "-Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni06.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni07.pos.controller[#X_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni07.pos.controller[#Y_Position] "-Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni07.pos.controller[#Z_Position] "Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni08.pos.controller[#X_Position] "Radius*2/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni08.pos.controller[#Y_Position] "-Radius*1/3"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模omni08.pos.controller[#Z_Position] "Radius*1/3"
--创建灯光TDLight
TargetDirectionallight rgb:(color 255 255 237) multiplier:create_light01_mul.value castshadows:on transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])) name:"渲染简模TDlight01" mapbias:0.01 mapsize:2000
instance $渲染简模TDlight01 isselected:on name:"渲染简模TDlight02"
instance $渲染简模TDlight01 isselected:on name:"渲染简模TDlight03"
instance $渲染简模TDlight01 isselected:on name:"渲染简模TDlight04"
--绑定TDLight
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight01.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight01.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight01.pos.controller[#X_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight01.pos.controller[#Z_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight02.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight02.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight02.pos.controller[#Y_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight02.pos.controller[#Z_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight03.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight03.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight03.pos.controller[#X_Position] "-Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight03.pos.controller[#Z_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight04.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight04.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight04.pos.controller[#Y_Position] "-Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模TDlight04.pos.controller[#Z_Position] "Radius"
--创建灯光FTDLight
TargetDirectionallight rgb:(color 220 220 220) multiplier:create_light03_mul.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])) name:"渲染简模FTDlight01"
instance $渲染简模FTDlight01 isselected:on name:"渲染简模FTDlight02"
instance $渲染简模FTDlight01 isselected:on name:"渲染简模FTDlight03"
instance $渲染简模FTDlight01 isselected:on name:"渲染简模FTDlight04"
--绑定FTDLight
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight01.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight01.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight01.pos.controller[#X_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight02.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight02.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight02.pos.controller[#Y_Position] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight03.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight03.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight03.pos.controller[#X_Position] "-Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight04.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight04.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模FTDlight04.pos.controller[#Y_Position] "-Radius"
--创建TD
TargetDirectionallight rgb:(color 255 255 247) multiplier:create_light04_mul.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])) name:"渲染简模DTDlight01"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模DTDlight01.baseObject[#falloff] "Radius"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模DTDlight01.baseObject[#hotspot] "Radius*1/2"
paramWire.connect $ZBH渲染简模全局光大小.baseObject[#Radius] $渲染简模DTDlight01.pos.controller[#Z_Position] "-Radius*1/2"

select $Target01
$.name = "渲染简模Target01"
select $Target02
$.name = "渲染简模Target02"
select $Target03
$.name = "渲染简模Target03"

select $渲染简模*
--连接灯光
max link
$.parent = $ZBH渲染简模全局光大小
max select
$ZBH渲染简模全局光大小.pos = cankao_zb


		)
		on help_create_global_light pressed do--全局光 帮助
		(
		messagebox "在场景中没有任何灯光和相机时为场景打一组灯光。\n选中物体的情况下使用，灯光范围和位置以选中的物 \n体为主；反之，以坐标原点为主！" title:"全局光"
		)
	)
	addrollout graph main
	rollout graph "删除"--删除分组
	(
		group "物体"--物体分类
		(
			button del_unobj "删除空面物体" pos:[10,22] width:145 height:20--删除空面物体
			button help_del_unobj "★" pos:[155,22] width:20 height:20
			button del_unmat "删除空材质物体" pos:[210,22] width:145 height:20--删除空材质物体
			button help_del_unmat "★" pos:[355,22] width:20 height:20		
		)
		group "材质"--材质分类
		(
			button del_mat "删除选中的物体材质" pos:[10,72] width:145 height:20--删除选中的物体材质
			button help_del_mat "★" pos:[155,72] width:20 height:20
			button del_mat_clear "清空材质编辑器" pos:[210,72] width:145 height:20--清空材质编辑器
			button help_del_mat_clear "★" pos:[355,72] width:20 height:20
		)
		on del_unobj pressed do--删除空面物体
		(
			unobj = # ()
			for obj in geometry do
			(
				fv = getpolygoncount obj
				if fv[1] == 0 then append unobj obj
			)
			undo on
			if unobj.count != 0 then
			(
				select unobj
				max delete
			)
		)
		on help_del_unobj pressed do--删除空面物体 帮助
		(
			messagebox "使用前将所有组打开，用途删除场景中的零面物体。" title:"删除空面物体"
		)
		on del_unmat pressed do--删除空材质物体
		(
			unmat = #()
			for mat in geometry do
			(
				if mat.material == undefined then append unmat mat
			)
			undo on
			if unmat.count != 0 then
			(
				select unmat
				max delete
			)
		)
		on help_del_unmat pressed do--删除空材质物体 帮助
		(
			messagebox "使用前将所有组打开，用途删除场景中没有材质的物体。" title:"删除空材质物体"
		)
		on del_mat pressed do--删除选中的物体材质
		(
			try ( $.material = undefined ) catch ()
		)
		on help_del_mat pressed do--删除选中的物体材质 帮助
		(
			messagebox "将所选择的物体材质清除。" title:"清除所选物体的材质"
		)
		on del_mat_clear pressed do--清空材质编辑器
		(
			for n = 1 to 24 do
			(
				meditmaterials[n] = standard()
				meditmaterials[n].name = n as string + " - Default"
			)
		)
		on help_del_mat_clear pressed do--清空材质编辑器 帮助
		(
			messagebox "将材质编辑器清空。" title:"清空材质编辑器"
		)
	)
	addrollout graph main
	rollout graph "动画"
	(
		group "设置辅助模型"
		(
			checkbox moxingcenggao_state "" across:2
			spinner moxingcenggao "模型标准层高：" range:[-99999,99999,300] type:#integer align:#right enabled:false
			button create_ani_model "生成Lattice模型" pos:[10,47] width:145 height:20 visible:false--设置辅助模型
			button help_create_ani_model "★" pos:[10,47] width:20 height:20
			label account_create_ani_model "生成Lattice模型必须要认真调整层高，以避免死机！" pos:[35,50] height:20 visible:true
		)
		group "动画设置"
		(
			button ani_random_flash "选中的物体中随机闪烁" pos:[10,97] width:145 height:20--选中的物体中随机闪烁
			button help_ani_random_flash "★" pos:[155,97] width:20 height:20			
		)
		checkbox ani_start_state "" across:2
		spinner ani_start "动画开始帧：" range:[-99999,99999,0] type:#integer align:#right enabled:false
		checkbox ani_end_state "" across:2
		spinner ani_end "动画结束帧：" range:[-99999,99999,100] type:#integer align:#right enabled:false
		checkbox ani_sleep_state "" across:2
		spinner ani_sleep "动画间隔帧：" range:[-99999,99999,5] type:#integer align:#right enabled:false
		on moxingcenggao_state changed state do
		(
			moxingcenggao.enabled = state
			create_ani_model.visible = state
			if moxingcenggao.enabled == false then moxingcenggao.value = 300
			if state then account_create_ani_model.visible = false else account_create_ani_model.visible = true
			if state then help_create_ani_model.pos = [155,47] else help_create_ani_model.pos = [10,47]
		)
		on ani_start_state changed state do
		(
			ani_start.enabled = state
			if ani_start.enabled == false then ani_start.value = 0
		)
		on ani_end_state changed state do
		(
			ani_end.enabled = state
			if ani_end.enabled == false then ani_end.value = 100
		)
		on ani_sleep_state changed state do
		(
			ani_sleep.enabled = state
			if ani_sleep.enabled == false then ani_sleep.value = 5
		)
		on create_ani_model pressed do
		(
			try
			(
				ass_model_x = $.max.x - $.min.x
				ass_model_y = $.max.y - $.min.y
				ass_model_z = $.max.z - $.min.z

				box length:(ass_model_y+moxingcenggao.value/3) width:(ass_model_x+moxingcenggao.value/3) height:(ass_model_z+moxingcenggao.value/6) lengthsegs:(ass_model_y/moxingcenggao.value) widthsegs:(ass_model_x/moxingcenggao.value) heightsegs:(ass_model_z/moxingcenggao.value) pos:[($.max.x+$.min.x)/2,($.max.y+$.min.y)/2,($.max.z+$.min.z)/2-($.max.z-$.min.z)/2] isselected:on
				$.name = "模型辅助框架"
				copy $ name:"模型辅助网格"
				max modify mode
				modpanel.addmodtoselection (lattice ()) ui:on
				$.modifiers[#lattice].strut_radius = moxingcenggao.value/10
				$.modifiers[#lattice].joint_radius = moxingcenggao.value/5
				convertto $ mesh
				max modify mode
				meditmaterials[1] = standard()
				$.material = meditmaterials[1]
				$.material.name = "模型辅助框架"
				$.material.shadertype = 2
				$.material.adtexturelock = on
				$.material.adlock = off
				$.material.ambient = color 0 0 0
				$.material.diffuse = color 190 204 219
				$.material.specularlevel = 160
				$.material.glossiness = 60
				$.name = "模型辅助框架OK"
				select $模型辅助网格
				meditmaterials[2] = standard()
				$.material = meditmaterials[2]
				$.material.name = "模型辅助网格"
				$.material.shadertype = 1
				$.material.adtexturelock = on
				$.material.adlock = off
				$.material.ambient = color 0 0 0
				$.material.diffuse = color 18 18 18				
				$.material.specularlevel = 12
				$.material.glossiness = 12
				$.material.opacity = 20	
				$.name = "模型辅助网格OK"
				clearselection()

			)
			catch
			(
				messagebox "请选择至少一个物体" title:"辅助模型"
			)
		)
		on help_create_ani_model pressed do
		(
			messagebox "在对选择的物体外面加上一个BOX（目前只是一个小小的测试）" title:"生成辅助模型"
		)
		on ani_random_flash pressed do
		(
			try
			(
				animate on
				(
				for t = ani_start.value to ani_end.value by ani_sleep.value do
				(
					slidertime = t
					try
					(
						$.visibility = true
						a = #()
						for i in $ do
						(
							if random 0 1 == 0 then append a i
						)
						a.visibility = false
					)
					catch ()
				)
				)
			)
			catch ()
		)
		on help_ani_random_flash pressed do
		(
			messagebox "选中的物体中随机闪烁！" title:"选中的物体中随机闪烁"
		)
	)
	addrollout graph main
	rollout graph "渲染"--渲染分组
	(
			button render_fourview "四视图渲染" pos:[10,10] width:145 height:20--四视图渲染
			button help_render_fourview "★" pos:[155,10] width:20 height:20
			on render_fourview pressed do--四视图渲染
			(
				rscale = 100
				gap = 0
				b = #()
				for v = 1 to 4 do
				(
					viewport.activeViewport = v
					lab = viewport.getType() as string
					vsize = getViewSize()
					b[v]=bitmap (rscale*vsize.x) (rscale*vsize.y)
					render to:b[v]
				)
				a=bitmap (b[1].width + b[2].width + gap) (b[1].height + b[3].height + gap)
				n=a.height
				for v = 0 to 3 do
				(
					for nrow = 0 to n-1 do
					(
					row = getPixels b[v+1] [0,nrow] b[v+1].width 
					setPixels a [ (bit.and v 1)*(b[1].width+gap) , nrow + (bit.and v 2)*(b[1].height+gap)/2 ] row
					close b[v+1]
					)
				)
				display a
				b=undefined
			)
			on help_render_fourview pressed do--四视图渲染 帮助
			(
			messagebox "保证视图为四视图状态，并将各个视图里面的内容\n设好，点击本按钮可以对四个视图逐一渲染，再将\n四个图片自动和为一张。图片尺寸为设置渲染尺寸\n长宽的2倍。" title:"四视图渲染"
			)
	)
	addrollout graph main rolledup:true
	rollout graph "整理提交"--
	(
		button tijiao_taxian "快速塌陷" pos:[10,10] width:145 height:20
		button help_tijiao_taxian "★" pos:[155,10] width:20 height:20
		on tijiao_taxian pressed do
		(
		try
		(
										select $*
							convertTo $ PolyMeshObject
							max group explode
							for i in 1 to scenematerials.count do
							(   
								mq = #()
								for obj in selection do
								(		
									if obj.material==scenematerials[i] then
									append mq obj
								)
								
								if mq.count>0 then
									(	
										if mq.count!=1 then 
										(		
											for n in 1 to mq.count do
											(   
												polyop.attach mq[1] mq[n+1]
											    if (n+1)==mq.count then
												(							 	
												exit
												)
											)
										)						
										else
	
										mq[1].name=scenematerials[i].name
								
									)
								
							)		
							
							
							convertTomesh $*
							clearSelection()
							max unfreeze all
							max unhide all
							redrawviews()


		)
		catch ()
		)
		on help_tijiao_taxian pressed do
		(
		messagebox "对场景里面的所有物体按材质进行塌陷，使其一个材质\n对应一个物体。" title:"塌陷"
		)
	)
	addrollout graph main rolledup:true
	rollout graph "常用工具"
	(
		button file_note "文件说明" pos:[10,10] width:145 height:20
		button help_file_note "★" pos:[155,10] width:20 height:20
		button fan_taxian "反塌陷" pos:[10,40] width:145 height:20
		button help_fan_taxian "★" pos:[155,40] width:20 height:20
		progressbar jindu_fan color:red pos:[180,40] width:200 height:20
		on file_note pressed do
		(
rollout zhaoxuan_note "文件信息说明"
(
	Edittext auth "制作人：" pos:[20,10] fieldwidth:150 text:""
	Edittext dtstmp "制作日期：" pos:[20,30] fieldwidth:150 offset:[8,0] text:localtime 
	Edittext line1 height:200 text:"" 

	Button CanclAll "取消" offset:[110,0] width:75 
	Button Go "确定" offset:[190,-26] width:75 

	On Go pressed do 
		(
		callbacks.removescripts id:#SceneNote 
		Persistent Global Note_NoteString = "Messagebox \"" + "制作人：" + auth.text+"\n"+dtstmp.text+"\n\n制作说明：\n"+ line1.text+ "\"" + "title:\"文件信息\""
		Persistent Global Note_AuthorString = auth.text 
		Persistent Global Note_TextString = line1.text 
		callbacks.addscript #filepostopen "Execute Note_NoteString" id:#SceneNote persistent:true 
		destroydialog zhaoxuan_note 
		fileproperties.addproperty #summary "comments" Note_TextString 
		fileproperties.addproperty #summary "author" Note_AuthorString 

		)
	On zhaoxuan_note Open do  
		( 
			try (auth.text = fileProperties.getPropertyvalue #summary 2) Catch()  
			try (line1.text = fileProperties.getPropertyvalue #summary 1) Catch()  
		)	
	On CanclAll pressed do destroydialog zhaoxuan_note 
)
createdialog zhaoxuan_note width:500 height:300 
		)
		on help_file_note pressed do
		(
		messagebox "在max文件里面加入制作人、制作日期和制作说明等\n相关信息。使它在打开时显示这些信息；对已有信息\n的文件可以进行修改！" title:"文件信息"
		)
		on fan_taxian pressed do
		(
		if $ != undefined then
		(
			taxian_j = selection as array
			taxian_v = taxian_j.count
		)
		else
		(
		taxian_v = $geometry.count
		taxian_j = $geometry
		)
		for i = 1 to taxian_v do
		(
			sphere isselected:on pos:[(taxian_j[1].max.x + taxian_j[1].min.x)/2 , (taxian_j[1].max.y + taxian_j[1].min.y)/2 , (taxian_j[1].max.z + taxian_j[1].min.z)/2]
			$.name = taxian_j[1].name
			converttomesh $
			max modify mode
			taxian_n = getuserpropbuffer taxian_j[1]
			attach $ taxian_j[1]
			setuserpropbuffer $ taxian_n
			try ( deleteitem taxian_j 1 ) catch ()
			converttopoly $
			subobjectlevel = 1
			$.editablepoly.setselection #vertex #{1..114}
			max delete
			subobjectlevel = 0
			converttomesh $
			modpanel.addmodtoselection (Normalmodifier ()) ui:on
			$.modifiers[#normal].unify = true
			jindu_fan.value = 100.*i/taxian_v
			converttomesh $
		)
		jindu_fan.value = 0
		clearselection ()
		
		for i in $* do
		(
			if ( getUserPropBuffer i ) == "" then
			(
				setuserpropbuffer i ( sysinfo.computername + "     " + sysinfo.username )
			)
		)
		)
		on help_fan_taxian pressed do
		(
		messagebox "一次性反塌陷场景里的所有物体或者是选择的物体。\n注：反塌陷后无组。" title:"反塌陷"
		)
	)
	addrollout graph main rolledup:true
	rollout graph "关于"
	(
		bitmap zhaoxuan_pic "Bitmap" pos:[10,12] width:200 height:200 fileName:"\\\zhaoxuan\\@动画模型专用@\\scripts\\scripts-maps\\ZBH.jpg" 
		label lbl1 "程序说明:" pos:[215,10]
		label lbl2 "本脚本为内部使用，禁止" pos:[249,30]
		label lb13 "转载！！！" pos:[215,50]
		label lbl4 "如有问题或建议请联系：" pos:[249,70]
		label lbl5 "北京水晶石" pos:[215,90]
		label lbl6 "数字影视中心.三维模型部" pos:[249,110]
		label lb17 "作者：_&頭頭是噵.. " pos:[280,200]
	)
	addrollout graph main rolledup:true
)
		)
		else
		(
			messagebox "本程序已到期，请支持正版！___ _&頭頭是噵.. " title:"新工具合集"
		)
)
catch ()

--_&頭頭是噵..
--END