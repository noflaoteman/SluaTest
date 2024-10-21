print("**********协同程序************")

print("**********协程的创建************")
--常用方式
--coroutine.create()
fun = function()
	print(123)
end
co = coroutine.create(fun)--返回一个线程对象
--协程的本质是一个线程对象
print(co)--thread: 00B5D718
print(type(co))--thread

--coroutine.wrap() 返回的是一个函数
co2 = coroutine.wrap(fun)
print(co2)--function: 00A97750
print(type(co2))--function

print("**********协程的运行************")
--第一种方式 对应的 是通过 create创建的协程
coroutine.resume(co)--本质就是在执行一个线程
--第二种方式
co2()--调用一个函数的形式

print("**********协程的挂起************")
fun2 = function( )
	local i = 1
	while true do
		print(i)
		i = i + 1
		--协程的挂起函数
		print(coroutine.status(co3))
		print(coroutine.running())
		coroutine.yield(i)
	end
end

co3 = coroutine.create(fun2)
--协程 resume运行的APi的返回值
--默认第一个返回值 是 协程是否启动成功
--yield 里面的返回值
--因为lua的脚本是从上往下执行的,不存在一个死循环,所以我们必须手动的每次启动!!!!!!!!
isOk, tempI = coroutine.resume(co3)
print(isOk,tempI)
isOk, tempI = coroutine.resume(co3)
print(isOk,tempI)
isOk, tempI = coroutine.resume(co3)
print(isOk,tempI)

print("**********函数的类型的调用的方式************")
co4 = coroutine.wrap(fun2)--因为返回值是一个函数直接括号就可以调用
--这种方式的协程调用 也可以有返回值 只是没有默认第一个返回值了
print("返回值"..co4())--因为这里启动的co4,但是里面的协程判断的是co3,所以会是打印suspended状态
print("返回值"..co4())
print("返回值"..co4())

print("**********协程的状态************")
--coroutine.status(协程对象)
--dead 结束
--suspended 暂停
--running 正在进行中
print(coroutine.status(co3))--因为co3是一个死循环
print(coroutine.status(co))--co不是死循环所以会直接挂掉

--这个函数可以得到当前正在 运行的携程的线程号!!!!类似是这样的thread: 001F8668
print(coroutine.running())