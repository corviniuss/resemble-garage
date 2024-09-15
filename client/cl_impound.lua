if not Config.Impound then return end

local ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    for k,v in pairs(Config.Garages) do
        if v.Impound then
            local npc = exports[Config.Dialogue]:CreateNPC({
                npc = v.Ped,
                coords = vector4(v.Pedcoords[1], v.Pedcoords[2], v.Pedcoords[3]-1, v.Pedcoords[4]),
                name = v.Pedname,
                animName = 'mini@strip_club@idles@bouncer@base',
                animDist = 'base',
                tag = k,
                color = 'indigo. 9',
                startMSG = TranslateCap('impound_message'),
            }, {
                [1] = {
                    label = TranslateCap('impound_menu'),
                    action = function()
                        local vehicles = {}
                        ESX.TriggerServerCallback('impound:server:getVehicles', function(result)
                            local vehicles = {}
                            if result then 
                                for x,y in pairs(result) do
                                    local model = GetDisplayNameFromVehicleModel(y.model)
                                    vehicles[x] = {
                                        label = model..' - '..y.plate,
                                        action = function()
                                            exports[Config.Dialogue]:changeDialog(TranslateCap('impound_yes_no', Config.ImpoundPrice, model), {
                                                [1] = {
                                                    label = TranslateCap('yes_option'),
                                                    action = function()
                                                        ESX.TriggerServerCallback('impound:server:payImpound', function(result)
                                                            if result then
                                                                TriggerEvent('impound:client:freeVehicle', k, y.plate, y.model)
                                                                exports[Config.Dialogue]:changeDialog(TranslateCap('impound_free'), {})
                                                            else
                                                                exports[Config.Dialogue]:changeDialog(TranslateCap('impound_no_money'), {})
                                                            end
                                                        end, Config.ImpoundPrice)
                                                    end
                                                },
                                                [2] = {
                                                    label = TranslateCap('no_option'),
                                                    action = function()
                                                        exports[Config.Dialogue]:changeDialog(TranslateCap('impound_timewaste'), {})
                                                    end
                                                }
                                            })
                                        end
                                    }
                                    exports[Config.Dialogue]:changeDialog(TranslateCap('impound_vehicle_menu'), vehicles)
                                end
                            else
                                exports[Config.Dialogue]:changeDialog(TranslateCap('impound_no_vehicles'), {})
                            end
                        end)
                    end
                },
                [2] = {
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
                [3] = {
                    label = TranslateCap('goodbye_option', v.Pedname),
                    action = function()
                        exports[Config.Dialogue]:changeDialog(TranslateCap('impound_goodbye_message'), {})
                    end
                }
            })
        end
    end
end)

RegisterNetEvent('impound:client:freeVehicle')
AddEventHandler('impound:client:freeVehicle', function(garageName, garagePlate, garageVehicle)
    TriggerServerEvent('garage:server:updateStatus', garageName, garagePlate, 1)
end)