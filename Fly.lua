local Flygui = Instance.new("ScreenGui")
local Speed = Instance.new("TextLabel")
local COREGUI = game:GetService("CoreGui")

Flygui.Parent = game.Players.LocalPlayer.PlayerGui
Flygui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Speed.Name = "Speed"
Speed.Parent = Flygui
Speed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Speed.BackgroundTransparency = 1.000
Speed.BorderColor3 = Color3.fromRGB(0, 0, 0)
Speed.BorderSizePixel = 0
Speed.Position = UDim2.new(0, 0, 0.0804347843, 0)
Speed.Size = UDim2.new(0.10080184, 0, 0.0673913062, 0)
Speed.Font = Enum.Font.SourceSans
Speed.Text = "0"
Speed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speed.TextScaled = true
Speed.TextSize = 14.000
Speed.TextWrapped = true

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local cas = game:GetService("ContextActionService")
local flying = false
local flySpeed = 50

local bodyGyro
local bodyVelocity

local function startFlying()
	if flying then return end
	flying = true

	bodyGyro = Instance.new("BodyGyro")
	bodyVelocity = Instance.new("BodyVelocity")

	bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000) 
	bodyGyro.CFrame = rootPart.CFrame

	bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)  
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)

	bodyGyro.Parent = rootPart
	bodyVelocity.Parent = rootPart

	humanoid.PlatformStand = true 
end


local function stopFlying()
	if not flying then return end
	flying = false

	bodyGyro:Destroy()
	bodyVelocity:Destroy()
	humanoid.PlatformStand = false  
end

local function updateFlight()
	if not flying then return end


	local targetPosition = mouse.Hit.p
	local direction = (targetPosition - rootPart.Position).unit


	bodyVelocity.Velocity = direction * flySpeed
	bodyGyro.CFrame = CFrame.new(rootPart.Position, targetPosition)
end

uis.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) 
	if gameProcessedEvent then return end

	if input.KeyCode == Enum.KeyCode.LeftAlt then
		if flying then
			stopFlying()
		else
			startFlying()
		end
	elseif input.KeyCode == Enum.KeyCode.LeftBracket then
		flySpeed = flySpeed + 5
	elseif input.KeyCode == Enum.KeyCode.RightBracket then
		flySpeed = flySpeed - 5
	end
end)
game:GetService("RunService").RenderStepped:Connect(function()
	Speed.Text = flySpeed
	if flying then
		updateFlight()
	end
end)



-- freaky ass nigga hes 69 god
