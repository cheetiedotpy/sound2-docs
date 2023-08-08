type Sound2Config = {
	LoadingTimeout: number?,
	SoundRemovalDelay: number?,
	ParentObject: Instance?,
	SoundsDictionary: { [string]: string }?
}

type Sound2Properties = {
	SoundId: string?,
	Priority: number?,
	VolumeChangeType: number?,
	VolumeChangeTime: number?,
	Volume: number?,
	MuteOthers: boolean?,
	StartDelay: number?,
	MutedVolume: number?,
	Parent: Instance?,
}

type SoundProperties = {
	Archivable: boolean?;
	Name: string?;
	Parent: Instance?;
	PlayOnRemove: boolean?;
	RollOffMaxDistance: number?;
	RollOffMinDistance: number?;
	RollOffMode: Enum.RollOffMode?;
	Looped: boolean?;
	PlaybackRegionsEnabled: boolean?;
	PlaybackSpeed: number?;
	Playing: boolean?;
	TimePosition: number?;
	SoundGroup: SoundGroup?;
}

type Sound2 = {
	-- You need to list all the Sound2Properties fields
	SoundId: string?,
	Priority: number?,
	VolumeChangeType: number?,
	VolumeChangeTime: number?,
	Volume: number?,
	MuteOthers: boolean?,
	StartDelay: number?,
	MutedVolume: number?,
	Parent: Instance?,

	Play: (self: Sound2, WaitForLoading: boolean?) -> nil;
	Pause: (self: Sound2) -> nil;
	Resume: (self: Sound2) -> nil;
	Stop: (self: Sound2) -> nil;
	SetCallback: (self: Sound2, name: string, callback: () -> nil) -> nil;
	RemoveCallback: (self: Sound2, name: string) -> nil;
	AdjustVolume: (self: Sound2, newVolume: number) -> nil;
}

local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local VolumeChangeType: {
	Smooth: number;
	Instant: number;
} = {
	Smooth = 1,
	Instant = 2
}

local CurrentSounds = {}

local DefaultProps = {
	SoundId = "rbxassetid://0",
	Priority = 1,
	VolumeChangeType = VolumeChangeType.Smooth,
	VolumeChangeTime = .25,
	Volume = .5,
	MuteOthers = false,
	StartDelay = 0,
	MutedVolume = 0,
	Parent = "nan",
}

local GlobalConfig = {
	LoadingTimeout = 10,
	SoundRemovalDelay = 1,
	ParentObject = SoundService,
	SoundsDictionary = {}
}

local Sound2 = {}
Sound2.__index = Sound2
Sound2.VolumeChangeType = VolumeChangeType

function UpdateAll()
	for i,v in pairs(CurrentSounds) do
		v:__UPDATE()
	end
end

function Sound2.new(Sound2Props: Sound2Properties?, SoundProps: SoundProperties?): Sound2
	local self = setmetatable({}, Sound2)
	return self:Constructor(Sound2Props, SoundProps) or self
end

function Sound2.GetGlobalConfig(): Sound2Config
	return table.clone(GlobalConfig)
end

function Sound2.SetGlobalConfig(NewGlobalConfig: Sound2Config)
	for i,v in pairs(GlobalConfig) do
		GlobalConfig[i] = NewGlobalConfig[i] or v
	end
end

function Sound2.GetAllPlayingSounds(): { Sound2 }
	return CurrentSounds
end

function Sound2:Constructor(Sound2Props: Sound2Properties?, SoundProps: SoundProperties?)
	Sound2Props = Sound2Props or {}

	for i,v in pairs(DefaultProps) do
		self[i] = Sound2Props[i] or v
	end

	self.SoundProps = SoundProps or {}
	self.Callbacks = {}
end

function Sound2:Play(WaitForLoading: boolean)
	local NewSound = Instance.new("Sound") do
		NewSound.Name = self.SoundId
		NewSound.SoundId = GlobalConfig.SoundsDictionary and GlobalConfig.SoundsDictionary[self.SoundId] or self.SoundId
		NewSound.Parent = typeof(self.Parent) == "Instance" and self.Parent or GlobalConfig.ParentObject
		NewSound.Volume = self.Volume

		for i,v in pairs(self.SoundProps) do
			if self[i] then
				continue
			end

			NewSound[i] = v
		end
	end

	local IsLoaded
	if not NewSound.IsLoaded and WaitForLoading then
		task.delay(GlobalConfig.LoadingTimeout, function()
			if IsLoaded then
				return
			end

			Debris:AddItem(NewSound, GlobalConfig.SoundRemovalDelay)
			warn("Dropping sound request for "..self.SoundId.." (Timeout)")
		end)

		NewSound.Loaded:Wait()
		IsLoaded = true
	end

	if not NewSound then
		return
	end

	for i,v in pairs(self.Callbacks) do
		local Event = NewSound[i]

		if not Event then
			error("Attempted to bind unexisting event "..i.." for callback")
		end

		Event:Connect(v)
	end


	NewSound.Ended:Connect(function()
		local Index = table.find(CurrentSounds, self)
		if Index then
			table.remove(CurrentSounds, Index)
			UpdateAll()
		end

		Debris:AddItem(NewSound, GlobalConfig.SoundRemovalDelay)
	end)

	table.insert(CurrentSounds, self)
	UpdateAll()

	if self.StartDelay > 0 then
		task.delay(self.StartDelay, NewSound.Play, NewSound)
	else
		NewSound:Play()
	end

	self.Instance = NewSound
end

function Sound2:Pause()
	if not self.Instance then
		return
	end
	
	if not self.Instance.IsPlaying then
		return
	end

	self.Instance:Pause()

	local Index = table.find(CurrentSounds, self)
	if Index then
		table.remove(CurrentSounds, Index)
		UpdateAll()
	end
end

function Sound2:Resume()
	if not self.Instance then
		return
	end
	
	if not self.Instance.IsPaused then
		return
	end

	self:__UPDATE()

	self.Instance:Resume()
	table.insert(CurrentSounds, self)
end

function Sound2:Stop()
	if not self.Instance then
		return
	end
	
	if not self.Instance.IsPlaying then
		return
	end

	self.Instance:Stop()
	Debris:AddItem(self.Instance, GlobalConfig.SoundRemovalDelay)

	local Index = table.find(CurrentSounds, self)
	if Index then
		table.remove(CurrentSounds, Index)
		UpdateAll()
	end
end

function Sound2:SetCallback(Name: string, Callback: () -> nil)
	self.Callbacks[Name] = Callback
end

function Sound2:RemoveCallback(Name: string)
	self.Callbacks[Name] = nil
end

function Sound2:AdjustVolume(NewVolume: number)
	if self.VolumeChangeType == VolumeChangeType.Smooth then
		local NumberValue = Instance.new("NumberValue")
		NumberValue.Value = self.Volume
		NumberValue.Parent = script

		NumberValue.Changed:Connect(function(NewValue)
			if not NumberValue then
				return
			end

			self.Volume = NewValue
			self:__UPDATE(true)
		end)

		local Tween = TweenService:Create(NumberValue, TweenInfo.new(self.VolumeChangeTime), {
			Value = NewVolume
		})

		Tween:Play()

		Tween.Completed:Connect(function()
			NumberValue:Destroy()
		end)
	elseif self.VolumeChangeType == VolumeChangeType.Instant then
		self.Volume = NewVolume
		self:__UPDATE(true)
	end
end

function Sound2:__ADJUST_REAL_VOLUME(SkipTween: boolean)
	local SoundInstance = self.Instance

	if self.VolumeChangeType == VolumeChangeType.Smooth then
		if SkipTween then
			SoundInstance.Volume = self.__REAL_VOLUME
			return
		end

		TweenService:Create(SoundInstance, TweenInfo.new(self.VolumeChangeTime), {
			Volume = self.__REAL_VOLUME
		}):Play()
	elseif self.VolumeChangeType == VolumeChangeType.Instant then
		SoundInstance.Volume = self.__REAL_VOLUME
	end
end

function Sound2:__UPDATE(SkipTween: boolean)
	if not self.Instance then
		return
	end

	self.__REAL_VOLUME = self.Volume
	for i,v in pairs(CurrentSounds) do
		if v == self then
			continue
		end

		if v.Priority > self.Priority and v.MuteOthers then
			self.__REAL_VOLUME = self.MutedVolume
			break
		end
	end

	self:__ADJUST_REAL_VOLUME(SkipTween)
end

return {
	new = Sound2.new;
	VolumeChangeType = VolumeChangeType;
	GetGlobalConfig = Sound2.GetGlobalConfig;
	SetGlobalConfig = Sound2.SetGlobalConfig;
	GetAllPlayingSounds = Sound2.GetAllPlayingSounds;
}