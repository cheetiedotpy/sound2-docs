Let's smooth our transition between muting and unmuting a sound, so it won't be instant.
We will achieve that by setting some properties:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local MySound = Sound2.new({
    SoundId = "rbxassetid://9112854440",
    VolumeChangeType = Sound2.VolumeChangeType.Smooth
})
 
MySound:Play()
```
To set a time duration of the transition, we simply just set another property:
!!! note
    By the default, time is set to 0.25
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local MySound = Sound2.new({
    SoundId = "rbxassetid://9112854440",
    VolumeChangeType = Sound2.VolumeChangeType.Smooth,
    VolumeChangeTime = 2
})
 
MySound:Play()
```