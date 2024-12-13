local uis = game:GetService("UserInputService")
local cas = game:GetService("ContextActionService")
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local RS = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local controls = {
	W = 0,
	A = 0,
	S = 0,
	D = 0,
}

local flying = false
local boosting = false

local gyro
local vel
local thrust

local acceleration = Vector3.new(0,16,0)
local lastframeacc = Vector3.zero

local cam = game:GetService("Workspace").CurrentCamera

local gyrocf = CFrame.new()

local flyfunc

local ts = game:GetService("TweenService")

 local function Toggle()
	if player.Character == nil then
		return
	end
	if player.Character.Humanoid.Health <= 0 then
		return
	end

	if flying == false then
		char = player.Character
		flying = true
		gyro = Instance.new("BodyGyro")
		gyro.MaxTorque = Vector3.new(40000,40000,40000)
		gyro.D = 4
		gyro.P = 30
		gyro.Parent = char.PrimaryPart
		gyro.CFrame = gyrocf
		vel = Instance.new("BodyVelocity")
		vel.Velocity = Vector3.new(0,0,0)
		vel.P = 30
		vel.MaxForce = Vector3.new(40000,40000,40000)
		vel.Parent = char.PrimaryPart
		char.Humanoid.PlatformStand = true
		acceleration = Vector3.new(0,16,0)
		lastframeacc = Vector3.new(0,0,-1)
		flyfunc = RS.Heartbeat:Connect(function(dt)
			if player.Character == nil then
	            Toggle()
				return
			end
			if player.Character.PrimaryPart == nil then
				Toggle()
				return
			end
			local Direction = cam.CFrame:VectorToWorldSpace(Vector3.new(controls.A + controls.D, controls.W * 0.1 + controls.S * 0.1, controls.W + controls.S))
			acceleration = acceleration:Lerp(lastframeacc + Direction * 72 * 60 / (1 / dt), 0.02)
			gyro.CFrame = CFrame.lookAt(char.PrimaryPart.Position, char.PrimaryPart.Position + lastframeacc) * CFrame.Angles(-math.pi / 2 * math.clamp((Direction.Magnitude + acceleration.Magnitude) * 0.01, -1, 1), 0, 0)
			vel.Velocity = acceleration
			if Direction.Magnitude > 1 then
				lastframeacc = acceleration * 0.5
			end
		end)
	else
		flying = false
		char.Humanoid.PlatformStand = false
		if gyro ~= nil then
			gyro:Destroy()
			gyro = nil
		end
		if vel ~= nil then
			vel:Destroy()
			vel = nil
		end
		if flyfunc ~= nil then
			flyfunc:Disconnect()
			flyfunc = nil
		end
	end
end

uis.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.W then
		controls.W = -1
	end
	if Input.KeyCode == Enum.KeyCode.A then
		controls.A = -1
	end
	if Input.KeyCode == Enum.KeyCode.S then
		controls.S = 1
	end
	if Input.KeyCode == Enum.KeyCode.D then
		controls.D = 1
	end
end)

uis.InputEnded:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.W then
		controls.W = 0
	end
	if Input.KeyCode == Enum.KeyCode.A then
		controls.A = 0
	end
	if Input.KeyCode == Enum.KeyCode.S then
		controls.S = 0
	end
	if Input.KeyCode == Enum.KeyCode.D then
		controls.D = 0
	end
end)

uis.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then -- Ensure the key press is not processed by the game UI
		if input.KeyCode == Enum.KeyCode.LeftAlt then
		    Toggle()
		end
	end
end)

char.Humanoid.Died:Connect(function()
	flying = false
	boosting = false
end)


-- freaky ass nigga hes 69 god
