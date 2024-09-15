function GetAvailableVehicleSpawnPoint(SpawnCoords)
	local found, foundSpawnPoint = false, nil
    
	for i = 1, #SpawnCoords, 1 do
		if IsSpawnPointClear(vector3(SpawnCoords[i].x, SpawnCoords[i].y, SpawnCoords[i].z), 2.5) then
			found, foundSpawnPoint = true, SpawnCoords[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		return false
	end
end

IsSpawnPointClear = function(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

GetVehiclesInArea = function(coords, area)
	local vehicles       = GetGamePool("CVehicle")
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end