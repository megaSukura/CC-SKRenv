--- @type basalt
local basalt = require(basaltPath)
local toolkit = require("toolkit.UItoolkit")
basalt.LOGGER.setEnabled(true)
basalt.LOGGER.setLogToFile(true)
basalt.LOGGER.info("test")

--=======================--



local main = basalt:getMainFrame()
main = toolkit.makeTaggedFrame(main)


--=======================-- PAGE1 --=======================--
local page1 = main:addPage("page1")

local window = toolkit.createPopup(page1,10,10,20,20,"test",true,true)
local window = toolkit.createPopup(page1,10,10,20,20,"test2",true,true)

basalt:run()