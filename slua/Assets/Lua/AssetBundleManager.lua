
AssetBundleManager = {}
AssetBundleManager.__index = AssetBundleManager
--lua端十分简易的AB包加载逻辑,没有处理AB包依赖问题
local loadedBundles = {}   
local loadingBundles = {}  

-- 回调方法，用于处理异步加载的逻辑
local function onAssetBundleLoaded(bundleName, assetBundle, callback)
    loadedBundles[bundleName] = assetBundle  
    loadingBundles[bundleName] = nil         
    if callback then
        callback(assetBundle)  
    end
end

-- 异步加载AB包
function AssetBundleManager.LoadAssetBundleAsync(bundleName, callback)
    if loadedBundles[bundleName] then
        if callback then
            callback(loadedBundles[bundleName])
        end
        return
    end

    if loadingBundles[bundleName] then
        table.insert(loadingBundles[bundleName], callback)
        return
    end

    loadingBundles[bundleName] = { callback }

    --利用SLua中的协程实现异步
    coroutine.wrap(function()
        --大坑!!!大坑!!!大坑!!!大坑!!!大坑!!!不能这样调用UnityEngine.AssetBundle
        local assetBundle = AssetBundle.LoadFromFileAsync(Application.streamingAssetsPath .. "/" .. bundleName)
        while not assetBundle.isDone do
            coroutine.yield()
        end

        for _, cb in ipairs(loadingBundles[bundleName]) do
            onAssetBundleLoaded(bundleName, assetBundle.assetBundle, cb)
        end
    end)()
end

-- 同步卸载指定AB包
function AssetBundleManager.UnloadAssetBundle(bundleName, unloadAllLoadedObjects)
    if loadedBundles[bundleName] then
        loadedBundles[bundleName]:Unload(unloadAllLoadedObjects)
        loadedBundles[bundleName] = nil
    end
end

-- 获取已加载的资源(若获取的ab包正在加载会报错)!!!!!!
function AssetBundleManager.GetAssetFromBundle(bundleName, assetName, assetType)
    if loadedBundles[bundleName] then
        return loadedBundles[bundleName]:LoadAsset(assetName, assetType)
    end
    return nil
end

-- 同步卸载所有加载的AB包
function AssetBundleManager.UnloadAllBundles(unloadAllLoadedObjects)
    for bundleName, assetBundle in pairs(loadedBundles) do
        assetBundle:Unload(unloadAllLoadedObjects)
    end
    loadedBundles = {}
end

-- 使用某个AB包中的资源 
function UseGameObject(abName, resName, callback)
    local prefab = AssetBundleManager.GetAssetFromBundle(abName, resName, UnityEngine.GameObject)
    if prefab then
        local instance = UnityEngine.GameObject.Instantiate(prefab)
        instance.transform.position = UnityEngine.Vector3.zero
        callback(instance)
    else
        local function onBundleLoaded(assetBundle)
            if assetBundle then
                local prefab = assetBundle:LoadAsset(resName, UnityEngine.GameObject)
                if prefab then 
                    local instance = UnityEngine.GameObject.Instantiate(prefab)
                    instance.transform.position = UnityEngine.Vector3.zero
                    callback(instance)
                else
                    callback(nil)  
                end
            else
                callback(nil)  
            end
        end
        AssetBundleManager.LoadAssetBundleAsync(abName, onBundleLoaded)
    end
end


