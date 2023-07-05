## Sound2 Module
### Sound2.VolumeChangeType
```lua
Sound2.VolumeChangeType = {Smooth = 1, Instant = 2}
```
A Table that represents VolumeChangeType Enum.
### Sound2.GetGlobalConfig()
```lua
Sound2.GetGlobalConfig() => {} : GlobalConfig
```
Returns a copy of the current global config.
### Sound2.SetGlobalConfig()
```lua
Sound2.SetGlobalConfig(Config : GlobalConfig) => void
```
Sets the current global config.
!!! note
    You don't need to specify all the properties of the config, works exactly the same like the properties table.
### Sound2.GetAllPlayingSounds()
```lua
Sound2.GetAllPlayingSounds() => {Sound2}
```
Returns a table with all the currently playing `Sound2` Objects.
## Sound2 Object
### Sound2:Play()
```lua
Sound2:Play() => void
```
Plays the current `Sound2` Object. Will not stop automatically if `Roblox Instance` is `.Looped`
### Sound2:Pause()
```lua
Sound2:Pause() => void
```
Pauses the current object if playing. Can only be resumed by `Sound2:Resume()`
!!! warning
    Using `:Play()` is used on a paused object will create a new `Roblox Sound Instance` Avoid using `:Play()` on paused objects!
### Sound2:Resume()
```lua
Sound2:Resume() => void
```
Resumes the `Sound2` Object if paused.
### Sound2:Stop()
```lua
Sound2:Stop() => void
```
Stops the current `Sound2` Object if playing.
### Sound2:SetCallback()
```lua
Sound2:SetCallback(EventName : string, Callback : () => void) => void
```
`:Connect()`'s the provided `callback function` with the `Roblox Sound Instance` event on creation.
### Sound2:RemoveCallback()
```lua
Sound2:RemoveCallback(EventName : string) => void
```
Unbinds the event from a function.
### Sound2:AdjustVolume()
```lua
Sound2:AdjustVolume(NewVolume : number) => void
```
Sets the `Sound2 Object`'s volume. Respects current `Sound2.VolumeChangeType`