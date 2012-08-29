--[[
	[OA]Severance Automatic Item Spawner
	Revision: 0.0
	Author: Next Tier Gaming [Ludicium] bryan.flannery@gmail.com
	Purpose: Spawns Random Items in severance via a text file of coordinates
]]--

if (SERVER) then

	local locationFilepath = "ItemSpawner/locations.txt"
	local isLocations = {}
	local x = 20
	
	// {"<item>", <rarity value>} everything on list has 1 in 60 chance of being spawned each item has its own rarness 1 being most rare 20 being always spawns
	// 0 will make the item unable to spawn
	local possibleLewt = {
		{"ammo_357", 20},
		{"ammo_buckshot", 20},
		{"ammo_pistol", 20},
		{"ammo_smg1", 20},
		{"ammo_sniper", 20},
		{"ammo_xbowbolt", 20},
		{"aura_flaregrenade", 20},
		{"aura_flashgrenade", 20},
		{"aura_smokegrenade", 20},
		{"backpack", 20},
		{"bandage", 20},
		{"beer", 20},
		{"bleach", 20},
		{"boxed_backpack", 20},
		{"boxed_bag", 20},
		{"boxed_jacket", 20},
		{"breach", 20},
		{"canned_beans", 20},
		{"ceda_uniform", 20},
		{"chinese_takeout", 20},
		{"clothes_base", 20},
		{"handheld_radio", 20},
		{"health_kit", 20},
		{"health_vial", 20},
		{"jacket", 20},
		{"melon", 20},
		{"milk_carton", 20},
		{"milk_jug", 20},
		{"small_bag", 20},
		{"spray_can", 20},
		{"stationary_radio", 20},
		{"storage_jacket", 20},
		{"vegetable_oil", 20},
		{"weapon_ak47", 20},
		{"weapon_awp", 20},
		{"weapon_baseball_bat", 20},
		{"weapon_deagle", 20},
		{"weapon_famas", 20},
		{"weapon_fiveseven", 20},
		{"weapon_g3sg1", 20},
		{"weapon_galil", 20},
		{"weapon_glock", 20},
		{"weapon_m3super920", 20},
		{"weapon_m4a1", 20},
		{"weapon_m249", 20},
		{"weapon_mac120", 20},
		{"weapon_mp5", 20},
		{"weapon_p920", 20},
		{"weapon_p228", 20},
		{"weapon_plank", 20},
		{"weapon_remington8720", 20},
		{"weapon_scout", 20},
		{"weapon_sg552", 20},
		{"weapon_shovel", 20},
		{"weapon_sledgehammer", 20},
		{"weapon_spas12", 20},
		{"weapon_ump45", 20},
		{"weapon_usp45", 20},
		{"weapon_woodaxe", 20},
		{"zip_tie", 20}
	}
	
	function locationDataCreate() -- creates file if needed
		file.Write(locationFilepath, "")
		if file.Exists(locationFilepath) then
			return true
		else
			return false
		end
	end
	
	function file.AppendLine(filename, addme)
		data = file.Read(filename)
		if ( data ) then
			file.Write(filename, data .. "\n" .. tostring(addme))
		else
			file.Write(filename, tostring(addme))
		end
	end
	
	function itemLocationInit()
		isLocations = {}
		local textData = file.Read(locationFilepath)
		local lines = string.Explode("\n", textData)
		for i = 1, #lines do
			local line = string.Explode(";", lines[i])
			local tempVector = Vector(line[1],line[2],line[3])
			table.insert( isLocations, {tempVector} )
			randomEntCreate( tempVector, #isLocations )
		end
		timerGeneration()
	end
	
	function mapLocationLoad() -- Checks file existence on map load if not existent creates it
		if !file.Exists(locationFilepath) then 
			print("File not found: "..locationFilepath)
			print("Attempting to create: "..locationFilepath)
			if locationDataCreate() then
				print("File created successfully!")
			else
				print("File creation failed: Please check locationFilepath!")
			end
		else
			itemLocationInit()
			print("[OA] Severance Automatic Item Spawner Active")
			print("Created By Next Tier Gaming [Ludicium]")
			timerGeneration()
		end
	end
	hook.Add( "InitPostEntity", "LocationInit", mapLocationLoad) -- called when map loads
	
	function locationDataWipe( ply, commandName, args )
		if ply:IsSuperAdmin() then
			file.Write(locationFilepath, "")
			print("[OA]Item Spawner Location File was erased!")
		end
	end
	concommand.Add("itemspawner_location_file_wipe", locationDataWipe)
	
	function locationItemAdd( ply, commandName, args )
		if ply:IsSuperAdmin() then
			local entryVector = ply:GetShootPos()
			local entry = tostring(entryVector.x)..";"..tostring(entryVector.y)..";"..tostring(entryVector.z).."\n"
			file.Append(locationFilepath, entry)
			itemLocationInit()
			ply:PrintMessage( HUD_PRINTCONSOLE, "Added Location: "..tostring(entryVector.x)..","..tostring(entryVector.y)..","..tostring(entryVector.z)..".\n")
		end
	end
	concommand.Add("itemspawner_location_add", locationItemAdd)
	
	function randomEntCreate( location, index )
		local selection = math.random( 1, #possibleLewt )
		local rarity = possibleLewt[selection][2]
		if (math.random(1,20) <= rarity) then
			isLocations[index][2] = ents.Create( "aura_item" )
				isLocations[index][2]:SetPos(location)	
				isLocations[index][2]:SetItem(possibleLewt[selection][1])
			isLocations[index][2]:Spawn()
		else
			randomEntCreate( location, index )
		end
	end
	
	function timerGeneration()
		print("Timer function")
		x = math.random(10, 11)
		timer.Adjust("randomItemSpawn", x, 1, function()
			for i = 1, #isLocations do
				if !isLocations[i][2]:IsValid() then
					randomEntCreate( isLocations[i][1], i )
				end
			end
			timerGeneration()
		end)
		timer.Start("randomItemSpawn")
	end

	function locationDebug( ply, commandName, args )
		PrintTable(isLocations)
	end
	concommand.Add("itemspawner_debug", locationDebug)
end