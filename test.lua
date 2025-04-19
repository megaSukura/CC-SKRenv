--- @type basalt
local basalt = require(basaltPath)
local toolkit = require("toolkit.UItoolkit")
basalt.LOGGER.setEnabled(true)
basalt.LOGGER.setLogToFile(true)
basalt.LOGGER.info("test")

--=======================--



local main = basalt:getMainFrame()
local monitor = peripheral.find("monitor")
if monitor then
    main:setTerm(monitor)
end
main = toolkit.makeTaggedFrame(main)
main.topBar:onClick(function(self)
    basalt.LOGGER.info("1")
end)

--=======================-- PAGE1 --=======================--
local page1 = main:addPage("page1")

local window = toolkit.createPopup(page1,nil,nil,20,8,"test",true,true)
local window = toolkit.createPopup(page1,nil,nil,20,8,"test2",true,true)

local labeled = toolkit.addLabeledFlexbox(page1,"label")
labeled:addButton({text = "button",background = "{self.clicked and colors.black or colors.cyan}",foreground = "{self.clicked and colors.cyan or colors.black}"})

--=======================-- PAGE2 --=======================--
local page2 = main:addPage("page2")

local window = toolkit.createPopup(page2,nil,nil,20,8,"test",true,true)
local window = toolkit.createPopup(page2,nil,nil,20,8,"test2",true,false)



basalt:run()