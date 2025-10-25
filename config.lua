Config = {}

-- Framework Selection (set to 'ESX' or 'QB')
Config.Framework = 'ESX'

-- Plate Configuration
Config.MinPlateLength = 1
Config.MaxPlateLength = 10

-- ESX Settings
Config.ESXTrigger = 'esx:getSharedObject' -- Change if your ESX trigger is different

-- QB-Core Settings
Config.QBCoreName = 'qb-core' -- Change if your QB-Core resource name is different

-- Locale
Config.Locale = {
    ['not_in_vehicle'] = 'You must be in a vehicle!',
    ['invalid_length'] = 'Plate must be between ' .. Config.MinPlateLength .. ' and ' .. Config.MaxPlateLength .. ' characters!',
    ['plate_set'] = 'Custom plate set to: %s',
    ['plate_saved'] = 'Plate saved successfully!',
    ['error_occurred'] = 'An error occurred!',
    ['no_permission'] = 'You don\'t have permission to use this command!',
}
