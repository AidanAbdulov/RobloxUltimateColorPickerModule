local ColorWheelAPI = {}
ColorWheelAPI.__index = ColorWheelAPI

-- Private arguments / functions

local UIS = game:GetService("UserInputService")

local ColorWheelGuiContainer = Instance.new("ScreenGui")
ColorWheelGuiContainer.Name = "ColorWheelGuiContainer"
ColorWheelGuiContainer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ColorWheelGuiContainer.ResetOnSpawn = false

local buttonDown = false

UIS.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	buttonDown = false
end)

UIS.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	buttonDown = true
end)

local function DotOnCircle(ColorWheel , MousePos)
	local Radius = ColorWheel.AbsoluteSize.X / 2 
	local colorWheelCenter =  ColorWheel.AbsolutePosition + Vector2.one * Radius
	local MoveVector = MousePos - colorWheelCenter
	
	if MoveVector.Magnitude > Radius then
		MoveVector = MoveVector.Unit * Radius
	end
	
	return MoveVector
end

local function updateColor(colorWheelClass)
	local Radius = colorWheelClass.ColorWheel.AbsoluteSize.X / 2 
	
	colorWheelClass.PickedColorPos = colorWheelClass.PickedColorPos or Vector2.zero
	local h = (math.pi - math.atan2(colorWheelClass.PickedColorPos.Y , colorWheelClass.PickedColorPos.X)) / (math.pi * 2) -- max when angle at 0, min at angel 360
	local s = colorWheelClass.PickedColorPos.Magnitude / Radius -- distance from center 0 - at center 1 - at radius
	local v = math.abs((colorWheelClass.Slider.AbsolutePosition.Y - colorWheelClass.DarknessPicker.AbsolutePosition.Y) / colorWheelClass.DarknessPicker.AbsoluteSize.Y - 1)
	
	colorWheelClass.readColor = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1))
	colorWheelClass.brightColor = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1),1)
end

local function shallowDictionaryCopy(dictToCopy)
	local copiedDictionary = {}
	
	for key , data in pairs(dictToCopy) do
		copiedDictionary[key] = data
	end
	
	return copiedDictionary
end


-- Constructor
function ColorWheelAPI.new(Arguments)
	Arguments = Arguments or {}
	Arguments = shallowDictionaryCopy(Arguments)
	
	local ColorWheelClass = setmetatable(Arguments , ColorWheelAPI)
	-- Instances:
	ColorWheelClass.DarknessPicker = Instance.new("ImageButton")
	ColorWheelClass.UIGradient = Instance.new("UIGradient")
	ColorWheelClass.Slider = Instance.new("ImageLabel")
	ColorWheelClass.ColorDisplay = Instance.new("ImageLabel")
	ColorWheelClass.ColorWheel = Instance.new("ImageButton")
	ColorWheelClass.Picker = Instance.new("ImageLabel")
	
	ColorWheelClass.DarknessPicker.Visible = false
	ColorWheelClass.ColorDisplay.Visible = false
	ColorWheelClass.ColorWheel.Visible = false
	
	
	local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
	local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	--Properties:

	

	ColorWheelClass.DarknessPicker.Name = "DarknessPicker"
	ColorWheelClass.DarknessPicker.Parent = ColorWheelGuiContainer
	ColorWheelClass.DarknessPicker.Active = false
	ColorWheelClass.DarknessPicker.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorWheelClass.DarknessPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorWheelClass.DarknessPicker.BackgroundTransparency = 1.000
	ColorWheelClass.DarknessPicker.BorderSizePixel = 0
	ColorWheelClass.DarknessPicker.Position = UDim2.new(0.436005175, 0, 0.5, 0)
	ColorWheelClass.DarknessPicker.Selectable = false
	ColorWheelClass.DarknessPicker.Size = UDim2.new(0.0478173457, 0, 0.592719018, 0)
	ColorWheelClass.DarknessPicker.ZIndex = 2
	ColorWheelClass.DarknessPicker.Image = "rbxassetid://3570695787"
	ColorWheelClass.DarknessPicker.ScaleType = Enum.ScaleType.Slice
	ColorWheelClass.DarknessPicker.SliceCenter = Rect.new(100, 100, 100, 100)
	ColorWheelClass.DarknessPicker.SliceScale = 0.120

	ColorWheelClass.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
	ColorWheelClass.UIGradient.Rotation = 90
	ColorWheelClass.UIGradient.Parent = ColorWheelClass.DarknessPicker

	ColorWheelClass.Slider.Name = "Slider"
	ColorWheelClass.Slider.Parent = ColorWheelClass.DarknessPicker
	ColorWheelClass.Slider.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorWheelClass.Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorWheelClass.Slider.BackgroundTransparency = 1.000
	ColorWheelClass.Slider.BorderSizePixel = 0
	ColorWheelClass.Slider.Position = UDim2.new(0.491197795, 0, 0.0733607039, 0)
	ColorWheelClass.Slider.Size = UDim2.new(1.28656352, 0, 0.0265010502, 0)
	ColorWheelClass.Slider.ZIndex = 2
	ColorWheelClass.Slider.Image = "rbxassetid://3570695787"
	ColorWheelClass.Slider.ImageColor3 = Color3.fromRGB(255, 74, 74)
	ColorWheelClass.Slider.ScaleType = Enum.ScaleType.Slice
	ColorWheelClass.Slider.SliceCenter = Rect.new(100, 100, 100, 100)
	ColorWheelClass.Slider.SliceScale = 0.120

	UIAspectRatioConstraint.Parent = ColorWheelClass.DarknessPicker
	UIAspectRatioConstraint.AspectRatio = 0.157

	ColorWheelClass.ColorDisplay.Name = "ColorDisplay"
	ColorWheelClass.ColorDisplay.Parent = ColorWheelGuiContainer
	ColorWheelClass.ColorDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorWheelClass.ColorDisplay.BackgroundTransparency = 1.000
	ColorWheelClass.ColorDisplay.BorderSizePixel = 0
	ColorWheelClass.ColorDisplay.Position = UDim2.new(0.47527355, 0, 0.203556925, 0)
	ColorWheelClass.ColorDisplay.Size = UDim2.new(0.124204591, 0, 0.242313251, 0)
	ColorWheelClass.ColorDisplay.ZIndex = 2
	ColorWheelClass.ColorDisplay.Image = "rbxassetid://3570695787"
	ColorWheelClass.ColorDisplay.ScaleType = Enum.ScaleType.Slice
	ColorWheelClass.ColorDisplay.SliceCenter = Rect.new(100, 100, 100, 100)
	ColorWheelClass.ColorDisplay.SliceScale = 0.120

	UIAspectRatioConstraint_2.Parent = ColorWheelClass.ColorDisplay

	ColorWheelClass.ColorWheel.Name = "ColorWheel"
	ColorWheelClass.ColorWheel.Parent = ColorWheelGuiContainer
	ColorWheelClass.ColorWheel.Active = false
	ColorWheelClass.ColorWheel.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorWheelClass.ColorWheel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorWheelClass.ColorWheel.BackgroundTransparency = 1.000
	ColorWheelClass.ColorWheel.BorderSizePixel = 0
	ColorWheelClass.ColorWheel.Position = UDim2.new(0.296660334, 0, 0.499338031, 0)
	ColorWheelClass.ColorWheel.Selectable = false
	ColorWheelClass.ColorWheel.Size = UDim2.new(0.210223019, 0, 0.565415323, 0)
	ColorWheelClass.ColorWheel.Image = "http://www.roblox.com/asset/?id=6020299385"

	UIAspectRatioConstraint_3.Parent = ColorWheelClass.ColorWheel
	UIAspectRatioConstraint_3.AspectRatio = 1.000

	ColorWheelClass.Picker.Name = "Picker"
	ColorWheelClass.Picker.Parent = ColorWheelClass.ColorWheel
	ColorWheelClass.Picker.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorWheelClass.Picker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorWheelClass.Picker.BackgroundTransparency = 1.000
	ColorWheelClass.Picker.BorderSizePixel = 0
	ColorWheelClass.Picker.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorWheelClass.Picker.Size = UDim2.new(0.0900257826, 0, 0.0900257975, 0)
	ColorWheelClass.Picker.Image = "http://www.roblox.com/asset/?id=3678860011"
	
	ColorWheelClass.readColor = Color3.fromHSV(0, 0, 1)
	ColorWheelAPI.isOn = false
	
	return ColorWheelClass
end

-- Destructor

function ColorWheelAPI:Destroy()
	if self.isOn then
		self.MoveWheelEvent:Disconnect() 
		self.MoveBarEvent:Disconnect()
	end
	
	self.ColorWheel:Destroy()
	self.ColorDisplay:Destroy()
	self.DarknessPicker:Destroy()
	self = nil
end

-- Public functions
function ColorWheelAPI:turnOn()
	if self.customOn ~= nil then
		self.customOn(self)
	else
		self.DarknessPicker.Visible = true
		self.ColorDisplay.Visible = true
		self.ColorWheel.Visible = true
	end

	ColorWheelAPI.isOn = true
	self.MoveWheelEvent = self.ColorWheel.MouseMoved:Connect(function(mouseX , mouseY)
		if not buttonDown then return end
		
		self.PickedColorPos = DotOnCircle(self.ColorWheel , Vector2.new(mouseX , mouseY - game:GetService("GuiService"):GetGuiInset().Y))
		
		local pickerPosition = self.PickedColorPos / self.ColorWheel.AbsoluteSize + Vector2.new(.5 , .5)
		self.Picker.Position = UDim2.new(pickerPosition.X , 0 , pickerPosition.Y , 0)
		
		updateColor(self)
		self.ColorDisplay.ImageColor3 = self.readColor
		self.DarknessPicker.UIGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, self.brightColor), 
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
		}
	end)
	
	self.MoveBarEvent = self.DarknessPicker.MouseMoved:Connect(function(mouseX , mouseY)
		if not buttonDown then return end
		
		self.Slider.Position = UDim2.new(self.Slider.Position.X.Scale, 0, 0, 
			math.clamp(mouseY - self.DarknessPicker.AbsolutePosition.Y - game:GetService("GuiService"):GetGuiInset().Y,  0, self.DarknessPicker.AbsoluteSize.Y)
		)	
		
		updateColor(self)
		self.ColorDisplay.ImageColor3 = self.readColor
	end)
end

function ColorWheelAPI:turnOff()
	if self.customOff ~= nil then
		self.customOff(self)
	else
		self.DarknessPicker.Visible = false
		self.ColorDisplay.Visible = false
		self.ColorWheel.Visible = false
	end
	ColorWheelAPI.isOn = false
	self.MoveWheelEvent:Disconnect() 
	self.MoveBarEvent:Disconnect()
end

function ColorWheelAPI:readColor()
	return self.readColor or Color3.fromRGB(255, 255, 255)
end

return ColorWheelAPI

--[[
	© COPYRIGHT 2022
	Made by Aidan Abdulov

	Social Medias:
		Discord: Aidan_07#0007
		GitHub: https://github.com/AidanAbdulov
		Twitter: https://twitter.com/aidan_abdulov
	License: MIT license

	DO NOT REMOVE THE COPYRIGHT
]]