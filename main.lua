local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()
local Players = game:GetService("Players")

getgenv().locationCFrame = {
	["Booking"] = CFrame.new(189, 11, -152),
	["Minimum/Medium"] = CFrame.new(-10, 11, -76),
	["Maximum"] = CFrame.new(87, -9, -114),
	["Escape"] = CFrame.new(347, 5, -168),
	["Gate Control"] = CFrame.new(294, 7, -194)
}

getgenv().prisonerTeams = {
    [game.Teams.Booking] = true,
    [game.Teams["Minimum Security"]] = true,
    [game.Teams["Medium Security"]] = true,
    [game.Teams["Maximum Security"]] = true,
	[game.Teams.Escapee] = true
}

getgenv().policeTeams = {
	[game.Teams["Department of Corrections"]] = true,
	[game.Teams["Sheriff's Office"]] = true,
	[game.Teams["State Police"]] = true,
	[game.Teams["VCSO-SWAT"]] = true
}

local function refreshHighlights()
	for i, Player in pairs(Players:GetPlayers()) do
		if Player ~= Players.LocalPlayer then
			local Character = Player.Character

			if Character then
				if Character:FindFirstChildWhichIsA("Highlight") then
					Character:FindFirstChildWhichIsA("Highlight"):Destroy()
					if (getgenv().prisonerTeams[Player.Team] and getgenv().prisonerTeams[Players.LocalPlayer.Team]) or 
					(getgenv().policeTeams[Player.Team] and getgenv().policeTeams[Players.LocalPlayer.Team]) then
						local Highlight = Instance.new("Highlight")
						Highlight.FillColor = Color3.new(0, 1, 0)
						Highlight.Parent = Character
					else
						local Highlight = Instance.new("Highlight")
						Highlight.FillColor = Color3.new(1, 0, 0)
						Highlight.Parent = Character
					end
				end
			end
		end
	end
end

local win = Flux:Window("Test", "Valley Prison", Color3.fromRGB(255, 110, 48), Enum.KeyCode.RightShift)
local tab = win:Tab("Tab 1", "http://www.roblox.com/asset/?id=6023426915")

tab:Toggle("Highlight Players", "Works both on prisoner and police", false, function(bool)
    getgenv().toggled = bool

    if getgenv().toggled then
        task.spawn(function()
            while getgenv().toggled do
                refreshHighlights()
                task.wait()
            end
        end)
	else
    end
end)

tab:Line()

tab:Label("Movement")

tab:Slider("Walkspeed", "Makes you faster", 0, 100,16,function(ws)
    game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = ws
end)

tab:Slider("Jump power", "jump power", 0, 100,16,function(jp)
    game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = jp
end)

tab:Line()

tab2 = win:Tab("Teleportation", "http://www.roblox.com/asset/?id=10789587576")

tab2:Dropdown("Place to teleport to", {"Booking", "Minimum/Medium", "Maximum", "Escape", "Gate Control"}, function (selectedLocation)
	getgenv().location = selectedLocation
	print(getgenv().location)
end)

tab2:Button("Teleport", "Teleport to the selected location in the dropdown", function()
	if getgenv().location == nil then
		print("No location selected")
	else
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = locationCFrame[getgenv().location]
	end
end)

tab3 = win:Tab("Aimbot", "http://www.roblox.com/asset/?id=12614416526")