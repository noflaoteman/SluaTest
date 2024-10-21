BasePanel:subClass("TipPanel")


--实例化对象 控件事件监听
function TipPanel:Init(name)
    self.base.Init(self, name)
    if self.isInitEvent == false then
        self:GetControl("btnClose", "Button").onClick:AddListener(function()
            self:btnCloseClick()
        end)
        self.isInitEvent = true
    end

    local eventTrigger = self.panelObj:GetComponent(typeof(EventTrigger))

    -- 设置拖动事件
    local entry = Entry()
    entry.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
    entry.callback:AddListener(function(data)
        self:JoyDrag(data)
    end)
    eventTrigger.triggers:Add(entry)

end

-- 拖动摇杆
function TipPanel:JoyDrag(data)
    local eventData = data
    local uiPos = Vector2.zero

    local success, uiPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(
        self.panelObj.transform.parent, 
        eventData.position, 
        Camera.main)

    if success then
        self:SetPos(uiPos)
    end
end

--显示
function TipPanel:ShowMe(name)
    self.base.ShowMe(self, name)
end

-- 显示面板逻辑
function TipPanel:ShowPanel(screenPosition, data)
	self:ShowMe("TipPanel")
    local uiPos = Vector2.zero
    local success, uiPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(
        self.panelObj.transform.parent, 
        screenPosition, 
        Camera.main)

    if success then
        self:SetPos(uiPos)
    end

    self:GetControl("txtDes", "Text").text = data.tips
    self:GetControl("txtName", "Text").text  =data.name

    
end

-- 设置位置，尽量不超出边界
function TipPanel:SetPos(uiPoint)
    local rightTopUIpoint = Vector2.zero
    local success, rightTopUIpoint = RectTransformUtility.ScreenPointToLocalPointInRectangle(
        self.panelObj.transform.parent,
        Vector2(CS.UnityEngine.Screen.width, CS.UnityEngine.Screen.height),
        Camera.main)

    if not success then
        return
    end

    local screenWidth = rightTopUIpoint.x
    local screenHeight = rightTopUIpoint.y

    local rect = self.panelObj:GetComponent(typeof(CS.UnityEngine.RectTransform))
    local imgHalfWidth = rect.sizeDelta.x / 2
    local imgHalfHeight = rect.sizeDelta.y / 2

    -- 计算新的位置
    local rectLocalPosition = CS.UnityEngine.Vector3(uiPoint.x, uiPoint.y, rect.localPosition.z)

    if rectLocalPosition.x > (screenWidth - imgHalfWidth) then
        rectLocalPosition.x = screenWidth - imgHalfWidth
    end
    if rectLocalPosition.y > (screenHeight - imgHalfHeight) then
        rectLocalPosition.y = screenHeight - imgHalfHeight
    end

    if rectLocalPosition.x < -screenWidth + imgHalfWidth then
        rectLocalPosition.x = -screenWidth + imgHalfWidth
    end
    if rectLocalPosition.y < -screenHeight + imgHalfHeight then
        rectLocalPosition.y = -screenHeight + imgHalfHeight
    end

    -- 设置UI的位置
    self.panelObj.transform.localPosition = rectLocalPosition
end


--关闭提示面板
function TipPanel:btnCloseClick()
    self:HideMe()
end

