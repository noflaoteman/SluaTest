Object = {}
--实例化
function Object:new()
	local obj = {}
	self.__index = self
	setmetatable(obj, self)
	return obj
end
--继承
function Object:subClass(sonClassName)
	_G[sonClassName] = {}
	local sonObj = _G[sonClassName]
	sonObj.base = self
	self.__index = self
	setmetatable(sonObj, self)
end
