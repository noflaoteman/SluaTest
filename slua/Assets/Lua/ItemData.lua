--将Json数据读取到Lua中的表中进行存储

local txt = ABMgr:LoadRes("json", "ItemData", typeof(TextAsset))
local itemList = Json.decode(txt.text)
--键是道具ID 值是道具
ItemData = {}
for _, value in pairs(itemList) do
    ItemData[value.id] = value
end