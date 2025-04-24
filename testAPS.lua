--- @type basalt
local basalt = require(basaltPath)
local toolkit = require("toolkit.UItoolkit")
local APS = require("lib.autoPreparationSystem")

if basalt then
APS.setPrintFunction( basalt.LOGGER.info)
end
local monitorFrame = basalt.getMainFrame()
local monitor = peripheral.find("monitor")
if monitor then
    monitor.setTextScale(0.5)
    monitorFrame:setTerm(monitor)
end
--- @type Frame
local mainFrame = toolkit.makeTaggedFrame(monitorFrame)
local craftThread
--- @type Flexbox
local settingPage = mainFrame:addPage(" Setting ", colors.lightGray,nil,nil,true)
--- @type Flexbox
local initPage = mainFrame:addPage(" Init ", colors.lightGray,nil,nil,true)
--- @type Flexbox
local itemListReadPage = mainFrame:addPage(" Read Item List ", colors.lightGray,nil,nil,true)
--- @type Flexbox
local craftTaskPage = mainFrame:addPage(" Task ", colors.lightGray,nil,nil,true)

-- #region 设置页面
settingPage:setFlexDirection("column"):setFlexAlignItems("stretch")
:setFlexJustifyContent("center")
    :setFlexSpacing(2)

settingPage:addButton("CPUsettingButton"):setBackground(colors.lightBlue)
:onClick(function(self)
    APS.loadCPUsConfig()
    --弹出CPU设置界面
    local popup,content,confirm,cancel = toolkit.createSimpleDialog(mainFrame, "{parent.width/2-13}", "{parent.height/2-7}", 25, 14, "cpu setting",true,true)
    --- @type TextBox
    local textFild= content:addTextBox():setHeight(5)
    for cpu,_ in pairs(APS.craftingCPUs) do
        -- BPrintTable(basalt,cpu)
        -- textFild:addLine(cpu)
        table.insert(textFild:getLines(),cpu)
    end
    popup:sorting()
    confirm:onClick(function(self)
        --保存设置
        -- 清空:注意,这里不能直接={}来清空,因为这样会导致原表的引用丢失,无法保存
        for key,_ in pairs(APS.craftingCPUs) do
            APS.craftingCPUs[key] = nil
        end
        for i,cpu in pairs(textFild:getLines()) do
            APS.craftingCPUs[cpu] = true
        end
        APS.saveCPUsConfig()
        if APS.isInit() then
            APS.loadCPUsConfig()
            APS.initFreeCPU()
        end
        popup:close()
    end)
end):setText("CPU setting")
--#endregion

--#region 初始化页面
initPage:setFlexDirection("column")
    :setFlexJustifyContent("center"):setFlexAlignItems("center")
    :setFlexSpacing(2)
local initPageTable = {
    {
        type = "Label",
        name = "titleLabel",
        text = "Auto Preparation",
        fontSize = 1
    },
    {
        name = "startLabel",
        type = "Label",
        text = "-System-",
        fontSize = 2,
        background = colors.gray
    },
    {
        type = "Button",
        name = "startButton",
        text = "Start",
        background = colors.green,
        
    },
    {
        type = "Button",
        name = "settingButton",
        text = "Setting",
        background = colors.lightBlue,
        
    }
}
local initPageObj = toolkit.createUIFromTable(initPage, initPageTable)
initPageObj.titleLabel:animate():morphText("text","Auto Preparation",5)
                                -- :sequence()
                                :entries("foreground",{colors.lightBlue,colors.blue,colors.lightBlue,colors.cyan},5)
                                :start()
initPageObj.startButton:onClick(function(self)
    --初始化,初始化失败则弹出提示,初始化成功则跳转到下一页
    if APS.init() then
        mainFrame.topBar:getItems()[2].page:setVisible(false)
        mainFrame.topBar:getItems()[3].page:setVisible(true)
    else
        toolkit.createAlert(mainFrame,"{parent.width/2-20}","{parent.height/2-6}",40,20,"Initialization failed!")
    end
end)
initPageObj.settingButton:onClick(function(self)
    mainFrame.topBar:getItems()[2].page:setVisible(false)
    mainFrame.topBar:getItems()[1].page:setVisible(true)
end)
-- #endregion

-- #region 读取物品列表页面
itemListReadPage:setFlexAlignItems("stretch")
local itemListReadTable = {
    type = "split",
    splitDirection = "row",
    splitNum = 2,
    childGrow = { 1.5, 1 },
    childShrink = { 1.5, 1 },
    childNames = { "itemListRight", "itemOperationLeft" },
    splitChildren = {
        {
            flexDirection = "column",
            flexJustifyContent = "center",
            flexAlignItems = "stretch",
            children = {
                {
                    type = "Label",
                    text = "Task list summary",
                    background = colors.lightBlue,
                    textAlign = "center",
                },
                {
                    type = "List",
                    height = 10,
                    name = "taskList",
                    flexGrow = 1,
                }
            }
        },
        {
            flexDirection = "column",
            flexJustifyContent = "flex-end",
            flexAlignItems = "stretch",
            flexSpacing = 1,
            children = {
                {
                    type = "Button",
                    name = "readButton",
                    text = "read ltem list",
                    
                    background = colors.lightBlue,
                },
                {
                    type = "Button",
                    name = "StartButton",
                    text = "Start->",
                    
                    background = colors.green,
                }
            }
        }
    }
}
local itemListReadObj = toolkit.createUIFromTable(itemListReadPage, itemListReadTable)
itemListReadObj.itemListRight:setBackground(colors.white)
itemListReadObj.taskList:setBackground(colors.gray)
itemListReadObj.taskList:addItem("111")
itemListReadObj.taskList:addItem("111")
-- 按下刷新按钮,尝试导出物品列表中的物品,并获得需要制作的任务列表
itemListReadObj.readButton:onClick(function(self)
    APS.getData()
    itemListReadObj.taskList:clear()
    
    for i,task in ipairs(APS.itemsList) do
        local taskStr = task.id.." x"..task.quantity
        itemListReadObj.taskList:addItem(taskStr)
    end
end)
-- 按下开始按钮,并跳转到下一页
itemListReadObj.StartButton:onClick(function(self)
    mainFrame.topBar:getItems()[3].page:setVisible(false)
    mainFrame.topBar:getItems()[4].page:setVisible(true)
end)

--#endregion

--#region 任务页面
craftTaskPage:setFlexDirection("column")
    :setFlexJustifyContent("center"):setFlexAlignItems("stretch")
    :setFlexSpacing(1)

local craftTaskTable = {
    {
        type = "ProgressBar",
        name = "taskProgress",
        progress = 10,
        height = 2,
    },
    {
        type = "List",
        name = "logList",
        background = colors.lightGray,
        foreground = colors.black,
        flexGrow = 2,
        flexShrink = 5,
        flexBasis = 2,
    },
    {
        type = "Frame",
        name = "dividingLine",
        background = colors.gray,
        height = 1,
    },
    {
        type = "Flexbox",
        flexDirection = "row",
        flexJustifyContent = "space-between",
        flexAlignItems = "center",
        baseDraw = false,
        height = 3,
        children = {
            {
                type = "Label",
                text = "failed task: ",
                flexGrow = 1,
                fontSize = 1
            },
            {
                type = "Button",
                name = "retryButton",
                text = "Retry",
                background = colors.green,
                
            }
        }
    },
    {
        type = "List",
        background = colors.gray,
        name = "failedTaskList",
        flexGrow = 1,
        flexBasis = 4,
        flexShrink = 1,
    }
}
local craftTaskObj = toolkit.createUIFromTable(craftTaskPage, craftTaskTable)
craftTaskObj.taskProgress:setBackground(colors.green)
craftTaskObj.dividingLine:setBackground(colors.gray)
craftTaskObj.logList:addItem("Log:")
--在读取物品列表页面中,按下开始按钮,开始准备物品
local function startTask()
    APS.tasking(
        --onAddTask
        function(id,quantity)
            craftTaskObj.logList:addItem("Add task: "..id.." x"..quantity)
            craftTaskObj.taskProgress:setProgress(APS.getTaskProgress())
        end,
        --onStartTask
        function(id,quantity,cpu)
            craftTaskObj.logList:addItem("Start task: "..id.." x"..quantity.." on "..cpu)
        end,
        --onTaskSuccess
        function(id,quantity,cpu)
            craftTaskObj.logList:addItem("Task success: "..id.." x"..quantity.." on "..cpu)
            craftTaskObj.taskProgress:setProgress(APS.getTaskProgress())
        end,
        --onTaskFailed
        function(id,quantity,cpu)
            craftTaskObj.logList:addItem("Task failed: "..id.." x"..quantity.." on "..cpu)
            craftTaskObj.taskProgress:setProgress(APS.getTaskProgress())
            craftTaskObj.failedTaskList:addItem(id.." x"..quantity)
        end,
        --onDone
        function()
            craftTaskObj.logList:addItem("All tasks are done!")
            craftTaskObj.taskProgress:setProgress(APS.getTaskProgress())
        end
    )
end
itemListReadObj.StartButton:onClick(function(self)
    craftTaskObj.logList:clear()
    craftTaskObj.failedTaskList:clear()
    craftTaskObj.taskProgress:setProgress(0)
    if craftThread or (coroutine.status(craftThread) or "nil") ~= "suspended" then

        craftThread = basalt.schedule(startTask)

    else
        basalt.LOGGER.info("task is " .. (craftThread:getStatus() or "nil"))
    end
end)
craftTaskObj.retryButton:onClick(function(self)
    if craftThread or(coroutine.status(craftThread) or "nil") ~= "suspended" then
    -- 重试失败的任务,不删除log
    craftTaskObj.logList:addItem("Retry:")
    craftTaskObj.failedTaskList:clear()
    craftTaskObj.taskProgress:setProgress(0)

    craftThread = basalt.schedule(startTask)

    else
        basalt.LOGGER.info("task is " .. (craftThread:getStatus() or "nil"))
    end
end)


--#endregion




mainFrame.topBar:getItems()[2].page:setVisible(true)
basalt.run() -- Starts the auto update loop
