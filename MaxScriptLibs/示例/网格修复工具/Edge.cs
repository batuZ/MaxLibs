using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace 网格修复工具
{
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
    }
}
