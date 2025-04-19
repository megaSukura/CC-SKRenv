
local clamp = function(value, min, max)
    return math.min(math.max(value, min), max)
end
local isContain = function (table,element)
    for _,v in pairs(table) do
        if v == element then
            return true
        end
    end
    return false
    
end
local function split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

local function tableCount(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
    
end
local function tableToString(t,filter)
    local str=""
    local writeRow = function(rowStr)
        if str == "" then
            str = rowStr or"\n"
        else
            str = str.."\n"..(rowStr or"\n")
        end
    end
    print_table(t,writeRow,filter)
    return str
end

----
local toolkit = {}
----
--- 创建可调整大小的框架
--- @param frame Frame 框架
--- @param minW number|nil 最小宽度
--- @param minH number|nil 最小高度
--- @param maxW number|nil 最大宽度
--- @param maxH number|nil 最大高度
--- @return Frame 调整后的框架
local function makeResizeable(frame, minW, minH, maxW, maxH)
    minW = minW or 4
    minH = minH or 4
    maxW = maxW or 99
    maxH = maxH or 99
    frame:setDraggable(true)
    local btn = frame:addButton()
        :setIgnoreOffset(true)
        :setPosition("{parent.width}", "{parent.height}")
        :setSize(1, 1)
        :setText("/")
        :setForeground(colors.white)
        :setBackground(colors.black)
        :onDrag(function(self,btn, x, y)
            local w, h = frame:getSize()
            frame:setSize(w+x-1, h+y-1)
        end)
        --
        :onClick(function(self)
            self:setBackground(colors.white)
            self:setForeground(colors.black)
        end)
        btn:onClickUp(function(self)
            self:setBackground(colors.black)
            self:setForeground(colors.white)
        end)
    return frame
end

--
local function makeTaggedFrame(frame)
    local topBar = frame:addMenu()
        :setPosition(1, 1)
        :setSize("{parent.width}", 1)
        :setBackground(colors.lightGray)
        :setIgnoreOffset(true)
    local onTopBarSelect = function(self)
        local cont = #self:getItems()
        for i = 1, cont do
            local item = self:getItems()[i]
            if item.text == self:getSelectedItem().text then
                --print_r(item.args[1])
                item.page:setVisible(true)
            else
                item.page:setVisible(false)
            end
        end
    end

    local addPage = function(self,name, BackgroundColor, tabFrotColor, tabBgColor)
        BackgroundColor = BackgroundColor or colors.white
        tabFrotColor = tabFrotColor or colors.white
        tabBgColor = tabBgColor or colors.gray
        local page = frame:addFrame()
            :setPosition(1, 2)
            :setSize("{parent.width-1}", "{parent.height-2}")
            :setBackground(BackgroundColor)
            :setVisible(false)
        topBar:addItem({text=name,background=tabBgColor,foreground=tabFrotColor,page=page})
            :onSelect(onTopBarSelect)
        return page
    end
    frame.addPage = addPage
    frame.topBar = topBar

    return frame
end

--- 组合控件:弹出框
local function createPopup(container, x, y, w, h, title,Draggable,Resizable)
    x = x or "{math.floor((parent.width-self.width) / 2 > 0 and math.floor((parent.width-self.width) / 2) or 1)}"
    y = y or "{math.floor((parent.height-self.height) / 2 > 0 and math.floor((parent.height-self.height) / 2) or 1)}"
    local popup = container:addFrame()
        :setSize(w, h)
        :setPosition(x, y)
        :setBackground(colors.gray)
        :setForeground(colors.white)
        -- :setBorder(colors.black)
        :setDraggable(Draggable)
        
    
    local title = popup:addLabel()
        :setPosition(1, 1)
        :setText(title)
        :setForeground(colors.black)
        :setBackground(colors.white)
    local closeF = function()
        
        -- local targetX , targetY = popup:getPosition()
        -- targetY = - popup:getHeight()
        -- popup:animatePosition(targetX,targetY,0.2,0,"easeInOutCirc",function()
        --     container:removeChild(popup)
        -- end)
        container:removeChild(popup)
    end
    local close = popup:addButton()
        :setPosition("{parent.width}", 1)
        :setSize(1, 1)
        :setText("X")
        :setForeground(colors.black)
        :setBackground(colors.red)
        :onClickUp(closeF)
    local content = popup:addFlexbox()
        :setPosition(2, 2)
        :setSize("{parent.width-2}", "{parent.height-2}")
        :setBackground(colors.lightGray)
        
        if Resizable then
            popup=makeResizeable(popup)
        end
    popup:prioritize()
    popup:onFocus(function(self)
        popup:prioritize()
        self:setBackground(colors.lightBlue)
    end)
    popup:onBlur(function(self)
        self:setBackground(colors.gray)
    end)
    
    popup.content = content
    popup.title = title
    popup.close = closeF
    return popup,content
end
--组合控件:带标签的布局
local function addLabeledFlexbox(parent,labelText,labelColor,direction,pandding)
     labelColor = labelColor or colors.black
    pandding = pandding or 0
    direction = direction or "row"
    local labelLength = #labelText
    local flexbox = parent:addFlexbox()--:setSize(1,1)
    :setFlexDirection(direction):setFlexAlignItems("center")
    local label = flexbox:addLabel():setText(labelText):setBackgroundEnabled(false):setIgnoreOffset(true)
    flexbox:setBackground(parent:getBackground())
    label:setForeground(labelColor)
    -- label:setFlexMinWidth(labelLength+1):setFlexMaxHeight(1)
    flexbox.label = label
    flexbox.setLabelText = function(self,text)
        self.label:setText(text)
    end
    return flexbox , label
    
end

--组合控件:简单对话框
local function createSimpleDialog(container, x, y, w, h, title,Draggable,Resizable)
    local popup,content = createPopup(container, x, y, w, h, title,Draggable,Resizable)
    content:setFlexDirection("column"):setFlexAlignItems("stretch"):setFlexSpacing(1)

    local restSpace =content:addFlexbox():setFlexDirection("row"):setFlexAlignItems("flex-end"):setFlexJustifyContent("flex-end"):setFlexSpacing(1)
                                        :setFlexGrow(0.1):setFlexShrink(999):setFlexOrder(999):setFlexMinHeight(2)--:setBorder(colors.red)
                                        :setBackground(content:getBackground())
    local confirm = restSpace:addButton():setText("Confirm"):setFlexGrow(1):setFlexShrink(1):setFlexMinWidth(3)
    local cancel = restSpace:addButton():setText("Cancel"):setFlexGrow(1):setFlexShrink(1):setFlexMinWidth(3)

    cancel:onClickUp(popup.close)

    popup.confirmButton = confirm
    popup.cancelButton = cancel

    return popup,content,confirm,cancel,restSpace
end
--组合控件:提示框
local function createAlert(container, x, y, w, h, text,onConfirm,onCancel)
    local popup,content,confirm,cancel = createSimpleDialog(container, x, y, w, h, "Alert",true,true)
    local label = content:addLabel():setText(text):setFlexGrow(1):setFlexShrink(1):setFlexOrder(1)
    confirm:onClickUp(onConfirm, popup.close)
    cancel:onClick(onCancel)
    return popup,content,confirm,cancel,label
end
--组合控件:列表选择器
 -- items = { {text = "item1",bg=,fg=,args={}}, ...}
local function createListSelector(container, x, y, w, h, title,Draggable,Resizable,items,onConfirm)
    local popup,content,confirm,cancel = createSimpleDialog(container, x, y, w, h, title,Draggable,Resizable)
    local items = items or {}
    local itemNum = #items
    local list = content:addList():setFlexGrow(0.1):setFlexMinHeight(clamp(itemNum,1,3)):setFlexOrder(1)

    
    for i=1,itemNum do
        list:addItem(items[i].text,items[i].bg,items[i].fg,items[i].args)
    end
    confirm:onClickUp(function()
        local selected = list:getValue()
        if selected and onConfirm then
            onConfirm(selected,selected.text,selected.args)
        end
    end)
    confirm:onClickUp(popup.close)

    popup.list = list
    return popup,content,confirm,cancel,list
end
--组合控件:通用列表
local function createGenericList(parent,title,direction,pandding,gap,alignItems,justifyContent)
    direction = direction or "column"
    pandding = pandding or {0,1,1,1}
    gap = gap or 1
    alignItems = alignItems or "flex-start"
    justifyContent = justifyContent or "flex-start"
    local flexbox = parent:addFlexbox()
    :setFlexDirection(direction):setFlexSpacing(gap):setFlexAlignItems(alignItems):setFlexJustifyContent(justifyContent)
    flexbox:setBackground(parent:getBackground())
    flexbox:setBorder(colors.black)
    if parent:getType() == "flexbox" then
        flexbox:setFlexGrow(1):setFlexShrink(0)
    end
    flexbox:addLabel():setText(title):setForeground(colors.black):setBackground(parent:getBackground()):setFlexOrder(-1)
    return flexbox
    
end
--组合控件:滑条输入框
local function createSliderInput(parent,label, min, max, defaultValue,onValueChange)
    local flexbox = parent:addFlexbox():setFlexDirection("row"):setFlexSpacing(1):setFlexAlignItems("center")
    flexbox:setFlexShrink(1):setHeight(5)
    flexbox:setBackground(parent:getBackground())
    flexbox.label = flexbox:addLabel():setText(label):setForeground(colors.black):setBackground(parent:getBackground()):setFlexGrow(1):setFlexShrink(0)

    flexbox.slider = flexbox:addSlider():setFlexGrow(5):setFlexShrink(0):setSymbolForeground(colors.lightBlue)
    flexbox.slider:setMaxValue(max-min):setValue(defaultValue-min)

    flexbox.input = flexbox:addInput():setFlexGrow(1):setFlexShrink(0)
    flexbox.input:setInputType("number")
    flexbox.input:setValue(tostring(defaultValue))

    flexbox.slider:onChange(function(self,e, value)
        flexbox.input:rawSetValue(tostring(value+min))
        if onValueChange then
            onValueChange(value+min)
        end
    end)
    flexbox.input:onChange(function(self,e, value)
        local num = tonumber(value)
        if num then
            num = clamp(num,min,max)
            flexbox.slider:setValue(num-min)
            if onValueChange then
                onValueChange(num)
            end
        end
    end)
    flexbox.input:onLoseFocus(function(self)
        local num = tonumber(self:getValue())
        if num then
            num = clamp(num,min,max)
            self:setValue(tostring(num))
        end
    end)
    
    return flexbox
end
--组合控件:数值编辑器
local function createNumberEditorPopup(parent,title, min, max, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{parent.width/2-10}", "{parent.height/2-5}", 25, 14, title,true,false)
    local dirtyValue = getter()
    local inputFlexbox = createSliderInput(content,"Value",min,max,getter(),function(value)
        dirtyValue = value
    end)
    inputFlexbox.input:setValue(tostring(getter()))
    confirm:onClickUp(function()
        
        if dirtyValue then
            dirtyValue = clamp(dirtyValue,min,max)
            setter(dirtyValue)
        end
    end)
    confirm:onClickUp(popup.close)
    return popup,content,confirm,cancel,inputFlexbox
end
--组合控件:字符串输入框
local function createStringInput(parent,label,defaultValue,onValueChange)
    local flexbox = parent:addFlexbox():setFlexDirection("row"):setFlexSpacing(1):setFlexAlignItems("center")
    flexbox:setFlexShrink(1):setHeight(5)
    flexbox:setBackground(parent:getBackground())
    flexbox.label = flexbox:addLabel():setText(label):setForeground(colors.black):setBackground(parent:getBackground()):setFlexGrow(1):setFlexShrink(0)

    flexbox.input = flexbox:addInput():setFlexGrow(5):setFlexShrink(0):setWidth(10)
    flexbox.input:setValue(defaultValue)
    flexbox.input:onChange(function(self,e, value)
        if onValueChange then
            onValueChange(value)
        end
    end)
    return flexbox
end
--组合控件:字符串编辑器
local function createStringEditorPopup(parent,title, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{parent.width/2-10}", "{parent.height/2-5}", 25, 14, title,true,true)
    local dirtyValue = getter()
    local inputFlexbox = createStringInput(content,"Value",getter(),function(value)
        dirtyValue = value
    end)
    confirm:onClickUp(function()
        if dirtyValue then
            setter(dirtyValue)
        end
    end)
    confirm:onClickUp(popup.close)
    return popup,content,confirm,cancel,inputFlexbox
end
--组合控件:switch(开关)输入框
local function createSwitchInput(parent,label,defaultValue,onValueChange)
    local flexbox = parent:addFlexbox():setFlexDirection("row"):setFlexSpacing(1):setFlexAlignItems("center")
    flexbox:setFlexShrink(1):setHeight(5)
    flexbox:setBackground(parent:getBackground())
    flexbox.label = flexbox:addLabel():setText(label):setForeground(colors.black):setBackground(parent:getBackground()):setFlexGrow(5):setFlexShrink(0)

    flexbox.switch = flexbox:addSwitch():setFlexGrow(1):setFlexShrink(0):setWidth(3)
    flexbox.switch:setValue(defaultValue)
    flexbox.switch:onChange(function(self,e, value)
        if onValueChange then
            onValueChange(value)
        end
    end)
    return flexbox
end
--组合控件:布尔编辑器
local function createBooleanEditorPopup(parent,title, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{parent.width/2-10}", "{parent.height/2-5}", 25, 14, title,true,false)
    local dirtyValue = getter()
    local inputFlexbox = createSwitchInput(content,"Value",getter(),function(value)
        dirtyValue = value
    end)
    confirm:onClickUp(function()
        if dirtyValue then
            setter(dirtyValue)
        end
    end)
    confirm:onClickUp(popup.close)
    return popup,content,confirm,cancel,inputFlexbox
end
-- 生成table里deep的基础对象对应的UI
-- 找到table里的所有底层对象和key(只保留最底层的对象的key:以XXX-XXX-XXX的形式)
local function getDeepKeys(t,keys,preKey)
    keys = keys or {}
    for k,v in pairs(t) do
        if type(v) == "table" then
            getDeepKeys(v,keys,preKey and preKey.."-"..k or k)
        else
            keys[preKey and preKey.."-"..k or k] = v
        end
    end
    return keys
end
-- 根据deepKeys反过来修改table的值
local function setDeepKeys(t,deepKeys)
    for k,v in pairs(deepKeys) do
        local keys = split(k, "-")
        local temp = t
        if #keys>1 then
            for i=1,#keys-1 do
                local numKey = tonumber(keys[i])
                if numKey then
                    temp = temp[numKey]
                else
                    temp = temp[keys[i]]
                end
            end
            
        else
            temp = t
        end
        temp[keys[#keys]] = v
    end
    return t
end

--组合控件:table编辑器
local function createTableEditorPopup(parent,title, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{parent.width/2-10}", "{parent.height/2-5}", 41, 24, title,true,true)
    local dirtyValue = getter()
    local inputFlexboxs = {}
    local deepValue = getDeepKeys(dirtyValue)
    for k,v in pairs(deepValue) do
        -- 根据value的类型生成对应的UI
        local inputFlexbox
        if type(v) == "number" then
            inputFlexbox = createSliderInput(content,k,-1000,1000,v,function(value)
                deepValue[k] = value
            end)
        elseif type(v) == "string" then
            inputFlexbox = createStringInput(content,k,v,function(value)
                deepValue[k] = value
            end)
        elseif type(v) == "boolean" then
            inputFlexbox = createSwitchInput(content,k,v,function(value)
                deepValue[k] = value
            end)
        end
    end
    
    confirm:onClickUp(function()
        setDeepKeys(dirtyValue,deepValue)
        if dirtyValue then
            setter(dirtyValue)
        end
    end)
    confirm:onClickUp(popup.close)
    return popup,content,confirm,cancel,inputFlexboxs
end

local function createValueEditorPopup(parent,title,typ,getter,setter)
    local popup,content,confirm,cancel
    if typ == "number" then
        popup,content,confirm,cancel = createNumberEditorPopup(parent,title, -1000, 1000, getter, setter)
    elseif typ == "string" then
        popup,content,confirm,cancel = createStringEditorPopup(parent,title, getter, setter)
    elseif typ == "boolean" then
        popup,content,confirm,cancel = createBooleanEditorPopup(parent,title, getter, setter)
    elseif typ == "table" then
        popup,content,confirm,cancel = createTableEditorPopup(parent,title, getter, setter)
    end
    return popup,content,confirm,cancel
    
end


















------------------------------------------------
--SplitSpace 被废弃,改用NSplitSpace
-- local function createSplitSpace(container,direction,firstGrow,secondGrow,firstShrink,secondShrink,firstMin,secondMin)
--     direction = direction or "column"
--     firstGrow = firstGrow or 1
--     secondGrow = secondGrow or 1
--     firstShrink = firstShrink or 0
--     secondShrink = secondShrink or 0
--     firstMin = firstMin or 0
--     secondMin = secondMin or 0
--     local flexbox = container:addFlexbox()
--     :setFlexDirection(direction):setFlexSpacing(0):setFlexAlignItems("stretch")

--     flexbox:setBackground(container:getBackground()):setBaseDraw(false)
--     container:setBaseDraw(false)
--     --flexbox:setBorder(colors.red)
--     if container:getType() == "Flexbox" then
--         flexbox:setFlexGrow(1):setFlexShrink(0)
--     end
--     local first = flexbox:addFlexbox():setFlexDirection(direction):setFlexSpacing(0):setFlexAlignItems("stretch")
--     --local first = flexbox:addFrame()
--     first:setBackground(container:getBackground())--:setBorder(colors.blue)
--     first:setFlexGrow(firstGrow):setFlexShrink(firstShrink)
--     first:setBaseDraw(false)
--     local second = flexbox:addFlexbox():setFlexDirection(direction):setFlexSpacing(0):setFlexAlignItems("stretch")
--     --local second = flexbox:addFrame()
--     second:setBackground(container:getBackground())--:setBorder(colors.purple)
--     second:setFlexGrow(secondGrow):setFlexShrink(secondShrink)
--     second:setBaseDraw(false)
--     flexbox.first = first
--     flexbox.second = second

--     return flexbox,first,second
-- end
--lyout组合控件:分割空间
local function createNSplitSpace(container,selfname,direction,splitNum,grow,shrink,min,names)
    direction = direction or "column"
    
    if type(grow)~="table" then
        error("grow must be a table")
    end
    if type(shrink)~="table" then
        error("shrink must be a table")
    end
    if min and type(min)~="table" then
        error("min must be a table")
    end
    if names and type(names)~="table" then
        error("names must be a table")
    elseif not names then
        names = {}
    end
    
    local flexbox = container:addFlexbox(selfname)
    :setFlexDirection(direction):setFlexSpacing(0):setFlexAlignItems("stretch")
    flexbox:setBackground(container:getBackground()):setBaseDraw(false)
    container:setBaseDraw(false)
    if container:getType() == "Flexbox" then
        flexbox:setFlexGrow(1):setFlexShrink(0)
    end
    flexbox["split"] = setmetatable({},{__mode="v"}) -- !!:弱引用,防止内存泄漏
    for i=1,splitNum do
        local split = flexbox:addFlexbox(names[i]):setFlexDirection(direction):setFlexSpacing(0):setFlexAlignItems("stretch")
        split:setBackground(container:getBackground())
        split:setFlexGrow(grow[i]):setFlexShrink(shrink[i])

        split:setBaseDraw(false)
        flexbox["split"][i] = split
    end
    return flexbox
end

--⭐⭐⭐⭐⭐
-- @param container: 容器
-- @param table: 一个table,包含了所有的UI元素的属性
-- @return harvestObj: 一个弱引用的table,包含了所有设置了name的对象
local function createUIFromTable(container, table)
    --如果table直接含有type属性,则判断为单个元素
    if table.type then
        table = {table}
    end
    local harvestObj = setmetatable({},{__mode="v"}) -- --所有设置了name的对象,弱引用
    for _, item in ipairs(table) do
        local obj
        if item.type == "split" then
            obj = createNSplitSpace(container,item.name, item.splitDirection or "column", item.splitNum or 2, item.childGrow or {1, 1}, item.childShrink or {0, 0}, item.childBasis or nil,item.childNames or nil)
            if item.name then harvestObj[item.name] = obj end
            for i, splitChild in ipairs(item.splitChildren or {}) do -- 注意这里是splitChildren,而不是children
                --splitChild无法修改属性,所以这里专门设置
                for key, value in pairs(splitChild) do
                    if key ~= "type" and key ~= "children"  then
                        local method = "set" .. key:gsub("^%l", string.upper)
                        if obj["split"][i][method] then
                            obj["split"][i][method](obj["split"][i], value)
                        end
                    end
                end
                local subH= createUIFromTable(obj["split"][i], splitChild.children)
                for k,v in pairs(subH) do
                    harvestObj[k] = v
                end
                if item.childNames and item.childNames[i] then harvestObj[item.childNames[i]] = obj["split"][i] end
            end
        else
            local method = "add" .. item.type:gsub("^%l", string.upper)
            if container[method] then
                obj = container[method](container,item.name)
                if item.name then harvestObj[item.name] = obj end
            end
        end

        if obj then
            for key, value in pairs(item) do
                if key ~= "type" and key ~= "children" then
                    local method = "set" .. key:gsub("^%l", string.upper)
                    if obj[method] then
                        obj[method](obj, value)
                    end
                end
            end

            if item.children and item.type ~= "split" --[[and isContain(obj:getTypes(),"Container")]] then
                local subH= createUIFromTable(obj, item.children)
                for k,v in pairs(subH) do
                    harvestObj[k] = v
                end
            end
        end
    end
    return harvestObj
end
--#region

-- -- MVC -- --
--controller
-- @param observable: 被观察者
-- @param observeFuncName: 被观察者的方法名
-- @param observer: 观察者
-- @param observerFuncName: 观察者的方法名,如果为空则直接调用observer
-- 信息流向: 当observable的observeFuncName对应事件发生时,observer的observerFuncName对应方法被调用
-- 例子1: bind(someButton, "onClickUp", someObject, "someMethod")
-- 例子2: bind(someInput,"onChange",someObject,"someMethod")
local function bind(observable, observeFuncName, observer, observerFuncName)
    if observerFuncName then
        observable[observeFuncName](observable, function (...)
            observer[observerFuncName](observer, ...)
        end)
    else
        observable[observeFuncName](observable, function (...)
            observer(...)
        end)
    end
end

local function wrapFunction(wrapFunc,requireParams,isUnpack)
    --requireParams: 一个table,包含了所有需要的参数的位置
    --如:{2,1} 表示第一个参数是第二个参数,第二个参数是第一个参数
    --如{1} 只需要第一个参数
    return function(...)
        local params = {...}
        local newParams = {}
        if type(requireParams)=="table" then
            for _,v in ipairs(requireParams) do
                table.insert(newParams,params[v])
            end
        else
            newParams = params
        end
        if isUnpack then
            return wrapFunc(table.unpack(newParams))
        else
            return wrapFunc(newParams)
        end
    end
end

local function wrapObserver(observer,wrapFuncName,requireParams,isUnpack)
    return function(...)
        local params = {...}
        local newParams = {}
        if type(requireParams)=="table" then
            for _,v in ipairs(requireParams) do
                table.insert(newParams,params[v])
            end
        else
            newParams = params
        end

        if isUnpack then
            observer[wrapFuncName](observer,table.unpack(newParams))
        else
            observer[wrapFuncName](observer,newParams)
        end
    end
end

--综合例子
--bind(someButton, "onClickUp", wrapObserver(someInfoBoj,"setValue",{3,4},false))
--bind(someInput,"onChange",wrapObserver(someInfoBoj,"setValue",{2},true))


--#endregion
--
















--
toolkit={
    clamp=clamp
    ,isContain=isContain
    ,split=split
    ,getDeepKeys=getDeepKeys
    ,setDeepKeys=setDeepKeys
    ,tableCount=tableCount
    ,tableToString=tableToString
    ,
    makeResizeable=makeResizeable
    ,makeTaggedFrame=makeTaggedFrame,taggedFrame=makeTaggedFrame
    ,createPopup=createPopup,popup=createPopup
    ,addLabeledFlexbox=addLabeledFlexbox,labeledFlexbox=addLabeledFlexbox
    ,createSimpleDialog=createSimpleDialog,simpleDialog=createSimpleDialog
    ,createAlert=createAlert,alert=createAlert
    ,createListSelector=createListSelector,listSelector=createListSelector
    ,createGenericList=createGenericList,genericList=createGenericList
    ,createSliderInput=createSliderInput,sliderInput=createSliderInput
    ,createNumberEditorPopup=createNumberEditorPopup,numberEditorPopup=createNumberEditorPopup
    ,createStringInput=createStringInput,stringInput=createStringInput
    ,createStringEditorPopup=createStringEditorPopup,stringEditorPopup=createStringEditorPopup
    ,createSwitchInput=createSwitchInput,switchInput=createSwitchInput
    ,createBooleanEditorPopup=createBooleanEditorPopup,booleanEditorPopup=createBooleanEditorPopup
    ,createTableEditorPopup=createTableEditorPopup,tableEditorPopup=createTableEditorPopup
    ,createValueEditorPopup=createValueEditorPopup,valueEditorPopup=createValueEditorPopup
    ,
    createNSplitSpace=createNSplitSpace,nSplitSpace=createNSplitSpace
    ,createUIFromTable=createUIFromTable
    ,
    bind=bind
    ,wrapFunction=wrapFunction
    ,wrapObserver=wrapObserver
    
}
return toolkit