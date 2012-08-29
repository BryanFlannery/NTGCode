// Last maps

local locationFilepath = "LastMaps/tracker.txt"

function mapTrackerLoad() -- Checks file existence on map load if not existent creates it
	if !file.Exists(locationFilepath) then 
		print("File not found: "..locationFilepath)
		print("Attempting to create: "..locationFilepath)
		if mapDataCreate() then
			print("File created successfully!")
			lastMapsInit()
		else
			print("File creation failed: Please check locationFilepath!")
		end
	else
		lastMapsInit()
	end
end
hook.Add( "InitPostEntity", "mapsInit", mapTrackerLoad)

function mapDataCreate() -- creates file if needed
	file.Write(locationFilepath, "null\nnull\nnull\nnull\nnull")
	if file.Exists(locationFilepath) then
		return true
	else
		return false
	end
end

function lastMapsInit()
	local textData = file.Read(locationFilepath)
	if textData == nil then return end
	local newDataWrite = string.Explode("\n", textData)
	newDataWrite[1] = newDataWrite[2]
	newDataWrite[2] = newDataWrite[3]
	newDataWrite[3] = newDataWrite[4]
	newDataWrite[4] = newDataWrite[5]
	newDataWrite[5] = game.GetMap()
	file.Write(locationFilepath, table.concat(newDataWrite, "\n"))
	SetGlobalString( "lastThreeMaps", table.concat(newDataWrite, " "))
end
	