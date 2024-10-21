using UnityEngine;
using System.IO;
using SLua;
using System;
using UnityEngine.UIElements;

[CustomLuaClassAttribute] 
public class Init : MonoBehaviour
{

    private LuaFunction _luaStart = null;
    private LuaFunction _luaUpdate = null;
    private LuaFunction _luaLateUpdate = null;
    private LuaFunction _luaFixedUpdate = null;
    private LuaFunction _luaAwake = null;
    private LuaFunction _luaOnDisable = null;
    private LuaFunction _luaOnDestroy = null;

    static public Action MouseButtonAction;
    static public Action MouseButtonDownAction;
    static public Action MouseButtonUpAction;
    static public Action<float> MouseAxisMoveAction;
    
    static public RaycastHit[] RaycastAll(Ray ray) {
        return Physics.RaycastAll(ray);
    }

    private void Awake()
    {
        LuaSvr svr = new LuaSvr();// 如果不先进行某个LuaSvr的初始化的话,下面的mianState会爆一个为null的错误..
        LuaSvr.mainState.loaderDelegate += CustonLoader;
        svr.init(null, () => // 如果不用init方法初始化的话,在Lua中是不能import的
        {
            svr.start("Main");
            _luaAwake = LuaSvr.mainState.getFunction("Awake");
            _luaStart = LuaSvr.mainState.getFunction("Start");
            _luaFixedUpdate = LuaSvr.mainState.getFunction("FixedUpdate");
            _luaUpdate = LuaSvr.mainState.getFunction("Update");
            _luaLateUpdate = LuaSvr.mainState.getFunction("LateUpdate");
            _luaOnDisable = LuaSvr.mainState.getFunction("OnDisable");
            _luaOnDestroy = LuaSvr.mainState.getFunction("OnDestroy");
        });
        if (_luaAwake != null)
        {
            _luaAwake.call();
        }
    }

    private void Start()
    {

        if (_luaStart != null)
        {
            _luaStart.call();
        }
    }

    void FixedUpdate()
    {
        if (_luaFixedUpdate != null)
        {
            _luaFixedUpdate.call();
        }
    }


    void Update()
    {
        if (_luaUpdate != null)
        {
            _luaUpdate.call();
        }

        if (Input.GetMouseButton(0)) 
        {
            MouseButtonAction?.Invoke();
        }
        if (Input.GetMouseButtonUp(0))
        {
            MouseButtonUpAction?.Invoke();
        }
        if (Input.GetMouseButtonDown(0))
        {
            MouseButtonDownAction?.Invoke();
        }
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (scroll != 0)
        {
            MouseAxisMoveAction(scroll);
        }
    }
    void LateUpdate()
    {
        if (_luaLateUpdate != null)
        {
            _luaLateUpdate.call();
        }
    }
    void OnDisable()
    {
        if (_luaOnDisable != null)
        {
            _luaOnDisable.call();
        }
    }
    void OnDestroy()
    {
        if (_luaOnDestroy == null)
        {
            _luaOnDestroy.call();
        }
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