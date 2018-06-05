using OSGeo.GDAL;
using OSGeo.OGR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CreateMeshByPoints
{
    public class ToTIN
    {
        #region 处理栅格
        Dataset ds;
        double[] trans;
        float[] values;
        public float[] getOutBox(string filePath)
        {
            Gdal.AllRegister();
            ds = Gdal.Open(filePath, Access.GA_ReadOnly);
            trans = new double[6];
            ds.GetGeoTransform(trans);
            values = new float[ds.RasterXSize * ds.RasterYSize];
            Band band = ds.GetRasterBand(1);
            band.ReadRaster(0, 0, ds.RasterXSize, ds.RasterYSize, values, ds.RasterXSize, ds.RasterYSize, 0, 0);
            double minx, miny, maxx, maxy;
            imageToGeoSpace(trans, 0, 0, out minx, out maxy);
            imageToGeoSpace(trans, ds.RasterXSize, ds.RasterYSize, out maxx, out miny);
            return new float[] { (float)minx, (float)miny, (float)maxx, (float)maxy };
        }
        public float getZ_byXY(float x, float y)
        {
            int p, l, index;
            geoToImageSpace(trans, x, y, out p, out l);
            p = p == ds.RasterXSize ? p - 1 : p;
            l = l == ds.RasterYSize ? l - 1 : l;
            index = imgSpaceToIndex(p, l, ds.RasterXSize);
            return values[index];
        }
        #endregion

        #region 处理点集
        public float[] points;
        public int[] ids;
        public bool CreateMesh(float[] a)
        {
            bool res = false;
            if (a != null && a.Length > 0 && a.Length % 3 == 0)
            {
                PointList pList = new PointList();
                int id = 1;
                for (int i = 0; i < a.Length; i += 3)
                {
                    Point p = new Point(a[i], a[i + 1], a[i + 2], id++);
                    pList.pointList.Add(p);
                }

                Construction_TIN ct = new Construction_TIN(pList);
                TriangleList tl = ct.Triangle_const();

                if (tl.Count > 0)
                {
                    List<int> temp = new List<int>();
                    for (int i = 0; i < tl.Count; i++)
                    {
                        temp.Add(tl[i].A.ids);
                        temp.Add(tl[i].B.ids);
                        temp.Add(tl[i].C.ids);
                    }
                    points = a;
                    ids = temp.ToArray();
                    res = true;
                }
                else res = false;
            }
            else res = false;
            return res;
        }
        public bool CreateMesh_1(float[] pointArr)
        {
            bool res = false;
            if (pointArr != null && pointArr.Length > 0 && pointArr.Length % 3 == 0)
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
                
                CreateTri.testc();

                if (Triangle_1.TriangleList.Count > 0)
                {
                    List<int> temp = new List<int>();
                    for (int i = 0; i < Triangle_1.TriangleList.Count; i++)
                    {
                        temp.Add(Triangle_1.TriangleList[i].A);
                        temp.Add(Triangle_1.TriangleList[i].B);
                        temp.Add(Triangle_1.TriangleList[i].C);
                    }
                    points = pointArr;
                    ids = temp.ToArray();
                    res = true;
                }
                else res = false;
            }
            else res = false;
            return res;
        }
        #endregion

        #region 处理shpFile
        public bool CreateFromSHP(string shpfile)
        {
            Ogr.RegisterAll();
            OSGeo.OGR.Driver dr = Ogr.GetDriverByName("ESRI shapefile");
            DataSource ds = dr.Open(shpfile, 0);
            Layer layer = ds.GetLayerByIndex(0);
            List<float> points = new List<float>();
            //判断数据是否可用
            int FeatCount = layer.GetFeatureCount(0);
            wkbGeometryType geoType = layer.GetLayerDefn().GetGeomFieldDefn(0).GetFieldType();
            if (FeatCount > 2 && geoType.ToString().Contains("wkbPoint"))
            {
                int indexZ = layer.GetLayerDefn().GetFieldIndex("Z");
                if (indexZ > -1)    //优先使用 Z 字段
                {
                    for (int i = 0; i < FeatCount; i++)
                    {
                        points.Add((float)layer.GetFeature(i).GetGeometryRef().GetX(0));
                        points.Add((float)layer.GetFeature(i).GetGeometryRef().GetY(0));
                        points.Add((float)layer.GetFeature(i).GetFieldAsDouble(indexZ));
                    }
                }
                else if (geoType == wkbGeometryType.wkbPoint25D)
                {
                    for (int i = 0; i < FeatCount; i++)
                    {
                        points.Add((float)layer.GetFeature(i).GetGeometryRef().GetX(0));
                        points.Add((float)layer.GetFeature(i).GetGeometryRef().GetY(0));
                        points.Add((float)layer.GetFeature(i).GetGeometryRef().GetZ(0));
                    }
                }
            }
            ds.Dispose();
            return CreateMesh_1(points.ToArray());
        }
        #endregion

        #region TransFrom 与坐标转换
        /// <summary>
        /// 从值数组的索引转成图像坐标
        /// </summary>
        /// <param name="index"></param>
        /// <param name="xSize"></param>
        /// <param name="pixel"></param>
        /// <param name="line"></param>
        public static void indexToImgspace(int index, int xSize, out int pixel, out int line)
        {
            pixel = (index + 1) % xSize;
            line = index / xSize;
        }
        /// <summary>
        /// 从图像坐标转成值数组的索引
        /// </summary>
        /// <param name="pixel"></param>
        /// <param name="line"></param>
        /// <param name="zSize"></param>
        /// <returns></returns>
        public static int imgSpaceToIndex(int pixel, int line, int zSize)
        {
            return line * zSize + pixel;
        }
        /// <summary>
        /// 从像素空间转换到地理空间
        /// </summary>
        /// <param name="adfGeoTransform">影像坐标变换参数</param>
        /// <param name="pixel">像素所在行</param>
        /// <param name="line">像素所在列</param>
        /// <param name="x">X</param>
        /// <param name="y">Y</param>
        public static void imageToGeoSpace(double[] m_GeoTransform, int pixel, int line, out double X, out double Y)
        {
            X = m_GeoTransform[0] + pixel * m_GeoTransform[1] + line * m_GeoTransform[2];
            Y = m_GeoTransform[3] + pixel * m_GeoTransform[4] + line * m_GeoTransform[5];
        }
        /// <summary>
        /// 从地理空间转换到像素空间
        /// </summary>
        /// <param name="adfGeoTransform">影像坐标变化参数</param>
        /// <param name="x">X</param>
        /// <param name="y">Y</param>
        /// <param name="pixel">像素所在行</param>
        /// <param name="line">像素所在列</param>
        public static void geoToImageSpace(double[] m_GeoTransform, double x, double y, out int pixel, out int line)
        {
            line = (int)((y * m_GeoTransform[1] - x * m_GeoTransform[4] + m_GeoTransform[0] * m_GeoTransform[4] - m_GeoTransform[3] * m_GeoTransform[1]) / (m_GeoTransform[5] * m_GeoTransform[1] - m_GeoTransform[2] * m_GeoTransform[4]));
            pixel = (int)((x - m_GeoTransform[0] - line * m_GeoTransform[2]) / m_GeoTransform[1]);
        }
        #endregion
    }

    #region 三角化
    // Construction_TIN核心代码
    class Construction_TIN
    {
        //声明一个点列表和一个三角形列表对象
        private PointList pointlist;
        private TriangleList triangles;

        //构造函数用于给以上声明的两个列表初始化
        public Construction_TIN(PointList points)
        {
            this.pointlist = points;
            this.triangles = new TriangleList();
        }

        //构建三角网
        public TriangleList Triangle_const()
        {

            //当点数大于等于三个时再进行三角网构建
            if (this.pointlist.Count < 3)
            {
                return null;
            }

            //点数超过两个个时，继续进行，第一步是生成超级三角形
            //调用PointList类中的SuperTriangle方法，获取超三角形
            //赋给Triangle的对象superTriangle
            Triangle superTriangle = this.pointlist.SuperTriangle();

            //将超三角形放入三角形集合（this.对象.泛型列表.对列表的操作）
            this.triangles.triangleList.Add(superTriangle);

            //定义超三角形顶点列表，仅用于装超三角形顶点
            Point[] superpoints = new Point[] { superTriangle.A, superTriangle.B, superTriangle.C };
            //遍历点列表中所有点
            for (int i = 0; i < this.pointlist.Count; i++)
            {
                //将点列表中第i点赋给新点类对象
                Point anewpoint = pointlist[i];
                //定义边列表类对象
                EdgeList edges = new EdgeList();

                //遍历形成的每个三角形，找出点所在的三角形
                for (int j = 0; j < triangles.Count; j++)
                {
                    //三角形列表对象（其外接圆包含插入点的三角形）
                    Triangle contain_triangle = triangles[j];

                    //当点在某个三角形（第j个）外接圆中
                    if (contain_triangle.IsInCirclecircle(anewpoint))
                    {
                        //将包含新插入点的三角形三条边插入边列表的末端
                        edges.edgeList.AddRange(new Edge[] { contain_triangle.Edge1, contain_triangle.Edge2, contain_triangle.Edge3 });
                        //在三角形列表中删除这个三角形
                        this.triangles.triangleList.Remove(contain_triangle);
                        //三角形列表减少一个，指针后退
                        j--;
                    }
                }
                //在边列表中删除重复边
                edges.RemoveDiagonal(2);
                //将新插点与所有边连接成三角形
                for (int m = 0; m < edges.Count; m++)
                {
                    this.triangles.triangleList.Add(new Triangle(anewpoint, edges[m]));
                }
            }
            // 遍历超级三角形的顶点，并删除超级三角形
            foreach (Point sp_point in superpoints)
            {
                // 寻找包含超级三角形顶点的三角形，存入“被删三角形列表”
                List<Triangle> rmvTriangles = this.triangles.FindByPoint(sp_point);

                // 判断“被删三角形列表”是否为空
                if (rmvTriangles != null)
                {
                    // 遍历被删三角形集合
                    foreach (Triangle rmvTriangle in rmvTriangles)
                    {
                        // 移除被删三角形
                        this.triangles.Remove(rmvTriangle);
                    }
                }
            }
            //返回三角形列表
            return this.triangles;

        }
    }
    //点类和点列表类
    class Point
    {
        //成员有两个——点的坐标
        public float X { get; private set; }
        public float Y { get; private set; }
        public float Z { get; set; }
        public int ids { get; set; }
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
    //边类和边列表类
    class Edge
    {
        //边成员声明并初始化
        public Point pa { get; private set; }
        public Point pb { get; private set; }

        //边类构造函数
        public Edge(Point pa, Point pb)
        {
            this.pa = pa;
            this.pb = pb;
        }

        //判断两条边是否相等（重合）
        public bool EqualsEdge(Edge other)
        {
            if ((this.pa.Equals(other.pa) && this.pb.Equals(other.pb))
                || (this.pa.Equals(other.pb) && this.pb.Equals(other.pa)))
            {
                return true;
            }

            return false;
        }
    }
    //边列表
    class EdgeList
    {
        //定义边列表
        public List<Edge> edgeList = new List<Edge>();

        public int Count { get { return this.edgeList.Count; } }

        public Edge this[int i] { get { return this.edgeList[i]; } }

        //删除重合边，并将重合边在列表中的序号存入indexList列表
        public void RemoveDiagonal()
        {
            List<int> indexList = new List<int>();

            for (int i = 0; i < this.edgeList.Count; i++)
            {
                for (int j = i + 1; j < this.edgeList.Count; j++)
                {
                    if (this.edgeList[i].EqualsEdge(this.edgeList[j]))
                    {
                        indexList.Add(i);
                        indexList.Add(j);
                        break;
                    }
                }
            }
            //排序
            indexList.Sort();
            //反序
            indexList.Reverse();
            //先删后画出的重合边
            foreach (int i in indexList)
            {
                this.edgeList.RemoveAt(i);
            }
        }
        public void RemoveDiagonal(int m)
        {
            List<Edge> indexList = new List<Edge>();

            for (int i = 0; i < this.edgeList.Count; i++)
            {
                for (int j = i + 1; j < this.edgeList.Count; j++)
                {
                    if (this.edgeList[i].EqualsEdge(this.edgeList[j]))
                    {
                        indexList.Add(edgeList[i]);
                        indexList.Add(edgeList[j]);
                        break;
                    }

                }
            }
            foreach (var i in indexList)
            {
                this.edgeList.Remove(i);
            }
        }
    }
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
    #endregion
}
