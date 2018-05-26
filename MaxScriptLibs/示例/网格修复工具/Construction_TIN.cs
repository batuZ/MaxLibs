using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace 网格修复工具
{
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
            Point[] superpoints
                = new Point[] { superTriangle.A, superTriangle.B, superTriangle.C }; 
            //遍历点列表中所有点
            for (int i = 0; i < this.pointlist.Count;i++ )
            {
                //将点列表中第i点赋给新点类对象
                Point anewpoint = pointlist[i];
                //定义边列表类对象
                EdgeList edges = new EdgeList();

                //遍历形成的每个三角形，找出点所在的三角形
                for (int j = 0; j < triangles.Count;j++ )
                {
                    //三角形列表对象（其外接圆包含插入点的三角形）
                    Triangle contain_triangle = triangles[j];

                    //当点在某个三角形（第j个）外接圆中
                    if(contain_triangle.IsInCirclecircle(anewpoint))
                    {
                        //将包含新插入点的三角形三条边插入边列表的末端
                        edges.edgeList.AddRange(new Edge []{contain_triangle.Edge1,contain_triangle.Edge2,contain_triangle.Edge3});
                        //在三角形列表中删除这个三角形
                        this.triangles.triangleList.Remove(contain_triangle);
                        //三角形列表减少一个，指针后退
                        j--;
                    }
                }
                //在边列表中删除重复边
                edges.RemoveDiagonal();
                //将新插点与所有边连接成三角形
                for(int m=0;m<edges.Count;m++)
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
}
