local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local isMinimized = false
local currentDevice = "PC"

-- Fake device info
local function SetDevicePC()
    currentDevice = "PC"
    
    -- Manipular USER_AGENT
    local newUA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    
    -- Tentar mudar informações do cliente
    if game:FindFirstChild("CoreGui") then
        local httpService = game:GetService("HttpService")
    end
    
    -- Fake de device type
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            -- Adicionar tag de PC
            local tag = Instance.new("StringValue")
            tag.Name = "DeviceType"
            tag.Value = "Computer"
            tag.Parent = humanoid
        end
    end
end

local function SetDeviceMobile()
    currentDevice = "Mobile"
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            local tag = humanoid:FindFirstChild("DeviceType")
            if tag then tag:Destroy() end
            
            tag = Instance.new("StringValue")
            tag.Name = "DeviceType"
            tag.Value = "Mobile"
            tag.Parent = humanoid
        end
    end
end

local function SetDeviceConsole()
    currentDevice = "Console"
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            local tag = humanoid:FindFirstChild("DeviceType")
            if tag then tag:Destroy() end
            
            tag = Instance.new("StringValue")
            tag.Name = "DeviceType"
            tag.Value = "Console"
            tag.Parent = humanoid
        end
    end
end

-- Interceptar chamadas do jogo que checam device
game:GetService("RunService").Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            if currentDevice == "PC" then
                if not humanoid:FindFirstChild("DeviceType") or humanoid.DeviceType.Value ~= "Computer" then
                    SetDevicePC()
                end
            end
        end
    end
end)

local function CreatePanel()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("FakeDevicePanel") then
        playerGui:FindFirstChild("FakeDevicePanel"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FakeDevicePanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- PAINEL PRINCIPAL (ALL BLACK)
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 350, 0, 300)
    mainPanel.Position = UDim2.new(0.3, 0, 0.3, 0)
    mainPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainPanel.BorderSizePixel = 0
    mainPanel.Draggable = true
    mainPanel.Active = true
    mainPanel.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainPanel
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = mainPanel
    
    -- HEADER (ALL BLACK)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    header.BorderSizePixel = 0
    header.Parent = mainPanel
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = "🖥️ FAKE DEVICE"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- BOTÃO MINIMIZAR
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 50, 0, 50)
    minimizeBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "−"
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
    
    local minimizeStroke = Instance.new("UIStroke")
    minimizeStroke.Color = Color3.fromRGB(255, 255, 255)
    minimizeStroke.Thickness = 1
    minimizeStroke.Parent = minimizeBtn
    
    -- PAINEL MINIMIZADO (ALL BLACK)
    local minimizedPanel = Instance.new("Frame")
    minimizedPanel.Name = "MinimizedPanel"
    minimizedPanel.Size = UDim2.new(0, 80, 0, 80)
    minimizedPanel.Position = UDim2.new(0.3, 0, 0.3, 0)
    minimizedPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    minimizedPanel.BorderSizePixel = 0
    minimizedPanel.Visible = false
    minimizedPanel.Draggable = true
    minimizedPanel.Active = true
    minimizedPanel.Parent = screenGui
    
    local minimizedCorner = Instance.new("UICorner")
    minimizedCorner.CornerRadius = UDim.new(0, 15)
    minimizedCorner.Parent = minimizedPanel
    
    local minimizedStroke = Instance.new("UIStroke")
    minimizedStroke.Color = Color3.fromRGB(255, 255, 255)
    minimizedStroke.Thickness = 2
    minimizedStroke.Parent = minimizedPanel
    
    local emojiLabel = Instance.new("TextLabel")
    emojiLabel.Size = UDim2.new(1, 0, 1, 0)
    emojiLabel.BackgroundTransparency = 1
    emojiLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    emojiLabel.TextSize = 50
    emojiLabel.Font = Enum.Font.GothamBold
    emojiLabel.Text = "🖥️"
    emojiLabel.Parent = minimizedPanel
    
    -- BOTÃO PC (ALL BLACK)
    local pcBtn = Instance.new("TextButton")
    pcBtn.Size = UDim2.new(0, 100, 0, 60)
    pcBtn.Position = UDim2.new(0.07, 0, 0.28, 0)
    pcBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    pcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pcBtn.TextSize = 12
    pcBtn.Font = Enum.Font.GothamBold
    pcBtn.Text = "💻 PC"
    pcBtn.BorderSizePixel = 0
    pcBtn.Parent = mainPanel
    
    local pcCorner = Instance.new("UICorner")
    pcCorner.CornerRadius = UDim.new(0, 10)
    pcCorner.Parent = pcBtn
    
    local pcStroke = Instance.new("UIStroke")
    pcStroke.Color = Color3.fromRGB(255, 255, 255)
    pcStroke.Thickness = 1
    pcStroke.Parent = pcBtn
    
    pcBtn.MouseButton1Click:Connect(function()
        SetDevicePC()
        pcBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        mobileBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        consoleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)
    
    -- BOTÃO MOBILE (ALL BLACK)
    local mobileBtn = Instance.new("TextButton")
    mobileBtn.Size = UDim2.new(0, 100, 0, 60)
    mobileBtn.Position = UDim2.new(0.39, 0, 0.28, 0)
    mobileBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobileBtn.TextSize = 12
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.Text = "📱 MOBILE"
    mobileBtn.BorderSizePixel = 0
    mobileBtn.Parent = mainPanel
    
    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0, 10)
    mobileCorner.Parent = mobileBtn
    
    local mobileStroke = Instance.new("UIStroke")
    mobileStroke.Color = Color3.fromRGB(255, 255, 255)
    mobileStroke.Thickness = 1
    mobileStroke.Parent = mobileBtn
    
    mobileBtn.MouseButton1Click:Connect(function()
        SetDeviceMobile()
        mobileBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        pcBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        consoleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)
    
    -- BOTÃO CONSOLE (ALL BLACK)
    local consoleBtn = Instance.new("TextButton")
    consoleBtn.Size = UDim2.new(0, 100, 0, 60)
    consoleBtn.Position = UDim2.new(0.71, 0, 0.28, 0)
    consoleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    consoleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    consoleBtn.TextSize = 12
    consoleBtn.Font = Enum.Font.GothamBold
    consoleBtn.Text = "🎮 CONSOLE"
    consoleBtn.BorderSizePixel = 0
    consoleBtn.Parent = mainPanel
    
    local consoleCorner = Instance.new("UICorner")
    consoleCorner.CornerRadius = UDim.new(0, 10)
    consoleCorner.Parent = consoleBtn
    
    local consoleStroke = Instance.new("UIStroke")
    consoleStroke.Color = Color3.fromRGB(255, 255, 255)
    consoleStroke.Thickness = 1
    consoleStroke.Parent = consoleBtn
    
    consoleBtn.MouseButton1Click:Connect(function()
        SetDeviceConsole()
        consoleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        pcBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mobileBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)
    
    -- STATUS LABEL
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
    statusLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Text = "DEVICE: PC ✓"
    statusLabel.BorderSizePixel = 0
    statusLabel.Parent = mainPanel
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusLabel
    
    local statusStroke = Instance.new("UIStroke")
    statusStroke.Color = Color3.fromRGB(0, 200, 0)
    statusStroke.Thickness = 1
    statusStroke.Parent = statusLabel
    
    -- Update status
    local function updateStatus()
        statusLabel.Text = "DEVICE: " .. currentDevice .. " ✓"
    end
    
    pcBtn.MouseButton1Click:Connect(updateStatus)
    mobileBtn.MouseButton1Click:Connect(updateStatus)
    consoleBtn.MouseButton1Click:Connect(updateStatus)
    
    -- MINIMIZAR/MAXIMIZAR COM BOTÃO
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            mainPanel.Visible = false
            minimizedPanel.Visible = true
        else
            mainPanel.Visible = true
            minimizedPanel.Visible = false
        end
    end)
    
    -- CLIQUE DUPLO NO EMOJI PARA ABRIR
    local lastClickTime = 0
    local function onEmojiClick()
        local currentTime = tick()
        if currentTime - lastClickTime < 0.3 then
            -- Duplo clique
            isMinimized = false
            mainPanel.Visible = true
            minimizedPanel.Visible = false
        end
        lastClickTime = currentTime
    end
    
    emojiLabel.MouseButton1Click:Connect(onEmojiClick)
    minimizedPanel.MouseButton1Click:Connect(onEmojiClick)
    
    -- Iniciar como PC
    SetDevicePC()
    pcBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end

CreatePanel()

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    CreatePanel()
end)