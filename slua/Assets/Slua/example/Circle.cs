using UnityEngine;
using System.Collections;
using SLua;
using System;
using System.IO;

public class Circle : MonoBehaviour {
    private LuaSvr svr;//是对lua_state的一个封装
    private LuaTable selfLuaTable;
    private LuaFunction update;

    [CustomLuaClass]
    public delegate void UpdateDelegate(object self);

    UpdateDelegate udAction;

	void Start () {
		svr = new LuaSvr();
		LuaSvr.mainState.loaderDelegate = CustonLoader;

        svr.init(null, () =>
		{
			selfLuaTable = svr.start("circle") as LuaTable;
            update = selfLuaTable["update"] as LuaFunction ;
            udAction = update.cast<UpdateDelegate>();
		});
	}
	
	void Update () {
        if (udAction != null) udAction(selfLuaTable);
	}

    /// <summary>
    /// 重定向脚本路径
    /// </summary>
    /// <param name="fileName"></param>
    /// <param name="absoluteFn"></param>
    /// <returns></returns>
	public byte[] CustonLoader(string fileName, ref string absoluteFn) 
	{
        string path = Application.dataPath + "/Lua/" + fileName + ".lua";
        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        else
            Debug.Log("MyCustomLoader重定向失败");
        return null;
	}
}
