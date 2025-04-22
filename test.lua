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
    monitor.setTextScale(0.5)
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

local labeled = toolkit.addLabeledFlexbox(page1,"label"):setWidth(20)
labeled:addButton({text = "button",background = "{self.clicked and colors.black or colors.cyan}",foreground = "{self.clicked and colors.cyan or colors.black}"})
:onClick(function(self)
    self:animate()
    :morphText("text","Clicked",1)
    :start()
end)
--=======================-- PAGE2 --=======================--
local page2 = main:addPage("page2")

-- 创建一个tab栏弹出框,主要可以用于一些需要翻页的控件,特别是在monitor上,无法拖动,滚轮,键盘操作的时候
local popup,content,pages = toolkit.createTabPopup(page2,nil,nil,20,15,"test",{" 1 "," 2 "," 3 "," 4 "})
for i,v in pairs(pages) do
    v:addButton({text = "button "..i,background = "{self.clicked and colors.black or colors.cyan}",foreground = "{self.clicked and colors.cyan or colors.black}"})
    :onClick(function(self)
        basalt.LOGGER.info("clicked "..i)
    end)
end

--=======================-- PAGE3 --=======================--
local page3 = main:addPage("page3")
-- 创建一个简单对话框,主要可以用于一些需要确认的控件,特别是在monitor上,无法拖动,滚轮,键盘操作的时候
local popup,content,confirm,cancel,restSpace = toolkit.createSimpleDialog(page3,nil,nil,25,25,"test",true,true)

-- createAlert
local popup,content,confirm,cancel,label = toolkit.createAlert(page3,nil,nil,25,25,"test")

--=======================-- PAGE4 --=======================--
local page4 = main:addPage("page4")
local popup,content,confirm,cancel,list = toolkit.createListSelector(page4,nil,nil,25,25,"testlist",true,true,
    {
        {text = "item1",args = {}},
        {text = "item2",args = {}},
        {text = "item3",args = {}},
        {text = "item4",args = {}},
        {text = "item5",args = {}},
    },
    function(selected,text,args)
        basalt.LOGGER.info("selected "..selected.text)
    end)

basalt:run()