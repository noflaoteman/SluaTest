CustomSV = {}
CustomSV.__index = CustomSV

function CustomSV:new()
    local instance = setmetatable({}, CustomSV)
    instance.content = nil--content的RectTransform
    instance.viewPortH = 0--vieport的高
    instance.nowShowItems = {}--当前的显示的字典
    instance.items = {}--全部的数据
    instance.oldMinIndex = -1--上次刷新的最小值
    instance.oldMaxIndex = -1--上次刷新的最大值
    instance.itemW = 0--item的框
    instance.itemH = 0--item的高
    instance.col = 0--item的列
    instance.itemResName = ""--Prefab中的名字
    return instance
end

function CustomSV:Init(name, trans, viewPortH, items, w, h, col)
    self.itemResName = name
    self.content = trans
    self.viewPortH = viewPortH
    self.items = items
    self.itemW = w
    self.itemH = h
    self.col = col

    --向上取整,x = 3.2，那么 ceil(x) 的结果为 4；如果 x = 2.8，那么 ceil(x) 的结果为 3,设置Content的高度
    self.content.sizeDelta = Vector2(0, math.ceil(#items / col) * self.itemH)
end

function CustomSV:CheckShowOrHide()
    local poolMgr = PoolMgr:new() 
    -- 检测哪些格子应该显示出来
    --小于或等于输入参数 x 的最大整数。math向下取整
    local minIndex = math.floor(self.content.anchoredPosition.y / self.itemH) * self.col
    local maxIndex = math.floor((self.content.anchoredPosition.y + self.viewPortH) / self.itemH) * self.col + self.col+1

    -- 最小值判断
    if minIndex < 0 then
        minIndex = 0
    end

    -- 超出道具最大数量
    if maxIndex >= #self.items then
        maxIndex = #self.items-1
    end

    if minIndex ~= self.oldMinIndex or maxIndex ~= self.oldMaxIndex then
        -- 删除上一节溢出
        for i = self.oldMinIndex, minIndex - 1 do
            if self.nowShowItems[i] then
                poolMgr:PushObj(self.itemResName, self.nowShowItems[i])
                self.nowShowItems[i] = nil
            end
        end

        -- 删除下一节溢出
        for i = maxIndex + 1, self.oldMaxIndex do
            if self.nowShowItems[i] then
                poolMgr:PushObj(self.itemResName, self.nowShowItems[i])
                self.nowShowItems[i] = nil
            end
        end
    end

    self.oldMinIndex = minIndex
    self.oldMaxIndex = maxIndex


    for i = minIndex, maxIndex do
        if not self.nowShowItems[i] then
            local index = i
            --占个位置便于异步逻辑控制,注意这里赋值为1是为了占位置
            self.nowShowItems[index] = 1
            
            poolMgr:GetObj(self.itemResName, function(obj)
                obj.transform:SetParent(self.content)
                obj.transform.localScale = Vector3(1, 1, 1)
                obj.transform.localPosition = Vector3((index % self.col) * self.itemW, -math.floor(index / self.col) * self.itemH, 0)
                local itemUI = ItemUI:new(obj);
                itemUI:InitInfo(self.items[index+1])

                -- 判断是否应该显示
                if self.nowShowItems[index] then
                    self.nowShowItems[index] = obj
                else
                    --滑太快了,导致self.nowShowItems[index]赋值为nil,放进去对象池
                    poolMgr:PushObj(self.itemResName, obj)
                end
            end)
        end
    end
end
