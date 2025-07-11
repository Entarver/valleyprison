local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")

getgenv().toggled = false

local locationCFrame = {
	["Booking"] = CFrame.new(189, 11, -152),
	["Minimum/Medium"] = CFrame.new(-10, 11, -76),
	["Maximum"] = CFrame.new(87, -9, -114),
	["Escape"] = CFrame.new(347, 5, -168),
	["Gate Control"] = CFrame.new(294, 7, -194)
}

local prisonerTeams = {
    [game.Teams.Booking] = true,
    [game.Teams["Minimum Security"]] = true,
    [game.Teams["Medium Security"]] = true,
    [game.Teams["Maximum Security"]] = true,
	[game.Teams.Escapee] = true
}

local policeTeams = {
	[game.Teams["Department of Corrections"]] = true,
	[game.Teams["Sheriff's Office"]] = true,
	[game.Teams["State Police"]] = true,
	[game.Teams["VCSO-SWAT"]] = true
}

local function refreshHighlights()
	for _, player in Players:GetPlayers() do
		if player ~= Players.LocalPlayer then
			local Character = player.Character
			if Character then
				if Character:FindFirstChildWhichIsA("Highlight") then
					Character:FindFirstChildWhichIsA("Highlight"):Destroy()
				end
				if Character then
					if (prisonerTeams[player.Team] and prisonerTeams[Players.LocalPlayer.Team]) or (policeTeams[player.Team] and policeTeams[Players.LocalPlayer.Team]) then
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

local Window = Rayfield:CreateWindow({
   Name = "Valley Prison",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Valley Prison",
   LoadingSubtitle = "by cat from 1975",
   ShowText = "Valley Prison", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local espToggle = Tab:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Flag = "esp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(bool)
		getgenv().toggled = bool
		if not bool then
			for _, player in Players:GetPlayers() do
				if player ~= Players.LocalPlayer then
					local Character = player.Character
					if Character:FindFirstChildWhichIsA("Highlight") then
						Character:FindFirstChildWhichIsA("Highlight"):Destroy()
					end
				end
			end
		end
	end,
})

task.spawn(function()
	while task.wait(0.5) do
		if getgenv().toggled then
			refreshHighlights()
		end
	end
end)

local movementSection = Tab:CreateSection("Movement")

local walkspeedSlider = Tab:CreateSlider({
	Name = "Walkspeed",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 16,
	Flag = "walkspeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(ws)
		Players.LocalPlayer.Character.Humanoid.WalkSpeed = ws
	end,
})

local defaultWalkspeedButton = Tab:CreateButton({
   Name = "Set Walkspeed to default value",
   Callback = function()
		local defaultWalkspeed = 16
		walkspeedSlider:Set(defaultWalkspeed)
   end
})

local jumpSlider = Tab:CreateSlider({
	Name = "Jumppower",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 50,
	Flag = "jumppower", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(jp)
		Players.LocalPlayer.Character.Humanoid.JumpPower = jp
	end,
})

local defaultJumppowerButton = Tab:CreateButton({
   Name = "Set Jumppower to default value",
   Callback = function()
		local defaultJumppower = 25
		jumpSlider:Set(defaultJumppower)
   end
})

local tpTab = Window:CreateTab("Teleport", 10789587576) -- Title, Image

local selectedTeleport = nil

local tpDropdown = tpTab:CreateDropdown({
	Name = "Select location",
	Options = {"Booking", "Minimum/Medium", "Maximum", "Escape", "Gate Control"},
	CurrentOption = {"Escape"},
	MultipleOptions = false,
	Flag = "tpDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Options)
		selectedTeleport = Options[1]
		print(selectedTeleport)
	end,
})

local tpButton = tpTab:CreateButton({
   Name = "Teleport",
   Callback = function()
	if selectedTeleport == nil then
		print("No location selected")
	else
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = locationCFrame[selectedTeleport]
	end
   end,
})