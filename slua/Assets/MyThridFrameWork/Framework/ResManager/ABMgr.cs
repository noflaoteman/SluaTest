using SLua;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

/// <summary>
/// AB加载器，使用单例模式，无需泛型或基类
/// </summary>
[CustomLuaClass]
public class ABMgr : MonoBehaviour
{
    public delegate bool ActionGoCallback(UnityEngine.Object go);
    public ActionGoCallback callback;


    private static ABMgr instance;

    public static ABMgr Instance
    {
        get
        {
            if (instance == null)
            {
                GameObject obj = new GameObject("ABMgr");
                instance = obj.AddComponent<ABMgr>();
                DontDestroyOnLoad(obj); // 防止在场景切换时销毁
            }
            return instance;
        }
    }

    public AssetBundle _mainAB = null;
    public AssetBundleManifest _manifest = null;

    public Dictionary<string, AssetBundle> _abDic = new Dictionary<string, AssetBundle>();

    public string _PathUrl
    {
        get
        {
            // 注意：发布时需修改路径，开发阶段可使用此路径
            return Application.streamingAssetsPath + "/";
        }
    }

    public string _MainName
    {
        get
        {
#if UNITY_IOS
            return "IOS";
#elif UNITY_ANDROID
            return "Android";
#else
            return "PC";
#endif
        }
    }

    public void LoadMainAB()
    {
        if (_mainAB == null)
        {
            _mainAB = AssetBundle.LoadFromFile(_PathUrl + _MainName);
            _manifest = _mainAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    public void LoadResAsyncByType(string abName, string resName, System.Type type, ActionGoCallback callBack, bool isSync = false)
    {
        StartCoroutine(ReallyLoadResAsync(abName, resName, type, callBack, isSync));
    }

    public IEnumerator ReallyLoadResAsync(string abName, string resName, System.Type type, ActionGoCallback callBack, bool isSync)
    {
        LoadMainAB();
        string[] dependencies = _manifest.GetAllDependencies(abName);

        // 加载依赖的AssetBundle
        foreach (string dep in dependencies)
        {
            if (!_abDic.ContainsKey(dep))
            {
                if (isSync)
                {
                    AssetBundle ab = AssetBundle.LoadFromFile(_PathUrl + dep);
                    _abDic.Add(dep, ab);
                }
                else
                {
                    _abDic.Add(dep, null);
                    AssetBundleCreateRequest req = AssetBundle.LoadFromFileAsync(_PathUrl + dep);
                    yield return req;
                    _abDic[dep] = req.assetBundle;
                }
            }
            else
            {
                while (_abDic[dep] == null)
                {
                    yield return null;
                }
            }
        }

        // 加载指定的AssetBundle
        if (!_abDic.ContainsKey(abName))
        {
            if (isSync)
            {
                AssetBundle ab = AssetBundle.LoadFromFile(_PathUrl + abName);
                _abDic.Add(abName, ab);
            }
            else
            {
                _abDic.Add(abName, null);
                AssetBundleCreateRequest req = AssetBundle.LoadFromFileAsync(_PathUrl + abName);
                yield return req;
                _abDic[abName] = req.assetBundle;
            }
        }
        else
        {
            while (_abDic[abName] == null)
            {
                yield return null;
            }
        }

        // 同步或异步加载资源
        if (isSync)
        {
            UnityEngine.Object res = _abDic[abName].LoadAsset(resName, type);
            callBack(res);
        }
        else
        {
            AssetBundleRequest abq = _abDic[abName].LoadAssetAsync(resName, type);
            yield return abq;
            callBack(abq.asset);
        }
    }

    public void UnLoadAB(string name, UnityAction<bool> callBackResult)
    {
        if (_abDic.ContainsKey(name))
        {
            if (_abDic[name] == null)
            {
                callBackResult(false);
                return;
            }
            _abDic[name].Unload(false);
            _abDic.Remove(name);
            callBackResult(true);
        }
    }

    public void ClearAB()
    {
        StopAllCoroutines();
        AssetBundle.UnloadAllAssetBundles(false);
        _abDic.Clear();
        _mainAB = null;
    }
}
