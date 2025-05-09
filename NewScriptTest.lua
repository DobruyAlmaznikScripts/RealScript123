local service = 3886;--Set your Platoboost Id 
local secret = "c562226f-53e3-430c-9430-3d1e1f02155d"; --Set Your Platoboost Api key
local useNonce = true; 
local onMessage = function(message)  game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", { Text = message; }) end;


repeat task.wait(1) until game:IsLoaded() or game.Players.LocalPlayer;


local requestSending = false;
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local cachedLink, cachedTime = "", 0;
local HttpService = game:GetService("HttpService")

function lEncode(data)
	return HttpService:JSONEncode(data)
end
function lDecode(data)
	return HttpService:JSONDecode(data)
end
local function lDigest(input)
	local inputStr = tostring(input)


	local hash = {}
	for i = 1, #inputStr do
		table.insert(hash, string.byte(inputStr, i))
	end

	local hashHex = ""
	for _, byte in ipairs(hash) do
		hashHex = hashHex .. string.format("%02x", byte)
	end

	return hashHex
end
local host = "https://api.platoboost.com";
local hostResponse = fRequest({
	Url = host .. "/public/connectivity",
	Method = "GET"
});
if hostResponse.StatusCode ~= 200 or hostResponse.StatusCode ~= 429 then
	host = "https://api.platoboost.net";
end

function cacheLink()
	if cachedTime + (10*60) < fOsTime() then
		local response = fRequest({
			Url = host .. "/public/start",
			Method = "POST",
			Body = lEncode({
				service = service,
				identifier = lDigest(fGetHwid())
			}),
			Headers = {
				["Content-Type"] = "application/json"
			}
		});

		if response.StatusCode == 200 then
			local decoded = lDecode(response.Body);

			if decoded.success == true then
				cachedLink = decoded.data.url;
				cachedTime = fOsTime();
				return true, cachedLink;
			else
				onMessage(decoded.message);
				return false, decoded.message;
			end
		elseif response.StatusCode == 429 then
			local msg = "you are being rate limited, please wait 20 seconds and try again.";
			onMessage(msg);
			return false, msg;
		end

		local msg = "Failed to cache link.";
		onMessage(msg);
		return false, msg;
	else
		return true, cachedLink;
	end
end



cacheLink();

local generateNonce = function()
	local str = ""
	for _ = 1, 16 do
		str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
	end
	return str
end


for _ = 1, 5 do
	local oNonce = generateNonce();
	task.wait(0.2)
	if generateNonce() == oNonce then
		local msg = "platoboost nonce error.";
		onMessage(msg);
		error(msg);
	end
end

local copyLink = function()
	local success, link = cacheLink();

	if success then
		print("SetClipBoard")
		fSetClipboard(link);
	end
end

local redeemKey = function(key)
	local nonce = generateNonce();
	local endpoint = host .. "/public/redeem/" .. fToString(service);

	local body = {
		identifier = lDigest(fGetHwid()),
		key = key
	}

	if useNonce then
		body.nonce = nonce;
	end

	local response = fRequest({
		Url = endpoint,
		Method = "POST",
		Body = lEncode(body),
		Headers = {
			["Content-Type"] = "application/json"
		}
	});

	if response.StatusCode == 200 then
		local decoded = lDecode(response.Body);
		if decoded.success == true then
			if decoded.data.valid == true then
				if useNonce then
					if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
						return true;
					else
						onMessage("failed to verify integrity.");
						return false;
					end    
				else
					return true;
				end
			else
				onMessage("key is invalid.");
				return false;
			end
		else
			if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
				onMessage("you already have an active key, please wait for it to expire before redeeming it.");
				return false;
			else
				onMessage(decoded.message);
				return false;
			end
		end
	elseif response.StatusCode == 429 then
		onMessage("you are being rate limited, please wait 20 seconds and try again.");
		return false;
	else
		onMessage("server returned an invalid status code, please try again later.");
		return false; 
	end
end


local verifyKey = function(key)
	if requestSending == true then
		onMessage("a request is already being sent, please slow down.");
		return false;
	else
		requestSending = true;
	end

	local nonce = generateNonce();
	local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;

	if useNonce then
		endpoint = endpoint .. "&nonce=" .. nonce;
	end
	local response = fRequest({
		Url = endpoint,
		Method = "GET",
	});

	requestSending = false;

	if response.StatusCode == 200 then
		local decoded = lDecode(response.Body);
		if decoded.success == true then
			if decoded.data.valid == true then
				if useNonce then
					return true;
				else
					return true;
				end
			else
				if fStringSub(key, 1, 4) == "FREE_" then
					return redeemKey(key);
				else
					onMessage("key is invalid.");
					return false;
				end
			end
		else
			onMessage(decoded.message);
			return false;
		end
	elseif response.StatusCode == 429 then
		onMessage("you are being rate limited, please wait 20 seconds and try again.");
		return false;
	else
		onMessage("server returned an invalid status code, please try again later.");
		return false;
	end
end


local getFlag = function(name)
	local nonce = generateNonce();
	local endpoint = host .. "/public/flag/" .. fToString(service) .. "?name=" .. name;

	if useNonce then
		endpoint = endpoint .. "&nonce=" .. nonce;
	end

	local response = fRequest({
		Url = endpoint,
		Method = "GET",
	});

	if response.StatusCode == 200 then
		local decoded = lDecode(response.Body);
		if decoded.success == true then
			if useNonce then
				if decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
					return decoded.data.value;
				else
					onMessage("failed to verify integrity.");
					return nil;
				end
			else
				return decoded.data.value;
			end
		else
			onMessage(decoded.message);
			return nil;
		end
	else
		return nil;
	end
end
task.spawn(function()
	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local Topbar = Instance.new("Frame")
	local Exit = Instance.new("TextButton")
	local minimize = Instance.new("TextButton")
	local Frame_2 = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local Getkey = Instance.new("TextButton")
	local Checkkey = Instance.new("TextButton")
	local TextBox = Instance.new("TextBox")
    local Load = Instance.new("IntValue")
    local KeyString = Instance.new("StringValue")



	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Frame.Parent = ScreenGui
	Frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.0451651067, 0, 0.0653266311, 0)
	Frame.Size = UDim2.new(0, 514, 0, 272)

	Topbar.Name = "Topbar"
	Topbar.Parent = Frame
	Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Topbar.BorderSizePixel = 0
	Topbar.Size = UDim2.new(0, 499, 0, 46)

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

	minimize.Name = "minimize"
	minimize.Parent = Topbar
	minimize.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
	minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	minimize.BorderSizePixel = 0
	minimize.Position = UDim2.new(0.851943851, 0, 0, 0)
	minimize.Size = UDim2.new(0, 43, 0, 46)
	minimize.Font = Enum.Font.SourceSans
	minimize.Text = ""
	minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
	minimize.TextSize = 14.000

	Frame_2.Parent = Frame
	Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_2.BackgroundTransparency = 0.900
	Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_2.BorderSizePixel = 0
	Frame_2.Position = UDim2.new(0.02533333, 0, 0.197529405, 0)
	Frame_2.Size = UDim2.new(0, 485, 0, 218)

	TextLabel.Parent = Frame_2
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 0.600
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.0912660584, 0, -0.0361641012, 0)
	TextLabel.Size = UDim2.new(0, 399, 0, 63)
	TextLabel.ZIndex = 2
	TextLabel.Font = Enum.Font.Unknown
	TextLabel.Text = "Input Your Key"
	TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = true

	Getkey.Name = "Getkey"
	Getkey.Parent = Frame_2
	Getkey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Getkey.BackgroundTransparency = 0.400
	Getkey.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Getkey.BorderSizePixel = 0
	Getkey.Position = UDim2.new(0.54282403, 0, 0.594108939, 0)
	Getkey.Size = UDim2.new(0, 200, 0, 50)
	Getkey.Font = Enum.Font.Unknown
	Getkey.Text = "Get Key"
	Getkey.TextColor3 = Color3.fromRGB(0, 0, 0)
	Getkey.TextScaled = true
	Getkey.TextSize = 14.000
	Getkey.TextWrapped = true

	Checkkey.Name = "Checkkey"
	Checkkey.Parent = Frame_2
	Checkkey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Checkkey.BackgroundTransparency = 0.400
	Checkkey.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Checkkey.BorderSizePixel = 0
	Checkkey.Position = UDim2.new(0.0417178422, 0, 0.594108939, 0)
	Checkkey.Size = UDim2.new(0, 200, 0, 50)
	Checkkey.Font = Enum.Font.Unknown
	Checkkey.Text = "Check Key"
	Checkkey.TextColor3 = Color3.fromRGB(0, 0, 0)
	Checkkey.TextScaled = true
	Checkkey.TextSize = 14.000
	Checkkey.TextWrapped = true


    KeyString.Parent = ScreenGui
    KeyString.Value = "Zero or loading"
    Load.Parent = ScreenGui

    TextBox.Parent = Frame_2
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 0.600
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.0912660584, 0, 0.275762498, 0)
	TextBox.Size = UDim2.new(0, 399, 0, 63)
	TextBox.Font = Enum.Font.SourceSans
	TextBox.Text = KeyString
	TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.TextSize = 14.000
	




	TextBox:GetPropertyChangedSignal("Text"):Connect(function(text)
		if TextBox.Text == "" then
			TextLabel.Text =  "In Put Your Key"
		else
			TextLabel.Text = TextBox.Text
		end
	end)

	Checkkey.MouseButton1Down:Connect(function() 
		if TextBox and TextBox.Text then

			local Verify = verifyKey(TextBox.Text)
			if Verify and Load.Value == 0 then
                KeyString.Value = TextBox.Text
				wait(1)
				loadstring(game:HttpGet("https://raw.githubusercontent.com/DobruyAlmaznikScripts/RealScript123/refs/heads/main/Grow_A_Garden2.lua"))()
				ScreenGui:Destroy()
                Load.Value = 1
			else
				print("Key Is invalid")
			end 
		end	
	end)

	Getkey.MouseButton1Down:Connect(function() 
		copyLink()
	end)

	Exit.MouseButton1Down:Connect(function()
		if ScreenGui then
			ScreenGui:Destroy()
		end
	end)


	minimize.MouseButton1Down:Connect(function()
		if ScreenGui then
			ScreenGui.Enabled = false
		end
		end)
end)
