local ColourSliderAPI = {}
ColourSliderAPI.__index = ColourSliderAPI

-- Private arguments / functions --
local UIS = game:GetService("UserInputService")

local ColorSliderGuiContainer = Instance.new("ScreenGui")
ColorSliderGuiContainer.Name = "ColorSliderGuiContainer"
ColorSliderGuiContainer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ColorSliderGuiContainer.ResetOnSpawn = false

local buttonDown = false

UIS.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	buttonDown = false
end)

UIS.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	buttonDown = true
end)

local function shallowDictionaryCopy(dictToCopy)
	if type(dictToCopy) ~= "table" then error("Given parameter is not a table") end
	
	local copiedDictionary = {}

	for key , data in pairs(dictToCopy) do
		copiedDictionary[key] = data
	end

	return copiedDictionary
end

local function updateColor(colorSliderClass)
	local Lerp = (colorSliderClass.Slider.AbsolutePosition.Y - colorSliderClass.ColorSlider.AbsolutePosition.Y) / colorSliderClass.ColorSlider.AbsoluteSize.Y
	colorSliderClass.selectedColor = colorSliderClass.topColor:lerp(colorSliderClass.botColor , Lerp)
	colorSliderClass.ColorDisplay.ImageColor3 = colorSliderClass.selectedColor
end

-- CONSTRUCTOR -- 

function ColourSliderAPI.new(Arguments)
	Arguments = Arguments or {}
	Arguments = shallowDictionaryCopy(Arguments)
	
	local ColorSliderClass = setmetatable(Arguments , ColourSliderAPI)
	
	ColorSliderClass.ColorSlider = Instance.new("ImageButton")
	ColorSliderClass.UIGradient = Instance.new("UIGradient")
	ColorSliderClass.Slider = Instance.new("ImageLabel")
	ColorSliderClass.ColorDisplay = Instance.new("ImageLabel")
	
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = ColorSliderClass.ColorSlider
	UIAspectRatioConstraint.AspectRatio = 0.157
	
  ColorSliderClass.ColorSlider.Visible = false
  ColorSliderClass.ColorDisplay.Visible = false

	ColorSliderClass.ColorSlider.Name = "ColorSlider"
	ColorSliderClass.ColorSlider.Parent = ColorSliderGuiContainer
	ColorSliderClass.ColorSlider.Active = false
	ColorSliderClass.ColorSlider.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorSliderClass.ColorSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorSliderClass.ColorSlider.BackgroundTransparency = 1.000
	ColorSliderClass.ColorSlider.BorderSizePixel = 0
	ColorSliderClass.ColorSlider.Position = UDim2.new(0.436005175, 0, 0.5, 0)
	ColorSliderClass.ColorSlider.Selectable = false
	ColorSliderClass.ColorSlider.Size = UDim2.new(0.0478173457, 0, 0.592719018, 0)
	ColorSliderClass.ColorSlider.ZIndex = 2
	ColorSliderClass.ColorSlider.Image = "rbxassetid://3570695787"
	ColorSliderClass.ColorSlider.ScaleType = Enum.ScaleType.Slice
	ColorSliderClass.ColorSlider.SliceCenter = Rect.new(100, 100, 100, 100)
	ColorSliderClass.ColorSlider.SliceScale = 0.120

  ColorSliderClass.Slider.Name = "Slider"
	ColorSliderClass.Slider.Parent = ColorSliderClass.ColorSlider
	ColorSliderClass.Slider.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorSliderClass.Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorSliderClass.Slider.BackgroundTransparency = 1.000
	ColorSliderClass.Slider.BorderSizePixel = 0
	ColorSliderClass.Slider.Position = UDim2.new(0.491197795, 0, 0.0733607039, 0)
	ColorSliderClass.Slider.Size = UDim2.new(1.28656352, 0, 0.0265010502, 0)
	ColorSliderClass.Slider.ZIndex = 2
	ColorSliderClass.Slider.Image = "rbxassetid://3570695787"
	ColorSliderClass.Slider.ImageColor3 = Color3.fromRGB(255, 74, 74)
	ColorSliderClass.Slider.ScaleType = Enum.ScaleType.Slice
	ColorSliderClass.Slider.SliceCenter = Rect.new(100, 100, 100, 100)
	ColorSliderClass.Slider.SliceScale = 0.120

  ColorSliderClass.ColorDisplay.Name = "ColorDisplay"
	ColorSliderClass.ColorDisplay.Parent = ColorSliderGuiContainer
	ColorSliderClass.ColorDisplay.BackgroundTransparency = 1.000
	ColorSliderClass.ColorDisplay.BorderSizePixel = 0
	ColorSliderClass.ColorDisplay.Position = UDim2.new(0.47527355, 0, 0.203556925, 0)
	ColorSliderClass.ColorDisplay.Size = UDim2.new(0.124204591, 0, 0.242313251, 0)
	ColorSliderClass.ColorDisplay.ZIndex = 2
	ColorSliderClass.ColorDisplay.Image = "rbxassetid://3570695787"
	ColorSliderClass.ColorDisplay.ScaleType = Enum.ScaleType.Slice
	ColorSliderClass.ColorDisplay.SliceCenter = Rect.new(100, 100, 100, 100)
	ColorSliderClass.ColorDisplay.SliceScale = 0.120

  ColorSliderClass.isOn = false
  ColorSliderClass.topColor = ColorSliderClass.topColor or Color3.fromHSV(0, 0, 1)
  ColorSliderClass.botColor = ColorSliderClass.botColor or Color3.fromHSV(0, 0, 0)
	ColorSliderClass.ColorDisplay.BackgroundColor3 = ColorSliderClass.topColor
	
  ColorSliderClass.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, ColorSliderClass.topColor), ColorSequenceKeypoint.new(1.00, ColorSliderClass.botColor)}
	ColorSliderClass.UIGradient.Rotation = 90
	ColorSliderClass.UIGradient.Parent = ColorSliderClass.ColorSlider

  return ColorSliderClass
end

-- Destructor

function ColourSliderAPI:Destroy()
	if self.isOn then
		self.MoveSliderEvent:Disconnect()
	end
	
	self.ColorDisplay:Destroy()
	self.ColorSlider:Destroy()
	self = nil
end


-- Public functions
function ColourSliderAPI:turnOn()
	if self.customOn ~= nil then
		self.customOn({ColorSlider = self.ColorSlider, ColorDisplay = self.ColorDisplay})
	else
		self.ColorSlider.Visible = true
		self.ColorDisplay.Visible = true
	end

	self.isOn = true
	
	self.MoveSliderEvent = self.ColorSlider.MouseMoved:Connect(function(mouseX , mouseY)
		if not buttonDown then return end
		
		self.Slider.Position = UDim2.new(self.Slider.Position.X.Scale, 0, 0, 
			math.clamp(mouseY - self.ColorSlider.AbsolutePosition.Y - game:GetService("GuiService"):GetGuiInset().Y,  0, self.ColorSlider.AbsoluteSize.Y)
		)	
		
		updateColor(self)
	end)
end

function ColourSliderAPI:turnOff()
	if self.customOff ~= nil then
		self.customOff({ColorSlider = self.ColorSlider, ColorDisplay = self.ColorDisplay})
	else
    self.ColorSlider.Visible = false
		self.ColorDisplay.Visible = false
	end

	ColourSliderAPI.isOn = false
	self.MoveSliderEvent:Disconnect()
end

function ColourSliderAPI:readColor()
	return self.selectedColor or self.topColor
end

return ColourSliderAPI

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