Object:subClass("SvPanel")
Object:subClass("UIItem")
function UIItem:InitInfo(data)

end

function SvPanel:Init()
    -- 通过调用 CustomSv 的方法进行实例化
    self.newCustomSv = CustomSv:new()
    self.newCustomSv:InitItemResName("UIItem")
    local contentTrans = GameObject.Find("Content"):GetComponent("RectTransform");
    local viewPortHeight = 200;
    self.newCustomSv:InitContentAndSVH(contentTrans, viewPortHeight)
    self.itemDatas = {} -- 这里传入合适的项目数据列表
    table.insert(self.itemDatas, { id = 1, num = 1 })
    table.insert(self.itemDatas, { id = 2, num = 2 })
    table.insert(self.itemDatas, { id = 1, num = 4 })
    table.insert(self.itemDatas, { id = 2, num = 5 })
    table.insert(self.itemDatas, { id = 1, num = 4 })
    table.insert(self.itemDatas, { id = 2, num = 4 })
    table.insert(self.itemDatas, { id = 1, num = 3 })
    table.insert(self.itemDatas, { id = 2, num = 2 })
    table.insert(self.itemDatas, { id = 1, num = 5 })
    table.insert(self.itemDatas, { id = 2, num = 4 })
    table.insert(self.itemDatas, { id = 1, num = 3 })
    table.insert(self.itemDatas, { id = 1, num = 1 })
    table.insert(self.itemDatas, { id = 2, num = 2 })
    table.insert(self.itemDatas, { id = 1, num = 4 })
    table.insert(self.itemDatas, { id = 2, num = 5 })
    table.insert(self.itemDatas, { id = 1, num = 4 })
    table.insert(self.itemDatas, { id = 2, num = 4 })
    table.insert(self.itemDatas, { id = 1, num = 3 })
    table.insert(self.itemDatas, { id = 2, num = 2 })
    table.insert(self.itemDatas, { id = 1, num = 5 })
    table.insert(self.itemDatas, { id = 2, num = 4 })
    table.insert(self.itemDatas, { id = 1, num = 3 })
    table.insert(self.itemDatas, { id = 2, num = 1 })


    local itemWidth = 100
    local itemHeight = 100
    local colValue = 3
    self.newCustomSv:InitItemSizeAndCol(itemWidth, itemHeight, colValue)
    self.newCustomSv:InitInfos(self.itemDatas)
end
