MainPanel = {}
MainPanel.__index = MainPanel

function MainPanel:new()
    local instance = setmetatable({}, MainPanel)
    instance.scrollView = nil
    instance.itemList = {}
    instance.itemCount = 100  -- 假设我们有 100 个项目
    return instance
end

function MainPanel:Init(scrollView)
    self.scrollView = scrollView
    local items = {}
    
    -- 创建测试数据
    for i = 1, self.itemCount do
        local itemData = ItemData:new("Item " .. i, i)
        table.insert(items, itemData)
    end

    -- 初始化 CustomSV
    self.customSV = CustomSV:new()
    self.customSV:Init("ItemPrefab", UnityEngine.GameObject.Find("content"):GetComponent(RectTransform),200, items, 200, 100, 3)
end

function MainPanel:Update()
    if self.customSV then
        self.customSV:CheckShowOrHide()  -- 更新显示
    end
end
