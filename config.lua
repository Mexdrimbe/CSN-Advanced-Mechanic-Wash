config = {}

-- General script settings
config.UseCommands = true -- Choose whether to use manual repairs at a specific coordinate or enable command-based repairs.
config.playErrorSound = true -- Enable or disable the error sound effect when an incorrect command is entered (true/false).
config.playSuccesSound = true -- Enable or disable the success sound effect when a command is successfully executed (true/false).
config.debugs = false -- Enable debug prints in the F8 console for troubleshooting (true/false).

-- Mechanic settings
config.UsemanuallyRepair = true -- Set to true to require players to visit the repair location, false to use commands like /repair.
config.pedmodel = "s_m_y_xmech_01" -- Ped model to use for the mechanic NPC.
config.repairCoords = vector3(1773.3593, 3338.9509, 40.1877) -- Coordinates where the repair will take place.
-- Animation settings for mechanic ped before starting the repair
config.pedRepairAnimDict = "anim@mp_player_intcelebrationmale@thumbs_up" -- Dictionary for ped animation (thumbs up)
config.pedRepairAnimName = "thumbs_up" -- Animation name (thumbs up)
config.ShowRepairRestrictionText = true -- this is the red text showing up telling the player that he/she can't move while repair. return to false if you want to disable it!
config.pedRepairStartDelay = 4000 -- Delay in milliseconds before the repair sequence starts (4 seconds)
-- Animation settings for multiple repair stages
config.pedAnimations = {
    {animDict = "mp_cp_welcome_tutthink", animName = "b_think", duration = 5000},  -- you can either simply remove or add animation + duration in this scene, it's up to you here to make it realistic! (;
    {animDict = "amb@prop_human_bum_bin@base", animName = "base", duration = 3000}, 
    {animDict = "mp_car_bomb", animName = "car_bomb_mechanic", duration = 4000}, 
    {animDict = "amb@world_human_welding@male@base", animName = "base", duration = 4000}, 
    {animDict = "amb@prop_human_parking_meter@male@base", animName = "base", duration = 3000}, 
    {animDict = "amb@world_human_hammering@male@base", animName = "base", duration = 4500}, 
    {animDict = "rcmjosh1", animName = "idle", duration = 2500},
    {animDict = "anim@mp_player_intcelebrationfemale@thumbs_up", animName = "thumbs_up", duration = 2500} 
}






-- Camera settings for the repair process (first position)
config.repairCameraCoords1 = vector3(1780.3917, 3329.5090, 41.2491) -- Camera position during the initial repair sequence.
config.repairCameraHeading1 = 24.1138 -- Camera heading (rotation) during the initial repair sequence.
config.repairCameraFOV1 = 50.0 -- Field of view (FOV) for the initial camera position.

-- Camera settings for the repair process (second position)
config.repairCameraCoords2 = vector3(1760.1083, 3341.7903, 41.0966) -- Camera position during the second repair phase.
config.repairCameraHeading2 = 244.1562 -- Camera heading (rotation) during the second phase of the repair.
config.repairCameraFOV2 = 40.0 -- Field of view (FOV) for the second camera position.

-- Vehicle positioning and ped behavior settings for repairs
config.vehicleParkingCoords = vector3(1766.4347, 3339.6248, 40.6274) -- Coordinates where the vehicle will be parked during repairs.
config.vehicleParkingHeading = 121.3634 -- Heading (rotation) of the vehicle during parking.
config.pedWalkToCoords = vector3(1764.2052, 3338.3584, 41.2716) -- The coordinate where the ped will walk to during the repair.
config.pedWalkHeading = 294.7681 -- Heading (rotation) for the ped walking during repair.
config.vehicleExitCoords = vector3(1778.5868, 3349.5215, 40.1260) -- Coordinates where the vehicle will exit after the repair is complete.
config.vehicleExitHeading = 316.4923 -- Heading (rotation) for the vehicle during exit.
config.repairDuration = 15000 -- Duration of the repair process in milliseconds (15 seconds).



-- BLIP SETTINGS
config.blips = {
    {
        name = "Mechanic Shop", 
        coords = vector3(1774.2744, 3339.4663, 41.1347),
        sprite = 402, 
        color = 5, 
        scale = 1.0,
        display = 4,
        shortRange = true, 
        pulsing = true -- I made my own workaround here, if it's on true it will pulse, return to false to disable this!!
    },
    {
        name = "Vehicle Wash",
        coords = vector3(25.0186, -1392.1290, 28.9283), 
        sprite = 100, 
        color = 3, 
        scale = 1.2, 
        display = 4,
        shortRange = true,
        pulsing = true -- I made my own workaround here, if it's on true it will pulse, return to false to disable this!!
    }
}



-- Car wash settings >>>
config.WashDuration = 10000 -- Duration of the vehicle wash in milliseconds (10 seconds).
config.WashLocations = { {coords = vector3(25.0186, -1392.1290, 28.9283), heading = 89.1343} } -- List of car wash locations.

-- Player and vehicle teleport destination during the wash process
config.PlayerWashPosition = vector4(20.8278, -1391.8014, 29.3267, 265.9778503418) -- Coordinates where the player and vehicle will be moved during the car wash.

-- Car wash NPC ped positions
config.PedStartPosition = vector4(44.6581, -1391.9644, 29.3867, 85.5912) -- Starting position for the ped performing the car wash.
config.PedEndPosition = vector4(23.4665, -1391.8796, 29.3314, 89.2402) -- Ending position for the ped performing the car wash.

-- Initial camera settings for car wash process
config.CamCoords = vector3(10.5243, -1392.2426, 29.3078) -- Initial camera position for the car wash.
config.CamHeading = 270.0 -- Initial camera heading (rotation) for the car wash.
config.CamFOV = 70.0 -- Field of view (FOV) for the initial camera position.

-- Secondary camera settings for car wash process
config.WashCamCoords = vector3(32.8258, -1391.9996, 29.3647) -- Secondary camera position during the car wash.
config.WashCamHeading = 85.4542 -- Secondary camera heading (rotation) during the car wash.
config.WashCamFOV = 70.0 -- Field of view (FOV) for the secondary camera position.

-- NPC model for car wash
config.PedModel = "s_m_y_dockwork_01" -- Ped model used for the car wash NPC.

-- Animation settings for car wash ped
config.AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@" -- Animation dictionary used for the car wash.
config.AnimName = "machinic_loop_mechandplayer" -- Animation name used for the car wash process.

-- Sound settings for car wash process
config.PlayWashSound = true -- Set to true to enable sounds during the wash.
config.WashStartSoundName = "TIMER_STOP" -- Sound name to play when the car wash starts. // also, if you're looking to change it, you can find them here: https://wiki.rage.mp/index.php?title=Sounds
config.WashSoundSet = "HUD_MINI_GAME_SOUNDSET" -- Sound set used for the car wash sounds.

-- Admin settings for managing peds and commands
config.deletePedsAdmin = false -- Set to true to allow admins to delete all peds. ((MADE FOR DEBUG, NO REALLY USE))
config.adminLicenses = { 'license:cc073287147900711df91fee1950c56d77186bf' } -- List of admin licenses that have permission to use special admin commands.




-- List of admin licenses that have permission to use /clean and /dirt commands.
config.commandAdminLicenses = {      
    'license:cc073287147900711df91fee1950c56d77186bfd' -- Add more licenses here as needed.
}

-- Configuration options for the script
config.debugMode = false -- Sets debug mode to true/false if you want to see additional messages in the console. (FOR WASH STATION)
