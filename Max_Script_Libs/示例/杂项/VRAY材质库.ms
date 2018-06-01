macroScript avMaterials category:"VRAY材质" buttonText:"VRAY材质" tooltip:"VRAY材质"

(

Global av_Mtl
try(destroydialog av_Mtl)catch()
	
get_av_Mtl_dialog_pos_x = getinisetting "$plugcfg\\av_Mtl.ini" "Materials" "pos_x" as integer
if get_av_Mtl_dialog_pos_x == undefined or get_av_Mtl_dialog_pos_x == 0 then get_av_Mtl_dialog_pos_x = 305
	
get_av_Mtl_dialog_pos_y = getinisetting "$plugcfg\\av_Mtl.ini" "Materials" "pos_y" as integer
if get_av_Mtl_dialog_pos_y == undefined or get_av_Mtl_dialog_pos_y == 0 then get_av_Mtl_dialog_pos_y = 136
		
rollout a "金属"
	(
		button b_chrome1 "金属网(格)" pos:[10,10] width:112 height:20
		button b_chrome2 "拉丝金属" pos:[10,34] width:112 height:20
		button b_chrome3 "印花金属" pos:[10,58] width:112 height:20
		button b_aluminium1 "纹路金属" pos:[10,82] width:112 height:20
		button b_aluminium2 "磨沙金属" pos:[10,106] width:112 height:20
		button b_ssteel "不锈钢" pos:[10,179] width:112 height:20
		button b_silver "银" pos:[10,227] width:112 height:20
		button b_gold "黄金" pos:[10,251] width:112 height:20
		button b_cooper "铜" pos:[10,347] width:112 height:20
		button b_bronze "青铜" pos:[10,371] width:112 height:20
		button b_brass "黄铜" pos:[10,395] width:112 height:20
		button b_titanium "钛" pos:[10,443] width:112 height:20
		button b_gold_rose "镀金" pos:[10,275] width:112 height:20
		button b_gold_white "镀银" pos:[10,299] width:112 height:20
		button b_aluminium_anis "铝合金" pos:[10,131] width:112 height:20
		button b_aluminium_comp "铝" pos:[10,155] width:112 height:20
		button b_steel_obj "钢 (Objects)" pos:[10,203] width:112 height:20
		button b_gold_green "黄金合金(绿色)" pos:[10,323] width:112 height:20
		button b_brass_furn "黄铜(家具)" pos:[10,419] width:112 height:20
		button b_platinum "铂 白金" pos:[10,467] width:112 height:20

		on b_chrome1 pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
		   meditMaterials[activeMeditSlot].name = "金属网(格)"
		   meditMaterials[activeMeditSlot].Diffuse = color 52 41 37
		   meditMaterials[activeMeditSlot].Reflection = color 64 64 64
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
		   meditMaterials[activeMeditSlot].texmap_opacity = Bricks ()
		   meditMaterials[activeMeditSlot].texmap_opacity.Horizontal_Gap = 20
		   meditMaterials[activeMeditSlot].texmap_opacity.Vertical_Gap = 20
		   meditMaterials[activeMeditSlot].texmap_opacity.Horizontal_Gap = 20
		   meditMaterials[activeMeditSlot].texmap_opacity.Vertical_Gap = 5
		   meditMaterials[activeMeditSlot].texmap_opacity.Horizontal_Gap = 5
		   meditMaterials[activeMeditSlot].texmap_opacity.Vertical_Gap = 5
		   meditMaterials[activeMeditSlot].texmap_opacity.Horizontal_Count = 20
		   meditMaterials[activeMeditSlot].texmap_opacity.Vertical_Count = 5
		   meditMaterials[activeMeditSlot].texmap_opacity.Horizontal_Gap = 0.5
		   meditMaterials[activeMeditSlot].texmap_opacity.Vertical_Gap = 0.5
		   meditMaterials[activeMeditSlot].texmap_opacity.Horizontal_Gap = 0.5
		   meditMaterials[activeMeditSlot].texmap_opacity.Brick_Color = color 0 0 0
		   meditMaterials[activeMeditSlot].texmap_opacity.Mortar_Color = color 255 255 255
		   meditMaterials[activeMeditSlot].texmap_opacity.Random_Seed = 40016
		)
		on b_chrome2 pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
		   meditMaterials[activeMeditSlot].name = "拉丝金属(多种贴图)"
           meditMaterials[activeMeditSlot].Reflection = color 225 225 225
           meditMaterials[activeMeditSlot].reflection_glossiness = 0.75
           meditMaterials[activeMeditSlot].reflection_subdivs = 30
           meditMaterials[activeMeditSlot].brdf_type = 2
           meditMaterials[activeMeditSlot].anisotropy = 0.9
           meditMaterials[activeMeditSlot].texmap_bump_multiplier = 20
           meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\金属\拉丝\AS2_brushedmetal.jpg"
		   meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_bump.coords.U_Tiling = 2
           meditMaterials[activeMeditSlot].texmap_bump.coords.V_Tiling = 2

		)
		on b_chrome3 pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "拉丝金属(印花)"
		   meditMaterials[activeMeditSlot].Reflection = color 225 225 225
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
		   meditMaterials[activeMeditSlot].reflection_subdivs = 30
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\AS2_brushedmetal2.jpg"
		   meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
		   meditMaterials[activeMeditSlot].texmap_reflection.coords.U_Tiling = 7
		   meditMaterials[activeMeditSlot].texmap_reflection.coords.V_Tiling = 7
		   meditMaterials[activeMeditSlot].texmap_bump_multiplier = 60
		   meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\AS2_brushedmetal2.jpg"
		   meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
		   meditMaterials[activeMeditSlot].texmap_bump.coords.U_Tiling = 7
		   meditMaterials[activeMeditSlot].texmap_bump.coords.V_Tiling = 7
		)
		on b_aluminium1 pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "纹路金属"
           meditMaterials[activeMeditSlot].Reflection = color 205 205 205
           meditMaterials[activeMeditSlot].reflection_glossiness = 0.8
           meditMaterials[activeMeditSlot].reflection_subdivs = 25
           meditMaterials[activeMeditSlot].refraction_ior = 2
           meditMaterials[activeMeditSlot].brdf_type = 2
           meditMaterials[activeMeditSlot].texmap_bump_multiplier = 50
           meditMaterials[activeMeditSlot].texmap_bump = Normal_Bump ()
           meditMaterials[activeMeditSlot].texmap_bump.flipred = on
           meditMaterials[activeMeditSlot].texmap_bump.flipgreen = on
           meditMaterials[activeMeditSlot].texmap_bump.mult_spin = 2
           meditMaterials[activeMeditSlot].texmap_bump.normal_map = Bitmaptexture fileName:"D:\vraymaps\as2_metal_bump_04.jpg"
           meditMaterials[activeMeditSlot].texmap_bump.normal_map.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_bump.normal_map.coords.U_Tiling = 6.1
           meditMaterials[activeMeditSlot].texmap_bump.normal_map.coords.V_Tiling = 6

		)
		on b_aluminium2 pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "铝合金"
		   meditMaterials[activeMeditSlot].Diffuse = color 185 185 185
		   meditMaterials[activeMeditSlot].Reflection = color 90 90 90
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].reflection_subdivs = 20
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 2
		)
		on b_ssteel pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "不锈钢"
		   meditMaterials[activeMeditSlot].Diffuse = color 52 52 52
		   meditMaterials[activeMeditSlot].Reflection = color 152 152 152
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
		   meditMaterials[activeMeditSlot].reflection_subdivs = 16
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].anisotropy = 0.7
		   meditMaterials[activeMeditSlot].anisotropy_rotation = 90.0
		)
		on b_silver pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "银"
		   meditMaterials[activeMeditSlot].Diffuse = color 30 30 30
		   meditMaterials[activeMeditSlot].Reflection = color 231 231 231
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_gold pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "黄金"
		   meditMaterials[activeMeditSlot].Diffuse = color 80 62 50
		   meditMaterials[activeMeditSlot].Reflection = color 216 171 113
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_cooper pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "铜"
		   meditMaterials[activeMeditSlot].Diffuse = color 105 84 65
		   meditMaterials[activeMeditSlot].Reflection = color 130 70 34
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 2
		)
		on b_bronze pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "青铜"
		   meditMaterials[activeMeditSlot].Diffuse = color 31 12 0
		   meditMaterials[activeMeditSlot].Reflection = color 177 137 60
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].reflection_subdivs = 16
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_brass pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "黄铜"
		   meditMaterials[activeMeditSlot].Diffuse = color 105 91 65
		   meditMaterials[activeMeditSlot].Reflection = color 130 107 53
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].reflection_subdivs = 16
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 2
		)
		on b_titanium pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "钛"
		   meditMaterials[activeMeditSlot].Diffuse = color 34 40 38
		   meditMaterials[activeMeditSlot].Reflection = color 138 142 134
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.5
		   meditMaterials[activeMeditSlot].reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].reflect_minRate = -5
		   meditMaterials[activeMeditSlot].reflect_maxRate = -3
		   meditMaterials[activeMeditSlot].reflect_interpSamples = 20
		   meditMaterials[activeMeditSlot].reflect_normalThreshold = 0.4
		   meditMaterials[activeMeditSlot].reflect_colorThreshold = 0.25
		)
		on b_gold_rose pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "镀金"
		   meditMaterials[activeMeditSlot].Diffuse = color 150 102 80
		   meditMaterials[activeMeditSlot].Reflection = color 240 204 179
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.98
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 20
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_gold_white pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "镀银"
		   meditMaterials[activeMeditSlot].Diffuse = color 188 186 198
		   meditMaterials[activeMeditSlot].Reflection = color 243 224 228
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.99
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 18.6
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_aluminium_anis pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "铝合金"
		   meditMaterials[activeMeditSlot].Diffuse = color 127 127 127
		   meditMaterials[activeMeditSlot].Reflection = color 225 225 225 
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.62
		   meditMaterials[activeMeditSlot].reflection_subdivs = 30
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 18.5
		   meditMaterials[activeMeditSlot].anisotropy = 0.4
		   meditMaterials[activeMeditSlot].anisotropy_rotation = 0.0
		   meditMaterials[activeMeditSlot].brdf_type = 2
		)
		on b_aluminium_comp pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "铝"
		   meditMaterials[activeMeditSlot].Diffuse = color 157 164 170
		   meditMaterials[activeMeditSlot].Reflection = color 157 164 170 
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.8
		   meditMaterials[activeMeditSlot].reflection_subdivs = 10
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 2
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 20
		   meditMaterials[activeMeditSlot].anisotropy = 0.0
		   meditMaterials[activeMeditSlot].anisotropy_rotation = 90.0
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].texmap_bump_on = true
		   meditMaterials[activeMeditSlot].texmap_bump_multiplier = 5.0
		   meditMaterials[activeMeditSlot].texmap_bump = Noise type:0 size:500
		)
		on b_steel_obj pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "钢"
		   meditMaterials[activeMeditSlot].Diffuse = color 106 106 106
		   meditMaterials[activeMeditSlot].Reflection = color 76 76 76
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].reflection_subdivs = 10
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 0
		   meditMaterials[activeMeditSlot].anisotropy = 0.0
		   meditMaterials[activeMeditSlot].anisotropy_rotation = 0.0
		   meditMaterials[activeMeditSlot].reflect_minRate = -5
		   meditMaterials[activeMeditSlot].reflect_maxRate = -3
		   meditMaterials[activeMeditSlot].reflect_interpSamples = 20
		   meditMaterials[activeMeditSlot].reflect_normalThreshold = 0.4
		   meditMaterials[activeMeditSlot].reflect_colorThreshold = 0.25
		)
		on b_gold_green pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "黄金合金"
		   meditMaterials[activeMeditSlot].Diffuse = color 137 136 99
		   meditMaterials[activeMeditSlot].Reflection = color 252 248 186
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.99
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 20
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_brass_furn pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "黄铜(家具)"
		   meditMaterials[activeMeditSlot].Diffuse = color 174 120 25
		   meditMaterials[activeMeditSlot].Reflection = color 170 135 85
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].reflect_minRate = -5
		   meditMaterials[activeMeditSlot].reflect_maxRate = -3
		   meditMaterials[activeMeditSlot].reflect_interpSamples = 20
		   meditMaterials[activeMeditSlot].reflect_normalThreshold = 0.4
		   meditMaterials[activeMeditSlot].reflect_colorThreshold = 0.25
		)
		on b_platinum pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "铂 白金"
		   meditMaterials[activeMeditSlot].Diffuse = color 137 135 100
		   meditMaterials[activeMeditSlot].Reflection = color 207 197 155
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.94
		   meditMaterials[activeMeditSlot].reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].reflect_minRate = -5
		   meditMaterials[activeMeditSlot].reflect_maxRate = -3
		   meditMaterials[activeMeditSlot].reflect_interpSamples = 20
		   meditMaterials[activeMeditSlot].reflect_normalThreshold = 0.4
		   meditMaterials[activeMeditSlot].reflect_colorThreshold = 0.25
		)
	)

rollout b "玻璃"
	(
		button b_glass_objects "有色玻璃(红)" pos:[10,9] width:112 height:20
		button b_glass_brushed "磨沙玻璃" pos:[10,33] width:112 height:20
		button b_glass_frosty "冰裂玻璃" pos:[10,57] width:112 height:20
		button b_glass_lens "镜片" pos:[10,81] width:112 height:20
		button b_glass_bottle "啤酒瓶" pos:[10,105] width:112 height:20
		on b_glass_objects pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "有色玻璃(红)"
		   meditMaterials[activeMeditSlot].Diffuse = color 101 101 101
		   meditMaterials[activeMeditSlot].Reflection = color 235 163 163
		   meditMaterials[activeMeditSlot].reflection_subdivs = 25
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].refraction_ior = 1.56
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 20
		   meditMaterials[activeMeditSlot].Refraction = color 230 230 230
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 204 25 25
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].texmap_bump_multiplier = 100

		)
		on b_glass_brushed pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "磨沙玻璃"
		   meditMaterials[activeMeditSlot].Diffuse = color 101 101 101
		   meditMaterials[activeMeditSlot].Reflection = color 187 187 187
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
		   meditMaterials[activeMeditSlot].reflection_subdivs = 25
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 20
		   meditMaterials[activeMeditSlot].Refraction = color 170 170 170
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.9
		   meditMaterials[activeMeditSlot].refraction_subdivs = 25
		   meditMaterials[activeMeditSlot].refraction_ior = 1.56
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 20
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].texmap_bump_multiplier = 100

		)
		on b_glass_frosty pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "冰裂玻璃"
		   meditMaterials[activeMeditSlot].Diffuse = color 101 101 101
		   meditMaterials[activeMeditSlot].Reflection = color 187 187 187
		   meditMaterials[activeMeditSlot].reflection_subdivs = 25
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 213 213 213
		   meditMaterials[activeMeditSlot].refraction_subdivs = 25
		   meditMaterials[activeMeditSlot].refraction_ior = 1.56
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].texmap_bump_multiplier = 100
		   meditMaterials[activeMeditSlot].texmap_bump = Normal_Bump ()
		   meditMaterials[activeMeditSlot].texmap_bump.mult_spin = 2
		   meditMaterials[activeMeditSlot].texmap_bump.normal_map = Bitmaptexture fileName:"D:\vraymaps\AS2__glass_bump_15.jpg"
		   meditMaterials[activeMeditSlot].texmap_bump.normal_map.alphaSource = 2

		)
		on b_glass_lens pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "镜片"
		   meditMaterials[activeMeditSlot].Diffuse = color 0 0 0
		   meditMaterials[activeMeditSlot].Reflection = color 202 60 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 1.72
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 255 255 255
		   meditMaterials[activeMeditSlot].refraction_glossiness = 1.0
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.56
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 65 65 65
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.001
		   meditMaterials[activeMeditSlot].brdf_type = 0
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_glass_bottle pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "啤酒瓶"
		   meditMaterials[activeMeditSlot].Diffuse = color 1 0 0
		   meditMaterials[activeMeditSlot].Reflection = color 127 127 127
		   meditMaterials[activeMeditSlot].texmap_reflection = Falloff showInViewport:true color1:[59,59,59] color2:[255,255,255] name:"reflmap"
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.97
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 250 250 250
		   meditMaterials[activeMeditSlot].refraction_glossiness = 1.0
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.56
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 79 27 3
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.78
		   meditMaterials[activeMeditSlot].refraction_fogBias = 0.06
		   meditMaterials[activeMeditSlot].brdf_type = 0
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		   )
	)
	
rollout c "塑料(光泽)"
	(
		button b_glopl "塑料(非常低)" pos:[10,10] width:112 height:20
		button b_matpl "塑料(低)" pos:[10,34] width:112 height:20
		button b_opapl "塑料(中)" pos:[10,58] width:112 height:20
		button b_rubpl "塑料(高)" pos:[10,82] width:112 height:20
		button b_mirpl "塑料(非常高)" pos:[10,106] width:112 height:20
	
		on b_glopl pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
		   meditMaterials[activeMeditSlot].name = "塑料(非常低)"
		   meditMaterials[activeMeditSlot].Diffuse = color 206 206 206
		   meditMaterials[activeMeditSlot].Reflection = color 101 101 101
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
		   meditMaterials[activeMeditSlot].reflection_subdivs = 25
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].refraction_ior = 1.5
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].translucency_on = 1
		   meditMaterials[activeMeditSlot].brdf_type = 2
		   meditMaterials[activeMeditSlot].anisotropy = 0.7
		)
		on b_matpl pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "塑料(低)"
           meditMaterials[activeMeditSlot].Diffuse = color 66 66 66
           meditMaterials[activeMeditSlot].Reflection = color 39 39 39
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.6
           meditMaterials[activeMeditSlot].reflection_subdivs = 25
           meditMaterials[activeMeditSlot].refraction_affectShadows = on
           meditMaterials[activeMeditSlot].translucency_on = 1
           meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_opapl pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
		   meditMaterials[activeMeditSlot].name = "塑料(中)"
		   meditMaterials[activeMeditSlot].Diffuse = color 245 248 0
		   meditMaterials[activeMeditSlot].Reflection = color 79 79 79
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_subdivs = 25
		   meditMaterials[activeMeditSlot].refraction_ior = 2
		   meditMaterials[activeMeditSlot].translucency_on = 1
		) 
		on b_rubpl pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
		   meditMaterials[activeMeditSlot].name = "塑料(高)"
		   meditMaterials[activeMeditSlot].Diffuse = color 146 0 127
		   meditMaterials[activeMeditSlot].Reflection = color 101 101 101
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
		   meditMaterials[activeMeditSlot].reflection_subdivs = 25
		   meditMaterials[activeMeditSlot].refraction_ior = 0.7
		   meditMaterials[activeMeditSlot].translucency_on = 1
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		)
		on b_mirpl pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "塑料(非常高)"
           meditMaterials[activeMeditSlot].Diffuse = color 79 175 27
           meditMaterials[activeMeditSlot].Reflection = color 50 50 50
           meditMaterials[activeMeditSlot].reflection_lockGlossiness = off
           meditMaterials[activeMeditSlot].hilight_glossiness = 0.7
           meditMaterials[activeMeditSlot].Refraction = color 64 64 64
           meditMaterials[activeMeditSlot].refraction_glossiness = 0.7
           meditMaterials[activeMeditSlot].translucency_on = 1
           meditMaterials[activeMeditSlot].translucency_color = color 42 93 14
		)
		on c close do
		(
			setinisetting "$plugcfg\\av_Mtl.ini" "Materials" "pos_x" (av_Mtl.Pos.x as string)
			setinisetting "$plugcfg\\av_Mtl.ini" "Materials" "pos_y" (av_Mtl.Pos.y as string)
		)

	)

rollout d "液体"
	(
		button b_water "水 " pos:[10,10] width:112 height:20
		button b_alcohol "酒(乙荃)" pos:[10,34] width:112 height:20
		button b_wine "葡萄酒(红)" pos:[10,58] width:112 height:20
		button b_oil "油 (花生)" pos:[10,82] width:112 height:20
		button b_juice "汁(苹果)" pos:[10,106] width:112 height:20
		button b_tea "茶" pos:[10,130] width:112 height:20
		button b_milk "牛奶" pos:[10,154] width:112 height:20
	
		on b_water pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "水"
		   meditMaterials[activeMeditSlot].Diffuse = color 0 0 0
		   meditMaterials[activeMeditSlot].Reflection = color 126 126 126
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 12
		   meditMaterials[activeMeditSlot].Refraction = color 250 250 250
		   meditMaterials[activeMeditSlot].refraction_glossiness = 1.0
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.333
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 12
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_alcohol pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "酒"
		   meditMaterials[activeMeditSlot].Diffuse = color 50 50 50
		   meditMaterials[activeMeditSlot].Reflection = color 233 233 233
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 240 240 240
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.99
		   meditMaterials[activeMeditSlot].refraction_subdivs = 10
		   meditMaterials[activeMeditSlot].refraction_ior = 1.36
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 233 233 233
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.01
		   
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_wine pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "葡萄酒(红)"
		   meditMaterials[activeMeditSlot].Diffuse = color 81 2 2
		   meditMaterials[activeMeditSlot].Reflection = color 245 245 245
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.92
		   meditMaterials[activeMeditSlot].reflection_subdivs = 16
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 141 141 141
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.98
		   meditMaterials[activeMeditSlot].refraction_subdivs = 10
		   meditMaterials[activeMeditSlot].refraction_ior = 1.3
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 146 2 2
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.005
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
		on b_oil pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "油(花生)"
		   meditMaterials[activeMeditSlot].Diffuse = color 224 192 107
		   meditMaterials[activeMeditSlot].Reflection = color 232 232 232
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.97
		   meditMaterials[activeMeditSlot].reflection_subdivs = 12
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 220 220 220
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.98
		   meditMaterials[activeMeditSlot].refraction_subdivs = 12
		   meditMaterials[activeMeditSlot].refraction_ior = 1.483
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 193 135 35
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.3
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_juice pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "汁(苹果)"
		   meditMaterials[activeMeditSlot].Diffuse = color 189 166 96
		   meditMaterials[activeMeditSlot].Reflection = color 193 181 161
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 213 213 213
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.99
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.351
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 146 98 35
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.2
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_tea pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "茶"
		   meditMaterials[activeMeditSlot].Diffuse = color 45 9 3
		   meditMaterials[activeMeditSlot].Reflection = color 200 173 144
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 197 197 197
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.99
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.356
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = off
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 234 33 12
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.26
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_milk pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "牛奶"
		   meditMaterials[activeMeditSlot].Diffuse = color 254 254 254
		   meditMaterials[activeMeditSlot].Reflection = color 233 233 233
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 64 64 64
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.98
		   meditMaterials[activeMeditSlot].refraction_subdivs = 16
		   meditMaterials[activeMeditSlot].refraction_ior = 1.35
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 211 211 211
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.3
		   meditMaterials[activeMeditSlot].translucency_on = 1
		   meditMaterials[activeMeditSlot].translucency_thickness = 100
		   meditMaterials[activeMeditSlot].translucency_color = color 208 208 208
		   meditMaterials[activeMeditSlot].translucency_scatterCoeff = 0.0
		   meditMaterials[activeMeditSlot].translucency_fbCoeff = 1.0
		   meditMaterials[activeMeditSlot].translucency_multiplier = 1.0
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
	)

rollout f "石材"
	(
		button b_ruby "地砖" pos:[10,10] width:112 height:20
		button b_sapphire_y "黄宝石" pos:[10,34] width:112 height:20
		button b_topaz_blue "蓝宝石" pos:[10,58] width:112 height:20
		button b_topaz_pink "红宝石2" pos:[10,82] width:112 height:20
		button b_topaz_smokey "Topaz Smokey" pos:[10,106] width:112 height:20
		button b_peridot "橄榄石" pos:[10,130] width:112 height:20
		button b_garnet "石榴石(黑色)" pos:[10,154] width:112 height:20
		button b_diamond "钻石" pos:[10,178] width:112 height:20
		button b_onyx "黑玛瑙" pos:[10,202] width:112 height:20

		on b_ruby pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[1].name = "地砖"
		   meditMaterials[1].texmap_diffuse = Bitmaptexture fileName:"D:\vraymaps\mei.gif"
		   meditMaterials[1].DirectX_Manager.enabled = off
		   meditMaterials[1].Reflection = color 30 30 30
		   meditMaterials[1].reflection_glossiness = 0.9
		   meditMaterials[1].texmap_bump = meditMaterials[1].texmap_diffuse
		)
		on b_sapphire_y pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Sapphire_Yellow"
		   meditMaterials[activeMeditSlot].Diffuse = color 160 127 32
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 190 190 190
		   meditMaterials[activeMeditSlot].refraction_glossiness = 1.0
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.76
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 200 170 55
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.11
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_topaz_blue pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Topaz_Blue"
		   meditMaterials[activeMeditSlot].Diffuse = color 7 44 103
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 173 173 173
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.99
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.615
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 80 194 252
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.13
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_topaz_pink pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Topaz_Pink"
		   meditMaterials[activeMeditSlot].Diffuse = color 155 11 16
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 190 190 190
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.98
		   meditMaterials[activeMeditSlot].refraction_subdivs = 12
		   meditMaterials[activeMeditSlot].refraction_ior = 1.62
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 240 43 100
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.12
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_topaz_smokey pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Topaz_Smokey"
		   meditMaterials[activeMeditSlot].Diffuse = color 37 22 15
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 190 190 190
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.98
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.622
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 85 59 39
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.12
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_peridot pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Peridot"
		   meditMaterials[activeMeditSlot].Diffuse = color 68 79 8
		   meditMaterials[activeMeditSlot].Reflection = color 55 58 56
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = off
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 178 178 178
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.99
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.69
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 172 196 62
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.24
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_garnet pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Garnet"
		   meditMaterials[activeMeditSlot].Diffuse = color 11 2 1
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 169 169 169
		   meditMaterials[activeMeditSlot].refraction_glossiness = 1.0
		   meditMaterials[activeMeditSlot].refraction_subdivs = 8
		   meditMaterials[activeMeditSlot].refraction_ior = 1.82
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_affectAlpha = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 253 13 6
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.31
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_diamond pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Diamond"
		   meditMaterials[activeMeditSlot].Diffuse = color 65 65 65
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_glossiness = 1.0
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 255 255 255
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.99
		   meditMaterials[activeMeditSlot].refraction_subdivs = 10
		   meditMaterials[activeMeditSlot].refraction_ior = 2.417
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_affectShadows = on
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 220 209 146
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.001
		   meditMaterials[activeMeditSlot].brdf_type = 1
		   meditMaterials[activeMeditSlot].option_reflectOnBack = on
		)
		on b_onyx pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Onyx"
		   meditMaterials[activeMeditSlot].Diffuse = color 1 1 2
		   meditMaterials[activeMeditSlot].Reflection = color 255 255 255
		   meditMaterials[activeMeditSlot].reflection_lockGlossiness = off
		   meditMaterials[activeMeditSlot].hilight_glossiness = 0.99
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.91
		   meditMaterials[activeMeditSlot].reflection_subdivs = 30
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].reflection_ior = 1.7
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 0 0 0
		   meditMaterials[activeMeditSlot].refraction_glossiness = 1.0
		   meditMaterials[activeMeditSlot].refraction_subdivs = 5
		   meditMaterials[activeMeditSlot].refraction_ior = 1.486
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 0
		)
	)

rollout g "有机物"
	(
		button b_grass_fur "草(VRayFur)" pos:[10,10] width:112 height:20
		button b_eggshell "蛋(Shell)" pos:[10,34] width:112 height:20
		button b_peach "桃" pos:[10,58] width:112 height:20
		button b_plum "草梅" pos:[10,82] width:112 height:20
		button b_skin "皮肤 (SSS)" pos:[10,106] width:112 height:20
		
		on b_grass_fur pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Organic: Grass_VRayFur"
		   meditMaterials[activeMeditSlot].Diffuse = color 116 154 0
		   meditMaterials[activeMeditSlot].Reflection = color 5 5 5
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.89
		   meditMaterials[activeMeditSlot].reflection_subdivs = 8
		   meditMaterials[activeMeditSlot].reflection_fresnel = off
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 4
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_eggshell pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl()
		   meditMaterials[activeMeditSlot].name = "Organic: EggShell"
		   meditMaterials[activeMeditSlot].baseMtl = VrayMtl()
		   meditMaterials[activeMeditSlot].baseMtl.name = "Eggshell_base"
		   meditMaterials[activeMeditSlot].baseMtl.Diffuse = color 167 88 37
		   meditMaterials[activeMeditSlot].baseMtl.Reflection = color 59 59 59
		   meditMaterials[activeMeditSlot].baseMtl.reflection_glossiness = 0.7
		   meditMaterials[activeMeditSlot].baseMtl.reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].baseMtl.reflection_fresnel = on
		   meditMaterials[activeMeditSlot].baseMtl.reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].baseMtl.reflection_ior = 6.0
		   meditMaterials[activeMeditSlot].baseMtl.brdf_type = 1
		   meditMaterials[activeMeditSlot].baseMtl.texmap_bump = Cellular name:"BaseBump" cell_color:[255,255,255] division_color1:[128,128,128] division_color2:[27,27,27] type:0 size:0.8 spread:0.63 fractal:true iteration:2.0 midthresh:0.52 highthresh:0.96
		   meditMaterials[activeMeditSlot].baseMtl.texmap_bump_multiplier = 22.0
		   meditMaterials[activeMeditSlot].coatMtl = #(VrayMtl name:"Splat_Shell" diffuse:[55,9,0] reflection:[81,81,81] reflection_glossiness:0.55 reflection_subdivs:8 reflection_fresnel:on reflection_lockIOR:off reflection_ior:6.0 brdf_type:1,
			VrayMtl name:"Splat_Shell_02" diffuse:[202,151,89] reflection:[81,81,81] reflection_glossiness:0.55 reflection_subdivs:8 reflection_fresnel:on reflection_lockIOR:off reflection_ior:6.0 brdf_type:1, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
		   meditMaterials[activeMeditSlot].texmap_blend = #(Splat name:"Splat1" size:1.8 iterations:2 threshold:0.15 color1:[0,0,0] color2:[255,255,255],
			Splat name:"Splat2" size:1.2 iterations:3 threshold:0.15 color1:[0,0,0] color2:[255,255,255], undefined, undefined, undefined, undefined, undefined, undefined, undefined)
		)
		on b_peach pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Organic: Peach"
		   meditMaterials[activeMeditSlot].Diffuse = color 219 165 57
		   meditMaterials[activeMeditSlot].texmap_diffuse = Mix name:"Diffuse_color"
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1 = Mix name:"Base"
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1 = Gradient_ramp name:"Color" Gradient_Type:4
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.coordinates.W_Angle = 90.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.coordinates.U_Mirror = true
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.coordinates.V_Mirror = false
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.coordinates.U_Tile = false
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.coordinates.V_Tile = true
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.gradient_ramp.flag__1.color = color 177 29 15
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.gradient_ramp.flag__3.color = color 207 121 27
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map1.gradient_ramp.flag__2.color = color 219 165 57
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2 = Output name:"Color_Bright"
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1 = Gradient_ramp()
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.coordinates.W_Angle = 90.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.coordinates.U_Mirror = true
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.coordinates.V_Mirror = false
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.coordinates.U_Tile = false
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.coordinates.V_Tile = true
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.gradient_ramp.flag__1.color = color 177 29 15
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.gradient_ramp.flag__3.color = color 207 121 27
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Map2.Map1.gradient_ramp.flag__2.color = color 219 165 57
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Mask = Noise name:"Color_Mask" Type:1
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Mask.size = 1.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Mask.thresholdHigh = 0.701
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Mask.thresholdLow = 0.2
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map1.Mask.coords.Tiling = [1.0, 1.0, 0.6]
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2 = Gradient_ramp name:"Base_Color2"
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.coordinates.W_Angle = 90.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.coordinates.U_Mirror = true
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.coordinates.V_Mirror = false
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.coordinates.U_Tile = false
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.coordinates.V_Tile = true
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.coordinates.V_Tiling = 3.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.gradient_ramp.flag__1.color = color 177 29 15
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.gradient_ramp.flag__3.color = color 207 121 27
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.gradient_ramp.flag__2.color = color 219 165 57
		   meditMaterials[activeMeditSlot].texmap_diffuse.Map2.gradient_ramp.flag__3.position = 32.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask = Gradient_ramp name:"Base_Mix"
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.gradient_ramp.flag__1.color = color 0 0 0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.gradient_ramp.flag__2.color = color 0 0 0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.gradient_ramp.flag__3.color = color 255 255 255
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.gradient_ramp.flag__3.position = 50.0
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.coordinates.U_Tiling = 6
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.amount = 0.12
		   meditMaterials[activeMeditSlot].texmap_diffuse.Mask.size = 0.2
		   meditMaterials[activeMeditSlot].Reflection = color 109 109 109
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.6
		   meditMaterials[activeMeditSlot].reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
		on b_plum pressed do
		(
		   meditMaterials[activeMeditSlot] = Blend name:"Organic: Plum"
		   meditMaterials[activeMeditSlot].Map1 = VrayMtl name:"DiffColor"
		   meditMaterials[activeMeditSlot].Map1.Reflection = color 60 60 60
		   meditMaterials[activeMeditSlot].Map1.reflection_glossiness = 0.75
		   meditMaterials[activeMeditSlot].Map1.reflection_subdivs = 35
		   meditMaterials[activeMeditSlot].Map1.reflection_fresnel = on
		   meditMaterials[activeMeditSlot].Map1.reflection_lockIOR = off
		   meditMaterials[activeMeditSlot].Map1.reflection_ior = 3.2
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse = Mix name:"Mix_base"
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1 = Cellular name:"Cell_base1"
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.cell_color = color 7 3 4
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.division_color1 = color 3 1 1
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.division_color2 = color 3 2 2
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.size = 1.0
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.spread = 0.65
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.smooth = 0.0
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.lowthresh = 0.2
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.midthresh = 0.66
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map1.highthresh = 0.8
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2 = Cellular name:"Cell_base2"
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.cell_color = color 2 1 3
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.division_color1 = color 3 1 1
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.division_color2 = color 41 23 29
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.size = 1.0
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.spread = 0.65
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.smooth = 0.0
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.lowthresh = 0.2
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.midthresh = 0.66
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.Map2.highthresh = 0.8
		   meditMaterials[activeMeditSlot].Map1.texmap_diffuse.mixAmount = 20.0
		   meditMaterials[activeMeditSlot].Map1.brdf_type = 1
		   meditMaterials[activeMeditSlot].Map2 = VrayMtl name:"Co_01"
		   meditMaterials[activeMeditSlot].Map2.Diffuse = color 51 67 130
		   meditMaterials[activeMeditSlot].Map2.Reflection = color 34 34 34
		   meditMaterials[activeMeditSlot].Map2.reflection_glossiness = 0.6
		   meditMaterials[activeMeditSlot].Map2.reflection_subdivs = 16
		   meditMaterials[activeMeditSlot].Map2.reflection_fresnel = on
		   meditMaterials[activeMeditSlot].Map2.brdf_type = 1
		   meditMaterials[activeMeditSlot].Mask = Noise name:"MSK_01" type:1 thresholdLow:0.36 thresholdHigh:1.0 levels:4.0 phase:18.5 size:30.0
		   meditMaterials[activeMeditSlot].Mask.coords.blur = 0.2
		)
		on b_skin pressed do
		(
		   meditMaterials[activeMeditSlot] = VrayMtl ()
		   meditMaterials[activeMeditSlot].name = "Organic: Basic Skin"
		   meditMaterials[activeMeditSlot].Diffuse = color 216 165 130
		   meditMaterials[activeMeditSlot].Reflection = color 4 4 4
		   meditMaterials[activeMeditSlot].reflection_glossiness = 0.4
		   meditMaterials[activeMeditSlot].reflection_subdivs = 24
		   meditMaterials[activeMeditSlot].reflection_fresnel = on
		   meditMaterials[activeMeditSlot].reflection_lockIOR = on
		   meditMaterials[activeMeditSlot].reflection_maxDepth = 10
		   meditMaterials[activeMeditSlot].Refraction = color 124 124 124
		   meditMaterials[activeMeditSlot].refraction_glossiness = 0.3
		   meditMaterials[activeMeditSlot].refraction_subdivs = 24
		   meditMaterials[activeMeditSlot].refraction_ior = 1.62
		   meditMaterials[activeMeditSlot].refraction_maxDepth = 10
		   meditMaterials[activeMeditSlot].refraction_fogColor = color 185 131 90
		   meditMaterials[activeMeditSlot].refraction_fogMult = 0.1
		   meditMaterials[activeMeditSlot].translucency_type = 1
		   meditMaterials[activeMeditSlot].translucency_thickness = 100.0
		   meditMaterials[activeMeditSlot].translucency_scatterCoeff = 0.0
		   meditMaterials[activeMeditSlot].translucency_fbCoeff = 0.5
		   meditMaterials[activeMeditSlot].translucency_multiplier = 3.5
		   meditMaterials[activeMeditSlot].brdf_type = 1
		)
	)

rollout h "常用"
	(
		button b_ao_ov "实木地板(低)" pos:[10,10] width:112 height:20
		button b_clay_ov "实木地板(中)" pos:[10,34] width:112 height:20
		button b_ghost_ov "实木地板(高)" pos:[10,58] width:112 height:20
		button b_wire_ov "实木家具" pos:[10,82] width:112 height:20
		button b_ghwire_ov "墙纸" pos:[10,106] width:112 height:20
		button b_vraytoon_ov "皮革" pos:[10,130] width:112 height:20
		button b_vraytoon_ov1 "床单" pos:[10,154] width:112 height:20
		button b_vraytoon_ov2 "地毯" pos:[10,178] width:112 height:20
		button b_vraytoon_ov3 "等待添加..." pos:[10,202] width:112 height:20
		
		on b_ao_ov pressed do
		(
           meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "实木地板(低)"
           meditMaterials[activeMeditSlot].Diffuse = color 60 60 60
           meditMaterials[activeMeditSlot].texmap_diffuse = RGB_Tint ()
           meditMaterials[activeMeditSlot].texmap_diffuse.red = color 72 36 7
           meditMaterials[activeMeditSlot].texmap_diffuse.green = color 47 15 0
           meditMaterials[activeMeditSlot].texmap_diffuse.blue = color 47 32 25
           meditMaterials[activeMeditSlot].texmap_diffuse.map1 = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10.jpg"
           meditMaterials[activeMeditSlot].texmap_diffuse.map1.alphaSource = 2
           meditMaterials[activeMeditSlot].Reflection = color 173 173 173
           meditMaterials[activeMeditSlot].reflection_glossiness = 0.7
           meditMaterials[activeMeditSlot].reflection_subdivs = 25
           meditMaterials[activeMeditSlot].reflection_fresnel = on
           meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_reflect.jpg"
           meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_hilightGlossiness = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_reflect.jpg"
           meditMaterials[activeMeditSlot].texmap_hilightGlossiness.alphaSource = 2
           meditMaterials[activeMeditSlot].refraction_ior = 3
           meditMaterials[activeMeditSlot].texmap_bump_multiplier = 40
           meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_bump.jpg"
           meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_displacement_multiplier = 4
		   meditMaterials[activeMeditSlot].texmap_hilightGlossiness_multiplier = 50
		)
		on b_clay_ov pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "实木地板(中)"
           meditMaterials[activeMeditSlot].Diffuse = color 60 60 60
           meditMaterials[activeMeditSlot].texmap_diffuse = RGB_Tint ()
           meditMaterials[activeMeditSlot].texmap_diffuse.red = color 72 36 7
           meditMaterials[activeMeditSlot].texmap_diffuse.green = color 47 15 0
           meditMaterials[activeMeditSlot].texmap_diffuse.blue = color 47 32 25
           meditMaterials[activeMeditSlot].texmap_diffuse.map1 = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10.jpg"
           meditMaterials[activeMeditSlot].texmap_diffuse.map1.alphaSource = 2
           meditMaterials[activeMeditSlot].Reflection = color 173 173 173
           meditMaterials[activeMeditSlot].reflection_glossiness = 0.8
           meditMaterials[activeMeditSlot].reflection_subdivs = 25
           meditMaterials[activeMeditSlot].reflection_fresnel = on
           meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_reflect.jpg"
           meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_hilightGlossiness = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_reflect.jpg"
           meditMaterials[activeMeditSlot].texmap_hilightGlossiness.alphaSource = 2
           meditMaterials[activeMeditSlot].refraction_ior = 3
           meditMaterials[activeMeditSlot].texmap_bump_multiplier = 40
           meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_bump.jpg"
           meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_displacement_multiplier = 4
		   meditMaterials[activeMeditSlot].texmap_hilightGlossiness_multiplier = 50
		)
		on b_ghost_ov pressed do
		(
		   meditMaterials[activeMeditSlot] = VRayMtl ()
           meditMaterials[activeMeditSlot].name = "实木地板(高)"
           meditMaterials[activeMeditSlot].Diffuse = color 60 60 60
           meditMaterials[activeMeditSlot].texmap_diffuse = RGB_Tint ()
           meditMaterials[activeMeditSlot].texmap_diffuse.red = color 72 36 7
           meditMaterials[activeMeditSlot].texmap_diffuse.green = color 47 15 0
           meditMaterials[activeMeditSlot].texmap_diffuse.blue = color 47 32 25
           meditMaterials[activeMeditSlot].texmap_diffuse.map1 = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10.jpg"
           meditMaterials[activeMeditSlot].texmap_diffuse.map1.alphaSource = 2
           meditMaterials[activeMeditSlot].Reflection = color 173 173 173
           meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
           meditMaterials[activeMeditSlot].reflection_subdivs = 25
           meditMaterials[activeMeditSlot].reflection_fresnel = on
           meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_reflect.jpg"
           meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_hilightGlossiness = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_reflect.jpg"
           meditMaterials[activeMeditSlot].texmap_hilightGlossiness.alphaSource = 2
           meditMaterials[activeMeditSlot].refraction_ior = 3
           meditMaterials[activeMeditSlot].texmap_bump_multiplier = 40
           meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\as2_wood_10_bump.jpg"
           meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
           meditMaterials[activeMeditSlot].texmap_displacement_multiplier = 4
		   meditMaterials[activeMeditSlot].texmap_hilightGlossiness_multiplier = 50
		)
		on b_wire_ov pressed do
		(
			meditMaterials[activeMeditSlot] = VRayMtl ()
			meditMaterials[activeMeditSlot].name = "实木家具"
			meditMaterials[activeMeditSlot].texmap_diffuse = Bitmaptexture fileName:"D:\vraymaps\as2_wood_27.JPG"
			meditMaterials[activeMeditSlot].texmap_diffuse.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\AS2_wood_27_spec.jpg"
			meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].reflection_glossiness = 0.95
			meditMaterials[activeMeditSlot].reflection_maxDepth = 25
			meditMaterials[activeMeditSlot].reflection_subdivs = 25
			meditMaterials[activeMeditSlot].reflection_maxDepth = 20
			meditMaterials[activeMeditSlot].reflection_fresnel = on
			meditMaterials[activeMeditSlot].refraction_glossiness = 0.9
			meditMaterials[activeMeditSlot].refraction_subdivs = 25
			meditMaterials[activeMeditSlot].refraction_maxDepth = 20
			meditMaterials[activeMeditSlot].refraction_ior = 2.5
			meditMaterials[activeMeditSlot].refraction_affectShadows = on
			meditMaterials[activeMeditSlot].refraction_affectAlpha = on
			meditMaterials[activeMeditSlot].refraction_fogMult = 0.2
			meditMaterials[activeMeditSlot].brdf_type = 2
			meditMaterials[activeMeditSlot].texmap_bump_multiplier = 20
			meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\as2_wood_27_bump.jpg"
			meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
		)
		on b_ghwire_ov pressed do
		(
			meditMaterials[activeMeditSlot] = VRayMtl ()
			meditMaterials[activeMeditSlot].name = "墙纸"
			meditMaterials[activeMeditSlot].texmap_diffuse = Bitmaptexture fileName:"D:\vraymaps\AS2_wallpaper_01.jpg"
			meditMaterials[activeMeditSlot].texmap_diffuse.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].Reflection = color 25 25 25
			meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\as2_wallpaper_01_reflect.jpg"
			meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].reflection_glossiness = 0.9
			meditMaterials[activeMeditSlot].reflection_subdivs = 30
			meditMaterials[activeMeditSlot].brdf_type = 2
			meditMaterials[activeMeditSlot].texmap_reflection_multiplier = 50
			meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\as2_wallpaper_01_reflect.jpg"
			meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
		)
		on b_vraytoon_ov pressed do
		(
			meditMaterials[activeMeditSlot] = VRayMtl ()
			meditMaterials[activeMeditSlot].name = "皮革"
			meditMaterials[activeMeditSlot].Diffuse = color 149 23 23
			meditMaterials[activeMeditSlot].Reflection = color 0 0 0
			meditMaterials[activeMeditSlot].texmap_reflection = Bitmaptexture fileName:"D:\vraymaps\as2_leather_02.JPG"
			meditMaterials[activeMeditSlot].texmap_reflection.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].reflection_glossiness = 0.8
			meditMaterials[activeMeditSlot].reflection_subdivs = 25
			meditMaterials[activeMeditSlot].reflection_fresnel = on
			meditMaterials[activeMeditSlot].texmap_reflectionGlossiness = Bitmaptexture fileName:"D:\vraymaps\AS2_leather_02.jpg"
			meditMaterials[activeMeditSlot].texmap_reflectionGlossiness.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].refraction_ior = 2.5
			meditMaterials[activeMeditSlot].brdf_type = 2
			meditMaterials[activeMeditSlot].texmap_reflection_multiplier = 80
			meditMaterials[activeMeditSlot].texmap_bump = Bitmaptexture fileName:"D:\vraymaps\as2_leather_02.jpg"
			meditMaterials[activeMeditSlot].texmap_bump.alphaSource = 2
		)
		on b_vraytoon_ov1 pressed do
		(
			meditMaterials[activeMeditSlot] = VRayMtl ()
			meditMaterials[activeMeditSlot].name = "床单"
			meditMaterials[activeMeditSlot].Diffuse = color 0 0 0
			meditMaterials[activeMeditSlot].texmap_diffuse = Bitmaptexture fileName:"D:\vraymaps\AS2_cloth_01.jpg"
			meditMaterials[activeMeditSlot].texmap_diffuse.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].Reflection = color 23 23 23
			meditMaterials[activeMeditSlot].reflection_glossiness = 0.8
			meditMaterials[activeMeditSlot].reflection_subdivs = 25
			meditMaterials[activeMeditSlot].reflection_fresnel = on
			meditMaterials[activeMeditSlot].refraction_ior = 2.5
			meditMaterials[activeMeditSlot].brdf_type = 2
			meditMaterials[activeMeditSlot].texmap_bump_multiplier = 100

		)
		on b_vraytoon_ov2 pressed do
		(
			meditMaterials[activeMeditSlot] = VRayMtl ()
			meditMaterials[activeMeditSlot].name = "地毯"
			meditMaterials[activeMeditSlot].Diffuse = color 55 118 20
			meditMaterials[activeMeditSlot].texmap_diffuse = Bitmaptexture fileName:"D:\vraymaps\as2_carpet_01.JPG"
			meditMaterials[activeMeditSlot].texmap_diffuse.alphaSource = 2
			meditMaterials[activeMeditSlot].DirectX_Manager.enabled = off
			meditMaterials[activeMeditSlot].reflection_fresnel = on
			meditMaterials[activeMeditSlot].reflection_subdivs = 25
			meditMaterials[activeMeditSlot].refraction_ior = 2.5
			meditMaterials[activeMeditSlot].brdf_type = 2
			meditMaterials[activeMeditSlot].texmap_bump_multiplier = 300
			meditMaterials[activeMeditSlot].texmap_displacement_multiplier = 5
			meditMaterials[activeMeditSlot].texmap_displacement = Bitmaptexture fileName:"D:\vraymaps\AS2_carpet_01_disp.jpg"
			meditMaterials[activeMeditSlot].texmap_displacement.alphaSource = 2

		)
		
	)

rollout l "About and credits"
	(
		label lbl1 "Vray材质库" pos:[33,7] width:155 height:20
		label lbl3 "随行-2010" pos:[33,27] width:155 height:20
		HyperLink homepage "QQ:925041419" pos:[33,47] width:110 height:15 address:"http://user.qzone.qq.com/925041419" color:(color 255 255 255) hovercolor:(color 255 255 255) visitedcolor:(color 255 255 255)
		label lbl10 "有问题联系我" pos:[30,67] width:134 height:15
		HyperLink homepage2 "设计导航" pos:[33,87] width:115 height:15 address:"http://www.sj1122.com/" color:(color 255 255 255) hovercolor:(color 255 255 255) visitedcolor:(color 255 255 255)
	)

if av_Mtl != undefined then CloseRolloutFloater av_Mtl
av_Mtl = newrolloutfloater "Vray材质库" 148 168 get_av_Mtl_dialog_pos_x get_av_Mtl_dialog_pos_y

addRollout a av_Mtl rolledUp:true
addRollout b av_Mtl rolledUp:true
addRollout c av_Mtl rolledUp:true
addRollout d av_Mtl rolledUp:true
addRollout f av_Mtl rolledUp:true
addRollout g av_Mtl rolledUp:true
addRollout h av_Mtl rolledUp:true
addRollout l av_Mtl rolledUp:true
)