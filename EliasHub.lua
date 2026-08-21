--[[
    EliasHub - UI Prototype
    UI ONLY
    No game automation / remote interaction
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// Clean previous UI
local old = PlayerGui:FindFirstChild("EliasHub")
if old then
    old:Destroy()
end

--// Services
local TweenService = game:GetService("TweenService")

--// Theme
local COLORS = {
    Background = Color3.fromRGB(7, 9, 14),
    Sidebar = Color3.fromRGB(10, 13, 22),
    Panel = Color3.fromRGB(13, 17, 29),
    Panel2 = Color3.fromRGB(17, 22, 38),
    Accent = Color3.fromRGB(30, 90, 160),
    Accent2 = Color3.fromRGB(42, 120, 210),
    Text = Color3.fromRGB(235, 240, 250),
    SubText = Color3.fromRGB(145, 155, 175),
    Border = Color3.fromRGB(30, 42, 65),
    Green = Color3.fromRGB(60, 190, 115),
    Red = Color3.fromRGB(210, 70, 80),
}

--// Helpers
local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.Border
    s.Thickness = thickness or 1
    s.Transparency = 0
    s.Parent = obj
    return s
end

local function padding(obj, amount)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, amount)
    p.PaddingBottom = UDim.new(0, amount)
    p.PaddingLeft = UDim.new(0, amount)
    p.PaddingRight = UDim.new(0, amount)
    p.Parent = obj
end

local function createText(parent, text, size, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or COLORS.Text
    label.TextSize = size or 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createButton(parent, text)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.BackgroundColor3 = COLORS.Panel2
    button.Text = text
    button.TextColor3 = COLORS.Text
    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.Parent = parent
    corner(button, 7)
    stroke(button)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = COLORS.Accent}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = COLORS.Panel2}
        ):Play()
    end)
    
    return button
end

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliasHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--// Main window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 720, 0, 470)
Main.Position = UDim2.new(0.5, -360, 0.5, -235)
Main.BackgroundColor3 = COLORS.Background
Main.Parent = ScreenGui
corner(Main, 12)
stroke(Main, COLORS.Border, 1)

--// Responsive sizing
local UIScale = Instance.new("UIScale")
UIScale.Parent = Main

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local viewport = camera.ViewportSize
    
    if viewport.X < 700 then
        UIScale.Scale = math.clamp(viewport.X / 720, 0.72, 1)
    else
        UIScale.Scale = 1
    end
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
updateScale()

--// Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = COLORS.Panel
Header.Parent = Main
corner(Header, 12)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 38, 0, 38)
Logo.Position = UDim2.new(0, 10, 0.5, -19)
Logo.BackgroundColor3 = COLORS.Accent
Logo.Text = "E"
Logo.TextColor3 = Color3.new(1,1,1)
Logo.TextSize = 22
Logo.Font = Enum.Font.GothamBold
Logo.Parent = Header
corner(Logo, 10)

local Title = createText(Header, "EliasHub", 17, COLORS.Text)
Title.Position = UDim2.new(0, 58, 0, 9)
Title.Size = UDim2.new(0, 200, 0, 22)
Title.Font = Enum.Font.GothamBold

local Version = createText(Header, "UI Prototype", 11, COLORS.SubText)
Version.Position = UDim2.new(0, 58, 0, 30)
Version.Size = UDim2.new(0, 200, 0, 16)

local Minimize = createButton(Header, "—")
Minimize.Size = UDim2.new(0, 38, 0, 30)
Minimize.Position = UDim2.new(1, -88, 0.5, -15)

local Close = createButton(Header, "×")
Close.Size = UDim2.new(0, 38, 0, 30)
Close.Position = UDim2.new(1, -44, 0.5, -15)

--// Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundColor3 = COLORS.Sidebar
Sidebar.Parent = Main

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 15)
SidebarPad.PaddingLeft = UDim.new(0, 10)
SidebarPad.PaddingRight = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

--// Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -155, 1, -55)
Content.Position = UDim2.new(0, 155, 0, 55)
Content.BackgroundColor3 = COLORS.Background
Content.Parent = Main

--// Page containers
local Pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -24, 1, -24)
    page.Position = UDim2.new(0, 12, 0, 12)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = COLORS.Accent
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.Visible = false
    page.Parent = Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            layout.AbsoluteContentSize.Y + 20
        )
    end)
    
    Pages[name] = page
    return page
end

local LocalPage = createPage("Local")
local MainPage = createPage("Main")
local MiscPage = createPage("Misc")
local ShopPage = createPage("Shop")
local ConfigPage = createPage("Config")

--// Toggle creator
local function createToggle(parent, text, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundColor3 = COLORS.Panel
    container.Parent = parent
    corner(container, 8)
    stroke(container)
    
    local label = createText(container, text, 13, COLORS.Text)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -75, 1, 0)
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 46, 0, 24)
    toggle.Position = UDim2.new(1, -58, 0.5, -12)
    toggle.BackgroundColor3 = COLORS.Border
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = container
    corner(toggle, 20)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = COLORS.Text
    knob.Parent = toggle
    corner(knob, 20)
    
    local enabled = false
    
    local function setEnabled(value)
        enabled = value
        
        if enabled then
            TweenService:Create(
                toggle,
                TweenInfo.new(0.15),
                {BackgroundColor3 = COLORS.Accent2}
            ):Play()
            
            TweenService:Create(
                knob,
                TweenInfo.new(0.15),
                {Position = UDim2.new(1, -21, 0.5, -9)}
            ):Play()
        else
            TweenService:Create(
                toggle,
                TweenInfo.new(0.15),
                {BackgroundColor3 = COLORS.Border}
            ):Play()
            
            TweenService:Create(
                knob,
                TweenInfo.new(0.15),
                {Position = UDim2.new(0, 3, 0.5, -9)}
            ):Play()
        end
        
        if callback then
            callback(enabled)
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        setEnabled(not enabled)
    end)
    
    return {
        Container = container,
        Set = setEnabled,
        Get = function()
            return enabled
        end
    }
end

--// Section creator
local function createSection(parent, title, description)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 55)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local titleLabel = createText(section, title, 18, COLORS.Text)
    titleLabel.Size = UDim2.new(1, 0, 0, 26)
    titleLabel.Font = Enum.Font.GothamBold
    
    if description then
        local desc = createText(section, description, 11, COLORS.SubText)
        desc.Position = UDim2.new(0, 0, 0, 27)
        desc.Size = UDim2.new(1, 0, 0, 20)
    end
    
    return section
end

--// Local page
createSection(
    LocalPage,
    "Welcome to EliasHub",
    "A clean UI prototype."
)

local info = Instance.new("Frame")
info.Size = UDim2.new(1,0,0,150)
info.BackgroundColor3 = COLORS.Panel
info.Parent = LocalPage
corner(info, 10)
stroke(info)

local infoText = createText(
    info,
    "EliasHub\n\nPlayer: " .. player.DisplayName ..
    "\nUsername: @" .. player.Name ..
    "\n\nThis is a UI-only prototype.",
    13,
    COLORS.Text
)
infoText.Position = UDim2.new(0,15,0,15)
infoText.Size = UDim2.new(1,-30,1,-30)
infoText.TextWrapped = true

local DiscordButton = createButton(LocalPage, "Discord Server")
DiscordButton.Size = UDim2.new(1,0,0,40)

--// Main page
createSection(
    MainPage,
    "Main",
    "Customer, printing and appointment controls."
)

createToggle(MainPage, "Auto Appoint NPC")

createSection(
    MainPage,
    "Appointment Customer Types",
    "Choose which customer types are accepted."
)

local customerTypes = {
    "All",
    "Player",
    "Rich",
    "Youtuber",
    "Meme",
    "Politician"
}

local appointmentSelections = {}

for _, customer in ipairs(customerTypes) do
    appointmentSelections[customer] =
        createToggle(MainPage, customer)
end

createToggle(MainPage, "Reject NPC")

createSection(
    MainPage,
    "Reject Customer Types",
    "Choose which customer types are rejected."
)

local rejectSelections = {}

for _, customer in ipairs(customerTypes) do
    rejectSelections[customer] =
        createToggle(MainPage, customer)
end

createToggle(MainPage, "Auto Print")
createToggle(MainPage, "Auto Refill Printing Resources")

--// Misc page
createSection(
    MiscPage,
    "Misc",
    "General EliasHub controls."
)

createToggle(MiscPage, "Auto Clean")

createSection(
    MiscPage,
    "Auto Clean Options",
    "Choose which cleaning tasks are enabled."
)

createToggle(MiscPage, "Broom — Inventory Slot 1")
createToggle(MiscPage, "Glass Wipe — Inventory Slot 2")
createToggle(MiscPage, "Fire Extinguisher — Inventory Slot 3")

createToggle(MiscPage, "Auto Deliver")
createToggle(MiscPage, "Auto Cooking")
createToggle(MiscPage, "Auto Pay Electric Bill")
createToggle(MiscPage, "Auto Customize PC")

--// Shop data
local Grocery = {
    "Water",
    "Cooking Oil",
    "Pancit Kalamansi",
    "Beef Loaf",
    "C5 Klasik",
    "C5 Limon",
    "C5 Apol",
    "Lumpia",
    "Bcat",
    "Toby",
    "Piyatos",
    "Mang Kanor",
    "Sayang"
}

local PCParts = {
    "Wooden Chair",
    "Monoblock",
    "Collage",
    "ClassicCore",
    "[100 - Key] Keyboard",
    "OpenDesk",
    "WideView",
    "Folding CHair",
    "PulseCore",
    "FlatCore",
    "Slate",
    "[80 - Key] Keyboard",
    "Nimbus",
    "FrameDesk",
    "Japan",
    "[75 - Key] Keyboard",
    "TriFan-Lite",
    "Hoshi",
    "OfficeChair",
    "Ripple",
    "RoundView",
    "Azure",
    "BoxDesk",
    "Midnight",
    "Hanami",
    "Wavy",
    "Kasumi",
    "Konoha",
    "Evergreen",
    "Sora",
    "[60 - Key] Keyboard",
    "Petal",
    "Fuji",
    "Horizon",
    "Shadow",
    "Revy",
    "Blossom Keyboard",
    "ShelfDesk",
    "Nocturne",
    "BlockView",
    "Spider-X Keyboard",
    "Nightfall Keyboard",
    "G-Force Pink",
    "G-Force White",
    "G-Force Red",
    "G-Force",
    "TriFan-Core",
    "V-View",
    "Galon",
    "Overdrive Pink",
    "Overdrive Red",
    "Overdrive White",
    "Overdrive",
    "AngleView",
    "ArcView",
    "SlimDesk",
    "CyberCurve",
    "StoneChair",
    "Vesta",
    "HollowFrame",
    "Throne",
    "NexusChair",
    "Hexora",
    "Voltara",
    "Aether",
    "GamingTable",
    "Aviano Chair Red",
    "AvianoChair",
    "Aviano Chair White",
    "Polar X",
    "Aviano Chair Pink",
    "Sakura",
    "Initial-B",
    "Initial-P",
    "Dark Nexus",
    "AvianoDesk",
    "Aviano Desk White",
    "Aviano Desk Red",
    "Aviano Desk Pink",
    "PinkDrift",
    "SnowDrift",
    "Vortessa White",
    "Vortessa Pink",
    "Vortessa Red",
    "Vortessa"
}

local Accessories = {
    "Copy Paper",
    "Pink Ink",
    "Yellow Ink",
    "Blue Ink",
    "Black Ink",
    "Car",
    "PineappleHouse",
    "Blorb",
    "Kitty Plush",
    "Covertible",
    "Cute Plushie",
    "Oi Oi Oi",
    "RedBullCar"
}

local function combine(a,b)
    local result = {}
    
    for _, item in ipairs(a) do
        table.insert(result, item)
    end
    
    for _, item in ipairs(b) do
        table.insert(result, item)
    end
    
    return result
end

local Merchant = combine(PCParts, Accessories)

--// Item selector
local function createItemSection(parent, title, items, autoText)
    createSection(parent, title, "Select items to include.")
    
    local search = Instance.new("TextBox")
    search.Size = UDim2.new(1,0,0,38)
    search.BackgroundColor3 = COLORS.Panel
    search.PlaceholderText = "Search " .. title .. "..."
    search.PlaceholderColor3 = COLORS.SubText
    search.TextColor3 = COLORS.Text
    search.TextSize = 13
    search.Font = Enum.Font.Gotham
    search.ClearTextOnFocus = false
    search.Text = ""
    search.Parent = parent
    corner(search, 8)
    stroke(search)
    
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1,0,0,180)
    itemFrame.BackgroundColor3 = COLORS.Panel
    itemFrame.Parent = parent
    corner(itemFrame, 8)
    stroke(itemFrame)
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-10,1,-10)
    scroll.Position = UDim2.new(0,5,0,5)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.Parent = itemFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,4)
    layout.Parent = scroll
    
    local selections = {}
    
    local function refresh()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local query = string.lower(search.Text)
        
        for _, item in ipairs(items) do
            if query == "" or string.find(string.lower(item), query, 1, true) then
                
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1,-5,0,30)
                button.BackgroundColor3 =
                    selections[item] and COLORS.Accent or COLORS.Panel2
                button.Text = (selections[item] and "✓  " or "○  ") .. item
                button.TextColor3 = COLORS.Text
                button.TextSize = 12
                button.Font = Enum.Font.Gotham
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.Parent = scroll
                corner(button, 6)
                
                button.MouseButton1Click:Connect(function()
                    selections[item] = not selections[item]
                    refresh()
                end)
            end
        end
        
        task.defer(function()
            scroll.CanvasSize = UDim2.new(
                0,
                0,
                0,
                layout.AbsoluteContentSize.Y + 5
            )
        end)
    end
    
    search:GetPropertyChangedSignal("Text"):Connect(refresh)
    
    local buttons = Instance.new("Frame")
    buttons.Size = UDim2.new(1,0,0,38)
    buttons.BackgroundTransparency = 1
    buttons.Parent = parent
    
    local selectAll = createButton(buttons, "Select All")
    selectAll.Size = UDim2.new(0.49,0,1,0)
    selectAll.Position = UDim2.new(0,0,0,0)
    
    local clearAll = createButton(buttons, "Clear All")
    clearAll.Size = UDim2.new(0.49,0,1,0)
    clearAll.Position = UDim2.new(0.51,0,0,0)
    
    selectAll.MouseButton1Click:Connect(function()
        for _, item in ipairs(items) do
            selections[item] = true
        end
        refresh()
    end)
    
    clearAll.MouseButton1Click:Connect(function()
        table.clear(selections)
        refresh()
    end)
    
    createToggle(parent, autoText or "Auto Buy Stock")
    
    refresh()
    
    return selections
end

--// Shop page
createSection(
    ShopPage,
    "Shop",
    "Select items for the shop automation UI."
)

createItemSection(
    ShopPage,
    "Grocery",
    Grocery,
    "Auto Buy Grocery Stock"
)

createItemSection(
    ShopPage,
    "PC Parts",
    PCParts,
    "Auto Buy PC Parts Stock"
)

createItemSection(
    ShopPage,
    "Accessories",
    Accessories,
    "Auto Buy Accessories Stock"
)

createItemSection(
    ShopPage,
    "Merchant",
    Merchant,
    "Auto Buy Merchant"
)

--// Config page
createSection(
    ConfigPage,
    "Config",
    "Save and manage EliasHub UI settings."
)

local ConfigName = Instance.new("TextBox")
ConfigName.Size = UDim2.new(1,0,0,40)
ConfigName.BackgroundColor3 = COLORS.Panel
ConfigName.PlaceholderText = "Config name..."
ConfigName.PlaceholderColor3 = COLORS.SubText
ConfigName.TextColor3 = COLORS.Text
ConfigName.TextSize = 13
ConfigName.Font = Enum.Font.Gotham
ConfigName.ClearTextOnFocus = false
ConfigName.Parent = ConfigPage
corner(ConfigName, 8)
stroke(ConfigName)

local ConfigDropdown = createButton(ConfigPage, "Selected Config: None")
ConfigDropdown.Size = UDim2.new(1,0,0,40)

local Configs = {}
local SelectedConfig = nil

local CreateConfig = createButton(ConfigPage, "Create Config")
CreateConfig.Size = UDim2.new(1,0,0,40)

local OverwriteConfig = createButton(ConfigPage, "Overwrite Config")
OverwriteConfig.Size = UDim2.new(1,0,0,40)

local LoadConfig = createButton(ConfigPage, "Load Config")
LoadConfig.Size = UDim2.new(1,0,0,40)

local AutoLoad = createToggle(ConfigPage, "Set Auto Load")

local ResetAutoLoad = createButton(ConfigPage, "Reset Auto Load")
ResetAutoLoad.Size = UDim2.new(1,0,0,40)

local RemoveSelected = createButton(ConfigPage, "Remove Selected")
RemoveSelected.Size = UDim2.new(1,0,0,40)

local RemoveAll = createButton(ConfigPage, "Remove All")
RemoveAll.Size = UDim2.new(1,0,0,40)

CreateConfig.MouseButton1Click:Connect(function()
    local name = ConfigName.Text
    
    if name == "" then
        return
    end
    
    Configs[name] = {
        created = os.time()
    }
    
    SelectedConfig = name
    ConfigDropdown.Text = "Selected Config: " .. name
end)

OverwriteConfig.MouseButton1Click:Connect(function()
    if SelectedConfig then
        Configs[SelectedConfig] = {
            overwritten = os.time()
        }
    end
end)

LoadConfig.MouseButton1Click:Connect(function()
    if SelectedConfig and Configs[SelectedConfig] then
        ConfigName.Text = SelectedConfig
    end
end)

ResetAutoLoad.MouseButton1Click:Connect(function()
    AutoLoad.Set(false)
end)

RemoveSelected.MouseButton1Click:Connect(function()
    if SelectedConfig then
        Configs[SelectedConfig] = nil
        SelectedConfig = nil
        ConfigDropdown.Text = "Selected Config: None"
    end
end)

RemoveAll.MouseButton1Click:Connect(function()
    table.clear(Configs)
    SelectedConfig = nil
    ConfigDropdown.Text = "Selected Config: None"
end)

--// Navigation
local currentPage

local function showPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end
    
    currentPage = name
end

local navButtons = {}

local function createNav(name)
    local button = createButton(Sidebar, name)
    button.Size = UDim2.new(1,0,0,40)
    
    button.MouseButton1Click:Connect(function()
        showPage(name)
        
        for n, b in pairs(navButtons) do
            b.BackgroundColor3 =
                n == name and COLORS.Accent or COLORS.Panel2
        end
    end)
    
    navButtons[name] = button
    return button
end

createNav("Local")
createNav("Main")
createNav("Misc")
createNav("Shop")
createNav("Config")

--// Minimize
local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Position = UDim2.new(0, 20, 0.5, -25)
MiniButton.BackgroundColor3 = COLORS.Accent
MiniButton.Text = "E"
MiniButton.TextColor3 = Color3.new(1,1,1)
MiniButton.TextSize = 20
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Visible = false
MiniButton.Parent = ScreenGui
corner(MiniButton, 12)
stroke(MiniButton, COLORS.Border)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniButton.Visible = true
end)

MiniButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    MiniButton.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--// Dragging
local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        
        local delta = input.Position - dragStart
        
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// Start
showPage("Local")
navButtons["Local"].BackgroundColor3 = COLORS.Accent
