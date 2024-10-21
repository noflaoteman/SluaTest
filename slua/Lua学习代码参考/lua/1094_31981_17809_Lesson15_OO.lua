print("**********面向对象************")
--一定要用表去理解lua中的面向对象！！！！！！！！！！！
--__index 当子表中 找不到某一个属性时
--会到元表中 __index指定的表去找属性!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
----冒号 是会自动将调用这个函数的对象 作为第一个参数传入的写法!!!!!!!!!!!!!!!!!!!!!!!
----self 代表的是 我们默认传入的第一个参数!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--冒号的用法1
--Lua中 .和:的区别                   
--Student.Learn(Student)
--冒号调用方法 会默认把调用者 作为第一个参数传入方法中
--Student:Learn();

--冒号的用法2
--Student:Learn()!!!!!!!!!!!!!!!--函数的第三种申明方式
--function Student:Speak2()
	--lua中 有一个关键字 self 表示 默认传入的第一个参数
	--print(self.name .. "说话")
--end

--其实就是Gameobject在外部声明的方式GameObject.Move(GameObject)的简写,
--在这里（Gameobject）这个其实就是一个参数！！！其实就是一个表作为参数
--[[function GameObject:Move()
	--self只是一个简单的意思，代表着就是传入的第一个参数
	self.posX = self.posX + 1
	self.posY = self.posY + 1
	print(self.posX)
	print(self.posY)
end
]]

print("**********封装************")
--面向对象 类 其实都是基于 table来实现
--元表相关的知识点
Object = {}
Object.id = 1--相当于自定义索引Object["id"]=1,索引为字符串
print(Object["id"])

function Object:Test()
	print(self.id)
end

--冒号 是会自动将调用这个函数的对象 作为第一个参数传入的写法
function Object:new()
	--self 代表的是 我们默认传入的第一个参数
	--c#中的对象就是变量 返回一个新的变量
	--返回出去的内容 本质上就是表对象
	local obj = {}
	--元表知识 __index 当找自己的变量 找不到时 就会去找元表当中__index指向的内容
	self.__index = self--设置Index为自己
	setmetatable(obj, self)--设置元表
	return obj
end

local myObj = Object:new()
print(myObj)
print(myObj.id)
myObj:Test()--当调用这个test的时候因为myobj没有test,就会去元表指定的Index表中查找test
--对空表中 申明一个新的属性 叫做id,声明了在myObj中,因为没有指定_newIndex表所有这个是声明在自己这里
myObj.id = 2
myObj:Test() --会先去元表中找test方法,然后把myobj传进去

print("**********继承************")
--C# class 类名 : 子类
--写一个用于继承的方法
function Object:subClass(sonClassName)
	-- _G知识点 是总表 所有声明的全局标量 都以键值对的形式存在其中
	_G[sonClassName] = {}
	--写相关继承的规则
	--用到元表
	local son = _G[sonClassName]
	self.__index = self
	--子类 定义个base属性 base属性代表父类
	son.base = self
	setmetatable(son, self)
end
print(_G)
_G["a"] = 1
_G.b = "123"
print(a)
print(b)

Object:subClass("Person")
print("**********88888888888888****************")
local p1 = Person:new()--person没有new所以会去Object中调用new方法
print(p1.id)--打印的是Object的id
p1.id = 100--没有声明_newIndex所以这里给p1自己赋值
print(p1.id)
p1:Test()--最终会找到Object中的Test方法,把p1这个表传进去

Object:subClass("Monster")
local m1 = Monster:new()
print(m1.id)--打印的是Object的id
m1.id = 200
print(m1.id)
m1:Test()

print("**********多态************")
--相同行为 不同表象 就是多态
--相同方法 不同执行逻辑 就是多态
Object:subClass("GameObject")
GameObject.posX = 0;
GameObject.posY = 0;
--其实就是Gameobject在外部声明的方式GameObject.Move(GameObject)的简写,
--在这里（Gameobject）这个其实就是一个参数！！！其实就是一个表作为参数
function GameObject:Move()
	--self只是一个简单的意思，就是传入的第一个参数
	self.posX = self.posX + 1--这里有这个=,没有设置Index相当会在自己身上设置posy
	self.posY = self.posY + 1
	print(self.posX)
	print(self.posY)
end

GameObject:subClass("Player")
function Player:Move()
	--base 指的是 GameObject 表（类）
	--冒号调用 相当于是把基类表 作为第一个参数传入了方法中
	--避免把基类表 传入到方法中 这样相当于就是公用一张表的属性了
	--我们如果要执行父类逻辑 我们不要直接使用冒号调用
	--要通过.调用 然后自己传入第一个参数 
	self.base.Move(self)--这里不能用冒号调用,因为会把self.base传进去
end

local player1 = Player:new()

player1:Move()--p1的元表是Player
player1:Move() --p1的原表是Player

local p2 = Player:new()
p2:Move()

