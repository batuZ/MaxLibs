using OSGeo.GDAL;
using OSGeo.OGR;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace 网格修复工具
{
    class GetPointGroup
    {
        private Geometry geom;
        //private Envelope enve;
        private List<Point> outP;
        public List<Point> mapP;
        public GetPointGroup(string txtPaht, string demPaht, double yuZhi,string inDOM,string outMap)
        {
            outP = getOutFromTXT(txtPaht);
            mapP = getMap(demPaht, yuZhi);
            mapP.AddRange(outP);
            setID();
            getDom(inDOM, outMap);
        }
        /// <summary>
        /// 从文本中拿到轮廓线上的点
        /// </summary>
        /// <param name="txtFile"></param>
        /// <returns></returns>
        List<Point> getOutFromTXT(string txtFile)
        {
            List<Point> outP = new List<Point>();
            string[] lines = System.IO.File.ReadAllLines(txtFile);
            foreach (string line in lines)
            {
                int a = line.IndexOf(",");
                int b = line.LastIndexOf(",");
                int c = line.Length;
                string str1 = line.Substring(1, a - 1);
                string str2 = line.Substring(a + 1, b - a - 1);
                string str3 = line.Substring(b + 1, c - b - 2);
                Point temp = new Point((float)Convert.ToDouble(str1), (float)Convert.ToDouble(str2), (float)Convert.ToDouble(str3));
                outP.Add(temp);
            }
            toShp(outP);
            return outP;
        }
        void toShp(List<Point> mapP)
        {
            geom = new Geometry(wkbGeometryType.wkbPolygon);
            Geometry subGeom = new Geometry(wkbGeometryType.wkbLinearRing);
            for (int i = 0; i < mapP.Count; i++)
            {
                subGeom.AddPoint(mapP[i].X, mapP[i].Y, mapP[i].Z);
            }
            subGeom.AddPoint(mapP[0].X, mapP[0].Y, mapP[0].Z);
            geom.AddGeometry(subGeom);
            subGeom.Dispose();
        }

        /// <summary>
        /// 拿图像高程生成的点
        /// </summary>
        /// <param name="mapFile"></param>
        /// <returns></returns>
        List<Point> getMap(string demFile, double yuZhi)
        {
            Envelope enve = new Envelope();
            geom.GetEnvelope(enve);
            List<Point> mapP = new List<Point>();
            double xSize = enve.MaxX - enve.MinX;
            double ySize = enve.MaxY - enve.MinY;
            int xCount = (int)(xSize / yuZhi);
            int yCount = (int)(ySize / yuZhi);
            for (int i = 0; i < yCount; i++)
            {
                for (int j = 0; j < xCount; j++)
                {
                    float x = (float)(enve.MinX + yuZhi * j);
                    float y = (float)(enve.MinY + yuZhi * i);
                    float z = 6;
                    Point temp = new Point(x, y, z);

                    Geometry pointGeom = new Geometry(wkbGeometryType.wkbPoint);
                    pointGeom.AddPoint(x, y, z);
                    if (pointGeom.Within(geom))
                        mapP.Add(temp);
                }
            }
            getDemH(demFile, mapP);
            return mapP;
        }
        void getDemH(string demPath, List<Point> mapP)
        {
            Gdal.AllRegister();
            Dataset ds = Gdal.Open(demPath, Access.GA_ReadOnly);
            double[] geoTrans = new double[6];
            ds.GetGeoTransform(geoTrans);
            Band band = ds.GetRasterBand(1);
            for (int i = 0; i < mapP.Count; i++)
            {
                double x = mapP[i].X;
                double y = mapP[i].Y;
                int xoff, yoff;
                Tools.geoToImageSpace(geoTrans, x, y, out xoff, out yoff);
                double[] values = new double[1];
                band.ReadRaster(xoff, yoff, 1, 1, values, 1, 1, 0, 0);
                mapP[i].Z = (float)values[0];
            }
            ds.Dispose();
        }
        void setID()
        {
            int s = mapP.Count;
            for (int i = 0; i < s; i++)
            {
                mapP[i].ids = i;
            }
        }
     

        /// <summary>
        /// 从影像拿到帖图
        /// </summary>
        /// <param name="inMapPath"></param>
        /// <param name="saveMapPath"></param>
        void getDom(string inMapPath, string saveMapPath)
        {
            Gdal.AllRegister();
            Dataset ds = Gdal.Open(inMapPath, Access.GA_ReadOnly);
            double[] geoTran = new double[6];
            ds.GetGeoTransform(geoTran);

            Envelope enve = new Envelope();
            geom.GetEnvelope(enve);
            int xoff, yoff, xend, yend, xSize, ySize;
            Tools.geoToImageSpace(geoTran, enve.MinX, enve.MaxY, out xoff, out yoff);
            Tools.geoToImageSpace(geoTran, enve.MaxX, enve.MinY, out xend, out yend);
            xSize = xend - xoff;
            ySize = yend - yoff;
            if (File.Exists(saveMapPath))
                File.Delete(saveMapPath);
            OSGeo.GDAL.Driver dr = Gdal.GetDriverByName("GTiff");
            Dataset outDs = dr.Create(saveMapPath, xSize, ySize, 3, DataType.GDT_UInt16, null);
            
            for (int i = 1; i <= ds.RasterCount; i++)
            {
                double[] values = new double[xSize * ySize];
                ds.GetRasterBand(i).ReadRaster(xoff, yoff, xSize, ySize, values, xSize, ySize, 0, 0);
                outDs.GetRasterBand(i).WriteRaster(0, 0, xSize, ySize, values, xSize, ySize, 0, 0);
            }
            ds.Dispose();
            outDs.Dispose();
        }
    }
    class Tools
    {
        /*******************************TransFrom 与坐标转换**************************************************/

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
    }
}
