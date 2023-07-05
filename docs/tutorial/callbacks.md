Callbacks in Sound2 allow you to connect any `Roblox Sound Instance` events to your own function, without accessing the instance itself.
You can set callbacks via the built-in method of the `Sound2 Instance` itself.
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local MySound = Sound2.new({
    SoundId = "rbxassetid://9112854440",
    VolumeChangeType = Sound2.VolumeChangeType.Smooth
})
 
MySound:SetCallback("Ended", function()
    print("The sound has ended!")
end)

MySound:Play()
```
!!! note
    You can only bind one function to a certain event, if you will try to do it twice, the newest function will be called.
To remove a callback, use another built-in method:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local MySound = Sound2.new({
    SoundId = "rbxassetid://9112854440",
    VolumeChangeType = Sound2.VolumeChangeType.Smooth
})
 
MySound:SetCallback("Ended", function()
    print("The sound has ended!")
end)

MySound:Play()

MySound:RemoveCallback("Ended")
```