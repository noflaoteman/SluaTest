ObjectPool = {}
ObjectPool.__index = ObjectPool

function ObjectPool:new(objectPrefab, initialSize)
    local pool = {}
    setmetatable(pool, ObjectPool)
    
    pool.prefab = objectPrefab
    pool.pool = {}              
    pool.activeObjects = {}     
    
    for i = 1, initialSize do
        local obj = self:CreateNewObject()
        table.insert(pool.pool, obj)
    end
    
    return pool
end

function ObjectPool:CreateNewObject()
    local newObj = Instantiate(self.prefab)
    newObj:SetActive(false)  
    return newObj
end

function ObjectPool:Get()
    local obj
    
    if #self.pool > 0 then
        obj = table.remove(self.pool)
    else
        obj = self:CreateNewObject()
    end
    
    obj:SetActive(true)
    table.insert(self.activeObjects, obj)
    
    return obj
end

function ObjectPool:Release(obj)
    obj:SetActive(false)
    
    for i, activeObj in ipairs(self.activeObjects) do
        if activeObj == obj then
            table.remove(self.activeObjects, i)
            break
        end
    end
    
    table.insert(self.pool, obj)
end


function ObjectPool:GetPoolSize()
    return #self.pool
end

function ObjectPool:GetActiveSize()
    return #self.activeObjects
end

return ObjectPool
