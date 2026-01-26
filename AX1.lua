-- AX Fly ✈️ كامل + Drag GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60
local up, down = false, false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AXFlyGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,110)
frame.Position = UDim2.new(0.5,-160,0.75,0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ====== DRAG SYSTEM ======
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Button helper
local function makeBtn(txt, pos, size, color)
	local b = Instance.new("TextButton", frame)
	b.Text = txt
	b.Position = pos
	b.Size = size
	b.BackgroundColor3 = color
	b.TextScaled = true
	b.TextColor3 = Color3.new(0,0,0)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

-- Buttons
local upBtn   = makeBtn("UP",   UDim2.new(0,10,0,10),   UDim2.new(0,60,0,40), Color3.fromRGB(120,255,120))
local downBtn = makeBtn("DOWN", UDim2.new(0,10,0,55),   UDim2.new(0,60,0,40), Color3.fromRGB(255,255,120))
local plusBtn  = makeBtn("+", UDim2.new(0,80,0,10), UDim2.new(0,50,0,40), Color3.fromRGB(200,200,255))
local minusBtn = makeBtn("-", UDim2.new(0,80,0,55), UDim2.new(0,50,0,40), Color3.fromRGB(200,255,255))
local speedLbl = makeBtn(tostring(speed), UDim2.new(0,140,0,10), UDim2.new(0,60,0,85), Color3.fromRGB(255,160,80))
speedLbl.Active = false
local flyBtn = makeBtn("FLY", UDim2.new(0,210,0,10), UDim2.new(0,100,0,85), Color3.fromRGB(255,220,120))

-- Buttons logic
upBtn.MouseButton1Down:Connect(function() up = true end)
upBtn.MouseButton1Up:Connect(function() up = false end)

downBtn.MouseButton1Down:Connect(function() down = true end)
downBtn.MouseButton1Up:Connect(function() down = false end)

plusBtn.MouseButton1Click:Connect(function()
	speed += 10
	speedLbl.Text = tostring(speed)
end)

minusBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedLbl.Text = tostring(speed)
end)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "STOP" or "FLY"
end)

-- Fly movement
RunService.RenderStepped:Connect(function()
	if not flying then return end

	local move = hrp.CFrame.LookVector * speed
	local y = 0
	if up then y = speed end
	if down then y = -speed end

	hrp.Velocity = Vector3.new(move.X, y, move.Z)
end)
