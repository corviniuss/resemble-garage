local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('impound:server:getVehicles', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        local vehicles = {}
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND stored = @stored', {
            ['@owner'] = xPlayer.identifier,
            ['@stored'] = 0
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

ESX.RegisterServerCallback('impound:server:payImpound', function(source, cb, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)