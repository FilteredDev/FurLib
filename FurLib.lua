--FurLib2 - A complete rewrite of FurLib that changes how libraries work, now you dont have to use Invoke, extensions are now also automatically registered
--Extensions also work the same way
--Registering also automatically starts modules, but you can defer loading by using the ModuleLoaded event

local FurLib = {}

FurLib.__index = FurLib

local eTable = {
	ExtensionLoadedEvent = "ExtensionLoaded",
	ExtensionLoadFailedEvent = "ExtensionFailedToLoad",
	LibraryLoadedEvent = "LibraryLoaded",
	LibraryLoadFailedEvent = "LibraryFailedToLoad",
	VariableChangedEvent = "VariableChanged"
}

local StoreValues = {}
local function CreateStoreValue(proxy, name, value)
	local StoreValue = StoreValues[proxy]
	if not StoreValue then
		StoreValue = {}
		StoreValues[proxy] = StoreValue
	end
	
	StoreValue[name] = value
end

local function GetStoreValues(proxy, name)
	local StoreValue = StoreValues[proxy]
	if not StoreValue then return nil end
	return StoreValue[name]
end

local function MakeEvents(self, eventTable)
	for name, event in pairs(eventTable) do
		local e = Instance.new("BindableEvent")
		eventTable[event] = e.Event
		CreateStoreValue(self, name, e)
	end
end

local function RegisterExtension(obj, moduleSrc)
	local module = require(moduleSrc)
	
	local Extensions = GetStoreValues(obj, "Extensions")
	local LoadedEvent = GetStoreValues(obj, "ExtensionLoadedEvent")
	local FailedEvent = GetStoreValues(obj, "ExtensionLoadFailedEvent")
	
	local ID = module.ID
	assert(not Extensions[ID], ID .. " already registered, please use unique names")
	
	local newLibraryTable = setmetatable({}, {__index = module})
	newLibraryTable.State = "NotStartedYet"
	Extensions[ID] = newLibraryTable
	
	coroutine.wrap(function()
		local s, e = pcall(newLibraryTable.start, newLibraryTable, obj)
		if s then
			newLibraryTable.State = "Running"
			LoadedEvent:Fire(ID)
		else
			newLibraryTable.State = "Failed"
			FailedEvent.ExtensionLoadedFailEvent:Fire(ID, e)
		end
	end)()
end

function FurLib:RegisterLibrary(moduleSrc)
	local module = require(moduleSrc)
	
	local Libraries = GetStoreValues(self, "Libraries")
	local LoadedEvent = GetStoreValues(self, "LibraryLoadedEvent")
	local FailedEvent = GetStoreValues(self, "LibraryLoadFailedEvent")
	
	local ID = module.ID
	assert(not Libraries[ID], ID .. " already registered, please use unique names")

	local newLibraryTable = setmetatable({}, {__index = module})
	newLibraryTable.State = "NotStartedYet"
	Libraries[ID] = newLibraryTable

	coroutine.wrap(function()
		local s, e = pcall(newLibraryTable.start, newLibraryTable, self)
		if s then
			newLibraryTable.State = "Running"
			LoadedEvent:Fire(ID)
		else
			newLibraryTable.State = "Failed"
			FailedEvent:Fire(ID, e)
		end
	end)()
end

function FurLib:WaitForExtension(n)
	local Extensions = GetStoreValues(self, "Extensions")
	
	local ext = Extensions[n]
	if ext and ext.State == "Running" then
		return Extensions[n]
	end
	
	local interupt = Instance.new("BindableEvent")
	self.ExtensionLoaded:Connect(function(id)
		if id == n then
			interupt:Fire(Extensions[n])
		end
	end)
	
	return interupt:Wait()
end

function FurLib:WaitForLibrary(n)
	local Libraries = GetStoreValues(self, "Libraries")
	
	local lib = Libraries[n]
	if lib and lib.State == "Running" then
		return Libraries[n]
	end

	local interupt = Instance.new("BindableEvent")
	
	self.LibraryLoaded:Connect(function(id)
		if id == n then
			interupt:Fire(Libraries[n])
		end
	end)

	return interupt:Wait()
end

function FurLib:GetLibrary(n)
	return GetStoreValues(self, "Libraries")[n]
end

function FurLib:GetExtension(n)
	return GetStoreValues(self, "Extensions")[n]
end

function FurLib:SetVariable(n, v)
	GetStoreValues(self, "Variables")[n] = v
	GetStoreValues(self, "VariableChangedEvent"):Fire(n,v)
end

function FurLib:GetVariable(n)
	return GetStoreValues(self, "Variables")[n]
end

local FurLibModule = {}

function FurLibModule.new()
	local storage = setmetatable({}, FurLib)
	
	CreateStoreValue(storage, "Libraries", {})
	CreateStoreValue(storage, "Extensions", {})
	CreateStoreValue(storage, "Variables", {})
	
	MakeEvents(storage, eTable)
	
	for _, v in ipairs(script.Extensions:GetChildren()) do
		RegisterExtension(storage, v)
	end
	
	return storage
end

return FurLibModule
