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
        public double[] points;
        public int[] ids;
        public bool CreateMesh(double[] pointArr)
        {
            bool res = false;
            if (pointArr != null && pointArr.Length > 0 && pointArr.Length % 3 == 0)
            {
                //初始化
                Point.PointList = new Dictionary<int, Point>();
                Triangle.TriangleList = new List<Triangle>();

                //获取点集
                int pIndex = 1;
                for (int i = 0; i < pointArr.Length; i += 3)
                {
                    Point.PointList[pIndex] = new Point(pointArr[i], pointArr[i + 1], pointArr[i + 2], pIndex++);
                }

                CreateTri.testc();

                if (Triangle.TriangleList.Count > 0)
                {
                    List<int> temp = new List<int>();
                    for (int i = 0; i < Triangle.TriangleList.Count; i++)
                    {
                        temp.Add(Triangle.TriangleList[i].A);
                        temp.Add(Triangle.TriangleList[i].B);
                        temp.Add(Triangle.TriangleList[i].C);
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
            List<double> points = new List<double>();
            //判断数据是否可用
            int FeatCount = layer.GetFeatureCount(0);
            wkbGeometryType geoType = layer.GetLayerDefn().GetGeomFieldDefn(0).GetFieldType();
            if (FeatCount > 2 && geoType.ToString().Contains("wkbPoint"))
            {
                int indexZ = layer.GetLayerDefn().GetFieldIndex("Z");
                if (indexZ > -1)    //优先使用 Z 字段
                {
                    for (int i = 0; i < FeatCount - 1; i++)
                    {
                        points.Add(layer.GetFeature(i).GetGeometryRef().GetX(0));
                        points.Add(layer.GetFeature(i).GetGeometryRef().GetY(0));
                        points.Add(layer.GetFeature(i).GetFieldAsDouble(indexZ));
                    }
                }
                else if (geoType == wkbGeometryType.wkbPoint25D)
                {
                    for (int i = 0; i < FeatCount; i++)
                    {
                        points.Add(layer.GetFeature(i).GetGeometryRef().GetX(0));
                        points.Add(layer.GetFeature(i).GetGeometryRef().GetY(0));
                        points.Add(layer.GetFeature(i).GetGeometryRef().GetZ(0));
                    }
                }
            }
            ds.Dispose();
            return CreateMesh(points.ToArray());
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
    static class CreateTri
    {
        public static void testc()
        {
            //创建超三角，加入三角集，并把顶点加入点集，索引为-1，-2，-3
            Triangle.SuperTriangle(Point.PointList.Values.ToList());

            //遍历除超三角（索引小于0）外所有的点，使用点ID为索引，从1开始
            for (int i = 0; i < Point.PointList.Count - 3; i++)
            {
                //当前点
                Point tagP = Point.PointList[i + 1];

                //边集，把所有与当前点有关的三角上的边塞入
                List<Edge> edges = new List<Edge>();

                //遍历已创建的所有三角形，如果点在外接圆内，则把自己的三个边塞入边集 
                for (int t = 0; t < Triangle.TriangleList.Count; t++)
                {
                    Triangle tagT = Triangle.TriangleList[t];
                    if (tagT.IsInCirclecircle(tagP))
                    {
                        edges.AddRange(new Edge[] { tagT.e1, tagT.e2, tagT.e3 });
                        //从三角集中移除，避免重复
                        Triangle.TriangleList.Remove(tagT);
                        t--;
                    }
                }

                //处理边集，任意两个边如果重合，则两个全部移除掉
                Dictionary<int, int> ids = new Dictionary<int, int>();
                for (int es = 0; es < edges.Count; es++)
                {
                    for (int eos = es + 1; eos < edges.Count; eos++)
                    {
                        if (edges[es].isSame(edges[eos]))
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
                    edges.RemoveAt(moveItems[m] - m);
                }

                //用当前点与所有剩下的边分别创建三角形，并塞入三角集
                for (int k = 0; k < edges.Count; k++)
                {
                    Triangle.TriangleList.Add(new Triangle(tagP.id, edges[k]));
                }
            }

            //完成所有点处理后，需要清理与超三角有关的三角
            Triangle.RemoveSupers();
        }
    }
    class Triangle
    {
        // 静态部分
        public static List<Triangle> TriangleList = new List<Triangle>();
        //创建超三角
        public static void SuperTriangle(List<Point> pointList)
        {
            //定义四个变量，存储最大最小的横纵坐标值
            double xmax = pointList[0].X;
            double ymax = pointList[0].Y;

            double xmin = pointList[0].X;
            double ymin = pointList[0].Y;

            //遍历获取最大最小坐标值
            foreach (Point point in pointList)
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
            double dx = xmax - xmin;
            double dy = ymax - ymin;
            double d = (dx > dy) ? dx : dy;

            double xmid = (xmin + xmax) * 0.5;
            double ymid = (ymin + ymax) * 0.5;

            //用点类的构造函数定义超三角形三个顶点，并赋值
            Point.PointList[-1] = new Point(xmid, ymid + 2 * d, 0, -1);
            Point.PointList[-2] = new Point(xmid + 2 * d, ymid - d, 0, -2);
            Point.PointList[-3] = new Point(xmid - 2 * d, ymid - d, 0, -3);

            //返回超三角形
            //构造函数Triangle（PointA，PointB,PointC）定义在Triangle类中
            TriangleList.Add(new Triangle(-1, -2, -3));
        }
        //移除与超三角有关的三角
        public static void RemoveSupers()
        {
            //三角中有任意一点属于超三角的，移除！
            for (int i = 0; i < TriangleList.Count; i++)
            {
                var t = TriangleList[i];
                if (t.A < 0 || t.B < 0 || t.C < 0)
                {
                    TriangleList.Remove(t);
                    i--;
                }
            }
        }

        //实例部分
        public int A { get; }
        public int B { get; }
        public int C { get; }
        public Edge e1 { get; }
        public Edge e2 { get; }
        public Edge e3 { get; }

        public double circumCirlecenterX;
        public double circumCirlecenterY;
        public double circumCirleRadius2;

        public Triangle(int a, int b, int c)
        {
            this.A = a;
            this.B = b;
            this.C = c;
            this.e1 = new Edge(A, B);
            this.e2 = new Edge(B, C);
            this.e3 = new Edge(C, A);

            //定义三角形顶点
            double x1 = Point.PointList[A].X;
            double y1 = Point.PointList[A].Y;
            double x2 = Point.PointList[B].X;
            double y2 = Point.PointList[B].Y;
            double x3 = Point.PointList[C].X;
            double y3 = Point.PointList[C].Y;
            //计算三角形外接圆圆心
            circumCirlecenterX = ((y2 - y1) * (y3 * y3 - y1 * y1 + x3 * x3 - x1 * x1) - (y3 - y1) * (y2 * y2 - y1 * y1 + x2 * x2 - x1 * x1)) / (2 * (x3 - x1) * (y2 - y1) - 2 * ((x2 - x1) * (y3 - y1)));
            circumCirlecenterY = ((x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1) - (x3 - x1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)) / (2 * (y3 - y1) * (x2 - x1) - 2 * ((y2 - y1) * (x3 - x1)));
            //计算外接圆半径的平方
            circumCirleRadius2 = Math.Pow(circumCirlecenterX - x1, 2) + Math.Pow(circumCirlecenterY - y1, 2);
        }
        public Triangle(int a, Edge e) : this(a, e.start, e.end) { }
        //判断点是否在三角形外接圆内部
        public bool IsInCirclecircle(Point Point)
        {
            //计算外接圆圆心和插入点距离的平方
            return Math.Pow(Point.X - circumCirlecenterX, 2) + Math.Pow(Point.Y - circumCirlecenterY, 2) <= circumCirleRadius2;
        }
    }
    class Edge
    {
        public static List<Edge> edgeList = new List<Edge>();
        public int start { get; }
        public int end { get; }
        public Edge(int s, int e)
        {
            start = s;
            end = e;
        }
        public bool isSame(Edge other)
        {
            return (start == other.start && end == other.end) || (end == other.start && start == other.end);
        }
    }
    class Point
    {
        public static Dictionary<int, Point> PointList = new Dictionary<int, Point>();
        public double X { get; }
        public double Y { get; }
        public double Z { get; }
        public int id { get; }
        public Point(double x, double y, double z, int index)
        {
            this.X = x;
            this.Y = y;
            this.Z = z;
            this.id = index;
        }
    }
    #endregion
}
