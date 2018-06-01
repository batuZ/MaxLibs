using Autodesk.Max;
using Autodesk.Max.Plugins;
using System;

namespace TestPlugin
{
    // 程序出入口
    public class Loader
    {
        public static IGlobal Global;
        public static IInterface14 Core;

        public static void AssemblyMain()
        {
            Global = GlobalInterface.Instance;    //初始化全局实例
            Core = Global.COREInterface14;
            Core.AddClass(new Descriptor());      //初始化插件描述
        }
        public static void AssemblyShutdown() { }
    }

    // 插件描述类，提供此类会对插件进行管理分类，最后通过Create进入插件主体
    class Descriptor : ClassDesc2
    {
        // 全部初始化完成，MAX启动后调Create函数，进入功能实现部份
        public override object Create(bool loading) { return new Tool_A(); }
        public override bool IsPublic { get { return true; } }
        public override string Category { get { return "HelloMax"; } }
        public override string ClassName { get { return "MyTools"; } }

        // 根据不同的功能需求继承不同的类  
        public override SClass_ID SuperClassID { get { return SClass_ID.Gup; } }

        // 为当前插件生成一个ID，用SDK\maxsdk\help\gencid.exe生成
        public override IClass_ID ClassID { get { return Loader.Global.Class_ID.Create(0x413c5c0c, 0x4052b8a); } }
    }
    public class Test_ActionItem : ActionItem
    {
        // -------------  借口部份 ------------------
        public override bool ExecuteAction()
        {
            Execute_Action();
            return true;
        }
        public override int Id_ { get { return _Id_; } }
        public override string ButtonText { get { return _ButtonText; } }
        public override string MenuText { get { return _MenuText; } }
        public override string DescriptionText { get { return _DescriptionText; } }
        public override string CategoryText { get { return _CategoryText; } }
        public override bool IsChecked_ { get { return _IsChecked_; } }
        public override bool IsItemVisible { get { return _IsItemVisible; } }
        public override bool IsEnabled_ { get { return _IsEnabled_; } }

        // ------------------ 二次封装 ---------------------
        public event Action Execute_Action = () => { };
        int _Id_;
        bool _IsChecked_;
        bool _IsItemVisible;
        bool _IsEnabled_;
        string _ButtonText;
        string _MenuText;
        string _DescriptionText;
        string _CategoryText;
        public Test_ActionItem(
            string MenuText,
            string DescriptionText = "DescriptionText",
            string ButtonText = "ButtonText",
            string CategoryText = "CategoryText",
            int Id_ = 1,
            bool IsChecked_ = false,
            bool IsItemVisible = true,
            bool IsEnabled_ = true
            )
        {
            _Id_ = Id_;
            _IsChecked_ = IsChecked_;
            _IsItemVisible = IsItemVisible;
            _IsEnabled_ = IsEnabled_;
            _ButtonText = ButtonText;
            _MenuText = MenuText;
            _DescriptionText = DescriptionText;
            _CategoryText = CategoryText;
        }
    }
    public class Callback : ActionCallback { }


    // 插件出入口
    class Tool_A : GUP
    {
        IIMenu MenuBox;
        IIMenuItem MenuBoxItem;
        IIMenuManager menuManager;
        IActionTable actionTable;
        Callback cBack = new Callback();
        uint idActionTable;
        public override uint Start
        {
            get
            {
                // Set up global actions
                IIActionManager actionManager = Loader.Core.ActionManager;
                idActionTable = (uint)actionManager.NumActionTables;
                string actionTableName = "Test Actions";
                actionTable = Loader.Global.ActionTable.Create(idActionTable, 0, ref actionTableName);

                Test_ActionItem ta1 = new Test_ActionItem("Test1_task", "第一个action");
                ta1.Execute_Action += () =>
                {
                    // 点击事件，可以启动Max以后持进程调试 ...
                };
                Test_ActionItem ta2 = new Test_ActionItem("Test2_task", "第二个action");
                ta2.Execute_Action += () => { };
                Test_ActionItem ta3 = new Test_ActionItem("Test3_task", "第三个action");
                ta3.Execute_Action += () => { };

                actionTable.AppendOperation(ta1);
                actionTable.AppendOperation(ta2);
                actionTable.AppendOperation(ta3);
                actionManager.RegisterActionTable(actionTable);
                actionManager.ActivateActionTable(new Callback(), idActionTable);

                // Set up menu
                menuManager = Loader.Core.MenuManager;
                string mainMenu = "&SDK Test Menu";
                //cleanup menu
                MenuBox = menuManager.FindMenu(mainMenu);
                if (MenuBox != null)
                {
                    menuManager.UnRegisterMenu(MenuBox);
                    Loader.Global.ReleaseIMenu(MenuBox);
                    MenuBox = null;
                }

                // Main menu
                MenuBox = Loader.Global.IMenu;
                MenuBox.Title = mainMenu;
                menuManager.RegisterMenu(MenuBox, 0);

                // sub menu
                for (int i = 0; i < actionTable.Count; i++)
                {
                    IActionItem action = actionTable[i];
                    IIMenuItem mItem = Loader.Global.IMenuItem;
                    mItem.Title = action.ButtonText;
                    mItem.ActionItem = action;
                    MenuBox.AddItem(mItem, -1);
                }

                //MenuBox -> MenuBoxItem -> MainMenuBar
                MenuBoxItem = Loader.Global.IMenuItem;
                MenuBoxItem.SubMenu = MenuBox;
                menuManager.MainMenuBar.AddItem(MenuBoxItem, -1);
                Loader.Global.COREInterface.MenuManager.UpdateMenuBar();

                return 0;
            }
        }

        public override void Stop()
        { ///释放部份还没完成
            try
            {
                // Close exporter form manually
                //if (babylonExportActionItem != null)
                //{
                //    babylonExportActionItem.Close();
                //}

                if (actionTable != null)
                {
                    Loader.Global.COREInterface.ActionManager.DeactivateActionTable(actionCallback, idActionTable);
                }

                // Clean up menu
                if (MenuBox != null)
                {
                    Loader.Global.COREInterface.MenuManager.UnRegisterMenu(MenuBox);
                    Loader.Global.ReleaseIMenu(MenuBox);
                    Loader.Global.ReleaseIMenuItem(MenuBoxItem);

                    MenuBox = null;
                    MenuBoxItem = null;
                }
            }
            catch
            {
                // Fails silently
            }
        }
    }
}