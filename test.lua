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
--=======================-- PAGE5 --=======================--
local page5 =main:addPage("page5")
local Rthread
Rthread = basalt.schedule(function ()
    basalt.LOGGER.info("test schedule:")
    local i = 0
    while i<10 do
        basalt.LOGGER.info("clicked")
        coroutine.yield("mouse_click")
        i = i+1
    end
    
end)
--=======================-- PAGE6 --=======================--
local page6 = main:addPage("page6")
local window2,content2 = toolkit.createPopup(page6,nil,nil,20,8,"test2",true,true)
content2:setFlexDirection("column"):setFlexAlignItems("stretch"):setFlexJustifyContent("center")
-- 测试createUIFromTable
local table1 = {
    type = "split",
    name = "split1",
    splitDirection = "column",
    splitNum = 2,
    childGrow = { 1, 1 },
    childNames = { "button1Box", "button2Box" },
    background = colors.brown,
    splitChildren = {
        {
            flexDirection = "column",
            flexJustifyContent = "center",
            flexAlignItems = "stretch",
            background = colors.green,
            children = {
                {
                    type = "button",
                    text = "button1",
                    background = colors.blue,
                }
            },
        },
        {
            flexDirection = "column",
            flexJustifyContent = "flex-end",
            flexAlignItems = "stretch",
            background = colors.cyan,
            children = {
                {
                    type = "button",
                    text = "button2",
                    background = colors.red,
                }
            },
        }
    }
}
local harvestObj = toolkit.createUIFromTable(content2,table1)

--=======================-- PAGE7 --=======================--
local page7 = main:addPage("page7")
--测试createButtonNumberInput
local numInput = toolkit.createButtonNumberInput(page7,"numInput",100,200,150,function(value)
    basalt.LOGGER.info("numInput: "..value)
end)
--测试createNumberEditorPopup
local _num = 150
local numEditor = toolkit.createNumberEditorPopup(page7,"numEditor",100,200,
    function()
        return _num
    end,
    function(value)
        _num = value
        basalt.LOGGER.info("numEditor: "..value)
    end
)


--测试createStringInput
local stringInput = toolkit.createStringInput(page7,"stringInput","test",function(value)
    basalt.LOGGER.info("stringInput: "..value)
end)
stringInput:setY(10):setWidth(20)

--测试createCheckboxInput
local checkboxInput = toolkit.createCheckboxInput(page7,"checkboxInput",true,function(value)
    basalt.LOGGER.info("checkboxInput: "..tostring(value))
end)
checkboxInput:setY(20):setWidth(20)

--=======================-- PAGE8 --=======================--
local page8 = main:addPage("page8")
--测试createTableEditorPopup
local _table = {
    {text = "item1",args = {a = 1,b = 2}},
    {text = "item2",args = {c = 3,d = 4}},
}
local popup8,content8,confirm8,cancel8,inputFlexboxs8 =
        toolkit.createTableEditorPopup(page8,"tableEditor",
            function()
                return _table
            end,
            function(value)
                basalt.LOGGER.info("tableEditor 1: ")
                print_table(_table,basalt.LOGGER.info)
                _table = value
                basalt.LOGGER.info("tableEditor 2: ")
                print_table(_table,basalt.LOGGER.info)
            end
        )

basalt:run()