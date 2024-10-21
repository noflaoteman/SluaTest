Object:subClass("ItemGrid")
ItemGrid.obj = nil
ItemGrid.imgIcon = nil
ItemGrid.Text = nil
ItemGrid.btnTipClick = nil
ItemGrid.itemData = nil

--初始化格子UI gameObject
function ItemGrid:Init(father, posX, posY)
    self.obj = ABMgr:LoadRes("ui", "ItemGrid");
    self.obj.transform:SetParent(father, false)

    --self.obj.transform.localPosition = Vector3(posX, posY, 0)
    
    self.imgIcon = self.obj.transform:Find("imgIcon"):GetComponent(typeof(Image))
    self.Text = self.obj .transform:Find("Text"):GetComponent(typeof(Text))
    self.btnTipClick = self.obj.transform:Find("btnTipClick"):GetComponent(typeof(Button))

    self.btnTipClick.onClick:AddListener(function()
            self:BtnTipClick()
        end)
end

--初始化格子数据
function ItemGrid:InitData(data)
    self.itemData = ItemData[data.id]
    local strs = string.split(self.itemData.icon, "_")
    --图集
    local spriteAtlas = ABMgr:LoadRes("ui", strs[1], typeof(SpriteAtlas))
    --图标
    self.imgIcon.sprite = spriteAtlas:GetSprite(strs[2])
    self.Text.text = data.num
end


function ItemGrid:BtnTipClick()
    local rectTransform = self.obj:GetComponent(typeof(RectTransform))
    local screenPosition = RectTransformUtility.WorldToScreenPoint(Camera.main, rectTransform.position)
    TipPanel:ShowPanel(screenPosition,self.itemData)
end


--销毁
function ItemGrid:Destroy()
    GameObject.Destroy(self.obj)
    self.obj = nil
end