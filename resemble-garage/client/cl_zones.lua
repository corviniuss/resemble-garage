CreateThread(function()
    for k,v in pairs(Config.Garages) do
        for i=1, #v.Parking do
            local coords = v.Parking[i]
            lib.zones.box({
                name =  k .. ' Parking'.. i,
                coords = vec3(coords.x, coords.y, coords.z),
                size = vec3(2, 2, 4),
                debug = false,
                inside = inside,
                onEnter = onEnter,
                onExit = onExit
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.JobGarages) do
        for i=1, #v.Parking do
            local coords = v.Parking[i]
            lib.zones.box({
                name =  k .. ' Parking'.. i,
                coords = vec3(coords.x, coords.y, coords.z),
                size = vec3(2, 2, 2),
                debug = false,
                inside = inside,
                onEnter = onEnter,
                onExit = onExit
            })
        end
    end
end)

function inside(self)
    for k,v in pairs(Config.Garages) do
        if string.find(self.name, k .. ' Parking') and IsPedInAnyVehicle(PlayerPedId()) then
            if IsControlJustPressed(1, 38) then
                local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
                TriggerServerEvent('garage:server:checkOwner', plate, k)
                lib.hideTextUI()
            end
        end
    end
    for k,v in pairs(Config.JobGarages) do
        if string.find(self.name, k .. ' Parking') and IsPedInAnyVehicle(PlayerPedId()) and ESX.GetPlayerData().job.name == v.Job then
            if IsControlJustPressed(1, 38) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                TriggerEvent('garage:client:delteVehicle', vehicle)
                lib.hideTextUI()
            end
        end
    end
end

function onEnter(self)
    for k,v in pairs(Config.Garages) do
        if string.find(self.name, k .. ' Parking') and IsPedInAnyVehicle(PlayerPedId()) then
            lib.showTextUI('[E] '..TranslateCap('park_vehicle'))
        end
    end
    for k,v in pairs(Config.JobGarages) do
        if string.find(self.name, k .. ' Parking') and IsPedInAnyVehicle(PlayerPedId()) and ESX.GetPlayerData().job.name == v.Job then
            lib.showTextUI('[E] '..TranslateCap('park_vehicle'))
        end
    end
end
 
function onExit(self)
    for k,v in pairs(Config.Garages) do
        if string.find(self.name, k .. ' Parking') and IsPedInAnyVehicle(PlayerPedId()) then
            lib.hideTextUI()
        end
    end
    for k,v in pairs(Config.JobGarages) do
        if string.find(self.name, k .. ' Parking') and IsPedInAnyVehicle(PlayerPedId()) and ESX.GetPlayerData().job.name == v.Job then
            lib.hideTextUI()
        end
    end
end