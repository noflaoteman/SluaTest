local PoolData = {}
PoolData.__index = PoolData

function PoolData.new(root, name, usedObj)
    local self = setmetatable({}, PoolData)
    self.dataStack = {}
    self.usedList = {}
    if PoolMgr.isOpenLayout then
        self.rootObj = UnityEngine.GameObject(name)
        self.rootObj.transform:SetParent(root.transform)
    end
    table.insert(self.usedList, usedObj)
    local poolObj = usedObj:GetComponent("PoolObj")
    if poolObj == nil then
        UnityEngine.Debug.LogError("请为使用缓存池功能的预设体对象挂载 PoolObj 脚本，用于设置数量上限")
        return self
    end
    self.maxNum = poolObj.maxNum
    return self
end

function PoolData:dataCount()
    return #self.dataStack
end

function PoolData:UsedCount()
    return #self.usedList
end

function PoolData:NeedCreate()
    return self:UsedCount() < self.maxNum
end

function PoolData:Pop()
    local obj
    if #self.dataStack > 0 then
        obj = table.remove(self.dataStack)
        table.insert(self.usedList, obj)
    else
        obj = self.usedList[1]
        table.remove(self.usedList, 1)
        table.insert(self.usedList, obj)
    end
    obj:SetActive(true)
    if PoolMgr.isOpenLayout then
        obj.transform:SetParent(nil)
    end
    return obj
end

function PoolData:Push(obj)
    obj:SetActive(false)
    if PoolMgr.isOpenLayout then
        obj.transform:SetParent(self.rootObj.transform)
    end
    table.insert(self.dataStack, obj)
    for i, v in ipairs(self.usedList) do
        if v == obj then
            table.remove(self.usedList, i)
            break
        end
    end
end

function PoolData:PushUsedList(obj)
    table.insert(self.usedList, obj)
end

local PoolObjectBase = {}

local PoolObject = {}
PoolObject.__index = PoolObject

function PoolObject.new(T)
    local self = setmetatable({}, PoolObject)
    self.poolObjs = {}
    return self
end

local IPoolObject = {}

function IPoolObject.ResetInfo()
    error("ResetInfo method must be implemented in derived classes.")
end

local PoolMgr = {}
PoolMgr.__index = PoolMgr

function PoolMgr.new()
    local self = setmetatable({}, PoolMgr)
    self.poolDic = {}
    self.poolObjectDic = {}
    if PoolMgr.isOpenLayout and self.poolObj == nil then
        self.poolObj = UnityEngine.GameObject("Pool")
    end
    return self
end

function PoolMgr:GetObj(name, callback)
    local obj = nil
    if self.poolObj == nil and PoolMgr.isOpenLayout then
        self.poolObj = UnityEngine.GameObject("Pool")
    end
    if not self.poolDic[name] or (self.poolDic[name]:dataCount() == 0 and self.poolDic[name]:NeedCreate()) then
        local ABMgr = require "ABMgr" -- 假设 ABMgr 模块已在项目中
        ABMgr.Instance:LoadResAsync("prefab", "name", function(go)
            obj = UnityEngine.GameObject.Instantiate(go)
            obj.name = name
            if not self.poolDic[name] then
                self.poolDic[name] = PoolData.new(self.poolObj, name, obj)
            else
                self.poolDic[name]:PushUsedList(obj)
            end
            callback(obj)
        end, true)
    else
        obj = self.poolDic[name]:Pop()
        callback(obj)
    end
end

function PoolMgr:GetObj(T, nameSpace)
    local poolName = nameSpace and nameSpace .. "_" .. T.Name or T.Name
    if self.poolObjectDic[poolName] then
        local pool = self.poolObjectDic[poolName]
        if pool.poolObjs and #pool.poolObjs > 0 then
            return table.remove(pool.poolObjs)
        else
            return T.new()
        end
    else
        return T.new()
    end
end

function PoolMgr:PushObj(obj)
    self.poolDic[obj.name]:Push(obj)
end

function PoolMgr:PushObj(obj, nameSpace)
    if obj == nil then
        return
    end
    local poolName = nameSpace and nameSpace .. "_" .. obj.ClassName or obj.ClassName
    local pool
    if self.poolObjectDic[poolName] then
        pool = self.poolObjectDic[poolName]
    else
        pool = PoolObject.new(obj)
        self.poolObjectDic[poolName] = pool
    end
    obj:ResetInfo()
    table.insert(pool.poolObjs, obj)
end

function PoolMgr:ClearPool()
    self.poolDic = {}
    self.poolObj = nil
    self.poolObjectDic = {}
end

return PoolMgr
