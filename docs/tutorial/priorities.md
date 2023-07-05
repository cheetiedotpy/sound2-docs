`Priority` is a property that allows us to control and mute other sounds, while current sound is playing.
For example, let's make an explosion that mutes our background music for more immersion.
We'll start off by creating an explosion sound:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

local Explosion = Sound2.new({
    Volume = 2,
    Priority = 2,
    MuteOthers = true,
    SoundId = "rbxassetid://9120020523"
})
```
As you can see, we have created a `Sound2 Object` with `priority` set to 2.
!!! note
    By default, every `Sound2 Object's` `priority` is set to 1
`Mute Others` is a property that deafens all the currently playing sounds with lower `Priority`.
They will automatically unmute again on completion of our explosion sound.
Let's make a background music sound and put our explosion sound inside a function:
```lua
local Sound2 = require(game.ReplicatedStorage.Sound2)

function Explode()
    local Explosion = Sound2.new({
        Volume = 2,
        Priority = 2,
        MuteOthers = true,
        SoundId = "rbxassetid://9120020523"
    })

    Explosion:Play()
end

local BGMusic = Sound2.new({
    SoundId = "rbxassetid://9112854440"
})

BGMusic:Play()

task.delay(15, Explode)
```
As we can see, after 15 seconds our music automatically mutes itself and the explosion sound plays.