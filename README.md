# OVERVIEW
`pigment` is a collection of utility functions for working with colors in Roblox.

## hsl(hue, saturation, lightness)
A wrapper around `Color3.fromHSV` to avoid using the [0, 1] range.
```luau
local hsl = pigment.hsl
local color = hsl(0, 0, 90)
```

## get_rgb_relative_luminance(color)
Returns the total luminance of a color.
```luau
local hsl = pigment.hsl

local color = hsl(0, 0, 25),
local luminance = pigment.get_rgb_relative_luminance(color)
```

## is_color_dark(color)
Determines if the provided color is dark.
```luau
local hsl = pigment.hsl

local color = hsl(0, 0, 25),
local is_dark = pigment.is_color_dark(color)
```

## is_color_sequence_dark(color_sequence)
Determines if the provided ColorSequence is dark, based on the average luminance of the colors in the sequence.
```luau
local hsl = pigment.hsl

local color_sequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, hsl(0, 0, 10)),
    ColorSequenceKeypoint.new(1, hsl(0, 0, 90))
}),

local is_dark = pigment.is_color_sequence_dark(color_sequence)
```

## get_brightest_color_in_color_sequence(color_sequence)
Returns the color with the highest luminance.
```luau
local hsl = pigment.hsl

local color_sequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, hsl(0, 0, 10)),
    ColorSequenceKeypoint.new(1, hsl(0, 0, 90))
}),

local brightest_color = pigment.get_brightest_color_in_color_sequence(color_sequence)
```

## evaluaute_color_sequence(color_sequence, elapsed_time)
TBA
```luau
local pigment = require("path/to/pigment")

local RunService = game:GetService("RunService")
local Part = workspace:WaitForChild("Part")

local COLOR_CHANGE_SPEED = 0.5
local COLOR_SEQUENCE = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
})

local elapsed_time = 0
local direction = 1

RunService.PreRender:Connect(function(delta_time)
    elapsed_time = math.clamp(elapsed_time + (delta_time * direction * COLOR_CHANGE_SPEED))

    if elapsed_time == 0 or elapsed_time == 1 then
        direction = -direction
    end

    Part.Color = pigment.evaluate_color_sequence()
end)
```