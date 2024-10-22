CustomSV = {}
CustomSV.__index = CustomSV

function CustomSV:new()
    local instance = setmetatable({}, CustomSV)
    instance.content = nil
    instance.viewPortH = 0
    instance.nowShowItems = {}
    instance.items = {}
    instance.oldMinIndex = -1
    instance.oldMaxIndex = -1
    instance.itemW = 0
    instance.itemH = 0
    instance.col = 0
    instance.itemResName = ""
    return instance
end

function CustomSV:Init(name, trans, h, items, w, h, col)
    self.itemResName = name
    self.content = trans
    self.viewPortH = h
    self.items = items--绑定的数据信息
    self.itemW = w
    self.itemH = h
    self.col = col

    self.content.sizeDelta = UnityEngine.Vector2(0, math.ceil(#items / col) * self.itemH)
end

function CustomSV:CheckShowOrHide()
    local poolMgr = PoolMgr:new() 
    -- 检测哪些格子应该显示出来
    local minIndex = math.floor(self.content.anchoredPosition.y / self.itemH) * self.col
    local maxIndex = math.floor((self.content.anchoredPosition.y + self.viewPortH) / self.itemH) * self.col + self.col - 1

    -- 最小值判断
    if minIndex < 0 then
        minIndex = 0
    end

    -- 超出道具最大数量
    if maxIndex >= #self.items then
        maxIndex = #self.items - 1
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

    -- 创建指定索引范围内的格子
    for i = minIndex, maxIndex do
        if not self.nowShowItems[i] then
            -- 根据这个关键索引用来设置位置初始化道具信息
            local index = i
            self.nowShowItems[index] = nil
            
            poolMgr:GetObj(self.itemResName, function(obj)
                -- 设置它的父对象
                obj.transform:SetParent(self.content)
                -- 重置相对缩放大小
                obj.transform.localScale = UnityEngine.Vector3(1, 1, 1)
                -- 重置位置
                obj.transform.localPosition = UnityEngine.Vector3((index % self.col) * self.itemW, -math.floor(index / self.col) * self.itemH, 0)
                -- 更新格子信息
                obj:GetComponent(ItemBase):InitInfo(self.items[index]) -- 这里需要修改为具体的类名

                -- 判断是否应该显示
                if self.nowShowItems[index] then
                    self.nowShowItems[index] = obj
                else
                    --滑太快了,导致要放进去池子
                    PoolMgr:PushObj(self.itemResName, obj)
                end
            end)
        end
    end
end
