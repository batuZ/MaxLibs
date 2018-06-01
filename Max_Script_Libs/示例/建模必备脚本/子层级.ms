macroScript X1
category:"模型工具"
toolTip:"子层级1"

(                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
if  $selection.count==1 and numSubObjectLevels == 0
  then
    (if  isShapeObject selection[1]
        then
             ( macros.run "Modifier Stack" "Convert_to_Spline"
              macros.run "Modifier Stack" "SubObject_1")
         else
                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
                 if modPanel.getCurrentObject() != $.baseobject 
				 do modPanel.setCurrentObject $
			   if numSubObjectLevels > 0 do
                      subObjectLevel = 1)
  else 
  (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
  (if numSubObjectLevels > 0 do
      subObjectLevel = 1))

macroScript X2
category:"模型工具"
toolTip:"子层级2"
(                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
if $selection.count==1 and numSubObjectLevels == 0
  then
    (if  isShapeObject selection[1]
        then
             ( macros.run "Modifier Stack" "Convert_to_Spline"
              macros.run "Modifier Stack" "SubObject_2")
         else
                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
                 if modPanel.getCurrentObject() != $.baseobject
				 do modPanel.setCurrentObject $
			   if numSubObjectLevels > 1 do
                      subObjectLevel = 2)
  else
  (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
 ( if numSubObjectLevels > 1 do
      subObjectLevel = 2))

macroScript X3
category:"模型工具"
toolTip:"子层级3"
(                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
if $selection.count==1 and numSubObjectLevels == 0
  then
    (if  isShapeObject selection[1]
        then
             ( macros.run "Modifier Stack" "Convert_to_Spline"
              macros.run "Modifier Stack" "SubObject_3")
         else
                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
                 if modPanel.getCurrentObject() != $.baseobject
				 do modPanel.setCurrentObject $
			   if numSubObjectLevels > 2 do
                      subObjectLevel = 3)
  else 
  (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
  (if numSubObjectLevels > 2 do
      subObjectLevel = 3))
	  
macroScript X4
category:"模型工具"
toolTip:"子层级4"
(                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
if $selection.count==1 and numSubObjectLevels == 0
  then
    (if  isShapeObject selection[1]
        then
             ( macros.run "Modifier Stack" "Convert_to_Spline"
              macros.run "Modifier Stack" "SubObject_4")
         else
                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
                 if modPanel.getCurrentObject() != $.baseobject
				 do modPanel.setCurrentObject $
			   if numSubObjectLevels > 3 do
                      subObjectLevel = 4)
  else 
  (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
  (if numSubObjectLevels > 3 do
      subObjectLevel = 4))

macroScript X5
category:"模型工具"
toolTip:"子层级5"
(                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
if $selection.count==1 and numSubObjectLevels == 0
  then
    (if  isShapeObject selection[1]
        then
             ( macros.run "Modifier Stack" "Convert_to_Spline"
              macros.run "Modifier Stack" "SubObject_5")
         else
                (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
                 if modPanel.getCurrentObject() != $.baseobject
				 do modPanel.setCurrentObject $
			   if numSubObjectLevels > 4 do
                      subObjectLevel = 5)
  else 
  (if getCommandPanelTaskMode() != #modify
                 do setCommandPanelTaskMode mode:#modify)
  (if numSubObjectLevels > 4 do
      subObjectLevel = 5))


macroScript XXX
category:"模型工具"
toolTip:"退出子层级"
(if selection[1] != undefined  do
( if getCommandPanelTaskMode()==#modify 
   then (if subObjectLevel != 0 
        then(max create mode
            max modify mode)
        else clearNodeSelection())
   else clearNodeSelection ()))