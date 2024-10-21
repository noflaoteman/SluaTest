BasePanel:subClass("TipPanelNoDrop")

--面板初始化
function TipPanelNoDrop:Init(name)
    self.base.Init(self, name)
    if self.isInitEvent == false then
        self.isInitEvent = true
    end
end

--显示面板
function TipPanelNoDrop:ShowMe(name)
    self.base.ShowMe(self, name)
end

-- 通过rectTransform显示
function TipPanelNoDrop:ShowPanelByRect(rectTransform,tipData)
    local screenPosition = RectTransformUtility.WorldToScreenPoint(Camera.main, rectTransform.position)
	self:ShowPanelBy(screenPosition,tipData)
end

-- 通过screenPosition显示
function TipPanelNoDrop:ShowPanelByScreenPos(screenPosition,tipData)
    self:ShowMe("TipPanelNoDrop")

    CS.DG.Tweening.DOTween.KillAll();
    --设置Panel位置
    local uiPanelPos = Vector2.zero
    local success, uiPanelPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(
        self.panelObj.transform.parent, 
        screenPosition, 
        Camera.main)
    if success then
        uiPanelPos.y=uiPanelPos.y+100 
        self:ChangePanelPos(uiPanelPos)
    end 

    --一定要先设置Panel的坐标!!一定要先设置Panel的坐标!!一定要先设置Panel的坐标!!
    --设置角标位置
    local imgPointPos = Vector2.zero
    local success, imgPointPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(
        self:GetControl("imgPoint", "Image").transform.parent, 
        screenPosition, 
        Camera.main)
    local imgPointPosV3 = Vector3(imgPointPos.x, imgPointPos.y+10, self:GetControl("imgPoint", "Image").transform.localPosition.z)
    self:GetControl("imgPoint", "Image").rectTransform.localPosition = imgPointPosV3

    --最终通过配置设置效果
    self:SetTipData(tipData)
end


--配置数据结构类
Object:subClass("TipData")
TipData.isAlpha = false--tip是否过度效果
TipData.isUp=false--tip是否上升动画
TipData.tipContentText="默认的文本默认的文本默认的文本"--默认的提示内容
TipData.isTypeText = false--输出文本时否是打字机效果

-- 设置panel的效果
function TipPanelNoDrop:SetTipData(tipData)
    -- 设置透明度
    local canvasGroup = self.panelObj:GetComponent(typeof(CanvasGroup))
    if tipData ~= nil and tipData.isAlpha then
        canvasGroup:DOFade(1, 1)
    else
        canvasGroup.alpha = 1
    end

    -- 上升效果
    if tipData ~= nil and tipData.isUp then
        -- 从当前Y位置向下移动到指定位置，然后上升
        local transPos = self.panelObj.transform.localPosition
        self.panelObj.transform.localPosition = Vector3(transPos.x, transPos.y-50 , transPos.z) -- 设置初始位置
        self.panelObj.transform:DOLocalMoveY(transPos.y, 1) -- 移动回原位置
    end

    -- 设置提示内容
    if tipData.tipContentText ~= nil and tipData.isTypeText == false then
        self:GetControl("txtDes", "Text").text = tipData.tipContentText
    end
    --if tipData.tipContentText ~= nil and tipData.isTypeText == true then 
      --  self:GetControl("txtDes", "Text"):DOText(tipData.tipContentText,2,true,CS.DG.Tweening.ScrambleMode.All)
    --end
end

-- 控制Panel不超出边界
function TipPanelNoDrop:ChangePanelPos(uiPoint)
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
    local rectLocalPosition = Vector3(uiPoint.x, uiPoint.y, rect.localPosition.z)

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
function TipPanelNoDrop:btnCloseClick()
    self.panelObj:GetComponent(typeof(CanvasGroup)):DOFade(0, 1);
end

