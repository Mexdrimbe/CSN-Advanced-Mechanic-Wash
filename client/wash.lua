local washingPed = nil
local isWashing = false
local disableDriving = false 

function washVehicle(location)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or isWashing then
        TriggerEvent("chat:addMessage", { color = {255, 0, 0}, multiline = true, args = {"WASH", "You must be in a vehicle to wash it!"}})
        return
    end

    SetEntityCoords(vehicle, config.PlayerWashPosition.x, config.PlayerWashPosition.y, config.PlayerWashPosition.z)
    SetEntityHeading(vehicle, config.PlayerWashPosition.w)
    SetPedIntoVehicle(playerPed, vehicle, -1)

    isWashing = true
    disableDriving = true

    TriggerEvent("chat:addMessage", { color = {0, 255, 0}, multiline = true, args = {"WASH", "Starting vehicle wash... Please wait."}})
    if config.PlayWashSound then
        local soundId = GetSoundId()
        PlaySoundFrontend(soundId, config.WashStartSoundName, config.WashSoundSet, true)
        ReleaseSoundId(soundId)
    end

    local washCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(washCam, config.CamCoords.x, config.CamCoords.y, config.CamCoords.z)
    SetCamRot(washCam, 0.0, 0.0, config.CamHeading, 2)
    SetCamFov(washCam, config.CamFOV)
    SetCamActive(washCam, true)
    RenderScriptCams(true, false, 0, true, true)

    local pedModel = GetHashKey(config.PedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(0)
    end

    washingPed = CreatePed(4, pedModel, config.PedStartPosition.x, config.PedStartPosition.y, config.PedStartPosition.z, config.PedStartPosition.w, true, true)
    
    TaskGoToCoordAnyMeans(washingPed, config.PedEndPosition.x, config.PedEndPosition.y, config.PedEndPosition.z, 1.0, 0, 0, 786603, 0xbf800000)

    Citizen.CreateThread(function()
        
        while #(GetEntityCoords(washingPed) - vector3(config.PedEndPosition.x, config.PedEndPosition.y, config.PedEndPosition.z)) > 1.5 do
            Citizen.Wait(0)
        end

        Citizen.Wait(1000)

        SetCamCoord(washCam, config.WashCamCoords.x, config.WashCamCoords.y, config.WashCamCoords.z)
        SetCamRot(washCam, 0.0, 0.0, config.WashCamHeading, 2)
        SetCamFov(washCam, config.WashCamFOV)
        RenderScriptCams(true, false, 0, true, true)

        if config.debugs then print("Starting washing animation...") end
        RequestAnimDict(config.AnimDict)
        while not HasAnimDictLoaded(config.AnimDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(washingPed, config.AnimDict, config.AnimName, 8.0, -8.0, config.WashDuration, 1, 0, false, false, false)

        Citizen.Wait(config.WashDuration)

        ClearPedTasksImmediately(washingPed)

        TriggerEvent("chat:addMessage", { color = {0, 255, 0}, multiline = true, args = {"WASH", "You have cleaned the car."}})
        SetVehicleDirtLevel(vehicle, 0.0)

        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent("vehicleWash:syncWash", vehicleNetId)

        DeleteEntity(washingPed)
        washingPed = nil
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(washCam, false)

        if config.debugs then print("Wash completed!") end
        isWashing = false
        disableDriving = false 
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disableDriving then
            DisableControlAction(0, 71, true) -- Acceleration
            DisableControlAction(0, 72, true) -- Brake
            DisableControlAction(0, 59, true) -- Steering left-right
            DisableControlAction(0, 60, true) -- Steering left-right
            DisableControlAction(0, 63, true) -- Left
            DisableControlAction(0, 64, true) -- Right            
        end
    end
end)

RegisterNetEvent('vehicle:clean')
AddEventHandler('vehicle:clean', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        SetVehicleDirtLevel(vehicle, 0.0)
        TriggerEvent("chat:addMessage", { color = { 0, 255, 0 }, multiline = true, args = { "VEHICLE", "The vehicle has been cleaned." } })
    else
        TriggerEvent("chat:addMessage", { color = { 255, 0, 0 }, multiline = true, args = { "VEHICLE", "You must be in a vehicle to clean it!" } })
    end
end)

RegisterNetEvent('vehicle:dirt')
AddEventHandler('vehicle:dirt', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        SetVehicleDirtLevel(vehicle, 15.0)
        TriggerEvent("chat:addMessage", { color = { 255, 0, 0 }, multiline = true, args = { "VEHICLE", "The vehicle has been dirtied." } })
    else
        TriggerEvent("chat:addMessage", { color = { 255, 0, 0 }, multiline = true, args = { "VEHICLE", "You must be in a vehicle to dirty it!" } })
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, location in ipairs(config.WashLocations) do
            if #(playerCoords - location.coords) < 5.0 and not isWashing then
                DrawText3D(location.coords.x, location.coords.y, location.coords.z + 1.0, "[E] - Wash Vehicle")
                if IsControlJustPressed(0, 38) then -- 38 is the 'E'-button
                    washVehicle(location)
                end
            end
        end
    end
end)

-- function to add the 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local dist = #(GetGameplayCamCoords() - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
    end
end
