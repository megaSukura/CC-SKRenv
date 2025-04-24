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
    --- add page
    --- @param self any
    --- @param name string|nil
    --- @param BackgroundColor ccTweaked.colors.color|nil
    --- @param tabFrotColor ccTweaked.colors.color|nil
    --- @param tabBgColor ccTweaked.colors.color|nil
    --- @param isFlexbox boolean|nil
    --- @return Frame|Flexbox
    local addPage = function(self,name, BackgroundColor, tabFrotColor, tabBgColor,isFlexbox)
        BackgroundColor = BackgroundColor or colors.white
        tabFrotColor = tabFrotColor or colors.white
        tabBgColor = tabBgColor or colors.gray
        if nil == isFlexbox then isFlexbox = false end
        local page
        if isFlexbox then
            --- @type Flexbox
            page = frame:addFlexbox()
            self:observe("width",function(self)
                page:setWidth(self:getWidth())
            end)
            self:observe("height",function(self)
                page:setHeight(self:getHeight())
            end)
        else
            --- @type Frame
            page = frame:addFrame()
        end
        page:setPosition(1, 2)
            :setSize("{parent.width}", "{parent.height-1}")
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
    x = x or (math.floor((container:getWidth()-w) / 2 > 0 and math.floor((container:getWidth()-w) / 2) or 1))
    y = y or (math.floor((container:getHeight()-h) / 2 > 0 and math.floor((container:getHeight()-h) / 2) or 1))
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
        -- container:removeChild(popup)
        popup:animate()
        :move(popup:getX(), -popup:getHeight(), 1,"easeOutQuad")
        :entries("background",{colors.red,colors.gray,colors.red,colors.gray,colors.black},1)
        :onComplete(function()
            container:removeChild(popup)
        end)
        :start()
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
    popup:observe("width",function(self)
        content:setSize(self:getWidth()-2,self:getHeight()-2)
        content:setFlexUpdateLayout(true)
    end)
    popup:observe("height",function(self)
        content:setSize(self:getWidth()-2,self:getHeight()-2)
        content:setFlexUpdateLayout(true)
    end)
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

--- 组合控件:tab栏弹出框,为了避免一些情况无法拖动,只能点击来翻页
local function createTabPopup(container, x, y, w, h, title,tabNames)
    local popup,content = createPopup(container, x, y, w, h, title,false,false)
    content = makeTaggedFrame(content)
    local pages = {}
    for _,v in pairs(tabNames) do
        local page = content:addPage(v)
        pages[#pages+1] = page
    end
    return popup,content,pages
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
    content:setFlexDirection("column"):setFlexAlignItems("stretch"):setFlexWrap(false)
    :setFlexJustifyContent("center")
    local restSpace =content:addFlexbox({height=3}):setFlexDirection("row"):setFlexAlignItems("flex-end"):setFlexJustifyContent("flex-end"):setFlexSpacing(1)
                                        :setFlexGrow(0.1):setFlexShrink(1)

    local confirm = restSpace:addButton():setText("Confirm"):setFlexGrow(1):setFlexShrink(1)
                                        :setBackground("{self.clicked and colors.black or colors.cyan}")
                                        :setForeground("{self.clicked and colors.cyan or colors.black}")
    local cancel = restSpace:addButton():setText("Cancel"):setFlexGrow(1):setFlexShrink(1)
                                        :setBackground("{self.clicked and colors.black or colors.cyan}")
                                        :setForeground("{self.clicked and colors.cyan or colors.black}")

    cancel:onClickUp(popup.close)

    popup.confirmButton = confirm
    popup.cancelButton = cancel
    popup.restSpace = restSpace
    popup.sorting = function(self)
        restSpace:prioritize()
    end
    return popup,content,confirm,cancel,restSpace
end
--组合控件:提示框
local function createAlert(container, x, y, w, h, text,onConfirm,onCancel)
    local popup,content,confirm,cancel,restSpace = createSimpleDialog(container, x, y, w, h, "Alert",true,true)
    local label = content:addLabel():setText(text):setFlexGrow(1):setFlexShrink(1)
    restSpace:prioritize()
    confirm:onClickUp(onConfirm, popup.close)
    cancel:onClick(onCancel)
    return popup,content,confirm,cancel,label
end
--组合控件:列表选择器
 -- items = { {text = "item1",bg=,fg=,args={}}, ...}
local function createListSelector(container, x, y, w, h, title,Draggable,Resizable,items,onConfirm)
    local popup,content,confirm,cancel,restSpace = createSimpleDialog(container, x, y, w, h, title,Draggable,Resizable)
    local items = items or {}
    local itemNum = #items
    local list = content:addList():setFlexGrow(0.1)
    restSpace:prioritize()
    
    for i=1,itemNum do
        list:addItem(items[i])
    end
    confirm:onClickUp(function()
        local selected = list:getSelectedItem()
        if selected and onConfirm then
            onConfirm(selected,selected.text,selected.args)
            popup.close()
        end
    end)
    confirm:onClickUp(popup.close)

    popup.list = list
    return popup,content,confirm,cancel,list
end


--组合控件:按钮数字输入框
--@param parent: 父元素
--@param label: 标签
--@param min: 最小值
--@param max: 最大值
--@param defaultValue: 默认值
--@param onValueChange: 值变化回调
--@return flexbox: 返回flexbox
local function createButtonNumberInput(parent,label,min,max,defaultValue,onValueChange)
    local flexbox = parent:addFlexbox():setFlexDirection("row"):setFlexSpacing(1):setFlexAlignItems("center")
    flexbox:setHeight(5):setWidth("{ math.floor(parent.width/2) }")
    if parent:getType() == "Flexbox" then
        flexbox:setFlexGrow(1)
        flexbox:setFlexShrink(1)
    end
        flexbox:setBackground(parent:getBackground())
    local label = flexbox:addLabel():setText(label):setForeground(colors.black):setBackground(parent:getBackground()):setFlexGrow(1):setFlexShrink(0)
    --2个按钮,1个下拉框,下拉框选择单次加减的幅度
    local step = 1

    local input
    local subButton = flexbox:addButton():setText("-"):setHeight(1):setWidth(3)
    subButton:setBackground("{self.clicked and colors.black or colors.cyan}")
    subButton:setForeground("{self.clicked and colors.cyan or colors.black}")
    subButton:onClickUp(function()
        local currentValue = tonumber(input:getText())
        if currentValue and currentValue > min then
            local newValue = currentValue-step
            if newValue and newValue >= min and newValue <= max then
                input:setText(tostring(newValue))
            else
                input:setText(tostring(min))
            end
        end
    end)
    input = flexbox:addInput():setFlexGrow(1):setFlexShrink(0):setBackground(colors.black):setForeground(colors.white)
    input:setPattern("^[%+%-]?%d*%.?%d*$")
    input:setText(tostring(defaultValue))
    input:observe("text",function(self)
        local currentValue = tonumber(self:getText())
        if onValueChange and currentValue and currentValue >= min and currentValue <= max then
            onValueChange(currentValue)
        end
    end)
    input:onBlur(function(self)
        local currentValue = tonumber(self:getText())
        if currentValue and currentValue < min then
            self:setText(tostring(min))
        elseif currentValue and currentValue > max then
            self:setText(tostring(max))
        end
    end)
    local addButton = flexbox:addButton():setText("+"):setHeight(1):setWidth(3)
    addButton:setBackground("{self.clicked and colors.black or colors.cyan}")
    addButton:setForeground("{self.clicked and colors.cyan or colors.black}")
    addButton:onClickUp(function()
        local currentValue = tonumber(input:getText())
        if currentValue and currentValue < max then
            local newValue = currentValue+step
            if newValue and newValue >= min and newValue <= max then
                input:setText(tostring(newValue))
            else
                input:setText(tostring(max))
            end
        end
    end)

    local dropdown = flexbox:addDropdown():setWidth(4)
    dropdown:setItems(
        {
            {text= "0.1",callback=function()
                step = 0.1
            end},
            {text="1",callback=function()
                step = 1
            end},
            {text="10",callback=function()
                step = 10
            end},
            
        }
    )
    
    return flexbox
end


--组合控件:数值编辑器
local function createNumberEditorPopup(parent,title, min, max, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{math.floor(parent.width/2)-10}", "{math.floor(parent.height/2-5)}", 25, 14, title,true,false)
    local dirtyValue = getter()
    local inputFlexbox = createButtonNumberInput(content,"Value",min,max,getter(),function(value)
        dirtyValue = value
    end)
    confirm:onClickUp(function()
        
        if dirtyValue then
            dirtyValue = clamp(dirtyValue,min,max)
            setter(dirtyValue)
        end
        popup.close()
    end)
    popup:sorting() -- 确保确认按钮在最下方
    return popup,content,confirm,cancel,inputFlexbox
end
--组合控件:字符串输入框
local function createStringInput(parent,label,defaultValue,onValueChange)
    local flexbox = parent:addFlexbox():setFlexDirection("row"):setFlexSpacing(1):setFlexAlignItems("center")
    flexbox:setHeight(5)
    if parent:getType() == "Flexbox" then
        flexbox:setFlexGrow(1)
        flexbox:setFlexShrink(1)
    end
    flexbox:setBackground(parent:getBackground())
    flexbox.label = flexbox:addLabel():setText(label):setForeground(colors.black):setBackground(parent:getBackground())
    flexbox.label:setWidth(#label)

    flexbox.input = flexbox:addInput():setFlexGrow(2):setFlexShrink(0):setWidth(10)
    flexbox.input:setText(defaultValue)
    flexbox.input:onBlur(function(self)
        if onValueChange then
            onValueChange(self:getText())
        end
    end)
    return flexbox
end
--组合控件:字符串编辑器
local function createStringEditorPopup(parent,title, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{math.floor(parent.width/2)-10}", "{math.floor(parent.height/2-5)}", 25, 14, title,true,true)
    local dirtyValue = getter()
    local inputFlexbox = createStringInput(content,"Value",getter(),function(value)
        dirtyValue = value
    end)
    confirm:onClickUp(function()
        if dirtyValue then
            setter(dirtyValue)
        end
        popup.close()
    end)
    popup:sorting() -- 确保确认按钮在最下方
    return popup,content,confirm,cancel,inputFlexbox
end
--组合控件:checkbox(复选框)输入框
local function createCheckboxInput(parent,label,defaultValue,onValueChange)
    local flexbox = parent:addFlexbox():setFlexDirection("row"):setFlexSpacing(1):setFlexAlignItems("center")
    flexbox:setHeight(5)
    if parent:getType() == "Flexbox" then
        flexbox:setFlexGrow(1)
        flexbox:setFlexShrink(1)
    end
    flexbox:setBackground(parent:getBackground())
    flexbox.label = flexbox:addLabel():setText(label):setForeground(colors.black):setBackground(parent:getBackground())
    flexbox.label:setWidth(#label)

    flexbox.checkbox = flexbox:addCheckbox():setBackgroundEnabled(true)
    :setBackground(colors.brown):setForeground(colors.black):setText(" "):setCheckedText("X")
    flexbox.checkbox:setChecked(defaultValue)
    flexbox.checkbox:observe("checked",function(self)
        if onValueChange then
            onValueChange(self:getChecked())
        end
    end)

    return flexbox
end
--组合控件:布尔编辑器
local function createBooleanEditorPopup(parent,title, getter, setter)
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{math.floor(parent.width/2)-10}", "{math.floor(parent.height/2-5)}", 25, 14, title,true,true)
    local dirtyValue = getter()
    local inputFlexbox = createCheckboxInput(content,"Value",getter(),function(value)
        dirtyValue = value
    end)
    confirm:onClickUp(function()
        if dirtyValue then
            setter(dirtyValue)
        end
        popup.close()
    end)
    popup:sorting() -- 确保确认按钮在最下方
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
    local popup,content,confirm,cancel = createSimpleDialog(parent, "{math.floor(parent.width/2)-10}", "{math.floor(parent.height/2-5)}", 30, 20, title,true,true)
    local dirtyValue = getter()
    local inputFlexboxs = {}
    local deepValue = getDeepKeys(dirtyValue)
    content:setFlexJustifyContent("flex-start")
    content = content:addFrame():setHeight("{math.floor(parent.height-5)}")
    -- 将content变为带标签页的框架
    content = makeTaggedFrame(content)
    popup:sorting()
    -- 页面计数和当前页面
    local pageCount = 0
    local currentPage = nil
    local currentHeight = 0
    local maxPageHeight = 14 -- 单页最大高度
    local pagePrefix = "seting "
    
    -- 创建新页面的函数
    local function createNewPage()
        pageCount = pageCount + 1
        local tabBgColor = colors.gray
        local tabFgColor = colors.white
        --轮转
        if pageCount%2 == 0 then
            tabBgColor = colors.white
            tabFgColor = colors.black
        else
            tabBgColor = colors.black
            tabFgColor = colors.white
        end
        currentPage = content:addPage(pagePrefix..pageCount, colors.gray , tabFgColor, tabBgColor, true)
        currentPage:setFlexDirection("column"):setFlexAlignItems("stretch")
        currentHeight = 0
        return currentPage
    end
    
    -- 创建第一个页面
    currentPage = createNewPage()
    
    -- 对每个值创建输入控件并根据控件高度分配到对应页面
    local keys = {}
    for k in pairs(deepValue) do table.insert(keys, k) end
    table.sort(keys) -- 对键进行排序以保持页面顺序一致
    
    for _, k in ipairs(keys) do
        local v = deepValue[k]
        local controlHeight = 5 -- 默认控件高度
        
        -- 检查是否需要创建新页面
        if currentHeight + controlHeight > maxPageHeight then
            currentPage = createNewPage()
        end
        
        -- 根据value的类型生成对应的UI
        local inputFlexbox
        if type(v) == "number" then
            inputFlexbox = createButtonNumberInput(currentPage, k, -1000, 1000, v, function(value)
                deepValue[k] = value
            end)
        elseif type(v) == "string" then
            inputFlexbox = createStringInput(currentPage, k, v, function(value)
                deepValue[k] = value
            end)
        elseif type(v) == "boolean" then
            inputFlexbox = createCheckboxInput(currentPage, k, v, function(value)
                deepValue[k] = value
            end)
        end
        
        if inputFlexbox then
            table.insert(inputFlexboxs, inputFlexbox)
            currentHeight = currentHeight + controlHeight
        end
    end
    
    -- 如果没有创建任何页面（空table的情况）
    if pageCount == 0 then
        createNewPage()
    end
    
    -- 确保最后一个页面可见
    currentPage:setVisible(true)
    
    confirm:onClickUp(function()
        setDeepKeys(dirtyValue,deepValue)
        if dirtyValue then
            setter(dirtyValue)
        end
        popup.close()
    end)
    return popup,content,confirm,cancel,inputFlexboxs
end

local function createValueEditorPopup(parent,title,typ,getter,setter)
    local popup,content,confirm,cancel
    if typ == "number" then
        popup,content,confirm,cancel = createNumberEditorPopup(parent,title, -math.huge, math.huge, getter, setter)
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
    flexbox:setBackground(container:getBackground())--:setBaseDraw(false)
    --container:setBaseDraw(false)
    if container:getType() == "Flexbox" then
        flexbox:setFlexGrow(1)
    end
    flexbox["split"] = setmetatable({},{__mode="v"}) -- !!:弱引用,防止内存泄漏
    for i=1,splitNum do
        local split = flexbox:addFlexbox(names[i]):setFlexDirection(direction):setFlexSpacing(0):setFlexAlignItems("stretch")
        split:setBackground(container:getBackground())
        split:setFlexGrow(grow[i]):setFlexShrink(shrink[i])

        --split:setBaseDraw(false)
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
    ,createTabPopup=createTabPopup,tabPopup=createTabPopup
    ,addLabeledFlexbox=addLabeledFlexbox,labeledFlexbox=addLabeledFlexbox
    ,createSimpleDialog=createSimpleDialog,simpleDialog=createSimpleDialog
    ,createAlert=createAlert,alert=createAlert
    ,createListSelector=createListSelector,listSelector=createListSelector
    ,createButtonNumberInput=createButtonNumberInput,buttonNumberInput=createButtonNumberInput
    ,createNumberEditorPopup=createNumberEditorPopup,numberEditorPopup=createNumberEditorPopup
    ,createStringInput=createStringInput,stringInput=createStringInput
    ,createStringEditorPopup=createStringEditorPopup,stringEditorPopup=createStringEditorPopup
    ,createCheckboxInput=createCheckboxInput,switchInput=createCheckboxInput
    ,createBooleanEditorPopup=createBooleanEditorPopup,booleanEditorPopup=createBooleanEditorPopup
    ,createTableEditorPopup=createTableEditorPopup,tableEditorPopup=createTableEditorPopup
    ,createValueEditorPopup=createValueEditorPopup,valueEditorPopup=createValueEditorPopup
    ,
    createNSplitSpace=createNSplitSpace,nSplitSpace=createNSplitSpace
    ,createUIFromTable=createUIFromTable
    
}
return toolkit