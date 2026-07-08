local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local isMinimized = false
local dragging = false
local dragInput
local dragStart
local startPos

local function MakeInvisible()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.DisplayDistance = 0
    end
    
    for _, obj in pairs(char:GetChildren()) do
        if obj:IsA("BillboardGui") then
            obj:Destroy()
        end
    end
end

local function MakeVisible()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.DisplayDistance = 100
    end
end

local function CreatePanel()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("InvisPanel") then
        playerGui:FindFirstChild("InvisPanel"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InvisPanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- PAINEL PRINCIPAL
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 350, 0, 250)
    mainPanel.Position = UDim2.new(0.3, 0, 0.3, 0)
    mainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainPanel.BorderSizePixel = 0
    mainPanel.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainPanel
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 2
    stroke.Parent = mainPanel
    
    -- HEADER
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
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
    title.Text = "👻 INVISIBILIDADE"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- BOTÃO MINIMIZAR
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 50, 0, 50)
    minimizeBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "−"
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
    
    -- PAINEL MINIMIZADO
    local minimizedPanel = Instance.new("Frame")
    minimizedPanel.Name = "MinimizedPanel"
    minimizedPanel.Size = UDim2.new(0, 80, 0, 80)
    minimizedPanel.Position = UDim2.new(0.3, 0, 0.3, 0)
    minimizedPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    minimizedPanel.BorderSizePixel = 0
    minimizedPanel.Visible = false
    minimizedPanel.Parent = screenGui
    
    local minimizedCorner = Instance.new("UICorner")
    minimizedCorner.CornerRadius = UDim.new(0, 15)
    minimizedCorner.Parent = minimizedPanel
    
    local minimizedStroke = Instance.new("UIStroke")
    minimizedStroke.Color = Color3.fromRGB(0, 200, 255)
    minimizedStroke.Thickness = 2
    minimizedStroke.Parent = minimizedPanel
    
    local emojiLabel = Instance.new("TextLabel")
    emojiLabel.Size = UDim2.new(1, 0, 1, 0)
    emojiLabel.BackgroundTransparency = 1
    emojiLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    emojiLabel.TextSize = 50
    emojiLabel.Font = Enum.Font.GothamBold
    emojiLabel.Text = "🥵"
    emojiLabel.Parent = minimizedPanel
    
    -- BOTÃO INVISÍVEL
    local invisibleBtn = Instance.new("TextButton")
    invisibleBtn.Size = UDim2.new(0, 140, 0, 60)
    invisibleBtn.Position = UDim2.new(0.07, 0, 0.32, 0)
    invisibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    invisibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    invisibleBtn.TextSize = 14
    invisibleBtn.Font = Enum.Font.GothamBold
    invisibleBtn.Text = "INVISÍVEL"
    invisibleBtn.BorderSizePixel = 0
    invisibleBtn.Parent = mainPanel
    
    local invisibleCorner = Instance.new("UICorner")
    invisibleCorner.CornerRadius = UDim.new(0, 10)
    invisibleCorner.Parent = invisibleBtn
    
    invisibleBtn.MouseButton1Click:Connect(function()
        MakeInvisible()
        invisibleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        visibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end)
    
    -- BOTÃO VISÍVEL
    local visibleBtn = Instance.new("TextButton")
    visibleBtn.Size = UDim2.new(0, 140, 0, 60)
    visibleBtn.Position = UDim2.new(0.53, 0, 0.32, 0)
    visibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    visibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    visibleBtn.TextSize = 14
    visibleBtn.Font = Enum.Font.GothamBold
    visibleBtn.Text = "VISÍVEL"
    visibleBtn.BorderSizePixel = 0
    visibleBtn.Parent = mainPanel
    
    local visibleCorner = Instance.new("UICorner")
    visibleCorner.CornerRadius = UDim.new(0, 10)
    visibleCorner.Parent = visibleBtn
    
    visibleBtn.MouseButton1Click:Connect(function()
        MakeVisible()
        visibleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        invisibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end)
    
    -- FUNÇÃO DE DRAG PARA PAINEL PRINCIPAL
    local function UpdateMainPanelDrag(input)
        local delta = input.Position - dragStart
        mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    header.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainPanel.Position
            dragInput = input
        end
    end)
    
    header.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- FUNÇÃO DE DRAG PARA PAINEL MINIMIZADO
    local function UpdateMinimizedPanelDrag(input)
        local delta = input.Position - dragStart
        minimizedPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    minimizedPanel.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = minimizedPanel.Position
            dragInput = input
        end
    end)
    
    minimizedPanel.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            if minimizedPanel.Visible then
                UpdateMinimizedPanelDrag(input)
            else
                UpdateMainPanelDrag(input)
            end
        end
    end)
    
    -- MINIMIZAR/MAXIMIZAR
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            mainPanel.Visible = false
            minimizedPanel.Visible = true
            minimizeBtn.Text = "+"
        else
            mainPanel.Visible = true
            minimizedPanel.Visible = false
            minimizeBtn.Text = "−"
        end
    end)
    
    -- CLICAR NO EMOJI PARA ABRIR
    emojiLabel.MouseButton1Click:Connect(function()
        isMinimized = false
        mainPanel.Visible = true
        minimizedPanel.Visible = false
    end)
end

CreatePanel()

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    CreatePanel()
end)