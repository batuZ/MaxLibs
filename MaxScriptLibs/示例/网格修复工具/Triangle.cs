using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace 网格修复工具
{
    //三角形类及三角形列表类 
    class Triangle
    {
        //定义三角形类中点成员
        public Point A { get; private set; }
        public Point B { get; private set; }
        public Point C { get; private set; }

        //定义三角形类中的边成员
        public Edge Edge1 { get; private set; }
        public Edge Edge2 { get; private set; }
        public Edge Edge3 { get; private set; }

        //定义三角形外接圆及其半径平方
        public float circumCirlecenterX;
        public float circumCirlecenterY;
        public double circumCirleRadius2;

        //构造函数由点构成边，由点构成三角形
        public Triangle(Point A, Point B, Point C)
        {
            this.A = A;
            this.B = B;
            this.C = C;
          
            this.Edge1 = new Edge(A, B);
            this.Edge2 = new Edge(B, C);
            this.Edge3 = new Edge(C, A);
        }

        //构造函数“重载”，由点和边构成三角形
        public Triangle(Point point, Edge edge)
            : this(point, edge.pa, edge.pb)
        {
        }

        //判断点是否在三角形外接圆内部
        public bool IsInCirclecircle(Point Point)
        {
            //定义三角形顶点
            float x1, x2, x3, y1, y2, y3;

            //两点之间距离的平方
            double dist2;
            x1 = this.A.X;
            y1 = this.A.Y;
            x2 = this.B.X;
            y2 = this.B.Y;
            x3 = this.C.X;
            y3 = this.C.Y;

            //计算三角形外接圆圆心
            circumCirlecenterX = ((y2 - y1) * (y3 * y3 - y1 * y1 + x3 * x3 - x1 * x1) - (y3 - y1) * (y2 * y2 - y1 * y1 + x2 * x2 - x1 * x1)) / (2 * (x3 - x1) * (y2 - y1) - 2 * ((x2 - x1) * (y3 - y1)));
            circumCirlecenterY = ((x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1) - (x3 - x1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)) / (2 * (y3 - y1) * (x2 - x1) - 2 * ((y2 - y1) * (x3 - x1)));
            //计算外接圆半径的平方
            circumCirleRadius2
                = Math.Pow(circumCirlecenterX - x1, 2)
                + Math.Pow(circumCirlecenterY - y1, 2);
            //计算外接圆圆心和插入点距离的平方
            dist2
                = Math.Pow(Point.X - circumCirlecenterX, 2)
                + Math.Pow(Point.Y - circumCirlecenterY, 2);

            //在外接圆内部返回真，否则返回假
            if (dist2 <= circumCirleRadius2)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        //判断某一个三角形三个顶点A、B、C是否与stPoint相等，
        //有一个相等，则说明此三角形为包含超级三角形顶点的三角形,
        //则返回真
        internal bool ContainPoint(Point stPoint)
        {
            if (this.A.EqualPoints(stPoint) || this.B.EqualPoints(stPoint) || this.C.EqualPoints(stPoint))
            {
                return true;
            }

            return false;
        }
    }

    class TriangleList
    {
        //定义三角形列表
        public List<Triangle> triangleList = new List<Triangle>();

        public Triangle this[int i] { get { return this.triangleList[i]; } }

        public int Count { get { return this.triangleList.Count; } }


        //返回包含超三角形顶点的三角形列表（除去重复的，不重复的返回）
        internal List<Triangle> FindByPoint(Point stPoint)
        {

            List<Triangle> pTriangleList = new List<Triangle>();
            //遍历三角形列表
            foreach (Triangle triangle in triangleList)
            {
                //将包含超三角形顶点的三角形加入pTriangleList列表
                if (triangle.ContainPoint(stPoint))
                {
                    pTriangleList.Add(triangle);
                }
            }
            //去掉重复三角形
            //pTriangleList.Distinct();

            return pTriangleList;
        }

        //删除列表的第一个三角形
        internal void Remove(Triangle rmvTriangle)
        {
            triangleList.Remove(rmvTriangle);
        }
    }
}
