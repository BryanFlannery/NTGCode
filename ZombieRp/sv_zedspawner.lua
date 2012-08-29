	local locationFilepath = "ZombieSpawner/locations.txt"
	local zedLocations = {}
	
	function zedDataCreate() -- creates file if needed
		file.Write(locationFilepath, "")
		if file.Exists(locationFilepath) then
			return true
		else
			return false
		end
	end
	
	function file.AppendLinezed(filename, addme)
		data = file.Read(filename)
		if ( data ) then
			file.Write(filename, data .. "\n" .. tostring(addme))
		else
			file.Write(filename, tostring(addme))
		end
	end
	
	function zedLocationInit()
		zedLocations = {}
		local textData = file.Read(locationFilepath)
		print(textData)
		if textData == nil then return end
		local lines = string.Explode("\n", textData)
		for i = 1, #lines do
			local line = string.Explode(";", lines[i])
			local tempVector = Vector(line[1],line[2],line[3])
			table.insert( zedLocations, {tempVector} )
		end
	end
	
	function zedLocationLoad() -- Checks file existence on map load if not existent creates it
		if !file.Exists(locationFilepath) then 
			print("File not found: "..locationFilepath)
			print("Attempting to create: "..locationFilepath)
			if zedDataCreate() then
				print("File created successfully!")
			else
				print("File creation failed: Please check locationFilepath!")
			end
		else
			zedLocationInit()
			print("[OA] Severance Automatic Item Spawner Active")
			print("Created By Next Tier Gaming [Ludicium]")
		end
		zedSpawnLocationCycle()
	end
	hook.Add( "InitPostEntity", "zedLocationInit", zedLocationLoad) -- called when map loads
	
	function zedDataWipe( ply, commandName, args )
		if ply:IsSuperAdmin() then
			file.Write(locationFilepath, "")
			print("[OA]Item Spawner Location File was erased!")
		end
	end
	concommand.Add("zedspawner_location_file_wipe", zedDataWipe)
	
	function locationZedAdd( ply, commandName, args )
		if ply:IsSuperAdmin() then
			local entryVector = ply:GetShootPos()
			local entry = tostring(entryVector.x)..";"..tostring(entryVector.y)..";"..tostring(entryVector.z).."\n"
			file.Append(locationFilepath, entry)
			zedLocationInit()
			ply:PrintMessage( HUD_PRINTCONSOLE, "Added Location: "..tostring(entryVector.x)..","..tostring(entryVector.y)..","..tostring(entryVector.z)..".\n" )
		end
	end
	concommand.Add("zedspawner_location_add", locationZedAdd)
	
	 function zedSpawnEntCreate( location )
		local ent = ents.Create( "aura_spawner")
			ent:SetPos(location)
			ent:Spawn()
	end
	
	function zedSpawnLocationCycle()
		for i = 1, #zedLocations do
			zedSpawnEntCreate( zedLocations[i][1] )
		end
	end

	
	
	
	
	
	
	