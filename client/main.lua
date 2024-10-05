local disableDrivingAction = false 

function config.succedMessage()

         if config.playSuccesSound then
        local soundId = GetSoundId()
        PlaySoundFrontend(soundId, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)    
    end
end


function config.errorMessage()

        if config.playErrorSound then
        local soundId = GetSoundId()
        PlaySoundFrontend(soundId, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)  
        
    end
end

function config.debug()
    if not config.debugs then return end
    
    if config.debugs == "simple" then
        print("DEBUG: ", " loaded succesfully, current state: (good)")
    elseif config.debugs == "advanced" then
        print("DEBUG: ", " something got wrong here, please control this debug print and take a look at the problem, simple_repair/client/client.lua, current state: (ERROR)")
    else
        print("DEBUG: ", " Script returned succesfully, current state: (good)")
    end
end
      

RegisterNetEvent("simple_repair:client:fix", function()
config.debug()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped) 
    local model = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(model)

    if IsPedInAnyVehicle(ped, false) then
    SetVehicleDeformationFixed(vehicle)
    SetVehicleBodyHealth(vehicle, 999)
    SetVehicleEngineHealth(vehicle, 999)
    SetVehiclePetrolTankHealth(vehicle, 999)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0) 
    

    TriggerEvent("chat:addMessage", {
    
        color = {255, 0, 0},
        multiline = true,
        args = {"VEHICLE ", "Vehicle model (".. vehicleName .. ") was just repaired!"}
    
    })
    config.succedMessage()
    else

        TriggerEvent("chat:addMessage", {
        
            color = {255, 0, 0},
            multiline = true,
            args = {"VEHICLE ", " your'e not in any vehicle..."}
        
            })
        config.errorMessage()
       
    
    print("You need to be in a vehicle for this command.") 

    end
end)

local pedList = {}
local repairPed = nil
local isRepairing = false

function manuallyRepair()

    if config.UsemanuallyRepair then
        local pedModel = GetHashKey(config.pedmodel)
        local coords = config.repairCoords

        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end

        repairPed = CreatePed(4, pedModel, coords.x, coords.y, coords.z, 0.0, false, true)
        ResetPedAudioFlags(repairPed)
        SetPedKeepTask(repairPed, true)
        SetPedCanRagdoll(repairPed, false)
        SetPedCanRagdollFromPlayerImpact(repairPed, false)
        SetEntityInvincible(repairPed, true)
        SetBlockingOfNonTemporaryEvents(repairPed, true)
        
        SetPedCanBeTargetted(repairPed, false)
        SetPedCanBeKnockedOffVehicle(repairPed, false)
        SetEntityProofs(repairPed, true, true, true, true, true, true, true, true) 
        SetEntityCanBeDamaged(repairPed, false) 
        SetPedConfigFlag(repairPed, 17, true) 
        SetPedConfigFlag(repairPed, 301, true) 
        SetPedConfigFlag(repairPed, 2, true)
        

        SetEntityAsMissionEntity(repairPed, true, true)
        table.insert(pedList, repairPed)

        config.debug()
    else
        config.debug()
    end
end

manuallyRepair() 

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

function resetPed()
    ClearPedTasksImmediately(repairPed)
    Citizen.Wait(100) 

    TaskGoToCoordAnyMeans(repairPed, config.repairCoords.x, config.repairCoords.y, config.repairCoords.z, 1.0, 0, 0, 786603, 0xbf800000)
    Citizen.CreateThread(function()
        
        while #(GetEntityCoords(repairPed) - config.repairCoords) > 1.0 do
            Citizen.Wait(0)
        end

        TaskStartScenarioInPlace(repairPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end)
end

function startRepairSequence()
    disableDrivingAction = true

    if isRepairing then
        return
    end
    isRepairing = true

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        config.errorMessage()
        isRepairing = false
        return
    end

    RequestAnimDict(config.pedRepairAnimDict)
    while not HasAnimDictLoaded(config.pedRepairAnimDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(repairPed, config.pedRepairAnimDict, config.pedRepairAnimName, 8.0, -8.0, config.pedRepairStartDelay, 1, 0, false, false, false)
    Citizen.Wait(config.pedRepairStartDelay)

    local repairCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(repairCam, config.repairCameraCoords1.x, config.repairCameraCoords1.y, config.repairCameraCoords1.z)
    SetCamRot(repairCam, 0.0, 0.0, config.repairCameraHeading1, 2)
    SetCamFov(repairCam, config.repairCameraFOV1)
    SetCamActive(repairCam, true)
    RenderScriptCams(true, false, 0, true, true)

    TaskVehicleDriveToCoord(playerPed, vehicle, config.vehicleParkingCoords.x, config.vehicleParkingCoords.y, config.vehicleParkingCoords.z, 5.0, 0, GetEntityModel(vehicle), 16777216, 0.5, true)
    TaskGoToCoordAnyMeans(repairPed, config.pedWalkToCoords.x, config.pedWalkToCoords.y, config.pedWalkToCoords.z, 1.0, 0, 0, 786603, 0xbf800000)

    Citizen.CreateThread(function()

        while #(GetEntityCoords(repairPed) - config.pedWalkToCoords) > 1.0 or #(GetEntityCoords(vehicle) - config.vehicleParkingCoords) > 1.5 do
            Citizen.Wait(0)
        end

        TaskTurnPedToFaceEntity(repairPed, vehicle, 2000)
        Citizen.Wait(2000) 

        SetCamCoord(repairCam, config.repairCameraCoords2.x, config.repairCameraCoords2.y, config.repairCameraCoords2.z)
        SetCamRot(repairCam, 0.0, 0.0, config.repairCameraHeading2, 2)
        SetCamFov(repairCam, config.repairCameraFOV2)

        TriggerEvent("chat:addMessage", {
            color = {255, 255, 0},
            multiline = true,
            args = {"VEHICLE", "Starting repair..."}
        })

        SetVehicleDoorOpen(vehicle, 4, false, false)

        for _, anim in ipairs(config.pedAnimations) do
            RequestAnimDict(anim.animDict)
            while not HasAnimDictLoaded(anim.animDict) do
                Citizen.Wait(0)
            end
            TaskPlayAnim(repairPed, anim.animDict, anim.animName, 8.0, -8.0, anim.duration, 1, 0, false, false, false)
            Citizen.Wait(anim.duration) 
        end

        SetVehicleDoorShut(vehicle, 4, false)
        ClearPedTasksImmediately(repairPed)

        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(repairCam, false)

        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent("simple_repair:syncRepair", vehicleNetId)

        TaskVehicleDriveToCoord(playerPed, vehicle, config.vehicleExitCoords.x, config.vehicleExitCoords.y, config.vehicleExitCoords.z, 5.0, 0, GetEntityModel(vehicle), 16777216, 0.5, true)

        Citizen.CreateThread(function()
            while #(GetEntityCoords(vehicle) - config.vehicleExitCoords) > 1.5 do
                Citizen.Wait(0)
            end

            SetEntityCoords(vehicle, config.vehicleExitCoords.x, config.vehicleExitCoords.y, config.vehicleExitCoords.z, false, false, false, true)
            SetEntityHeading(vehicle, config.vehicleExitHeading)

            TriggerEvent("chat:addMessage", {
                color = {255, 0, 0},
                multiline = true,
                args = {"VEHICLE", "Repair completed! Drive safely!"}
            })

            config.succedMessage()
            isRepairing = false
            disableDrivingAction = false

            resetPed()
        end)
    end)
end



-- this function is only telling the player that "disableDrivingAction" is on, and that he/she can't move the vehicle while repair, can be changed in the config.lua (to disable the text)
function ShowRepairRestrictionText()
    
    if config.ShowRepairRestrictionText then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, "~r~(Under Repair) Driving Disabled") 
    end
end

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disableDrivingAction then
            -- Blockera kontrollerna
            DisableControlAction(0, 71, true) -- Acceleration
            DisableControlAction(0, 72, true) -- Brake
            DisableControlAction(0, 59, true) -- Steering left-right
            DisableControlAction(0, 60, true) -- Steering left-right
            DisableControlAction(0, 63, true) -- Left
            DisableControlAction(0, 64, true) -- Right  

            ShowRepairRestrictionText()
        end
    end
end)




RegisterNetEvent("simple_repair:repairVehicleSync")
AddEventHandler("simple_repair:repairVehicleSync", function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pedCoords = GetEntityCoords(repairPed)

        if #(playerCoords - pedCoords) < 5.0 then
            DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "[E] - Mechanic")
            if IsControlJustPressed(0, 38) and not isRepairing then
                startRepairSequence()
            end
        end
    end
end)






function deletePeds()

    if not config.deletePedsAdmin then
        return false
    end

    local deletedAnyPed = false

    for _, repairPed in pairs(pedList) do
        if DoesEntityExist(repairPed) then
            DeleteEntity(repairPed)
            deletedAnyPed = true
        end
    end

    pedList = {}

    if deletedAnyPed then
        config.debug()
        return true
    else
        config.debug()
        return false
    end
end





RegisterCommand("deletepeds", function(source, args, rawCommand)
    deletePeds()
end)



