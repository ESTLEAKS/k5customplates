local Framework = nil
local PlatesFile = 'plates.json'

-- Initialize Framework
if Config.Framework == 'ESX' then
    Framework = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QB' then
    Framework = exports[Config.QBCoreName]:GetCoreObject()
end

-- Load plates from JSON
local function LoadPlates()
    local file = LoadResourceFile(GetCurrentResourceName(), PlatesFile)
    if file then
        return json.decode(file) or {}
    end
    return {}
end

-- Save plates to JSON
local function SavePlates(plates)
    SaveResourceFile(GetCurrentResourceName(), PlatesFile, json.encode(plates, {indent = true}), -1)
end

-- Initialize plates table
local CustomPlates = LoadPlates()

-- Get player identifier based on framework
local function GetPlayerIdentifier(source)
    if Config.Framework == 'ESX' then
        local xPlayer = Framework.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier or nil
    elseif Config.Framework == 'QB' then
        local Player = Framework.Functions.GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    end
end

-- Command to set custom plate
RegisterCommand('customplate', function(source, args, rawCommand)
    local src = source
    
    if not args[1] then
        TriggerClientEvent('okokNotify:Alert', src, 'Custom Plate', 'Usage: /customplate [text]', 5000, 'error')
        return
    end
    
    local plateText = table.concat(args, ' ')
    
    -- Validate plate length
    if #plateText < Config.MinPlateLength or #plateText > Config.MaxPlateLength then
        TriggerClientEvent('okokNotify:Alert', src, 'Custom Plate', Config.Locale['invalid_length'], 5000, 'error')
        return
    end
    
    -- Get player identifier
    local identifier = GetPlayerIdentifier(src)
    if not identifier then
        TriggerClientEvent('okokNotify:Alert', src, 'Custom Plate', Config.Locale['error_occurred'], 5000, 'error')
        return
    end
    
    -- Set the plate on the vehicle
    TriggerClientEvent('customplate:setPlate', src, plateText)
    
    -- Save to JSON
    local vehicleData = {
        plate = plateText,
        owner = identifier,
        timestamp = os.time()
    }
    
    table.insert(CustomPlates, vehicleData)
    SavePlates(CustomPlates)
    
    TriggerClientEvent('okokNotify:Alert', src, 'Custom Plate', Config.Locale['plate_saved'], 5000, 'success')
end, false)

-- Export function to get all custom plates
exports('GetCustomPlates', function()
    return CustomPlates
end)

-- Event to sync plate across clients
RegisterNetEvent('customplate:syncPlate')
AddEventHandler('customplate:syncPlate', function(netId, plate)
    TriggerClientEvent('customplate:updatePlate', -1, netId, plate)
end)
