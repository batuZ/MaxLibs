# 3DsMax2018-SDK VS2015-C#示例

## 准备工作

	1. 创建一个C#类库，并按以下步骤设置工程属性

	2. 应用程序：
		目标框架 .NET4.6 
		输出类型 类库

	3. 成生： 
		目标平台 x64
		输出路径 {maxRoot}\bin\assemblies\
		ps:这里要向C盘写文件，所以VS要有足够的权限，否则编译会失败

	4. 调试：
		启动操作 启动外部程序 -> {maxRoot}\3dsmax.exe
		启用调试器  √ 启用本机代码调试

	5. 引用路径：
		{maxRoot} 添加到引用路径

	6. 项目引用：
		添加 Autodesk.Max, 设置 复制本地 -> False(其它引用也不需复制本地)


## Hello Max
	
#####	1. 新建一个【公开类】，命名为Loader，其中包括三个【公开静态函数】，ps:【必须项】否则插件将不能被启用
```C#
    public class Loader
    {
		public static IGlobal Global;
        public static IInterface14 Core;

    	//入口,MAX启动时先调这里初始化必要的全局变量，和插件的描述类
    	//必要函数
        public static void AssemblyMain()
        {
			Global = GlobalInterface.Instance;    //初始化全局实例

			Core = Global.COREInterface14;      
			Core.AddClass(new Descriptor());      //初始化插件描述
			//Core.AddClass(new Descriptor1());      
			//...
        }

        //带参数的入口函数，官方说法是可以带脚本，两个同时存在内有无参的启作用。
        public static void AssemblyMain(AssemblyLoader.Loader loader){}

        //走廊，初始化完成后调这里，非必要函数
        public static void AssemblyInitializationCleanup()
        {
        }

        //关闭插件时会调这里
        //必要函数
        public static void AssemblyShutdown()
        {
        }
    }
```

#####	2. 创建一个类，并继承 Autodesk.Max.Plugins.ClassDesc2 ，这是插件的描述类，包括了插件的必要属性，在初始化插件时同时被初始化
```C#
   class Descriptor : Autodesk.Max.Plugins.ClassDesc2
    {
        public override bool IsPublic
        {
            get
            {
                return true;        
            }
        }
        public override string ClassName
        {
            get
            {
                return "MyTools_test";
            }
        }
        public override SClass_ID SuperClassID
        {
            get
            {
                return SClass_ID.Gup;       //根据不同的功能需求继承不同的类
            }
        }
        public override IClass_ID ClassID
        {
            get
            {
                //为当前插件生成一个ID，用SDK\maxsdk\help\gencid.exe生成
                return Loader.a_Global.Class_ID.Create(0x413c5c0c, 0x4052b8a);
            }
        }
        public override string Category
        {
            get
            {
                return "HelloMax";
            }
        }
        //全部初始化完成，MAX启动后调Create函数，进入功能实现部份
        public override object Create(bool loading)
        {
            return new MyTool001();
        }
    }
```

#####	3. 创建一个类，并继承 SuperClassID 中所指定的父类，MAX启动完成后，或用户操作会调Start函数
```C#
    class MyTool001 : GUP
    {
        public override void Stop()
        {
        }
        public override uint Start
        {
            get
            {
                //插件界面、公共变量、实例等可以在这里初始化
                return 0;
            }
        }
    }
```

#####	4. 接口功能非常庞大，可以去查MaxSDK2018的[C++帮助文档](http://help.autodesk.com/view/3DSMAX/2018/ENU/?guid=__cpp_ref_index_html)

##### 其它资料：
    
    [MAX SDK之插件概述（一）](https://blog.csdn.net/duanwuqing/article/details/5461977)
    [MAX SDK之基本概念（二）](https://blog.csdn.net/duanwuqing/article/details/5464407)
    [MAX SDK之对象处理（三）](https://blog.csdn.net/duanwuqing/article/details/5467266)
    [MAX SDK之对象处理（三）-（3.3 网格对象）](https://blog.csdn.net/duanwuqing/article/details/5470346)
    [MAX SDK之对象处理（三）-（3.4 材质对象）](https://blog.csdn.net/duanwuqing/article/details/5477837)
    [MAX SDK网格专题](https://blog.csdn.net/duanwuqing/article/details/5477155)