ItemUI = {}
ItemUI.__index = ItemUI

function ItemUI:new(gameObject)
    local instance = setmetatable({}, ItemUI)
    instance.gameObject = gameObject
    instance.nameText = gameObject.transform:Find("NameText"):GetComponent(UnityEngine.UI.Text)
    instance.valueText = gameObject.transform:Find("ValueText"):GetComponent(UnityEngine.UI.Text)
    instance.ImageBk = gameObject:GetComponent(UnityEngine.UI.Image)
    return instance
end

function ItemUI:InitInfo(itemData)
    self.nameText.text = itemData.name
    self.valueText.text = tostring(itemData.value)
    ABMgr.Instance:LoadResAsyncByType("ui", itemData.path, Sprite, function(spriteObj)
        self.ImageBk.sprite = spriteObj
    end, true)
end
