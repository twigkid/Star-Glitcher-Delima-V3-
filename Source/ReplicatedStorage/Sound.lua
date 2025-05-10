local sound = {}

function sound.NewSoundEffect(SoundID: number, Volume: number, Pitch: number, DestroyOnFinish: boolean, Parent: Instance)
	local Sound = Instance.new("Sound", Parent)
	Sound.SoundId = "rbxassetid://"..SoundID
	Sound.Volume = Volume
	Sound.Pitch = Pitch
	
	Sound:Play()
	
	Sound.Ended:Once(function()
		Sound:Destroy()
		Sound = nil
	end)
	
	return Sound
end

function sound.NewDistanceSoundEffect(SoundID: number, Volume: number, Pitch: number, DestroyOnFinish: boolean, Parent: Instance, Distance: number)
	local Sound = Instance.new("Sound", Parent)
	Sound.SoundId = "rbxassetid://"..SoundID
	Sound.Volume = Volume
	Sound.Pitch = Pitch
	Sound.RollOffMaxDistance = Distance
	
	Sound:Play()
	
	Sound.Ended:Once(function()
		Sound:Destroy()
		Sound = nil
	end)
	
	return Sound
end

return sound