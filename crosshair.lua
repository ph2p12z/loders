local settings = {
    color = Color3.fromRGB(255, 255, 255),
    thickness = 2,
    length = 8,
    opacity = 1,
    x_offset = 0,
    y_offset = 0,
    recenter = true,
    spinning = false,
    pulsing = false,
    z_mode = false 
}

local cam = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
getgenv().crosshair_x = getgenv().crosshair_x or {}
getgenv().crosshair_y = getgenv().crosshair_y or {}
getgenv().z_crosshair = getgenv().z_crosshair or {} 

local function draw(a1, a2)
    local obj = Drawing.new(a1)
    for i, v in pairs(a2) do
        obj[i] = v
    end
    return obj
end

local function clearCrosshair()
    if getgenv().crosshair_x["Line"] then
        getgenv().crosshair_x["Line"]:Remove()
    end
    if getgenv().crosshair_y["Line"] then
        getgenv().crosshair_y["Line"]:Remove()
    end
    if getgenv().z_crosshair["Line1"] then
        getgenv().z_crosshair["Line1"]:Remove()
    end
    if getgenv().z_crosshair["Line2"] then
        getgenv().z_crosshair["Line2"]:Remove()
    end
    if getgenv().z_crosshair["Line3"] then
        getgenv().z_crosshair["Line3"]:Remove()
    end
    getgenv().crosshair_x = {}
    getgenv().crosshair_y = {}
    getgenv().z_crosshair = {}
end

clearCrosshair()

local angle = 0
local pulseSize = settings.length

local function updateCrosshair()
    local cx, cy = cam.ViewportSize.x / 2, cam.ViewportSize.y / 2

    if settings.spinning then
        angle = (angle + math.rad(2)) % (2 * math.pi) 
    else
        angle = 0
    end

    if settings.pulsing then
        pulseSize = settings.length + math.sin(tick() * 5) * 4
    else
        pulseSize = settings.length
    end

    if settings.z_mode then
        local size = pulseSize * 2

        getgenv().z_crosshair["Line1"]["From"] = Vector2.new(cx - size / 2, cy - size / 2)
        getgenv().z_crosshair["Line1"]["To"] = Vector2.new(cx + size / 2, cy - size / 2)

        getgenv().z_crosshair["Line2"]["From"] = Vector2.new(cx + size / 2, cy - size / 2)
        getgenv().z_crosshair["Line2"]["To"] = Vector2.new(cx - size / 2, cy + size / 2)

        getgenv().z_crosshair["Line3"]["From"] = Vector2.new(cx - size / 2, cy + size / 2)
        getgenv().z_crosshair["Line3"]["To"] = Vector2.new(cx + size / 2, cy + size / 2)
    else
        getgenv().crosshair_x["Line"]["To"] = Vector2.new(
            cx - math.cos(angle) * pulseSize - settings.x_offset,
            cy - math.sin(angle) * pulseSize - settings.y_offset
        )
        getgenv().crosshair_x["Line"]["From"] = Vector2.new(
            cx + math.cos(angle) * pulseSize - settings.x_offset,
            cy + math.sin(angle) * pulseSize - settings.y_offset
        )

        getgenv().crosshair_y["Line"]["To"] = Vector2.new(
            cx - math.sin(angle) * pulseSize - settings.x_offset,
            cy - math.cos(angle) * pulseSize - settings.y_offset
        )
        getgenv().crosshair_y["Line"]["From"] = Vector2.new(
            cx + math.sin(angle) * pulseSize - settings.x_offset,
            cy + math.cos(angle) * pulseSize - settings.y_offset
        )
    end
end

getgenv().crosshair_x["Line"] = draw("Line", {
    Thickness = settings.thickness,
    Color = settings.color,
    Transparency = settings.opacity,
    Visible = true
})

getgenv().crosshair_y["Line"] = draw("Line", {
    Thickness = settings.thickness,
    Color = settings.color,
    Transparency = settings.opacity,
    Visible = true
})

getgenv().z_crosshair["Line1"] = draw("Line", {
    Thickness = settings.thickness,
    Color = settings.color,
    Transparency = settings.opacity,
    Visible = false
})

getgenv().z_crosshair["Line2"] = draw("Line", {
    Thickness = settings.thickness,
    Color = settings.color,
    Transparency = settings.opacity,
    Visible = false
})

getgenv().z_crosshair["Line3"] = draw("Line", {
    Thickness = settings.thickness,
    Color = settings.color,
    Transparency = settings.opacity,
    Visible = false
})

game:GetService("RunService").RenderStepped:Connect(updateCrosshair)

local screenGui = Instance.new("ScreenGui", game.CoreGui)
local buttonFrame = Instance.new("Frame", screenGui)
buttonFrame.Size = UDim2.new(0, 200, 0, 170)
buttonFrame.Position = UDim2.new(0, 10, 0, 10)
buttonFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
buttonFrame.BorderSizePixel = 1
buttonFrame.BorderColor3 = Color3.fromRGB(102, 102, 102)

local dragging = false
local dragInput, dragStart, startPos

buttonFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = buttonFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

buttonFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        buttonFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local titleLabel = Instance.new("TextLabel", buttonFrame)
titleLabel.Size = UDim2.new(0, 200, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Lanzet.net"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1

local spinToggle = Instance.new("TextButton", buttonFrame)
spinToggle.Size = UDim2.new(0, 200, 0, 30)
spinToggle.Position = UDim2.new(0, 0, 0, 30)
spinToggle.Text = "Spin: OFF"
spinToggle.Font = Enum.Font.GothamBold
spinToggle.TextSize = 16
spinToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
spinToggle.BackgroundColor3 = Color3.fromRGB(8, 8, 8)

local pulseToggle = Instance.new("TextButton", buttonFrame)
pulseToggle.Size = UDim2.new(0, 200, 0, 30)
pulseToggle.Position = UDim2.new(0, 0, 0, 70)
pulseToggle.Text = "Pulse: OFF"
pulseToggle.Font = Enum.Font.GothamBold
pulseToggle.TextSize = 16
pulseToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
pulseToggle.BackgroundColor3 = Color3.fromRGB(8, 8, 8)

local zModeToggle = Instance.new("TextButton", buttonFrame)
zModeToggle.Size = UDim2.new(0, 200, 0, 30)
zModeToggle.Position = UDim2.new(0, 0, 0, 110)
zModeToggle.Text = "Sussy: OFF"
zModeToggle.Font = Enum.Font.GothamBold
zModeToggle.TextSize = 16
zModeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
zModeToggle.BackgroundColor3 = Color3.fromRGB(8, 8, 8)

spinToggle.MouseButton1Click:Connect(function()
    settings.spinning = not settings.spinning
    spinToggle.Text = "Spin: " .. (settings.spinning and "ON" or "OFF")
end)

pulseToggle.MouseButton1Click:Connect(function()
    settings.pulsing = not settings.pulsing
    pulseToggle.Text = "Pulse: " .. (settings.pulsing and "ON" or "OFF")
end)

zModeToggle.MouseButton1Click:Connect(function()
    settings.z_mode = not settings.z_mode
    zModeToggle.Text = "Sussy: " .. (settings.z_mode and "ON" or "OFF")
    getgenv().z_crosshair["Line1"].Visible = settings.z_mode
    getgenv().z_crosshair["Line2"].Visible = settings.z_mode
    getgenv().z_crosshair["Line3"].Visible = settings.z_mode
    getgenv().crosshair_x["Line"].Visible = not settings.z_mode
    getgenv().crosshair_y["Line"].Visible = not settings.z_mode
end)
