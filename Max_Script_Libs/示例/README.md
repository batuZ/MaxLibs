# 3D Max脚本 功能助记

### 文件操作

##### 加密脚本
将在目标脚本相同目录下产生一个同名的mse文件
```maxscript
	encryptScript @"E:\code\MAXScript\test.ms"
```

##### 引用另一个脚本
```maxscript
	fileinRes = undefind
	try fileinRes = fileIn "load1.ms" catch messagebox "引入失败"失败
	if fileinRes == OK then(
		-- use function in load1.ms
		)
```

##### 打开、导入文件
```maxscript 
	filePaths = getFiles @"E:\test\5-1-3.fbm\*.fbx"
	loadMAXFile f  
	importFile f #noPrompt 
```

##### 输出信息
```maxscript
msg = "E:\MAXScript"
print msg
format "% \n" msg
```

##### 写出文件
```maxscript
	fileStrea = CreateFile @"C:\NewTest.txt"
	if fileStrea == undefined then messagebox "无法创建文档"
	else (
		msg = "abcdef..."
		format "%\n" msg to:fileStrea
		close fileStrea
		messagebox "OK"
		)
```


### 选择

### 创建

