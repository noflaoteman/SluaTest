ItemUI = {}
ItemUI.__index = ItemUI

function ItemUI:new(gameObject)
    local instance = setmetatable({}, ItemUI)
    instance.gameObject = gameObject
    instance.nameText = gameObject.transform:Find("NameText"):GetComponent(typeof(UnityEngine.UI.Text))
    instance.valueText = gameObject.transform:Find("ValueText"):GetComponent(typeof(UnityEngine.UI.Text))
    return instance
end

function ItemUI:InitInfo(itemData)
    self.nameText.text = itemData.name
    self.valueText.text = tostring(itemData.value)
end
