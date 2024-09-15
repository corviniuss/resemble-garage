local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('garage:server:getVehicles', function(source, cb, garageName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        local vehicles = {}
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND parking = @parking and stored = @stored', {
            ['@owner'] = xPlayer.identifier,
            ['@parking'] = garageName,
            ['@stored'] = 1
        }, function(result)
            if result[1] ~= nil then
                for k,v in pairs(result) do
                    local vehicle = json.decode(v.vehicle)
                    table.insert(vehicles, {
                        plate = v.plate,
                        model = vehicle.model,
                        parking = v.parking
                    })
                end
                cb(vehicles)
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end)

RegisterNetEvent('garage:server:updateStatus') 
AddEventHandler('garage:server:updateStatus', function(garage, plate, status)
    MySQL.Async.execute('UPDATE owned_vehicles SET stored = @stored, parking = @parking WHERE plate = @plate', {
        ['@plate'] = plate,
        ['@stored'] = status,
        ['@parking'] = garage
    })
end)

RegisterNetEvent('garage:server:checkOwner')
AddEventHandler('garage:server:checkOwner', function(plate, garage)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = xPlayer.identifier,
        ['@plate'] = plate
    }, function(result)
        if result[1] ~= nil and result[1].plate == plate then
            TriggerClientEvent('garage:client:parkVehicle', src, plate, garage)
            TriggerClientEvent('garage:client:notify', src, TranslateCap('title'), TranslateCap('inserted', garage), 'success')
        else
            TriggerClientEvent('garage:client:notify', src, TranslateCap('title'), TranslateCap('not_own'), 'error')
        end
    end)
end)