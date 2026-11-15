--====================================================
--                 ES1RX UNIVERSAL v1.0.2
--====================================================
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--====================================================

-- SERVICES

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIG

local C = {
    Speed = 16,
    Jump = 50,
    FlySpeed = 60,
    FOV = 70,
    MaxHealth = 100,
    ESPDistance = 1000,

    SpeedEnabled = false,
    JumpEnabled = false,
    FlyEnabled = false,
    NoclipEnabled = false,
    InfiniteJump = false,

    ESPEnabled = false,
    ESPNames = true,
    ESPHighlight = true,
    ESPDistanceText = true,
    ESPTeamCheck = false,

    GodMode = false,
    InfiniteHealth = false,

    Fullbright = false,
    Crosshair = false,
    Coordinates = false,
    FPS = false,

    Theme = "Purple"
}

local Themes = {
    Purple = Color3.fromRGB(155, 95, 255),
    Blue = Color3.fromRGB(65, 145, 255),
    Red = Color3.fromRGB(255, 75, 95),
    Green = Color3.fromRGB(65, 210, 145)
}

local Accent = Themes[C.Theme]

-- CHARACTER

local Character
local Humanoid
local Root

local function getCharacter()
    Character = Player.Character

    if not Character then
        return false
    end

    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    Root = Character:FindFirstChild("HumanoidRootPart")

    return Humanoid ~= nil and Root ~= nil
end

-- GUI

local GUI = Instance.new("ScreenGui")
GUI.Name = "ES1RX_V102"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = Player:WaitForChild("PlayerGui")

-- NOTIFICATIONS

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size = UDim2.fromOffset(280, 300)
NotifyHolder.Position = UDim2.new(1, -295, 0, 15)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Parent = GUI

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 7)
NotifyLayout.Parent = NotifyHolder

local function notify(message)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(23, 23, 35)
    frame.Parent = NotifyHolder

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Accent
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.Text = "ES1RX  |  " .. tostring(message)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    task.delay(3, function()
        if not frame.Parent then return end

        TweenService:Create(frame, TweenInfo.new(0.25), {
            BackgroundTransparency = 1
        }):Play()

        task.wait(0.3)

        if frame.Parent then
            frame:Destroy()
        end
    end)
end

-- MAIN WINDOW

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(620, 440)
Main.Position = UDim2.new(0.5, -310, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(13, 14, 21)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = GUI

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Accent
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- HEADER

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 48)
Top.BackgroundColor3 = Color3.fromRGB(21, 22, 32)
Top.BorderSizePixel = 0
Top.Parent = Main

Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "ES1RX / UNIVERSAL v1.0.2"
Title.TextColor3 = Accent
Title.TextSize = 16
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 30)
Close.Position = UDim2.new(1, -42, 0, 9)
Close.BackgroundColor3 = Color3.fromRGB(170, 45, 65)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.Parent = Top

Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 7)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- DRAG

local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

-- SIDEBAR

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(0, 48)
Sidebar.Size = UDim2.new(0, 145, 1, -48)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 19, 27)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 7)
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 7)
SidePadding.PaddingLeft = UDim.new(0, 6)
SidePadding.Parent = Sidebar

local Pages = Instance.new("Frame")
Pages.Position = UDim2.fromOffset(155, 58)
Pages.Size = UDim2.new(1, -165, 1, -68)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local PageList = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = Pages

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = page

    table.insert(PageList, page)

    return page
end

local function showPage(selected)
    for _, page in ipairs(PageList) do
        page.Visible = page == selected
    end
end

local function createTab(name, page)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(28, 29, 42)
    button.Text = "   " .. name
    button.TextColor3 = Color3.fromRGB(220, 220, 235)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = Sidebar

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

    button.MouseButton1Click:Connect(function()
        showPage(page)
    end)
end

-- UI HELPERS

local function control(parent, text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -8, 0, 37)
    button.BackgroundColor3 = Color3.fromRGB(27, 28, 40)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 11
    button.Font = Enum.Font.GothamMedium
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

    return button
end

local function section(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 27)
    label.BackgroundTransparency = 1
    label.Text = "  " .. text
    label.TextColor3 = Accent
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    return label
end

local function infoLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 34)
    label.BackgroundColor3 = Color3.fromRGB(27, 28, 40)
    label.TextColor3 = Color3.fromRGB(225, 220, 240)
    label.Text = "  " .. text
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 7)

    return label
end

local function toggle(parent, name, initial, callback)
    local state = initial == true
    local button = control(parent, "")

    local function update(runCallback)
        button.Text = name .. (state and "  [ON]" or "  [OFF]")

        button.BackgroundColor3 = state
            and Color3.fromRGB(72, 49, 130)
            or Color3.fromRGB(27, 28, 40)

        if runCallback and callback then
            callback(state)
        end
    end

    update(false)

    button.MouseButton1Click:Connect(function()
        state = not state
        update(true)
    end)

    return {
        Set = function(value, runCallback)
            state = value == true
            update(runCallback ~= false)
        end,

        Get = function()
            return state
        end
    }
end

local function stepper(parent, name, initial, step, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(27, 28, 40)
    frame.Parent = parent

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

    local value = initial

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = name .. ": " .. value
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local function setValue(newValue, runCallback)
        value = math.clamp(newValue, min, max)
        label.Text = name .. ": " .. value

        if runCallback ~= false and callback then
            callback(value)
        end
    end

    for i, symbol in ipairs({"-", "+"}) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.fromOffset(30, 28)
        button.Position = UDim2.new(1, -75 + (i - 1) * 37, 0.5, -14)
        button.Text = symbol
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BackgroundColor3 = Accent
        button.Font = Enum.Font.GothamBold
        button.Parent = frame

        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)

        button.MouseButton1Click:Connect(function()
            setValue(value + (i == 1 and -step or step))
        end)
    end

    return {
        Set = setValue,
        Get = function()
            return value
        end
    }
end

-- PAGES

local Home = createPage("Home")
local PlayerPage = createPage("Player")
local Movement = createPage("Movement")
local Visuals = createPage("Visuals")
local ESPPage = createPage("ESP")
local PlayerListPage = createPage("PlayerList")
local HealthPage = createPage("Health")
local Settings = createPage("Settings")

createTab("HOME", Home)
createTab("PLAYER", PlayerPage)
createTab("MOVEMENT", Movement)
createTab("VISUALS", Visuals)
createTab("ESP SETTINGS", ESPPage)
createTab("PLAYER LIST", PlayerListPage)
createTab("HEALTH", HealthPage)
createTab("SETTINGS", Settings)

showPage(Home)

-- DASHBOARD

section(Home, "WELCOME TO ES1RX")

infoLabel(Home, "ES1RX UNIVERSAL CONTROL PANEL")
infoLabel(Home, "USER: " .. Player.DisplayName)

local PlayerCount = infoLabel(
    Home,
    "PLAYERS: " .. #Players:GetPlayers()
)

infoLabel(Home, "PLACE ID: " .. game.PlaceId)
infoLabel(Home, "VERSION: 1.0.2")

local function updatePlayerCount()
    PlayerCount.Text = "  PLAYERS: " .. #Players:GetPlayers()
end

Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)

-- MOVEMENT

local function applyMovement()
    if not getCharacter() then return end

    Humanoid.WalkSpeed = C.SpeedEnabled and C.Speed or 16
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = C.JumpEnabled and C.Jump or 50
end

local SpeedToggle = toggle(
    PlayerPage,
    "WalkSpeed",
    false,
    function(state)
        C.SpeedEnabled = state
        applyMovement()
    end
)

stepper(PlayerPage, "Speed", 16, 2, 0, 100, function(value)
    C.Speed = value
    applyMovement()
end)

local JumpToggle = toggle(
    PlayerPage,
    "JumpPower",
    false,
    function(state)
        C.JumpEnabled = state
        applyMovement()
    end
)

stepper(PlayerPage, "Jump", 50, 5, 0, 200, function(value)
    C.Jump = value
    applyMovement()
end)

local InfiniteJumpToggle = toggle(
    PlayerPage,
    "Infinite Jump",
    false,
    function(state)
        C.InfiniteJump = state
    end
)

UIS.JumpRequest:Connect(function()
    if C.InfiniteJump and getCharacter() then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

control(PlayerPage, "RESET CHARACTER").MouseButton1Click:Connect(function()
    if getCharacter() then
        Humanoid.Health = 0
    end
end)

-- HEALTH

section(HealthPage, "HEALTH SETTINGS")

local function applyHealth()
    if not getCharacter() then return end

    Humanoid.MaxHealth = C.MaxHealth

    if C.GodMode or C.InfiniteHealth then
        Humanoid.Health = Humanoid.MaxHealth
    else
        Humanoid.Health = math.min(
            Humanoid.Health,
            Humanoid.MaxHealth
        )
    end
end

local HealthStepper = stepper(
    HealthPage,
    "Maximum HP",
    C.MaxHealth,
    10,
    1,
    100000,
    function(value)
        C.MaxHealth = value
        applyHealth()
    end
)

local GodModeToggle = toggle(
    HealthPage,
    "God Mode",
    false,
    function(state)
        C.GodMode = state
        applyHealth()
        notify("God Mode " .. (state and "ON" or "OFF"))
    end
)

local InfiniteHealthToggle = toggle(
    HealthPage,
    "Infinite Health",
    false,
    function(state)
        C.InfiniteHealth = state
        applyHealth()
        notify("Infinite Health " .. (state and "ON" or "OFF"))
    end
)

infoLabel(HealthPage, "Maximum HP: 1 - 100000")
infoLabel(HealthPage, "Health restoration runs locally.")

local HealthConnection

local function setupHealthMonitor()
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end

    if not getCharacter() then return end

    applyHealth()

    local currentHumanoid = Humanoid

    HealthConnection = RunService.Heartbeat:Connect(function()
        if not currentHumanoid.Parent then return end

        if C.GodMode or C.InfiniteHealth then
            if currentHumanoid.MaxHealth ~= C.MaxHealth then
                currentHumanoid.MaxHealth = C.MaxHealth
            end

            if currentHumanoid.Health > 0
                and currentHumanoid.Health < currentHumanoid.MaxHealth then

                currentHumanoid.Health = currentHumanoid.MaxHealth
            end
        end
    end)
end

-- NOCLIP

local NoclipConnection
local OriginalCollision = {}

local function restoreCollision()
    for part, original in pairs(OriginalCollision) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end

    table.clear(OriginalCollision)
end

local function setNoclip(state)
    C.NoclipEnabled = state

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if not state then
        restoreCollision()
        return
    end

    local function updateCollision()
        if not getCharacter() then return end

        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if OriginalCollision[part] == nil then
                    OriginalCollision[part] = part.CanCollide
                end

                part.CanCollide = false
            end
        end
    end

    updateCollision()

    NoclipConnection = RunService.Stepped:Connect(updateCollision)
end

local NoclipToggle = toggle(
    Movement,
    "Noclip",
    false,
    setNoclip
)

section(Movement, "NOCLIP CONTROLS")
infoLabel(Movement, "Toggle Noclip to disable collisions.")
infoLabel(Movement, "Disable it to restore original collisions.")

-- FLY

local FlyConnection

local function setFly(state)
    C.FlyEnabled = state

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if not state then
        if getCharacter() then
            Root.AssemblyLinearVelocity = Vector3.zero
        end
        return
    end

    if not getCharacter() then return end

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not getCharacter() then return end

        local move = Vector3.zero
        local cf = Camera.CFrame

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            move += cf.LookVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.S) then
            move -= cf.LookVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.D) then
            move += cf.RightVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.A) then
            move -= cf.RightVector
        end

        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            move += Vector3.yAxis
        end

        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            move -= Vector3.yAxis
        end

        Root.AssemblyLinearVelocity =
            (move.Magnitude > 0 and move.Unit or Vector3.zero)
            * C.FlySpeed
    end)
end

local FlyToggle = toggle(
    Movement,
    "Fly",
    false,
    setFly
)

stepper(Movement, "Fly Speed", 60, 5, 5, 200, function(value)
    C.FlySpeed = value
end)

infoLabel(Movement, "WASD - movement")
infoLabel(Movement, "SPACE - up")
infoLabel(Movement, "LEFT CTRL - down")

-- ESP

local ESPObjects = {}

local function removeESP(target)
    local objects = ESPObjects[target]

    if not objects then return end

    for _, object in ipairs(objects) do
        if object and object.Parent then
            object:Destroy()
        end
    end

    ESPObjects[target] = nil
end

local function clearESP()
    for target in pairs(ESPObjects) do
        removeESP(target)
    end
end

local function sameTeam(target)
    return C.ESPTeamCheck
        and Player.Team ~= nil
        and target.Team == Player.Team
end

local function addESP(target)
    if target == Player then return end
    if not C.ESPEnabled then return end
    if sameTeam(target) then return end

    removeESP(target)

    local character = target.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local objects = {}

    if C.ESPHighlight then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ES1RX_Highlight"
        highlight.Adornee = character
        highlight.FillColor = Accent
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = GUI

        table.insert(objects, highlight)
    end

    if C.ESPNames or C.ESPDistanceText then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ES1RX_ESP"
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(180, 35)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = GUI

        local label = Instance.new("TextLabel")
        label.Name = "Info"
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.TextColor3 = Accent
        label.TextStrokeTransparency = 0.2
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard

        table.insert(objects, billboard)
    end

    ESPObjects[target] = objects
end

local function refreshESP()
    clearESP()

    if not C.ESPEnabled then return end

    for _, target in ipairs(Players:GetPlayers()) do
        addESP(target)
    end
end

local function setupESPPlayer(target)
    if target == Player then return end

    target.CharacterAdded:Connect(function()
        task.wait(0.5)

        if C.ESPEnabled then
            addESP(target)
        end
    end)

    target:GetPropertyChangedSignal("Team"):Connect(function()
        if C.ESPEnabled then
            addESP(target)
        end
    end)
end

for _, target in ipairs(Players:GetPlayers()) do
    setupESPPlayer(target)
end

Players.PlayerAdded:Connect(setupESPPlayer)

Players.PlayerRemoving:Connect(function(target)
    removeESP(target)
end)

local ESPToggle = toggle(
    ESPPage,
    "Enable ESP",
    false,
    function(state)
        C.ESPEnabled = state
        refreshESP()
    end
)

toggle(ESPPage, "Player Names", true, function(state)
    C.ESPNames = state
    refreshESP()
end)

toggle(ESPPage, "Highlight", true, function(state)
    C.ESPHighlight = state
    refreshESP()
end)

toggle(ESPPage, "Team Check", false, function(state)
    C.ESPTeamCheck = state
    refreshESP()
end)

toggle(ESPPage, "Distance Text", true, function(state)
    C.ESPDistanceText = state
    refreshESP()
end)

stepper(ESPPage, "Max Distance", 1000, 100, 100, 5000, function(value)
    C.ESPDistance = value
end)

RunService.RenderStepped:Connect(function()
    if not C.ESPEnabled then return end

    if not getCharacter() then return end

    for target, objects in pairs(ESPObjects) do
        local targetCharacter = target.Character

        local targetRoot = targetCharacter
            and targetCharacter:FindFirstChild("HumanoidRootPart")

        local distance = targetRoot
            and (Root.Position - targetRoot.Position).Magnitude
            or math.huge

        local visible = distance <= C.ESPDistance

        for _, object in ipairs(objects) do
            if object.Parent then
                object.Enabled = visible
            end
        end

        if visible then
            for _, object in ipairs(objects) do
                if object:IsA("BillboardGui") then
                    local label = object:FindFirstChild("Info")

                    if label then
                        local name = C.ESPNames
                            and target.DisplayName
                            or ""

                        local dist = C.ESPDistanceText
                            and string.format(" [%.0fm]", distance)
                            or ""

                        label.Text = name .. dist
                        label.TextColor3 = Accent
                    end
                end
            end
        end
    end
end)

-- VISUALS

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows
}

local function setFullbright(state)
    C.Fullbright = state

    if state then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
end

toggle(Visuals, "Fullbright", false, setFullbright)

stepper(Visuals, "Camera FOV", 70, 5, 30, 120, function(value)
    C.FOV = value
    Camera.FieldOfView = value
end)

local Crosshair = Instance.new("TextLabel")
Crosshair.Size = UDim2.fromOffset(30, 30)
Crosshair.Position = UDim2.fromScale(0.5, 0.5)
Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextColor3 = Accent
Crosshair.TextSize = 28
Crosshair.Font = Enum.Font.GothamBold
Crosshair.Visible = false
Crosshair.Parent = GUI

toggle(Visuals, "Crosshair", false, function(state)
    C.Crosshair = state
    Crosshair.Visible = state
end)

local Coordinates = Instance.new("TextLabel")
Coordinates.Size = UDim2.fromOffset(230, 28)
Coordinates.Position = UDim2.new(0, 12, 1, -42)
Coordinates.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Coordinates.TextColor3 = Accent
Coordinates.TextSize = 12
Coordinates.Font = Enum.Font.GothamBold
Coordinates.Visible = false
Coordinates.Parent = GUI

Instance.new("UICorner", Coordinates).CornerRadius = UDim.new(0, 6)

toggle(Visuals, "Coordinates HUD", false, function(state)
    C.Coordinates = state
    Coordinates.Visible = state
end)

RunService.RenderStepped:Connect(function()
    if C.Coordinates and getCharacter() then
        local pos = Root.Position

        Coordinates.Text = string.format(
            "  X: %.1f | Y: %.1f | Z: %.1f",
            pos.X,
            pos.Y,
            pos.Z
        )
    end
end)

-- PLAYER LIST

local function refreshPlayerList()
    for _, child in ipairs(PlayerListPage:GetChildren()) do
        if child:IsA("TextButton")
            and child.Name == "PlayerEntry" then

            child:Destroy()
        end
    end

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= Player then
            local button = control(
                PlayerListPage,
                target.DisplayName .. "  @" .. target.Name
            )

            button.Name = "PlayerEntry"

            button.MouseButton1Click:Connect(function()
                local targetRoot = target.Character
                    and target.Character:FindFirstChild("HumanoidRootPart")

                if targetRoot then
                    notify("Position: " .. tostring(targetRoot.Position))
                else
                    notify("Character unavailable")
                end
            end)
        end
    end
end

control(PlayerListPage, "REFRESH LIST").MouseButton1Click:Connect(
    refreshPlayerList
)

refreshPlayerList()

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- FPS

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.fromOffset(120, 25)
FPSLabel.Position = UDim2.new(1, -130, 0, 10)
FPSLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FPSLabel.TextColor3 = Color3.new(1, 1, 1)
FPSLabel.TextSize = 12
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.Visible = false
FPSLabel.Parent = GUI

Instance.new("UICorner", FPSLabel).CornerRadius = UDim.new(0, 6)

local FPSConnection

toggle(Settings, "FPS Counter", false, function(state)
    C.FPS = state
    FPSLabel.Visible = state

    if FPSConnection then
        FPSConnection:Disconnect()
        FPSConnection = nil
    end

    if state then
        local frames = 0
        local elapsed = 0

        FPSConnection = RunService.RenderStepped:Connect(function(dt)
            frames += 1
            elapsed += dt

            if elapsed >= 1 then
                FPSLabel.Text = "FPS: " .. frames
                frames = 0
                elapsed = 0
            end
        end)
    end
end)

-- THEME

local function setTheme(name)
    if not Themes[name] then return end

    C.Theme = name
    Accent = Themes[name]

    MainStroke.Color = Accent
    Title.TextColor3 = Accent
    Crosshair.TextColor3 = Accent
    Coordinates.TextColor3 = Accent

    for _, page in ipairs(PageList) do
        page.ScrollBarImageColor3 = Accent
    end

    for _, object in ipairs(GUI:GetDescendants()) do
        if object:IsA("Highlight") then
            object.FillColor = Accent
        elseif object:IsA("UIStroke") then
            object.Color = Accent
        end
    end

    refreshESP()
    notify("Theme: " .. name)
end

section(Settings, "INTERFACE THEME")

for name in pairs(Themes) do
    control(Settings, "THEME: " .. name).MouseButton1Click:Connect(
        function()
            setTheme(name)
        end
    )
end

-- CONFIGURATION

section(Settings, "CONFIGURATION")

local ConfigBox = Instance.new("TextBox")
ConfigBox.Size = UDim2.new(1, -8, 0, 90)
ConfigBox.BackgroundColor3 = Color3.fromRGB(25, 26, 38)
ConfigBox.TextColor3 = Color3.new(1, 1, 1)
ConfigBox.PlaceholderText = "Paste JSON configuration..."
ConfigBox.Text = ""
ConfigBox.TextSize = 11
ConfigBox.Font = Enum.Font.Code
ConfigBox.ClearTextOnFocus = false
ConfigBox.TextWrapped = true
ConfigBox.MultiLine = true
ConfigBox.Parent = Settings

Instance.new("UICorner", ConfigBox).CornerRadius = UDim.new(0, 7)

local function exportConfig()
    local success, result = pcall(function()
        return HttpService:JSONEncode(C)
    end)

    if success then
        ConfigBox.Text = result
        notify("Config exported")
    else
        notify("Export failed")
    end
end

local function importConfig()
    local success, data = pcall(function()
        return HttpService:JSONDecode(ConfigBox.Text)
    end)

    if not success or type(data) ~= "table" then
        notify("Invalid JSON")
        return
    end

    for key, value in pairs(data) do
        if C[key] ~= nil and type(value) == type(C[key]) then
            C[key] = value
        end
    end

    C.Speed = math.clamp(tonumber(C.Speed) or 16, 0, 100)
    C.Jump = math.clamp(tonumber(C.Jump) or 50, 0, 200)
    C.FlySpeed = math.clamp(tonumber(C.FlySpeed) or 60, 5, 200)
    C.FOV = math.clamp(tonumber(C.FOV) or 70, 30, 120)
    C.MaxHealth = math.clamp(tonumber(C.MaxHealth) or 100, 1, 100000)
    C.ESPDistance = math.clamp(tonumber(C.ESPDistance) or 1000, 100, 5000)

    SpeedToggle.Set(C.SpeedEnabled)
    JumpToggle.Set(C.JumpEnabled)
    InfiniteJumpToggle.Set(C.InfiniteJump)

    FlyToggle.Set(C.FlyEnabled)
    NoclipToggle.Set(C.NoclipEnabled)

    ESPToggle.Set(C.ESPEnabled)

    GodModeToggle.Set(C.GodMode)
    InfiniteHealthToggle.Set(C.InfiniteHealth)

    HealthStepper.Set(C.MaxHealth, false)

    setFullbright(C.Fullbright)

    Crosshair.Visible = C.Crosshair
    Coordinates.Visible = C.Coordinates

    Camera.FieldOfView = C.FOV

    setTheme(C.Theme)

    applyMovement()
    setupHealthMonitor()
    refreshESP()

    notify("Config imported")
end

control(Settings, "EXPORT CONFIG").MouseButton1Click:Connect(exportConfig)
control(Settings, "IMPORT CONFIG").MouseButton1Click:Connect(importConfig)

-- RESET

control(Settings, "RESET ALL").MouseButton1Click:Connect(function()
    SpeedToggle.Set(false)
    JumpToggle.Set(false)
    InfiniteJumpToggle.Set(false)

    FlyToggle.Set(false)
    NoclipToggle.Set(false)

    ESPToggle.Set(false)

    GodModeToggle.Set(false)
    InfiniteHealthToggle.Set(false)

    C.Speed = 16
    C.Jump = 50
    C.FlySpeed = 60
    C.FOV = 70
    C.MaxHealth = 100
    C.ESPDistance = 1000

    C.ESPNames = true
    C.ESPHighlight = true
    C.ESPDistanceText = true
    C.ESPTeamCheck = false

    C.Fullbright = false
    C.Crosshair = false
    C.Coordinates = false
    C.FPS = false

    C.InfiniteJump = false

    HealthStepper.Set(100, false)

    applyMovement()

    if getCharacter() then
        Humanoid.MaxHealth = 100
        Humanoid.Health = math.min(Humanoid.Health, 100)
    end

    setFullbright(false)

    Camera.FieldOfView = 70

    Crosshair.Visible = false
    Coordinates.Visible = false

    if FPSConnection then
        FPSConnection:Disconnect()
        FPSConnection = nil
    end

    FPSLabel.Visible = false

    setupHealthMonitor()
    refreshESP()
    setTheme("Purple")

    notify("Settings reset")
end)

-- REJOIN

control(Settings, "REJOIN SERVER").MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)

    if not success then
        notify("Rejoin failed: " .. tostring(err))
    end
end)

-- MENU HOTKEY

local function toggleMenu(_, inputState)
    if inputState == Enum.UserInputState.Begin then
        Main.Visible = not Main.Visible
    end

    return Enum.ContextActionResult.Sink
end

CAS:BindAction(
    "ES1RX_ToggleMenu",
    toggleMenu,
    true,
    Enum.KeyCode.RightShift
)

CAS:SetTitle("ES1RX_ToggleMenu", "ES1RX")

CAS:SetPosition(
    "ES1RX_ToggleMenu",
    UDim2.new(1, -85, 0.65, 0)
)

-- CHARACTER RESPAWN

Player.CharacterAdded:Connect(function(character)
    Character = character

    task.wait(0.5)

    if not getCharacter() then return end

    applyMovement()
    setupHealthMonitor()

    if C.FlyEnabled then
        setFly(true)
    end

    if C.NoclipEnabled then
        setNoclip(true)
    end

    if C.ESPEnabled then
        refreshESP()
    end
end)

-- INITIAL SETUP

task.defer(function()
    if getCharacter() then
        applyMovement()
        setupHealthMonitor()
    end
end)

-- CLEANUP

Player.CharacterRemoving:Connect(function()
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    restoreCollision()
end)

-- LOADING SCREEN

local Loading = Instance.new("Frame")
Loading.Size = UDim2.fromScale(1, 1)
Loading.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
Loading.ZIndex = 100
Loading.Parent = GUI

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromOffset(300, 90)
Logo.Position = UDim2.new(0.5, -150, 0.38, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "ES1RX"
Logo.TextColor3 = Accent
Logo.TextSize = 58
Logo.Font = Enum.Font.GothamBlack
Logo.ZIndex = 101
Logo.Parent = Loading

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.fromOffset(300, 25)
Sub.Position = UDim2.new(0.5, -150, 0.49, 0)
Sub.BackgroundTransparency = 1
Sub.Text = "UNIVERSAL CONTROL PANEL v1.0.2"
Sub.TextColor3 = Color3.fromRGB(150, 150, 170)
Sub.TextSize = 11
Sub.Font = Enum.Font.GothamMedium
Sub.ZIndex = 101
Sub.Parent = Loading

local BarBG = Instance.new("Frame")
BarBG.Size = UDim2.fromOffset(250, 5)
BarBG.Position = UDim2.new(0.5, -125, 0.58, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
BarBG.ZIndex = 101
BarBG.Parent = Loading

Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

local Bar = Instance.new("Frame")
Bar.Size = UDim2.fromScale(0, 1)
Bar.BackgroundColor3 = Accent
Bar.ZIndex = 102
Bar.Parent = BarBG

Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

local LoadText = Instance.new("TextLabel")
LoadText.Size = UDim2.fromOffset(250, 25)
LoadText.Position = UDim2.new(0.5, -125, 0.58, 12)
LoadText.BackgroundTransparency = 1
LoadText.TextColor3 = Color3.fromRGB(150, 150, 170)
LoadText.TextSize = 10
LoadText.Font = Enum.Font.GothamMedium
LoadText.ZIndex = 101
LoadText.Parent = Loading

task.spawn(function()
    local steps = {
        "INITIALIZING...",
        "LOADING INTERFACE...",
        "LOADING FEATURES...",
        "LOADING HEALTH SYSTEM...",
        "LOADING SETTINGS...",
        "READY!"
    }

    for i, message in ipairs(steps) do
        LoadText.Text = message

        local tween = TweenService:Create(
            Bar,
            TweenInfo.new(0.35),
            {Size = UDim2.fromScale(i / #steps, 1)}
        )

        tween:Play()
        tween.Completed:Wait()
        task.wait(0.15)
    end

    task.wait(0.3)

    Main.Visible = true

    local fade = TweenService:Create(
        Loading,
        TweenInfo.new(0.4),
        {BackgroundTransparency = 1}
    )

    TweenService:Create(
        Logo,
        TweenInfo.new(0.4),
        {TextTransparency = 1}
    ):Play()

    TweenService:Create(
        Sub,
        TweenInfo.new(0.4),
        {TextTransparency = 1}
    ):Play()

    TweenService:Create(
        BarBG,
        TweenInfo.new(0.4),
        {BackgroundTransparency = 1}
    ):Play()

    TweenService:Create(
        Bar,
        TweenInfo.new(0.4),
        {BackgroundTransparency = 1}
    ):Play()

    LoadText.TextTransparency = 1

    fade:Play()
    fade.Completed:Wait()

    Loading:Destroy()

    notify("ES1RX v1.0.2 loaded!")
end)

print("[ES1RX] Universal v1.0.2 initialized")
