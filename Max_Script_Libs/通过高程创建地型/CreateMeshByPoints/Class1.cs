using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CreateMeshByPoints
{
    class CreateTri
    {
        public static void testc(float[] pointArr)
        {
            //初始化
            Point_1.PointList = new Dictionary<int, Point_1>();
            Triangle_1.TriangleList = new List<Triangle_1>();

            //获取点集
            int pIndex = 1;
            for (int i = 0; i < pointArr.Length; i += 3)
            {
                Point_1.PointList[pIndex] = new Point_1(pointArr[i], pointArr[i + 1], pointArr[i + 2], pIndex++);
            }

            //创建超三角，加入三角集，并把顶点加入点集，索引为-1，-2，-3
            Triangle_1.SuperTriangle(Point_1.PointList.Values.ToList());

            for (int i = 0; i < Point_1.PointList.Count - 3; i++)
            {
                List<Edge_1> edges = new List<Edge_1>();
                Point_1 tagP = Point_1.PointList[i];
                for (int t = 0; t < Triangle_1.TriangleList.Count; t++)
                {
                    Triangle_1 tagT = Triangle_1.TriangleList[t];
                    if (tagT.IsInCirclecircle(tagP))
                    {
                        edges.Add(tagT.e1);
                        edges.Add(tagT.e2);
                        edges.Add(tagT.e3);
                        Triangle_1.TriangleList.Remove(tagT);
                        t--;
                    }
                }

                Dictionary<int, int> ids = new Dictionary<int, int>();
                for (int es = 0; es < edges.Count; es++)
                {
                    Edge_1 thisE = edges[es];
                    for (int eos = es + 1; eos < edges.Count; eos++)
                    {
                        Edge_1 nextE = edges[eos];
                        if ((thisE.end == nextE.end && thisE.start == nextE.start) || (thisE.start == nextE.end && thisE.end == nextE.start))
                        {
                            ids[es] = 0;
                            ids[eos] = 0;
                            break;
                        }
                    }
                }

                List<int> moveItems = ids.Keys.ToList();
                moveItems.Sort();
                for (int m = 0; m < moveItems.Count; m++)
                {
                    edges.RemoveAt(m);
                    m--;
                }

                for (int k = 0; k < edges.Count; k++)
                {
                    Triangle_1.TriangleList.Add(new Triangle_1(tagP.id, edges[k].start, edges[k].end));
                }

                for (int r = 0; r < Triangle_1.TriangleList.Count; r++)
                {
                    var t = Triangle_1.TriangleList[r];
                    if (t.A < 0 || t.B < 0 || t.C < 0)
                        Triangle_1.TriangleList.Remove(t);
                    r--;
                }
            }
        }
    }
    class Triangle_1
    {
        // 静态部分
        public static List<Triangle_1> TriangleList = new List<Triangle_1>();
        public static void SuperTriangle(List<Point_1> pointList)
        {
            //定义四个变量，存储最大最小的横纵坐标值
            float xmax = pointList[0].X;
            float ymax = pointList[0].Y;

            float xmin = pointList[0].X;
            float ymin = pointList[0].Y;

            //遍历获取最大最小坐标值
            foreach (Point_1 point in pointList)
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
            Point_1.PointList[-1] = new Point_1(xmid, ymid + 2 * d, 0, -1);
            Point_1.PointList[-2] = new Point_1(xmid + 2 * d, ymid - d, 0, -2);
            Point_1.PointList[-3] = new Point_1(xmid - 2 * d, ymid - d, 0, -3);

            //返回超三角形
            //构造函数Triangle（PointA，PointB,PointC）定义在Triangle类中
            TriangleList.Add(new Triangle_1(-1, -2, -3));
        }

        //实例部分
        public int A { get; }
        public int B { get; }
        public int C { get; }
        public Edge_1 e1 { get; }
        public Edge_1 e2 { get; }
        public Edge_1 e3 { get; }

        public float circumCirlecenterX;
        public float circumCirlecenterY;
        public double circumCirleRadius2;

        public Triangle_1(int a, int b, int c)
        {
            this.A = a;
            this.B = b;
            this.C = c;
            this.e1 = new Edge_1(A, B);
            this.e2 = new Edge_1(B, C);
            this.e3 = new Edge_1(C, A);


            //定义三角形顶点
            float x1 = Point_1.PointList[A].X;
            float y1 = Point_1.PointList[A].Y;
            float x2 = Point_1.PointList[B].X;
            float y2 = Point_1.PointList[B].Y;
            float x3 = Point_1.PointList[C].X;
            float y3 = Point_1.PointList[C].Y;

            //计算三角形外接圆圆心
            circumCirlecenterX = ((y2 - y1) * (y3 * y3 - y1 * y1 + x3 * x3 - x1 * x1) - (y3 - y1) * (y2 * y2 - y1 * y1 + x2 * x2 - x1 * x1)) / (2 * (x3 - x1) * (y2 - y1) - 2 * ((x2 - x1) * (y3 - y1)));
            circumCirlecenterY = ((x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1) - (x3 - x1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)) / (2 * (y3 - y1) * (x2 - x1) - 2 * ((y2 - y1) * (x3 - x1)));
            //计算外接圆半径的平方
            circumCirleRadius2 = Math.Pow(circumCirlecenterX - x1, 2) + Math.Pow(circumCirlecenterY - y1, 2);
        }

        //判断点是否在三角形外接圆内部
        public bool IsInCirclecircle(Point_1 Point)
        {
            //计算外接圆圆心和插入点距离的平方
            double dist2 = Math.Pow(Point.X - circumCirlecenterX, 2) + Math.Pow(Point.Y - circumCirlecenterY, 2);
            return dist2 <= circumCirleRadius2;
        }
    }
    class Edge_1
    {
        public static List<Edge_1> edgeList = new List<Edge_1>();
        public int start { get; }
        public int end { get; }
        public Edge_1(int s, int e)
        {
            start = s;
            end = e;
        }
    }
    class Point_1
    {
        public static Dictionary<int, Point_1> PointList = new Dictionary<int, Point_1>();
        public float X { get; }
        public float Y { get; }
        public float Z { get; }
        public int id { get; }
        public Point_1(float x, float y, float z, int index)
        {
            this.X = x;
            this.Y = y;
            this.Z = z;
            this.id = index;
        }
    }
}
