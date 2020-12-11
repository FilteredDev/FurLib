--FurLib Make Compiler, takes a Lua array and loads all modules as libraries, priority matters,

local flmk = {}
flmk.ID = "FLMake"

function flmk:start(fl)
	function self:GetAllExtensions()
		local r = {}
		for _, v in ipairs(script.Parent:GetChildren()) do
			local id = require(v).ID --we have to fetch the ID, so we'll load the module.
			r[id] = fl:WaitForExtension(id)
		end
		return r
	end
	
	function self:Compile(lmk)
		local rd = {}
		local intendedLibrariesToLoad = #lmk
		for _, v in ipairs(lmk) do 
			local id = require(v).ID --we have to fetch the ID, so we'll load the module before FurLib, this doesn't break any handling
			
			fl:RegisterLibrary(v)
			rd[id]=fl:WaitForLibrary(id)
		end
		
		return rd
	end
end

return flmk
