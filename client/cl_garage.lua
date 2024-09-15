local ESX = exports['es_extended']:getSharedObject()

inZone = {}

RegisterNetEvent('garage:client:notify')
AddEventHandler('garage:client:notify', function(title, description, type)
    if Config.Notification == 'ox' then
        lib.notify({
            title = title,
            description = description,
            type = type
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification(description)
    end
end)

CreateThread(function()
    for k,v in pairs(Config.Garages) do
        if Config.Impound then
            if not v.Impound then

                local npc = exports[Config.Dialogue]:CreateNPC({
                    npc = v.Ped,
                    coords = vector4(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3]-1, v.Pedcoords[4]),
                    name = v.Pedname,
                    animName = 'mini@strip_club@idles@bouncer@base',
                    animDist = 'base',
                    tag = k,
                    color = 'indigo. 9',
                    startMSG = TranslateCap('menu_message', v.Pedname)
                }, {
                    [1] = {
                        label = TranslateCap('garage_menu'),
                        action = function()
                            ESX.TriggerServerCallback('garage:server:getVehicles', function(result)
                                local vehicles = {}
                                if result then 
                                    for x,y in pairs(result) do
                                        local model = GetDisplayNameFromVehicleModel(y.model)
                                        vehicles[x] = {
                                            label = model..' - '..y.plate,
                                            action = function()
                                                exports[Config.Dialogue]:changeDialog(TranslateCap('garage_spawn_vehicle'), {})
                                                TriggerEvent('garage:client:spawnVehicle', k, y.plate, y.model)
                                            end
                                        }
                                    end
                                    exports[Config.Dialogue]:changeDialog(TranslateCap('garage_message'), vehicles)
                                else
                                    exports[Config.Dialogue]:changeDialog(TranslateCap('garage_no_vehicles'), {})
                                end
                            end, k)
                        end
                    },
                    [2] = {
                        label = TranslateCap('goodbye_option', v.Pedname),
                        action = function()
                            exports[Config.Dialogue]:changeDialog(TranslateCap('goodbye_message'), {})
                        end
                    }
                })
            end
        else
            local npc = exports[Config.Dialogue]:CreateNPC({
                npc = v.Ped,
                coords = vector4(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3]-1, v.Pedcoords[4]),
                name = v.Pedname,
                animName = 'mini@strip_club@idles@bouncer@base',
                animDist = 'base',
                tag = k,
                color = 'indigo. 9',
                startMSG = TranslateCap('menu_message', v.Pedname)
            }, {
                [1] = {
                    label = TranslateCap('garage_menu'),
                    action = function()
                        ESX.TriggerServerCallback('garage:server:getVehicles', function(result)
                            local vehicles = {}
                            if result then 
                                for x,y in pairs(result) do
                                    local model = GetDisplayNameFromVehicleModel(y.model)
                                    vehicles[x] = {
                                        label = model..' - '..y.plate,
                                        action = function()
                                            exports[Config.Dialogue]:changeDialog(TranslateCap('garage_spawn_vehicle'), {})
                                            TriggerEvent('garage:client:spawnVehicle', k, y.plate, y.model)
                                        end
                                    }
                                end
                                exports[Config.Dialogue]:changeDialog(TranslateCap('garage_message'), vehicles)
                            else
                                exports[Config.Dialogue]:changeDialog(TranslateCap('garage_no_vehicles'), {})
                            end
                        end, k)
                    end
                },
                [2] = {
                    label = TranslateCap('goodbye_option', v.Pedname),
                    action = function()
                        exports[Config.Dialogue]:changeDialog(TranslateCap('goodbye_message'), {})
                    end
                }
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.JobGarages) do
        local npc = exports[Config.Dialogue]:CreateNPC({
            npc = v.Ped,
            coords = vector4(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3]-1, v.Pedcoords[4]),
            name = v.Pedname,
            animName = 'mini@strip_club@idles@bouncer@base',
            animDist = 'base',
            tag = k,
            color = 'indigo. 9',
            startMSG = TranslateCap('menu_message', v.Pedname)
        }, {
            [1] = {
                label = TranslateCap('garage_menu'),
                action = function()
                    if ESX.GetPlayerData().job.name == v.Job then
                        local vehicles = {}
                        for x,y in pairs(v.Vehicles) do
                            vehicles[x] = {
                                label = y.label,
                                action = function()
                                    exports[Config.Dialogue]:changeDialog(TranslateCap('garage_spawn_vehicle'), {})
                                    TriggerEvent('garage:client:spawnjobVehicle', k, y.model)
                                end
                            }
                            exports[Config.Dialogue]:changeDialog(TranslateCap('garage_message'), vehicles)
                        end
                    else
                        exports[Config.Dialogue]:changeDialog(TranslateCap('garage_no_permission'), {})
                    end
                end
            },
            [2] = {
                label = TranslateCap('goodbye_option', v.Pedname),
                action = function()
                    exports[Config.Dialogue]:changeDialog(TranslateCap('goodbye_message'), {})
                end
            }
        })
    end
end)

RegisterNetEvent('garage:client:spawnVehicle')
AddEventHandler('garage:client:spawnVehicle', function(garageName, garagePlate, garageVehicle)
    local available, spawnCoords = GetAvailableVehicleSpawnPoint(Config.Garages[garageName].Parking)

    if not available then
        spawnCoords = Config.Garages[garageName].Parking[1]
    end
    RequestModel(garageVehicle)
    while not HasModelLoaded(garageVehicle) do
        Wait(0)
    end

    local vehicle = CreateVehicle(garageVehicle, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, false, false)
    SetVehicleNumberPlateText(vehicle, garagePlate)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    --SetModelAsNoLongerNeeded(garageVehicle)
    if Config.SpawnInVehicle then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
    TriggerServerEvent('garage:server:updateStatus', garageName, garagePlate, 0)
end)

RegisterNetEvent('garage:client:spawnjobVehicle')
AddEventHandler('garage:client:spawnjobVehicle', function(garageName, garageVehicle)
    local available, spawnCoords = GetAvailableVehicleSpawnPoint(Config.JobGarages[garageName].Parking)

    if not available then
        spawnCoords = Config.JobGarages[garageName].Parking[1]
    end
    RequestModel(garageVehicle)
    while not HasModelLoaded(garageVehicle) do
        Wait(0)
    end

    local vehicle = CreateVehicle(garageVehicle, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, false, false)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(garageVehicle)
    if Config.SpawnInVehicle then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
end)

RegisterNetEvent('garage:client:parkVehicle')
AddEventHandler('garage:client:parkVehicle', function(plate, garage)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    DeleteEntity(vehicle)
    TriggerServerEvent('garage:server:updateStatus', garage, plate, 1)
end)

RegisterNetEvent('garage:client:delteVehicle')
AddEventHandler('garage:client:delteVehicle', function(vehicle)
    DeleteEntity(vehicle)
end)

CreateThread(function()
    if Config.Blip.Enable then
        for k, v in pairs(Config.Garages) do
            if Config.Impound then
                if not v.Impound then
                    local blip = AddBlipForCoord(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3])

                    SetBlipSprite(blip, Config.Blip.Sprite)
                    SetBlipScale(blip, Config.Blip.Scale)
                    SetBlipColour(blip, Config.Blip.Colour)
                    SetBlipDisplay(blip, Config.Blip.Display)
                    SetBlipAsShortRange(blip, true)

                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(Config.Blip.Text)
                    EndTextCommandSetBlipName(blip)
                else
                    local blip = AddBlipForCoord(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3])

                    SetBlipSprite(blip, Config.Blip.Sprite)
                    SetBlipScale(blip, Config.Blip.Scale)
                    SetBlipColour(blip, Config.Blip.Colour)
                    SetBlipDisplay(blip, Config.Blip.Display)
                    SetBlipAsShortRange(blip, true)

                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(Config.Blip.ImpoundText)
                    EndTextCommandSetBlipName(blip)
                end
            else
                local blip = AddBlipForCoord(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3])

                SetBlipSprite(blip, Config.Blip.Sprite)
                SetBlipScale(blip, Config.Blip.Scale)
                SetBlipColour(blip, Config.Blip.Colour)
                SetBlipDisplay(blip, Config.Blip.Display)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(Config.Blip.Text)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)