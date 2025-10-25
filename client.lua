local Framework = nil

-- Initialize Framework
Citizen.CreateThread(function()
    if Config.Framework == 'ESX' then
        Framework = exports['es_extended']:getSharedObject()
    elseif Config.Framework == 'QB' then
        Framework = exports[Config.QBCoreName]:GetCoreObject()
    end
end)

-- Function to set custom plate
RegisterNetEvent('customplate:setPlate')
AddEventHandler('customplate:setPlate', function(plateText)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        exports['okokNotify']:Alert('Custom Plate', Config.Locale['not_in_vehicle'], 5000, 'error')
        return
    end
    
    -- Format plate text (convert to uppercase and trim)
    plateText = string.upper(plateText)
    
    -- Set the plate
    SetVehicleNumberPlateText(vehicle, plateText)
    
    -- Sync across all clients
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('customplate:syncPlate', netId, plateText)
    
    exports['okokNotify']:Alert('Custom Plate', string.format(Config.Locale['plate_set'], plateText), 5000, 'success')
end)

-- Update plate from server sync
RegisterNetEvent('customplate:updatePlate')
AddEventHandler('customplate:updatePlate', function(netId, plate)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        SetVehicleNumberPlateText(vehicle, plate)
    end
end)

-- Export function to set plate programmatically
exports('SetCustomPlate', function(vehicle, plateText)
    if DoesEntityExist(vehicle) then
        plateText = string.upper(plateText)
        SetVehicleNumberPlateText(vehicle, plateText)
        return true
    end
    return false
end)
