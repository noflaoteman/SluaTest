ItemData = {}
ItemData.__index = ItemData

function ItemData:new(name, value,imgPath)
    local instance = setmetatable({}, ItemData)
    instance.name = name      -- Item名称
    instance.value = value    -- item的数量
    instance.path = imgPath   --图片的路径
    return instance
end
