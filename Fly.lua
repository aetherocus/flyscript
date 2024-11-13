local Flygui = Instance.new("ScreenGui")
local Speed = Instance.new("TextLabel")
local COREGUI = game:GetService("CoreGui")

PARENT = nil
if get_hidden_gui or gethui then
	local hiddenUI = get_hidden_gui or gethui
	Flygui.Parent = hiddenUI()
	PARENT = Flygui
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
	syn.protect_gui(Flygui)
	Flygui.Parent = COREGUI
	PARENT = Flygui
elseif COREGUI:FindFirstChild('RobloxGui') then
	PARENT = COREGUI.RobloxGui
else
	Flygui.Parent = COREGUI
	PARENT = Flygui
end

Speed.Name = "Speed"
Speed.Parent = PARENT
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

local player = game:GetService("Players").LocalPlayer
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

end


local function stopFlying()
	if not flying then return end
	flying = false

	bodyGyro:Destroy()
	bodyVelocity:Destroy()
end

local function updateFlight()
	if not flying then return end

	local targetPosition = mouse.Hit.p
	local direction = (targetPosition - rootPart.Position).unit


	bodyVelocity.Velocity = direction * flySpeed
	bodyGyro.CFrame = CFrame.new(rootPart.Position, targetPosition)
end

local function toggle()
    if flying then
	stopFlying()
    else
	startFlying()
    end
end

cas:BindAction(Fly, toggle, false, Enum.KeyCode.LeftAlt)
cas:BindAction(speed0, function() 
	flySpeed = flySpeed + 5
	end, false, Enum.KeyCode.LeftBracket)
cas:BindAction(speed1, function() 
	flySpeed = flySpeed - 5
	end, false, Enum.KeyCode.RightBracket)

game:GetService("RunService").RenderStepped:Connect(function()
	Speed.Text = flySpeed
	if flying then
	updateFlight()
	end
end)
-- freaky ass nigga hes 69 god
