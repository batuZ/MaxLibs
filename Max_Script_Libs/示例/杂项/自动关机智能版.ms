-------------------------------------------------------------------------
----渲染完后,自动关机,60为关机时读秒数，可以自行更改。
----使用方法：找到渲染面板Common--Scripts--Post-Render点那个File然后打开此脚本，原理
----是渲染完后，调用 DOS 的 Shutdown 命令实现关机，关机过程中你可以单击取消便取消关机。
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------

rollout shd "渲染完关机" width:162 height:99
(
	label lbl1 "渲染完毕自动关机，单击取消关机退出关机。" pos:[14,9] width:142 height:31
	button btn1 "取消关机" pos:[37,50] width:86 height:30
	on shd open do
	(	doscommand "shutdown -s -f -t 200 -c 渲染完毕,自动关机:)" )
	on btn1 pressed do
	(
		doscommand "shutdown -a" 
		DestroyDialog shd
	)
)
createdialog shd pos:[(sysInfo.desktopSize[1]*0.08),(sysInfo.desktopSize[2]*0.08)]
