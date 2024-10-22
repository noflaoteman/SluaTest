Object:subClass("CustomSv")

CustomSv.contentTrans = nil
CustomSv.viewPortH = nil
CustomSv.nowShowItemDic = {}
CustomSv.itemDatas = nil
CustomSv.oldMinIndex = -1
CustomSv.oldMaxIndex = -1
CustomSv.showItemW = nil
CustomSv.showItemH = nil
CustomSv.col = nil
CustomSv.itemResName = nil
function CustomSv:InitItemResName(name)
    self.itemResName = name
end

function CustomSv:InitContentAndSVH(trans, h)
    self.contentTrans = trans
    self.viewPortH = h
end

function CustomSv:InitInfos(items)
    self.itemDatas = items
    local count = #items
    self.contentTrans.sizeDelta = Vector2(0, math.ceil(count / self.col) * self.showItemH)
end

function CustomSv:InitItemSizeAndCol(w, h, col)
    self.showItemW = w
    self.showItemH = h
    self.col = col
end

function CustomSv:CheckShowOrHide()
    local minIndex = math.floor(self.contentTrans.anchoredPosition.y / self.showItemH) * self.col
    local maxIndex = math.floor((self.contentTrans.anchoredPosition.y + self.viewPortH) / self.showItemH) * self.col +
        self.col - 1
    if minIndex < 0 then
        minIndex = 0
    end
    if maxIndex >= #self.itemDatas then
        maxIndex = #self.itemDatas - 1
    end
    if minIndex ~= self.oldMinIndex or maxIndex ~= self.oldMaxIndex then
        for i = self.oldMinIndex, minIndex - 1 do
            if self.nowShowItemDic[i] then
                PoolMgr.Instance:PushObj(self.nowShowItemDic[i])
                self.nowShowItemDic[i] = nil
            end
        end
        for i = maxIndex + 1, self.oldMaxIndex do
            if self.nowShowItemDic[i] then
                PoolMgr.Instance:PushObj(self.nowShowItemDic[i])
                self.nowShowItemDic[i] = nil
            end
        end
    end
    self.oldMinIndex = minIndex
    self.oldMaxIndex = maxIndex
    for i = minIndex, maxIndex do
        local index = i
        do
            if self.nowShowItemDic[index] ~= nil then
                break
            end
        end
        self.nowShowItemDic[index] = nil
        PoolMgr.Instance:GetObj(self.itemResName, function(uiItemGo)
            uiItemGo.transform:SetParent(self.contentTrans)
            uiItemGo.transform.localScale = { 1, 1, 1 }
            uiItemGo.transform.localPosition = { index % self.col * self.showItemW, -index / self.col * self.showItemH, 0 }
            --uiItemGo:GetComponent("UIItem"):InitInfo(self.itemDatas[index])
            -- 判断有没有这个坑，有说明当前异步加载出来的能使用
            if self.nowShowItemDic[index] then
                self.nowShowItemDic[index] = uiItemGo
            else
                -- 不能使用扔进去池子
                PoolMgr.Instance:PushObj(uiItemGo)
            end
        end)
    end
end

return CustomSv
