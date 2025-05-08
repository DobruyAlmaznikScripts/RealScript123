-- Gui to Lua
-- Version: 3.2

-- Instances:

local KeyGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Topbar = Instance.new("Frame")
local Exit = Instance.new("TextButton")
local Minimize = Instance.new("TextButton")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local Checkkey = Instance.new("TextButton")
local TextBox = Instance.new("TextBox")
local LinkText = Instance.new("TextBox")
local Getkey = Instance.new("TextButton")

--Properties:

KeyGui.Name = "KeyGui"
KeyGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = KeyGui
Frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.253429592, 0, 0.19974874, 0)
Frame.Size = UDim2.new(0, 750, 0, 500)

Topbar.Name = "Topbar"
Topbar.Parent = Frame
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
Topbar.BorderSizePixel = 0
Topbar.Size = UDim2.new(0, 750, 0, 46)

Exit.Name = "Exit"
Exit.Parent = Topbar
Exit.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
Exit.BorderSizePixel = 0
Exit.Position = UDim2.new(0.939999998, 0, 0, 0)
Exit.Size = UDim2.new(0, 45, 0, 46)
Exit.Font = Enum.Font.SourceSans
Exit.Text = ""
Exit.TextColor3 = Color3.fromRGB(0, 0, 0)
Exit.TextSize = 14.000

Minimize.Name = "Minimize"
Minimize.Parent = Topbar
Minimize.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
Minimize.BorderSizePixel = 0
Minimize.Position = UDim2.new(0.879999995, 0, 0, 0)
Minimize.Size = UDim2.new(0, 45, 0, 46)
Minimize.Font = Enum.Font.SourceSans
Minimize.Text = ""
Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
Minimize.TextSize = 14.000

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 0.900
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.0253333338, 0, 0.123999998, 0)
Frame_2.Size = UDim2.new(0, 712, 0, 413)

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 0.600
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.219101131, 0, 0.184019372, 0)
TextLabel.Size = UDim2.new(0, 399, 0, 63)
TextLabel.ZIndex = 2
TextLabel.Font = Enum.Font.Unknown
TextLabel.Text = "Input Your Key"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

Checkkey.Name = "Checkkey"
Checkkey.Parent = Frame_2
Checkkey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Checkkey.BackgroundTransparency = 0.400
Checkkey.BorderColor3 = Color3.fromRGB(0, 0, 0)
Checkkey.BorderSizePixel = 0
Checkkey.Position = UDim2.new(0.0870786533, 0, 0.566585958, 0)
Checkkey.Size = UDim2.new(0, 200, 0, 50)
Checkkey.Font = Enum.Font.Unknown
Checkkey.Text = "Check Key"
Checkkey.TextColor3 = Color3.fromRGB(0, 0, 0)
Checkkey.TextScaled = true
Checkkey.TextSize = 14.000
Checkkey.TextWrapped = true

TextBox.Parent = Frame_2
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 0.600
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.219101131, 0, 0.184019372, 0)
TextBox.Size = UDim2.new(0, 399, 0, 63)
TextBox.ClearTextOnFocus = false
TextBox.Font = Enum.Font.SourceSans
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextSize = 14.000


LinkText.Name = "LinkText"
LinkText.Parent = Frame_2
LinkText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LinkText.BorderColor3 = Color3.fromRGB(0, 0, 0)
LinkText.BorderSizePixel = 0
LinkText.Position = UDim2.new(0.0870786533, 0, 0.803874075, 0)
LinkText.Size = UDim2.new(0, 603, 0, 62)
LinkText.ClearTextOnFocus = false
LinkText.Font = Enum.Font.Unknown
LinkText.Text = "LINK"
LinkText.TextColor3 = Color3.fromRGB(0, 0, 0)
LinkText.TextScaled = true
LinkText.TextSize = 14.000
LinkText.TextWrapped = true

Getkey.Name = "Getkey"
Getkey.Parent = Frame_2
Getkey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Getkey.BackgroundTransparency = 0.400
Getkey.BorderColor3 = Color3.fromRGB(0, 0, 0)
Getkey.BorderSizePixel = 0
Getkey.Position = UDim2.new(0.606741548, 0, 0.566585958, 0)
Getkey.Size = UDim2.new(0, 200, 0, 50)
Getkey.Font = Enum.Font.Unknown
Getkey.Text = "Get Key"
Getkey.TextColor3 = Color3.fromRGB(0, 0, 0)
Getkey.TextScaled = true
Getkey.TextSize = 14.000
Getkey.TextWrapped = true

TextBox:GetPropertyChangedSignal("Text"):Connect(function(text)
	if TextBox.Text == "" then
		TextLabel.Text = "In Put Your Key"
	else
		TextLabel.Text = TextBox.Text
	end
end)

Checkkey.MouseButton1Down:Connect(function()
	if TextBox.Text =="Grow_A_Garden_2025" then
    loadstring(game:HttpGet("https://github.com/DobruyAlmaznikScripts/RealScript123/blob/main/InTest.lua"))()
    wait(0.5)
		if KeyGui then
			KeyGui:Destroy()
		end
	end
end)
Getkey.MouseButton1Down:Connect(function()
	local Players = game:GetService("Players")
	local UIS = game:GetService("UserInputService")
	local input = LinkText
	input.Text = "https://loot-link.com/s?mBWna15X"
end)

Exit.MouseButton1Down:Connect(function()
	if KeyGui then
		KeyGui:Destroy()
	end
end)
Minimize.MouseButton1Down:Connect(function()
	if KeyGui then
		KeyGui.Enabled = false
	end
end)
