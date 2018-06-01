(
fn buttonPressed1 a1 a2 =
(
print "1. Button Pressed - Two Arguments"
print a1
print a2
)
fn buttonPressed2 a1 =
(
print "2. Button Pressed - One Argument"
print a1
)
fn buttonPressed3 =
(
print "3. Button Pressed - No Arguments"
)
fn mouseEnter4 =
(
print "4. Mouse Entered The Button!"
)
fn mouseLeave5 =
(
print "5. Mouse Left The Button!"
)
local mButton = dotNetObject "System.windows.forms.button"
mButton.text = "Press Me"
mButton.size = dotNetObject "System.Drawing.Size" 100 100
mButton.location = dotNetObject "System.Drawing.Point" 10 10
local hForm = dotNetObject "System.Windows.Forms.Form"
hForm.size = dotNetObject "System.Drawing.Size" 120 140
hForm.controls.add mButton
dotNet.addEventHandler mButton "click" buttonPressed1
dotNet.addEventHandler mButton "click" buttonPressed2
dotNet.addEventHandler mButton "click" buttonPressed3
dotNet.addEventHandler mButton "MouseEnter" mouseEnter4
dotNet.addEventHandler mButton "MouseLeave" mouseLeave5
hForm.show()
ok
)