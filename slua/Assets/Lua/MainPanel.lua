MainPanel = {}
MainPanel.__index = MainPanel

function MainPanel:new()
    local instance = setmetatable({}, MainPanel)
    instance.itemList = {}
    instance.itemCount = 10000 -- 自定义数据大小
    return instance
end

function MainPanel:Init()
    -- Model数据层
    for i = 1, self.itemCount do
        local randomNumber = math.random(1, 17)
        local itemData = ItemData:new("Item " .. i, i, "itemImg" .. randomNumber)
        table.insert(self.itemList, itemData)
    end
    
    -- View层次
    self.customSV = CustomSV:new()
    self.customSV:Init("ItemPrefab", UnityEngine.GameObject.Find("content"):GetComponent(RectTransform), 888,
        self.itemList, 120, 120, 10)
end

function MainPanel:Update()
    if self.customSV then
        self.customSV:CheckShowOrHide()
    end
end
