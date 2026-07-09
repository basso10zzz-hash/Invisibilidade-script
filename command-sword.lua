local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local isMinimized = false
local commandSword = nil

-- Criar a Command Sword
local function CreateCommandSword()
    local sword = Instance.new("Tool")
    sword.Name = "Command Sword"
    sword.ToolTip = "⚔️ Command Sword - Execute commands!"
    
    -- Handle (cabo da espada)
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Shape = Enum.PartType.Cylinder
    handle.Size = Vector3.new(0.5, 2, 0.5)
    handle.Color = Color3.fromRGB(139, 69, 19)
    handle.Material = Enum.Material.Wood
    handle.CanCollide = false
    handle.Parent = sword
    
    -- Blade (lâmina)
    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Shape = Enum.PartType.Block
    blade.Size = Vector3.new(0.3, 4, 0.1)
    blade.Color = Color3.fromRGB(192, 192, 192)
    blade.Material = Enum.Material.Metal
    blade.CanCollide = false
    blade.Parent = sword
    
    local bladeMesh = Instance.new("SpecialMesh")
    bladeMesh.MeshType = Enum.MeshType.Brick
    bladeMesh.Parent = blade
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = blade
    weld.Parent = blade
    blade.Position = handle.Position + Vector3.new(0, 1.5, 0)
    
    -- Grip
    sword.GripForward = Vector3.new(0, 0, -1)
    sword.GripPos = Vector3.new(0, 0, -1.5)
    sword.GripRight = Vector3.new(1, 0, 0)
    sword.GripUp = Vector3.new(0, 1, 0)
    
    -- Detector de ataque
    local lastSwing = 0
    local damage = 25
    local attackDebounce = {}
    
    sword.Activated:Connect(function()
        local now = tick()
        if now - lastSwing < 0.5 then return end
        lastSwing = now
        
        -- Animação de ataque
        local blade = sword.Handle:FindFirstChild("Blade")
        if blade then
            local originalPos = blade.Position
            blade.Position = blade.Position + Vector3.new(0, 0, 2)
            task.wait(0.1)
            blade.Position = originalPos
        end
        
        -- Detectar hits
        local hitParts = {}
        local region = Region3.new(sword.Handle.Position - Vector3.new(5, 5, 5), sword.Handle.Position + Vector3.new(5, 5, 5))
        region = region:ExpandToGrid(4)
        
        for _, part in pairs(workspace:FindPartsBoundingRegion3(region, nil, 100)) do
            if part.Parent and part.Parent:FindFirstChild("Humanoid") then
                local humanoid = part.Parent.Humanoid
                if humanoid.Parent ~= LocalPlayer.Character then
                    if not attackDebounce[humanoid] or tick() - attackDebounce[humanoid] > 1 then
                        humanoid:TakeDamage(damage)
                        attackDebounce[humanoid] = tick()
                    end
                end
            end
        end
    end)
    
    return sword
end

-- Dar a espada pro player
local function GiveSwordToPlayer()
    local sword = CreateCommandSword()
    sword.Parent = LocalPlayer.Backpack
    commandSword = sword
end

-- Criar o painel
local function CreatePanel()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("CommandSwordPanel") then
        playerGui:FindFirstChild("CommandSwordPanel"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CommandSwordPanel"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- PAINEL PRINCIPAL (ALL BLACK)
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 300, 0, 250)
    mainPanel.Position = UDim2.new(0.35, 0, 0.35, 0)
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
    title.Text = "⚔️ COMMAND SWORD"
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
    minimizedPanel.Position = UDim2.new(0.35, 0, 0.35, 0)
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
    emojiLabel.Text = "⚔️"
    emojiLabel.Parent = minimizedPanel
    
    -- BOTÃO DAR ESPADA
    local giveBtn = Instance.new("TextButton")
    giveBtn.Size = UDim2.new(0, 260, 0, 60)
    giveBtn.Position = UDim2.new(0.07, 0, 0.3, 0)
    giveBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    giveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    giveBtn.TextSize = 14
    giveBtn.Font = Enum.Font.GothamBold
    giveBtn.Text = "📦 DAR ESPADA"
    giveBtn.BorderSizePixel = 0
    giveBtn.Parent = mainPanel
    
    local giveCorner = Instance.new("UICorner")
    giveCorner.CornerRadius = UDim.new(0, 10)
    giveCorner.Parent = giveBtn
    
    local giveStroke = Instance.new("UIStroke")
    giveStroke.Color = Color3.fromRGB(255, 255, 255)
    giveStroke.Thickness = 1
    giveStroke.Parent = giveBtn
    
    giveBtn.MouseButton1Click:Connect(function()
        GiveSwordToPlayer()
        giveBtn.Text = "✓ ESPADA DADA!"
        giveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(2)
        giveBtn.Text = "📦 DAR ESPADA"
        giveBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)
    
    -- INFO LABEL
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.9, 0, 0, 100)
    infoLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
    infoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Text = "⚔️ Clique para atacar\n💥 Causa 25 de dano\n🎯 Equipar e desequipar normalmente\n✨ Funciona em todos os jogos!"
    infoLabel.TextWrapped = true
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.BorderSizePixel = 0
    infoLabel.Parent = mainPanel
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoLabel
    
    local infoStroke = Instance.new("UIStroke")
    infoStroke.Color = Color3.fromRGB(100, 100, 100)
    infoStroke.Thickness = 1
    infoStroke.Parent = infoLabel
    
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
end

-- Iniciar
CreatePanel()
GiveSwordToPlayer()

-- Recriar painel quando character muda
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    CreatePanel()
    GiveSwordToPlayer()
end)