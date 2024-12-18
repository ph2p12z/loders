local ScreenGui = Instance.new("ScreenGui")
local PlayerInfoFrame = Instance.new("Frame")
local PlayerFPSLabel = Instance.new("TextLabel")
local PlayerPingLabel = Instance.new("TextLabel")
local PlayerTimeLabel = Instance.new("TextLabel")
local BrandingLabel = Instance.new("TextLabel")


ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


PlayerInfoFrame.Parent = ScreenGui
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
PlayerInfoFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
PlayerInfoFrame.BorderSizePixel = 2
PlayerInfoFrame.Position = UDim2.new(0.02, 0, 0.2, 0) 
PlayerInfoFrame.Size = UDim2.new(0, 400, 0, 40)

local gradient = Instance.new("UIGradient")
gradient.Parent = PlayerInfoFrame
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Rotation = 90


PlayerFPSLabel.Parent = PlayerInfoFrame
PlayerFPSLabel.BackgroundTransparency = 1
PlayerFPSLabel.Position = UDim2.new(0.02, 0, 0, 0) 
PlayerFPSLabel.Size = UDim2.new(0, 80, 0, 40)
PlayerFPSLabel.Font = Enum.Font.SourceSansBold
PlayerFPSLabel.Text = "FPS: 60"
PlayerFPSLabel.TextColor3 = Color3.fromRGB(231, 231, 231)
PlayerFPSLabel.TextSize = 14


PlayerPingLabel.Parent = PlayerInfoFrame
PlayerPingLabel.BackgroundTransparency = 1
PlayerPingLabel.Position = UDim2.new(0.25, 0, 0, 0) 
PlayerPingLabel.Size = UDim2.new(0, 80, 0, 40)
PlayerPingLabel.Font = Enum.Font.SourceSansBold
PlayerPingLabel.Text = "Ping: 50 ms"
PlayerPingLabel.TextColor3 = Color3.fromRGB(231, 231, 231)
PlayerPingLabel.TextSize = 14


PlayerTimeLabel.Parent = PlayerInfoFrame
PlayerTimeLabel.BackgroundTransparency = 1
PlayerTimeLabel.Position = UDim2.new(0.48, 0, 0, 0) 
PlayerTimeLabel.Size = UDim2.new(0, 100, 0, 40)
PlayerTimeLabel.Font = Enum.Font.SourceSansBold
PlayerTimeLabel.Text = "Time: 00:00"
PlayerTimeLabel.TextColor3 = Color3.fromRGB(231, 231, 231)
PlayerTimeLabel.TextSize = 14


BrandingLabel.Parent = PlayerInfoFrame
BrandingLabel.BackgroundTransparency = 1
BrandingLabel.Position = UDim2.new(0.75, 0, 0, 0) 
BrandingLabel.Size = UDim2.new(0, 150, 0, 40)
BrandingLabel.Font = Enum.Font.SourceSansBold
BrandingLabel.Text = "Lanzet.net"
BrandingLabel.TextColor3 = Color3.fromRGB(231, 231, 231)
BrandingLabel.TextSize = 14
BrandingLabel.TextXAlignment = Enum.TextXAlignment.Left


local function updateFPS()
    local frameCount = 0
    local lastTime = tick()
    game:GetService("RunService").Heartbeat:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            PlayerFPSLabel.Text = "FPS: " .. frameCount
            frameCount = 0
            lastTime = currentTime
        end
    end)
end


local function updatePing()
    game:GetService("RunService").Heartbeat:Connect(function()
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        PlayerPingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
    end)
end


local function updateTime()
    game:GetService("RunService").Heartbeat:Connect(function()
        local time = os.date("%H:%M")
        PlayerTimeLabel.Text = "Time: " .. time
    end)
end


local dragging, dragInput, startPos
local function onDrag(input)
    if dragging then
        local delta = input.Position - dragInput.Position
        PlayerInfoFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end

PlayerInfoFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startPos = PlayerInfoFrame.Position
        dragInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

PlayerInfoFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        onDrag(input)
    end
end)


updateFPS()
updatePing()
updateTime()
