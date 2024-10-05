        if config.UseCommands then

    RegisterCommand("repair", function(source, args, rawCommand)
        TriggerClientEvent('simple_repair:client:fix', source)
    end)
end


RegisterNetEvent("simple_repair:syncRepair")
AddEventHandler("simple_repair:syncRepair", function(vehicleNetId)
    TriggerClientEvent("simple_repair:repairVehicleSync", -1, vehicleNetId)
end)

RegisterNetEvent("simple_repair:syncWash")
AddEventHandler("simple_repair:syncWash", function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleDirtLevel(vehicle, 0.0)
    end
end)

config = config or {}

function IsPlayerAdmin(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if config.commandAdminLicenses then
            for _, license in ipairs(config.commandAdminLicenses) do
                if id == license then
                    return true
                end
            end
        end
    end
    return false
end

RegisterCommand('clean', function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        TriggerClientEvent('vehicle:clean', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = { 255, 0, 0 }, multiline = true, args = { "SYSTEM", "You do not have permission to use this command!" } })
    end
end, false)

RegisterCommand('dirt', function(source, args, rawCommand)
    if IsPlayerAdmin(source) then
        TriggerClientEvent('vehicle:dirt', source)
    else
        TriggerClientEvent('chat:addMessage', source, { color = { 255, 0, 0 }, multiline = true, args = { "SYSTEM", "You do not have permission to use this command!" } })
    end
end, false)

if config.debugMode then
    print("The script has been loaded, and admin control is enabled.")
end

