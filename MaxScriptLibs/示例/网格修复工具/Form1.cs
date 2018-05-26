using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace 网格修复工具
{
    public partial class Form1 : Form
    {
        //实例化一个点列表对象
        PointList points = new PointList();

        //定义一个三角形列表对象，并将三角形列表对象初始化为null，作为后续条件
        TriangleList triangles = null;
        public Form1()
        {
            InitializeComponent();
        }

        //点击左键
        private void panel_MouseDown(object sender, MouseEventArgs e)
        {
            //GDI+定义画图对象
            Image map = new Bitmap(panel.Width, panel.Height);
            Graphics g = Graphics.FromImage(map);
            //画线对象
            Pen linePen = new Pen(Color.Black, 2);
            //画点对象
            Pen pointPen = new Pen(Color.Red, 2);

            //实例化点对象
            Point newPoint = new Point(e.X, e.Y);
            //将点对象加入点列表中
            points.pointList.Add(newPoint);



            //当点数大于三时，实例化对象并调构造函数，存入点，创建三角形
            if (points.pointList.Count > 2)
            {
                Construction_TIN delaunay = new Construction_TIN(this.points);
                //此时triangles不再是null
                triangles = delaunay.Triangle_const();
            }

            //遍历点列表，画点
            for (int j = 0; j < points.Count; j++)
            {
                g.DrawEllipse(pointPen, points[j].X, points[j].Y, 2f, 2f);
            }

            //如果三角形列表不为空，画出三角形的边
            if (triangles != null)
            {
                for (int i = 0; i < triangles.Count; i++)
                {
                    Triangle triangle = triangles[i];
                    g.DrawLine(linePen, triangle.Edge1.pa.X, triangle.Edge1.pa.Y, triangle.Edge1.pb.X, triangle.Edge1.pb.Y);
                    g.DrawLine(linePen, triangle.Edge2.pa.X, triangle.Edge2.pa.Y, triangle.Edge2.pb.X, triangle.Edge2.pb.Y);
                    g.DrawLine(linePen, triangle.Edge3.pa.X, triangle.Edge3.pa.Y, triangle.Edge3.pb.X, triangle.Edge3.pb.Y);
                }
            }

            //返回给面板，重绘面板，用于显示
            this.panel.BackgroundImage = map;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            points = new PointList();
            triangles = null;
            this.panel.BackgroundImage = null;
        }
    }
}


/*
 Form1
public partial class TIN_Board : Form
    {
        public TIN_Board()
        {
            InitializeComponent();
        }

        //实例化一个点列表对象
        PointList points = new PointList();

        //定义一个三角形列表对象，并将三角形列表对象初始化为null，作为后续条件
        TriangleList triangles=null;



        //点击左键
        private void panel_MouseDown(object sender, MouseEventArgs e)
        {
            //GDI+定义画图对象
            Image map = new Bitmap(panel.Width, panel.Height) ;
            Graphics g = Graphics.FromImage(map);
            //画线对象
            Pen linePen = new Pen(Color.Black, 2);
            //画点对象
            Pen pointPen = new Pen(Color.Red, 2);

            //实例化点对象
            Point newPoint = new Point(e.X, e.Y);
            //将点对象加入点列表中
            points.pointList.Add(newPoint);



            //当点数大于三时，实例化对象并调构造函数，存入点，创建三角形
            if (points.pointList.Count > 2)
            {
                Construction_TIN delaunay = new Construction_TIN(this.points);
                //此时triangles不再是null
                triangles = delaunay.Triangle_const();
            }

            //定义状态栏显示的三角形个数
            if (triangles == null)
            {
                this.Triangle_Count.Text = "Triangles: 0";
            }
            else
            {
                this.Triangle_Count.Text = "Triangles: " + triangles.Count;
            }

            //遍历点列表，画点
            for (int j = 0; j < points.Count; j++)
            {
                g.DrawEllipse(pointPen, points[j].X, points[j].Y, 2f, 2f);
            }

            //定义状态栏显示的三角形个数
            this.Point_Count.Text = "Point: " + this.points.Count;

            //如果三角形列表不为空，画出三角形的边
            if (triangles != null)
            {
                for (int i = 0;i < triangles.Count;i++)
                {
                    Triangle triangle = triangles[i];
                    g.DrawLine(linePen, triangle.Edge1.pa.X, triangle.Edge1.pa.Y, triangle.Edge1.pb.X, triangle.Edge1.pb.Y);
                    g.DrawLine(linePen, triangle.Edge2.pa.X, triangle.Edge2.pa.Y, triangle.Edge2.pb.X, triangle.Edge2.pb.Y);
                    g.DrawLine(linePen, triangle.Edge3.pa.X, triangle.Edge3.pa.Y, triangle.Edge3.pb.X, triangle.Edge3.pb.Y);
                }
            }

            //返回给面板，重绘面板，用于显示
            this.panel.BackgroundImage = map;

        }



        //点击清除按钮
        private void Clear_btn_Click(object sender, EventArgs e)
        {
            //重新初始化点列表（清空点列表）
            this.points = new PointList();
            //清空背景图
            this.panel.BackgroundImage = null;
            //状态栏数值清零
            this.Point_Count.Text = "Point: 0";
            this.Triangle_Count.Text = "Triangles: 0";
        }

        //点击退出按钮
        private void Exit_btn_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        //鼠标移动事件
        private void panel_MouseMove(object sender, MouseEventArgs e)
        {
            this.Coordinate.Text = e.X + " ," + e.Y;
        }
    }
 */
