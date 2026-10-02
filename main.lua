--[[\
    Script: Steel and Egg - All-in-One Hub
    Features: Speed, Jump, Fast Steal, Auto Best Egg, Anti-Idle
]]--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- Config Settings
getgenv().SteelEggConfig = {
	SpeedEnabled = true,
	SpeedValue = 25,
	JumpEnabled = true,
	JumpValue = 50,
	FastSteal = true,
	AutoFarmBestEgg = true,
	AntiKick = true,
}

-- 1 & 2. Speed & Jump Hack
task.spawn(function()
	while task.wait(0.1) do
		if humanoid then
			if getgenv().SteelEggConfig.SpeedEnabled then
				humanoid.WalkSpeed = getgenv().SteelEggConfig.SpeedValue
			end
			if getgenv().SteelEggConfig.JumpEnabled then
				humanoid.UseJumpPower = true
				humanoid.JumpPower = getgenv().SteelEggConfig.JumpValue
			end
		end
	end
end)

-- 3 & 4. Fast Steal & Proximity Prompt Bypass
task.spawn(function()
	while task.wait(0.2) do
		if getgenv().SteelEggConfig.FastSteal then
			pcall(function()
				for _, prompt in ipairs(Workspace:GetDescendants()) do
					if prompt:IsA("ProximityPrompt") then
						prompt.HoldDuration = 0
						fireproximityprompt(prompt)
					end
				end
			end)
		end
	end
end)

-- 5. Auto Farm Best Egg
task.spawn(function()
	while task.wait(0.5) do
		if getgenv().SteelEggConfig.AutoFarmBestEgg then
			pcall(function()
				local bestEgg = nil
				local highestValue = -1
				local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("Map")
				
				if eggsFolder then
					for _, obj in ipairs(eggsFolder:GetDescendants()) do
						local eggValue = obj:GetAttribute("Value") or obj:GetAttribute("Tier") or 1
						if eggValue > highestValue then
							highestValue = eggValue
							bestEgg = obj
						end
					end
				end
				
				if bestEgg and rootPart then
					local targetPos = bestEgg:IsA("Model") and bestEgg:GetPrimaryPartCFrame() or (bestEgg:IsA("BasePart") and bestEgg.CFrame)
					if targetPos then
						rootPart.CFrame = targetPos + Vector3.new(0, 3, 0)
					end
				end
			end)
		end
	end
end)

-- 6. Anti-Idle (Anti-Kick)
task.spawn(function()
	local vu = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		if getgenv().SteelEggConfig.AntiKick then
			vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
		end
	end)
end)

print("Steel and Egg Hub Loaded Successfully!")
