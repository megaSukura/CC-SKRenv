-- 示例代码：展示listtools库的用法
local listtools = require("toolkit.listtools")

print("=== 基础函数演示 ===")

-- range函数演示
print("\n-- Range函数示例:")
local r1 = listtools.range(5)          -- 从1到4
local r2 = listtools.range(2, 10)      -- 从2到9
local r3 = listtools.range(1, 20, 3)   -- 1,4,7,10,13,16,19

print("range(5): " .. listtools.toString(r1))
print("range(2, 10): " .. listtools.toString(r2))
print("range(1, 20, 3): " .. listtools.toString(r3))

-- comprehension函数演示
print("\n-- Comprehension函数示例:")
local nums = listtools.range(1, 11)
local squares = listtools.comprehension(nums, function(x) return x * x end)
local evenSquares = listtools.comprehension(nums, 
                                          function(x) return x * x end, 
                                          function(x) return x % 2 == 0 end)

print("数字列表: " .. listtools.toString(nums))
print("数字的平方: " .. listtools.toString(squares))
print("偶数的平方: " .. listtools.toString(evenSquares))

-- map和filter演示
print("\n-- Map和Filter函数示例:")
local doubled = listtools.map(nums, function(x) return x * 2 end)
local evens = listtools.filter(nums, function(x) return x % 2 == 0 end)

print("数字乘2: " .. listtools.toString(doubled))
print("偶数: " .. listtools.toString(evens))

-- reduce函数演示
print("\n-- Reduce函数示例:")
local sum = listtools.reduce(nums, function(a, b) return a + b end)
local product = listtools.reduce(nums, function(a, b) return a * b end)

print("总和: " .. sum)
print("乘积: " .. product)

-- all和any函数演示
print("\n-- All和Any函数示例:")
print("都大于0? " .. tostring(listtools.all(nums, function(x) return x > 0 end)))
print("都大于5? " .. tostring(listtools.all(nums, function(x) return x > 5 end)))
print("存在偶数? " .. tostring(listtools.any(nums, function(x) return x % 2 == 0 end)))
print("存在大于15的数? " .. tostring(listtools.any(nums, function(x) return x > 15 end)))

-- 链式API演示
print("\n=== 链式API演示 ===")
local result = listtools.from(nums)
                :filter(function(x) return x % 2 == 0 end)  -- 过滤偶数
                :map(function(x) return x * x end)          -- 平方
                :toArray()

print("偶数的平方(链式): " .. listtools.toString(result))

-- 模拟Python列表推导式对比
print("\n=== 与Python列表推导式对比 ===")
print("Python: [x*x for x in range(1,11) if x % 2 == 0]")
print("Lua listtools: " .. listtools.toString(result))

-- 二维表格(嵌套table)处理示例
print("\n=== 二维表格处理示例 ===")

-- 创建一个3x3的二维表格
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}
print("原始矩阵:")
listtools.forEach(matrix, function(row)
    print("  " .. listtools.toString(row))
end)

-- 示例1: 对矩阵中所有元素进行操作 (相当于Python的[[x*2 for x in row] for row in matrix])
local doubledMatrix = listtools.comprehension(matrix, 
    function(row) 
        return listtools.comprehension(row, function(x) return x * 2 end)
    end
)

print("\n矩阵中所有元素乘2:")
listtools.forEach(doubledMatrix, function(row)
    print("  " .. listtools.toString(row))
end)

-- 示例2: 提取矩阵对角线元素 (用listtools实现)
local indices = listtools.range(1, #matrix + 1)
local diagonal = listtools.comprehension(indices, function(i)
    return matrix[i][i]
end)
print("\n矩阵对角线元素: " .. listtools.toString(diagonal))

-- 示例3: 矩阵转置 (用listtools实现)
local colIndices = listtools.range(1, #matrix[1] + 1)
local rowIndices = listtools.range(1, #matrix + 1)

local transposed = listtools.comprehension(colIndices, function(i)
    return listtools.comprehension(rowIndices, function(j)
        return matrix[j][i]
    end)
end)

print("\n矩阵转置:")
listtools.forEach(transposed, function(row)
    print("  " .. listtools.toString(row))
end)

-- 示例4: 计算每行的和
local rowSums = listtools.comprehension(matrix,
    function(row) 
        return listtools.reduce(row, function(a, b) return a + b end)
    end
)
print("\n每行的和: " .. listtools.toString(rowSums))

-- 示例5: 过滤矩阵中的偶数
local evenNumbers = listtools.comprehension(matrix,
    function(row)
        return listtools.filter(row, function(x) return x % 2 == 0 end)
    end
)
print("\n矩阵中的偶数:")
listtools.forEach(evenNumbers, function(row)
    print("  " .. listtools.toString(row))
end)

-- 示例6: 使用链式API创建和操作矩阵
local newMatrix = listtools.from(listtools.range(1, 4))
    :map(function(i)
        return listtools.from(listtools.range(1, 4))
            :map(function(j) return i * j end)
            :toArray()
    end)
    :toArray()

print("\n使用链式API创建的新矩阵:")
listtools.from(newMatrix)
    :forEach(function(row)
        print("  " .. listtools.toString(row))
    end)

-- 示例7: 扁平化二维数组
local flattened = listtools.from(matrix)
    :map(function(row)
        return listtools.from(row):toArray()
    end)
    :reduce(function(acc, row)
        local result = {}
        for i=1, #acc do result[i] = acc[i] end
        for i=1, #row do result[#result+1] = row[i] end
        return result
    end, {})

print("\n扁平化后的矩阵: " .. listtools.toString(flattened))

-- 示例8: 矩阵元素求和
local totalSum = listtools.from(matrix)
    :map(function(row)
        return listtools.reduce(row, function(a, b) return a + b end)
    end)
    :reduce(function(a, b) return a + b end)

print("\n矩阵所有元素之和: " .. totalSum)

-- 示例9: 使用链式forEach进行打印
print("\n使用链式forEach函数进行打印:")
listtools.from(matrix)
    :forEach(function(row)
        print("  " .. listtools.toString(row))
    end) 