using SLua;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

/// <summary>
/// AB加载器
/// </summary>
[CustomLuaClass]
public class ABMgr : SingletonAutoMono<ABMgr>
{
    private AssetBundle _mainAB = null;
    private AssetBundleManifest _manifest = null;

    private Dictionary<string, AssetBundle> _abDic = new Dictionary<string, AssetBundle>();

    private string _PathUrl
    {
        get
        {
            //注意注意!!!注意注意!!!注意注意!!!注意注意!!!注意注意!!!
            //若发布使用这个路径会有问题,开发情况下默认情况可以使用该路径
            //发布时候,ab包的路径可能会从服务器下到Application.persistentDataPath中
            return Application.streamingAssetsPath + "/";
        }
    }

    private string _MainName
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

    private void LoadMainAB()
    {
        if( _mainAB == null )
        {
            _mainAB = AssetBundle.LoadFromFile( _PathUrl + _MainName);
            _manifest = _mainAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }
    }

    private void LoadDependencies(string abName)
    {
        LoadMainAB();
        string[] dependStrabName = _manifest.GetAllDependencies(abName);
        for (int i = 0; i < dependStrabName.Length; i++)
        {
            if (!_abDic.ContainsKey(dependStrabName[i]))
            {
                AssetBundle ab = AssetBundle.LoadFromFile(_PathUrl + dependStrabName[i]);
                _abDic.Add(dependStrabName[i], ab);
            }
        }
    }

    public void LoadResAsync<T>(string abName, string resName, UnityAction<T> callBack, bool isSync = false) where T:Object
    {
        StartCoroutine(ReallyLoadResAsync<T>(abName, resName, callBack, isSync));
    }
    private IEnumerator ReallyLoadResAsync<T>(string abName, string resName, UnityAction<T> callBack, bool isSync) where T : Object
    {
        LoadMainAB();
        string[] dependStrs = _manifest.GetAllDependencies(abName);
        for (int i = 0; i < dependStrs.Length; i++)
        {
            if (!_abDic.ContainsKey(dependStrs[i]))
            {
                if(isSync)
                {
                    AssetBundle ab = AssetBundle.LoadFromFile(_PathUrl + dependStrs[i]);
                    _abDic.Add(dependStrs[i], ab);
                }
                else
                {
                    _abDic.Add(dependStrs[i], null);
                    AssetBundleCreateRequest req = AssetBundle.LoadFromFileAsync(_PathUrl + dependStrs[i]);
                    yield return req;
                    _abDic[dependStrs[i]] = req.assetBundle;
                }
            }
            else
            {
                while (_abDic[dependStrs[i]] == null)
                {
                    yield return 0;
                }
            }
        }

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
                yield return 0;
            }
        }

        if(isSync)
        {
            T res = _abDic[abName].LoadAsset<T>(resName);
            callBack(res);
        }
        else
        {
            AssetBundleRequest abq = _abDic[abName].LoadAssetAsync<T>(resName);
            yield return abq;
            callBack(abq.asset as T);
        }
    }

    public void LoadResAsyncByType(string abName, string resName, System.Type type, UnityAction<Object> callBack, bool isSync = false)
    {
        StartCoroutine(ReallyLoadResAsync(abName, resName, type, callBack, isSync));
    }
    private IEnumerator ReallyLoadResAsync(string abName, string resName, System.Type type, UnityAction<Object> callBack, bool isSync)
    {
        LoadMainAB();
        string[] strs = _manifest.GetAllDependencies(abName);
        for (int i = 0; i < strs.Length; i++)
        {
            if (!_abDic.ContainsKey(strs[i]))
            {
                if (isSync)
                {
                    AssetBundle ab = AssetBundle.LoadFromFile(_PathUrl + strs[i]);
                    _abDic.Add(strs[i], ab);
                }
                else
                {
                    _abDic.Add(strs[i], null);
                    AssetBundleCreateRequest req = AssetBundle.LoadFromFileAsync(_PathUrl + strs[i]);
                    yield return req;
                    _abDic[strs[i]] = req.assetBundle;
                }
            }
            else
            {
                while (_abDic[strs[i]] == null)
                {
                    yield return 0;
                }
            }
        }
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
                yield return 0;
            }
        }

        if(isSync)
        {
            Object res = _abDic[abName].LoadAsset(resName, type);
            callBack(res);
        }
        else
        {
            AssetBundleRequest abq = _abDic[abName].LoadAssetAsync(resName, type);
            yield return abq;

            callBack(abq.asset);
        }
        
    }

    public void LoadResAsync(string abName, string resName, UnityAction<Object> callBack, bool isSync = false)
    {
        StartCoroutine(ReallyLoadResAsync(abName, resName, callBack, isSync));
    }
    private IEnumerator ReallyLoadResAsync(string abName, string resName, UnityAction<Object> callBack, bool isSync)
    {
        LoadMainAB();
        string[] strs = _manifest.GetAllDependencies(abName);
        for (int i = 0; i < strs.Length; i++)
        {
            if (!_abDic.ContainsKey(strs[i]))
            {
                if (isSync)
                {
                    AssetBundle ab = AssetBundle.LoadFromFile(_PathUrl + strs[i]);
                    _abDic.Add(strs[i], ab);
                }
                else
                {
                    _abDic.Add(strs[i], null);
                    AssetBundleCreateRequest req = AssetBundle.LoadFromFileAsync(_PathUrl + strs[i]);
                    yield return req;
                    _abDic[strs[i]] = req.assetBundle;
                }
            }
            else
            {
                while (_abDic[strs[i]] == null)
                {
                    yield return 0;
                }
            }
        }
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
                yield return 0;
            }
        }

        if(isSync)
        {
            Object obj = _abDic[abName].LoadAsset(resName);
            callBack(obj);
        }
        else
        {
            AssetBundleRequest abq = _abDic[abName].LoadAssetAsync(resName);
            yield return abq;

            callBack(abq.asset);
        }

    }

    public void UnLoadAB(string name, UnityAction<bool> callBackResult)
    {
        if( _abDic.ContainsKey(name) )
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
