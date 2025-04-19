--- 加载basalt
-- _G.requireBasalt = function ()
--     local basalt = require("lib.basalt.src.init")
--     return basalt
-- end
_G.basaltPath = "lib/basalt/src/init"
--- 从lib目录加载模块
--- @param path string 模块路径
--- @return any 模块
_G.LibRequire = function (path)
    return require("lib/" .. path)
end
--- 打印table
_G.print_table = require("lib/print_r")
