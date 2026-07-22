--!strict
local pigment = {}

function pigment.hsl(hue: number, saturation: number, lightness: number)
	hue %= 360

	return Color3.fromHSV(hue / 360, saturation / 100, lightness / 100)
end

function pigment.get_rgb_relative_luminance(color: Color3)
	return (0.2126 * color.R) + (0.7152 * color.G) + (0.0722 * color.B)
end

function pigment.is_color_dark(luminance: number): boolean
	return luminance < 0.5
end

function pigment.is_color_sequence_dark(color_sequence: ColorSequence)
	local keypoints = color_sequence.Keypoints
	local total_luminance = 0
	local num_keypoints = #keypoints

	for index = 1, num_keypoints do
		local color = keypoints[index].Value
		total_luminance += pigment.get_rgb_relative_luminance(color)
	end

	local average_luminance = total_luminance / num_keypoints

	return pigment.is_color_dark(average_luminance)
end

function pigment.get_brightest_color_in_color_sequence(color_sequence: ColorSequence)
	local keypoints = color_sequence.Keypoints
	local num_keypoints = #keypoints

	local most_luminance = 0
	local brightest_color = Color3.new()

	for index = 1, num_keypoints do
		local color = keypoints[index].Value
		local luminance = pigment.get_rgb_relative_luminance(color)
		if luminance > most_luminance then
			brightest_color = color
		end
	end

	return brightest_color
end

function pigment.evaluate_color_sequence(color_sequence: ColorSequence, elapsed_time: number)
	local keypoints = color_sequence.Keypoints
	local num_keypoints = #keypoints

	local color = Color3.new()

	if elapsed_time == 0 then
		color = keypoints[1].Value
	elseif elapsed_time == 1 then
		color = keypoints[num_keypoints].Value
	end

	for index = 1, num_keypoints - 1 do
		local current_keypoint = keypoints[index]
		local next_keypoint = keypoints[index + 1]

		if elapsed_time >= current_keypoint.Time and elapsed_time <= next_keypoint.Time then
			local alpha = (elapsed_time - current_keypoint.Time) / (next_keypoint.Time - current_keypoint.Time)
			color = current_keypoint.Value:Lerp(next_keypoint.Value, alpha)
		end
	end

	return color
end

return pigment
