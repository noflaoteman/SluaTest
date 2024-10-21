print("**********特殊用法************")
print("**********多变量赋值************")
local a,b,c = 1,2,"123"
print(a)
print(b)
print(c)
--多变量赋值 如果后面的值不够 就没有赋值,相当于会自动补空
a,b,c = 1,2 
print(a)
print(b)
print(c) --nil
--多变量赋值 如果后面的值多了 会自动省略
a,b,c = 1,2,3,4,5,6
print(a)
print(b)
print(c)
print("**********多返回值************")
function Test()
	return 10,20,30,40
end
--多返回值时 你用几个变量接 就有几个值
--如果少了 就少接几个 如果多了 就没有接到相当于就自动补空
a,b,c = Test()
print(a)
print(b)
print(c)

a,b,c,d,e = Test()
print(a)
print(b)
print(c)
print(d)
print(e)--nil

print("**********and or************")
--[[C#：在C#中，只有false和null被视为假。所有其他值，包括0和空字符串，都被视为真。

C++：在C++中，false 和0,null被视为假。所有非零值，包括所有非空字符串，都被视为真。特别要注意c/c++中的0!!!!!

Lua：在Lua中，false和nil被视为假。所有其他值，包括0和空字符串，都被视为真。]]
--逻辑与 逻辑或
-- and or 他们不仅可以连接 boolean 任何东西都可以用来连接 所以就会造成这种特殊的用法!!!
--而编译型语言就只能连接bool类型
-- 在lua中 只有 nil 和 false 才认为是假
-- "短路"——对于and来说  有假则假  对于or来说 有真则真
-- 所以 他们只需要判断 第一个 是否满足 就会停止计算了
print( 1 and 2 )
print( 0 and 1)
print( nil and 1)
print( false and 2)
print( true and 3)
print("----------------------------------------")
print( true or 1 )
print( false or 1)
print( nil or 2)
--lua 不支持三目运算符 
x = 1
y = 2
-- ? :
local res = (x>y) and x or y
print(res)



