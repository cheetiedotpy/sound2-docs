`Sounds Dictionary` is a table, that can be used to not type in actual roblox sound id everytime you create a sound.
It is located inside global module settings, so we will be using a built-in static method to set it:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

Sound2.SetGlobalConfig({
	SoundsDictionary = {
		Rain = "rbxassetid://9112854440",
	}
})
```
From this moment, you can use the keyword "Rain" inside a sound id, and it will refer to the actual roblox asset id you specified:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

Sound2.SetGlobalConfig({
	SoundsDictionary = {
		Rain = "rbxassetid://9112854440",
	}
})

local MySound = Sound2.new({
    SoundId = "Rain",
})
 
MySound:Play()
```
!!! note
    You don't need to set the dictionary in every script, you can do it only once.