local player = game:GetService("Players").LocalPlayer

local gameUI = player:WaitForChild("PlayerGui"):WaitForChild("GameUI")

local function removeLabels()
    if gameUI then
        local serverStatus = gameUI:FindFirstChild("ServerStatus")
        if serverStatus and serverStatus:IsA("TextLabel") then
            serverStatus:Destroy()
        end

        local serverInfo = gameUI:FindFirstChild("ServerInfo")
        if serverInfo and serverInfo:IsA("TextLabel") then
            serverInfo:Destroy()
        end
    else
        warn("???")
    end
end

removeLabels()
