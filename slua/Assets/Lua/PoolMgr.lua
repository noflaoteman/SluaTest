PoolData = {}
PoolData.__index = PoolData

function PoolData:new(obj, poolObj)
    local instance = setmetatable({}, PoolData)
    instance.fatherObj = UnityEngine.GameObject(obj.name)
    instance.fatherObj.transform.parent = poolObj.transform
    instance.poolList = {}
    self:PushObj(instance, obj)
    return instance
end

function PoolData:PushObj(obj)
    obj:SetActive(false)
    table.insert(self.poolList, obj)
    obj.transform.parent = self.fatherObj.transform
end

function PoolData:GetObj()
    if #self.poolList == 0 then
        return nil
    end
    local obj = self.poolList[1]
    table.remove(self.poolList, 1)
    obj:SetActive(true)
    obj.transform.parent = nil
    return obj
end

PoolMgr = {}
PoolMgr.__index = PoolMgr

-- 存储 PoolMgr 的唯一实例
local instance = nil

-- 创建 PoolMgr 的唯一实例
function PoolMgr:new()
    if not instance then
        instance = setmetatable({}, PoolMgr)
        instance.poolDic = {}
        instance.poolObj = UnityEngine.GameObject("PoolMgr")
    end
    return instance
end

function PoolMgr:GetObj(name, callBack)
    if self.poolDic[name] and #self.poolDic[name].poolList > 0 then
        callBack(self.poolDic[name]:GetObj())
    else
        -- 使用 AssetBundleManager 异步加载资源
        local function onAssetLoaded(gameObject)
            gameObject.name = name
            callBack(gameObject)
        end
        UseGameObject("prefab", name, onAssetLoaded)  -- name 可以用作 AB 包和资源名
    end
end

function PoolMgr:PushObj(name, obj)
    if self.poolDic[name] then
        self.poolDic[name]:PushObj(obj)
    else
        self.poolDic[name] = PoolData:new(obj, self.poolObj)
    end
end

function PoolMgr:Clear()
    self.poolDic = {}
    self.poolObj = nil
end
