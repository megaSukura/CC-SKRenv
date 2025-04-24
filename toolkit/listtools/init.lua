local listtools = {}

-- range函数 - 类似Python的range
-- @param start 起始值(包含)
-- @param stop 结束值(不包含)
-- @param step 步长，默认为1
function listtools.range(start, stop, step)
    if not stop then
        stop = start
        start = 1
    end
    step = step or 1
    
    local result = {}
    for i = start, stop - 1, step do
        table.insert(result, i)
    end
    return result
end

-- 列表推导式 - 类似Python的list comprehension
-- @param array 输入数组
-- @param transform 转换函数
-- @param filter 过滤条件函数(可选)
function listtools.comprehension(array, transform, filter)
    local result = {}
    for _, v in ipairs(array) do
        if not filter or filter(v) then
            local transformed = transform(v)
            if transformed ~= nil then
                table.insert(result, transformed)
            else
                -- 处理没有返回值的情况（比如只是打印操作）
            end
        end
    end
    return result
end

-- map函数 - 对列表中的每个元素应用函数
-- @param array 输入数组
-- @param func 应用到每个元素的函数
function listtools.map(array, func)
    return listtools.comprehension(array, func)
end

-- filter函数 - 根据条件函数过滤列表
-- @param array 输入数组
-- @param predicate 判断函数，返回true保留元素
function listtools.filter(array, predicate)
    return listtools.comprehension(array, function(x) return x end, predicate)
end

-- forEach函数 - 对列表中的每个元素执行操作，不返回新列表
-- @param array 输入数组
-- @param action 要执行的操作函数
function listtools.forEach(array, action)
    for _, v in ipairs(array) do
        action(v)
    end
    return array -- 返回原数组以支持链式调用
end

-- reduce函数 - 聚合列表元素
-- @param array 输入数组
-- @param func 聚合函数，接收(累加值, 当前元素)
-- @param initial 初始值，默认为数组第一个元素
function listtools.reduce(array, func, initial)
    if #array == 0 then
        return initial
    end
    
    local start = 1
    local result
    
    if initial == nil then
        result = array[1]
        start = 2
    else
        result = initial
    end
    
    for i = start, #array do
        result = func(result, array[i])
    end
    
    return result
end

-- all函数 - 检查是否所有元素满足条件
-- @param array 输入数组
-- @param predicate 判断函数
function listtools.all(array, predicate)
    for _, v in ipairs(array) do
        if not predicate(v) then
            return false
        end
    end
    return true
end

-- any函数 - 检查是否存在元素满足条件
-- @param array 输入数组
-- @param predicate 判断函数
function listtools.any(array, predicate)
    for _, v in ipairs(array) do
        if predicate(v) then
            return true
        end
    end
    return false
end

-- 简写for-comprehension语法，创建链式API
function listtools.from(array)
    local chain = {
        _data = array or {},
        
        map = function(self, func)
            self._data = listtools.map(self._data, func)
            return self
        end,
        
        filter = function(self, predicate)
            self._data = listtools.filter(self._data, predicate)
            return self
        end,
        
        forEach = function(self, action)
            listtools.forEach(self._data, action)
            return self
        end,
        
        reduce = function(self, func, initial)
            return listtools.reduce(self._data, func, initial)
        end,
        
        toArray = function(self)
            return self._data
        end
    }
    
    return chain
end

-- 打印table辅助函数
function listtools.toString(t)
    if type(t) ~= "table" then return tostring(t) end
    local result = "{"
    local first = true
    for _, v in ipairs(t) do
        if not first then result = result .. ", " else first = false end
        if type(v) == "table" then
            result = result .. listtools.toString(v)
        elseif type(v) == "string" then
            result = result .. '"' .. v .. '"'
        else
            result = result .. tostring(v)
        end
    end
    return result .. "}"
end

return listtools 