`Muted Volume` is a `Volume` value that Sound2 considers deafened or muted. Changing this is useful when you want the sound to not be muted fully.
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
    SoundId = "rbxassetid://9112854440",
    MutedVolume = .5
})

BGMusic:Play()

task.delay(15, Explode)
MySound:Play()
```
In this case when the explosion happens volume of background music will decrease to .5