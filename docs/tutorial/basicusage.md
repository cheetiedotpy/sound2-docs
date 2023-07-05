First of all, let's import the module and create a `Sound2 object`:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local BGMusic = Sound2.new()

```
### .new() Constructor accepts 2 optional arguments:

   - Sound2 properties table
   - Roblox Instance properties table

If they arguments are not set at all, or the table lacks some arguments they will be set to default. (1)
This is the main rule you should remember: If you don't specify something in the properties table, it will be sent to default.

!!! note
    There is a set list of `Sound2 Object-Only` properties that can be seen in API. If you will try to put a `Sound2 Object-Only` property into the `Roblox Sound Object` properties table, It will be overwritten by the default `Sound2 Object` property.

Knowing that, we can create a new `Sound2 object` with specifying some properties we need.
For example, let's set the volume to 2, give it a Sound Id and play our sound:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local BGMusic = Sound2.new({
    Volume = 2,
    SoundId = "rbxassetid://9112854440"
})
 
BGMusic:Play()

```
Okay, great. If we play the game our sound plays once, but let's make it looped.
Looped is not a property of `Sound2 Object`, so we will need to provide it to a `Roblox Instance` via our second properties table:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local BGMusic = Sound2.new({
    Volume = 2,
    SoundId = "rbxassetid://9112854440"
}, {
    Looped = true
})
 
BGMusic:Play()
``` 
