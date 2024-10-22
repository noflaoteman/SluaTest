ItemData = {}
ItemData.__index = ItemData

function ItemData:new(name, value)
    local instance = setmetatable({}, ItemData)
    instance.name = name      -- 项目名称
    instance.value = value    -- 项目值
    return instance
end

function ItemData:ToString()
    return string.format("Name: %s, Value: %s", self.name, self.value)
end
