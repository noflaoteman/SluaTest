BasePanel:subClass("MainPanel")

--实例化对象 控件事件监听
function MainPanel:Init(name)
    self.base.Init(self, name)
    --只添加一次事件监听
    if self.isInitEvent == false then
        self:GetControl("btnRole", "Button").onClick:AddListener(function()
            self:BtnRoleClick()
        end)

        self.isInitEvent = true
    end
    
end

--角色按钮事件函数
function MainPanel:BtnRoleClick()
    BagPanel:ShowMe("BagPanel")
end