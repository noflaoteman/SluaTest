BasePanel:subClass("BagPanel")

BagPanel.Content = nil
--存储显示的格子Items
BagPanel.items = {}
--存储当前显示的页签
BagPanel.nowType = -1

--初始化
function BagPanel:Init(name)
    self.base.Init(self, name)

    if self.isInitEvent == false then
        self.Content = self:GetControl("svBag", "ScrollRect").transform:Find("Viewport"):Find("Content")

        --关闭按钮
        self:GetControl("btnClose", "Button").onClick:AddListener(function()
            self:HideMe()
        end)

        --单选框
        self:GetControl("togEquip", "Toggle").onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(1)
            end
        end)
        self:GetControl("togItem", "Toggle").onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(2)
            end
        end)
        self:GetControl("togGem", "Toggle").onValueChanged:AddListener(function(value)
            if value == true then
                self:ChangeType(3)
            end
        end)

        self.isInitEvent = true
    end
end

--显示
function BagPanel:ShowMe(name)
    self.base.ShowMe(self, name)
    if self.nowType == -1 then
        self:ChangeType(1)
    end
end

--逻辑处理函数
--type 1装备 2道具 3宝石
function BagPanel:ChangeType(type)
    if self.nowType == type then
        return
    end

    --先删旧的格子
    for i = 1, #self.items do
        self.items[i]:Destroy()
    end
    self.items = {}

    local nowItems = nil

    if type == 1 then
        nowItems = PlayerData.equips
    elseif type == 2 then
        nowItems = PlayerData.items
    else
        nowItems = PlayerData.gems
    end

    --创建新格子
    for i = 1, #nowItems do
        local grid = ItemGrid:new()
        grid:Init(self.Content, (i-1)%4*175, math.floor((i-1)/4)*175)
        grid:InitData(nowItems[i])    
        table.insert(self.items, grid)
    end
end