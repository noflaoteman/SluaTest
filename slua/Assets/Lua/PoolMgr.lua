PoolData = {}
PoolData.__index = PoolData

--池子对象(单个对象,池子的父类PoolMgr)
function PoolData:new(go, poolMgrObj)
    local instance = setmetatable({}, PoolData)
    instance.fatherObj = GameObject(go.name)
    instance.fatherObj.transform:SetParent(poolMgrObj.transform)
    instance.poolList = {}
    instance:PushObj(go)
    return instance
end

function PoolData:PushObj(obj)
    obj:SetActive(false)
    table.insert(self.poolList, obj)
    obj.transform:SetParent(self.fatherObj.transform)
end

function PoolData:GetObj()
    if #self.poolList == 0 then
        return nil
    end
    local obj = self.poolList[1]
    table.remove(self.poolList, 1)
    obj:SetActive(true)
    obj.transform:SetParent(nil)
    return obj
end

--池子管理器
PoolMgr = {}
PoolMgr.__index = PoolMgr
local instance = nil
function PoolMgr:new()
    if not instance then
        instance = setmetatable({}, PoolMgr)
        instance.poolDic = {}
        instance.poolObj = GameObject("PoolMgr")
    end
    return instance
end

function PoolMgr:GetObj(name, callBack)
    if self.poolDic[name] and #self.poolDic[name].poolList > 0 then
        callBack(self.poolDic[name]:GetObj())
    else
        ABMgr.Instance:LoadResAsyncByType("prefab",name,GameObject,function (prefab)
            go = GameObject.Instantiate(prefab,Vector3.zero,Quaternion.identity)
            callBack(go)
        end,true)

    end
end

function PoolMgr:PushObj(name,go)
    if self.poolDic[name] then
        self.poolDic[name]:PushObj(go)
    else
        self.poolDic[name] = PoolData:new(go, self.poolObj)
    end
end

function PoolMgr:Clear()
    self.poolDic = {}
    self.poolObj = nil
end
