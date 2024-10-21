print("**********复杂数据类型 talbe************")
--所有的复杂类型都是table（表）
print("**********数组************")
a = {1,2,nil,3,"1231",true,nil}
--lua中 索引从1开始
print(a[1])
print(a[5])
print(a[6])
print(a[7])
--#是通用的获取长度的关键字
--在打印长度的时候 空被忽略
--如果表中（数组中）某一位变成nil 会影响#获取的长度
print(#a)
a={["age"]=false,hah="naem",jfk=1;}
a={age=false,hah="naem",jfk=1;}
print(type(a.age))--会打印false
for k,v in pairs(a) do
	print(k,v)
end
