using SLua;
using System;
using System.Collections.Generic;
using UnityEngine;

[CustomLuaClass]
public class PoolData
{
    private Stack<GameObject> dataStack = new Stack<GameObject>();

    private List<GameObject> usedList = new List<GameObject>();

    private int maxNum;

    private GameObject rootObj;

    public int dataCount => dataStack.Count;

    public int UsedCount => usedList.Count;

    public bool NeedCreate
    {
        get
        {
            return usedList.Count < maxNum;
        }
    }

    public PoolData(GameObject root, string name, GameObject usedObj)
    {
        if(PoolMgr.isOpenLayout)
        {
            rootObj = new GameObject(name);
            rootObj.transform.SetParent(root.transform);
        }

        PushUsedList(usedObj);

        PoolObj poolObj = usedObj.GetComponent<PoolObj>();
        if (poolObj == null)
        {
            Debug.LogError("请为使用缓存池功能的预设体对象挂载PoolObj脚本 用于设置数量上限");
            return;
        }
        maxNum = poolObj.maxNum;
    }

    public GameObject Pop()
    {
        GameObject obj;

        if (dataCount > 0)
        {
            obj = dataStack.Pop();
            usedList.Add(obj);
        }
        else
        {
            obj = usedList[0];
            usedList.RemoveAt(0);
            usedList.Add(obj);
        }

        obj.SetActive(true);
        if (PoolMgr.isOpenLayout)
            obj.transform.SetParent(null);

        return obj;
    }

    public void Push(GameObject obj)
    {
        obj.SetActive(false);
        if (PoolMgr.isOpenLayout)
            obj.transform.SetParent(rootObj.transform);
        dataStack.Push(obj);
        usedList.Remove(obj);
    }

    public void PushUsedList(GameObject obj)
    {
        usedList.Add(obj);
    }
}

[CustomLuaClass]
public abstract class PoolObjectBase { }

[CustomLuaClass]
public class PoolObject<T> : PoolObjectBase where T:class
{
    public Queue<T> poolObjs = new Queue<T>();
}

[CustomLuaClass]
public interface IPoolObject
{
    void ResetInfo();
}

[CustomLuaClass]
public class PoolMgr : BaseManager<PoolMgr>
{
    public Dictionary<string, PoolData> poolDic = new Dictionary<string, PoolData>();

    public Dictionary<string, PoolObjectBase> poolObjectDic = new Dictionary<string, PoolObjectBase>();

    public GameObject poolObj;

    public static bool isOpenLayout = true;

    public PoolMgr() {

        if (poolObj == null && isOpenLayout)
            poolObj = new GameObject("Pool");
    }

    public void GetObj(string name,Action<GameObject> callback)
    {
        if (poolObj == null && isOpenLayout)
            poolObj = new GameObject("Pool");

        GameObject obj = null;

        if(!poolDic.ContainsKey(name) ||
            (poolDic[name].dataCount == 0 && poolDic[name].NeedCreate))
        {
            ABMgr.Instance.LoadResAsync<GameObject>("prefab", "name", (go) => { 
                obj = GameObject.Instantiate<GameObject>(go); 
                obj.name = name;
                if(!poolDic.ContainsKey(name))
                    poolDic.Add(name, new PoolData(poolObj, name, obj));
                else
                    poolDic[name].PushUsedList(obj);
                callback(obj);
                }, true);
        }
        else
        {
            obj = poolDic[name].Pop();
            callback(obj);
        }
        
    }

    public void PushObj(GameObject obj)
    {
        poolDic[obj.name].Push(obj);
    }


    public void ClearPool()
    {
        poolDic.Clear();
        poolObj = null;
        poolObjectDic.Clear();
    }
}
