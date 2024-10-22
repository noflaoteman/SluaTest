using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 自定义sv类 用于节约性能 通过缓存池创建复用对象
/// </summary>
public class CustomSV
{
    //履带对象  需要通过它得到可视范围的位置  还要把动态创建的格子设置为它的子对象
    private RectTransform content;
    //可视范围高
    private int viewPortH;

    //当前显示的格子对象
    private Dictionary<int, GameObject> nowShowItems = new Dictionary<int, GameObject>();

    //数据来源
    private List<object> items; // 这里改为 object 以便存储任意类型数据

    //记录上一次显示的索引范围
    private int oldMinIndex = -1;
    private int oldMaxIndex = -1;

    //格子的间隔宽高
    private int itemW;
    private int itemH;

    //格子的列数
    private int col;

    //预设体资源的路径
    private string itemResName;

    /// <summary>
    /// 初始化所有参数
    /// </summary>
    /// <param name="name">格子资源路径</param>
    /// <param name="trans">Content父对象</param>
    /// <param name="h">可视范围高度</param>
    /// <param name="items">数据来源</param>
    /// <param name="w">格子宽度</param>
    /// <param name="h">格子高度</param>
    /// <param name="col">每行列数</param>
    public void Init(string name, RectTransform trans, int h, List<object> items, int w, int h, int col)
    {
        itemResName = name;
        content = trans;
        viewPortH = h;
        this.items = items;
        itemW = w;
        itemH = h;
        this.col = col;

        // 初始化Content的高度
        content.sizeDelta = new Vector2(0, Mathf.CeilToInt(items.Count / col) * itemH);
    }

    /// <summary>
    /// 更新格子显示的方法
    /// </summary>
    public void CheckShowOrHide()
    {
        // 检测哪些格子应该显示出来
        int minIndex = (int)(content.anchoredPosition.y / itemH) * col;
        int maxIndex = (int)((content.anchoredPosition.y + viewPortH) / itemH) * col + col - 1;

        // 最小值判断
        if (minIndex < 0)
            minIndex = 0;

        // 超出道具最大数量
        if (maxIndex >= items.Count)
            maxIndex = items.Count - 1;

        if (minIndex != oldMinIndex || maxIndex != oldMaxIndex)
        {
            // 删除上一节溢出
            for (int i = oldMinIndex; i < minIndex; ++i)
            {
                if (nowShowItems.ContainsKey(i))
                {
                    if (nowShowItems[i] != null)
                        PoolMgr.GetInstance().PushObj(itemResName, nowShowItems[i]);
                    nowShowItems.Remove(i);
                }
            }
            // 删除下一节溢出
            for (int i = maxIndex + 1; i <= oldMaxIndex; ++i)
            {
                if (nowShowItems.ContainsKey(i))
                {
                    if (nowShowItems[i] != null)
                        PoolMgr.GetInstance().PushObj(itemResName, nowShowItems[i]);
                    nowShowItems.Remove(i);
                }
            }
        }

        oldMinIndex = minIndex;
        oldMaxIndex = maxIndex;

        // 创建指定索引范围内的格子
        for (int i = minIndex; i <= maxIndex; ++i)
        {
            if (nowShowItems.ContainsKey(i))
                continue;

            // 根据这个关键索引 用来设置位置 初始化道具信息
            int index = i;
            nowShowItems.Add(index, null);
            PoolMgr.GetInstance().GetObj(itemResName, (obj) =>
            {
                // 当格子创建出来后我们要做什么
                obj.transform.SetParent(content);
                obj.transform.localScale = Vector3.one;
                obj.transform.localPosition = new Vector3((index % col) * itemW, -index / col * itemH, 0);
                obj.GetComponent<ItemBase>().InitInfo(items[index]); // 这里需要修改为具体的类名

                // 判断有没有这个坑
                if (nowShowItems.ContainsKey(index))
                    nowShowItems[index] = obj;
                else
                    PoolMgr.GetInstance().PushObj(itemResName, obj);
            });
        }
    }
}
