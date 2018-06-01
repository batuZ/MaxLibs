fn Extrud val  =
(
try
(modPanel.addModToSelection (Extrude ()) ui:on
	$.modifiers[#Extrude].amount = val)
catch
($.modifiers[#Extrude].amount = val)
)


MacroScript Extrude50
ButtonText:"Extrude50"
Category:"模型工具"
Tooltip:"Extrude50"
(
on execute do Extrud 50
)

MacroScript Extrude100
ButtonText:"Extrude100"
Category:"模型工具"
Tooltip:"Extrude100"
(
on execute do Extrud 100
)

MacroScript Extrude150
ButtonText:"Extrude150"
Category:"模型工具"
Tooltip:"Extrude150"
(
on execute do Extrud 150
)

MacroScript Extrude200
ButtonText:"Extrude200"
Category:"模型工具"
Tooltip:"Extrude200"
(
on execute do Extrud 200
)

MacroScript Extrude240
ButtonText:"Extrude240"
Category:"模型工具"
Tooltip:"Extrude240"
(
on execute do Extrud 240
)

MacroScript Extrude250
ButtonText:"Extrude250"
Category:"模型工具"
Tooltip:"Extrude250"
(
on execute do Extrud 250
)

MacroScript Extrude300
ButtonText:"Extrude300"
Category:"模型工具"
Tooltip:"Extrude300"
(
on execute do Extrud 300
)





