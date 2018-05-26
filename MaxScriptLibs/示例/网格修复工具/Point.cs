using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace 网格修复工具
{
    //点类和点列表类
    class Point
    {
        //成员有两个——点的坐标
        public float X { get; private set; }
        public float Y { get; private set; }
        public float Z { get;  set; }
        public int ids { get;  set; }
        //构造函数：初始化点的成员
        public Point(float x, float y, float z = 0, int id = -1)
        {
            this.X = x;
            this.Y = y;
            this.Z = z;
            this.ids = id;
        }

        //方法：判断两个点是否重合，重合返回true，否则返回false
        public bool EqualPoints(Point newPoint)
        {
            const float tolerance = 0.00001f;
            if (Math.Abs(this.X - newPoint.X) < tolerance && Math.Abs(this.Y - newPoint.Y) < tolerance)
            {
                return true;
            }
            return false;
        }

    }



    //点列表的定义
    class PointList
    {
        //泛型，定义点列表
        public List<Point> pointList = new List<Point>();

        //将第i个单个点存入点列表
        public Point this[int i] { get { return pointList[i]; } }

        //定义变量Count用于存储点列表长度
        public int Count { get { return this.pointList.Count; } }

        //遍历所有已经点过的点，获取超三角形
        public Triangle SuperTriangle()
        {
            //定义四个变量，存储最大最小的横纵坐标值
            float xmax = this.pointList[0].X;
            float ymax = this.pointList[0].Y;

            float xmin = this.pointList[0].X;
            float ymin = this.pointList[0].Y;

            //遍历获取最大最小坐标值
            foreach (Point point in this.pointList)
            {
                if (point.X > xmax)
                {
                    xmax = point.X;
                }
                if (point.Y > ymax)
                {
                    ymax = point.Y;
                }
                if (point.X < xmin)
                {
                    xmin = point.X;
                }
                if (point.Y < ymin)
                {
                    ymin = point.Y;
                }
            }

            //用获取的最大最小横纵坐标值定义超三角形的三个顶点坐标
            //为保证能“包住”所有点，方法如此，不知怎么解释，不解释
            float dx = xmax - xmin;
            float dy = ymax - ymin;
            float d = (dx > dy) ? dx : dy;

            float xmid = (xmin + xmax) * 0.5f;
            float ymid = (ymin + ymax) * 0.5f;

            //用点类的构造函数定义超三角形三个顶点，并赋值
            Point superTA = new Point(xmid, ymid + 2 * d);
            Point superTB = new Point(xmid + 2 * d, ymid - d);
            Point superTC = new Point(xmid - 2 * d, ymid - d);

            //返回超三角形
            //构造函数Triangle（PointA，PointB,PointC）定义在Triangle类中
            return new Triangle(superTA, superTB, superTC);
        }
    }
}
