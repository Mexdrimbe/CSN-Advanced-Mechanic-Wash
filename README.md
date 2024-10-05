`CSN Advanced Mechanic & Wash Script`



## CSN Advanced Mechanic & Wash is a highly customizable FiveM script that provides an immersive experience for vehicle repairs and washing. The script is designed to be easily configurable, offering server owners full control over how mechanics and car washes function in their world. It integrates smooth animations, realistic restrictions, and interaction prompts to enhance roleplay.

## 🛠️ Features

>>🚗 Realistic Vehicle Repair: Players can repair their vehicles at designated mechanic locations with various animations and messages.

>>🚿 Vehicle Washing: Includes support for car wash locations, where players can drive in and get their vehicles cleaned.

>>🔄 Driving Restrictions: Disables vehicle driving during repairs to ensure roleplay immersion.

>>👷 Custom Mechanic Peds: NPC mechanics perform repairs with multiple animation sequences.

>>🗺️ Map Blips: Easily locate mechanic and wash stations on the map with custom blips. (I added a option where you can make it pulse, config.lua)

>>📝 Extensive Configuration: Almost every feature can be tweaked in the configuration file, from blip colors to animation durations.

>>🎵 Sound Effects: Configurable success and error sounds for feedback.

>>🛠️ Command Integration: Use /repair and /wash commands to manually initiate services.



## 📂 Installation
`Download and Extract the script files.`

`Place the extracted folder into your server's resources directory.`

`Add the following line to your server.cfg:`
>> ensure CSN_VehicleServices <<


## ⚙️ Configuration
## The config.lua file allows you to customize all aspects of the script, such as blips, animations, messages, and commands. Below are the key configuration options:

## 🚗 Mechanic Settings (((preview))

```lua
config.UsemanuallyRepair = true 
config.pedmodel = "s_m_y_xmech_01" 
config.repairCoords = vector3(1773.3593, 3338.9509, 40.1877) 

config.pedRepairAnimDict = "anim@mp_player_intcelebrationmale@thumbs_up" 
config.pedRepairAnimName = "thumbs_up" 
config.ShowRepairRestrictionText = true 
config.pedRepairStartDelay = 4000

config.pedAnimations = {
    {animDict = "mp_cp_welcome_tutthink", animName = "b_think", duration = 5000}, 
    {animDict = "amb@prop_human_bum_bin@base", animName = "base", duration = 3000}, 
    {animDict = "mp_car_bomb", animName = "car_bomb_mechanic", duration = 4000}, 
    {animDict = "amb@world_human_welding@male@base", animName = "base", duration = 4000}, 
    {animDict = "amb@prop_human_parking_meter@male@base", animName = "base", duration = 3000}, 
    {animDict = "amb@world_human_hammering@male@base", animName = "base", duration = 4500}, 
    {animDict = "rcmjosh1", animName = "idle", duration = 2500},
    {animDict = "anim@mp_player_intcelebrationfemale@thumbs_up", animName = "thumbs_up", duration = 2500} 
}

config.repairCameraCoords1 = vector3(1780.3917, 3329.5090, 41.2491) 
config.repairCameraHeading1 = 24.1138 
config.repairCameraFOV1 = 50.0 

config.repairCameraCoords2 = vector3(1760.1083, 3341.7903, 41.0966) 
config.repairCameraHeading2 = 244.1562 
config.repairCameraFOV2 = 40.0 

config.vehicleParkingCoords = vector3(1766.4347, 3339.6248, 40.6274)
config.vehicleParkingHeading = 121.3634 
config.pedWalkToCoords = vector3(1764.2052, 3338.3584, 41.2716) 
config.pedWalkHeading = 294.7681 
config.vehicleExitCoords = vector3(1778.5868, 3349.5215, 40.1260) 
config.vehicleExitHeading = 316.4923 
config.repairDuration = 15000 
```


## 🚿 Wash Settings ((preview))


```lua
config.WashDuration = 10000 
config.WashLocations = { {coords = vector3(25.0186, -1392.1290, 28.9283), heading = 89.1343} } 

config.PlayerWashPosition = vector4(20.8278, -1391.8014, 29.3267, 265.9778503418) 

config.PedStartPosition = vector4(44.6581, -1391.9644, 29.3867, 85.5912) 
config.PedEndPosition = vector4(23.4665, -1391.8796, 29.3314, 89.2402) 

config.CamCoords = vector3(10.5243, -1392.2426, 29.3078) 
config.CamHeading = 270.0 
config.CamFOV = 70.0 

config.WashCamCoords = vector3(32.8258, -1391.9996, 29.3647)
config.WashCamHeading = 85.4542 
config.WashCamFOV = 70.0 

config.PedModel = "s_m_y_dockwork_01"

config.AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@" 
config.AnimName = "machinic_loop_mechandplayer" 

config.PlayWashSound = true 
config.WashStartSoundName = "TIMER_STOP" 
config.WashSoundSet = "HUD_MINI_GAME_SOUNDSET" 
```




## 🗺️ Blip Settings ((Preview))

```lua
config.blips = {
    {
        name = "Mechanic Shop", 
        coords = vector3(1774.2744, 3339.4663, 41.1347),
        sprite = 402, 
        color = 5, 
        scale = 1.0,
        display = 4,
        shortRange = true, 
        pulsing = true 
    },
    {
        name = "Vehicle Wash",
        coords = vector3(25.0186, -1392.1290, 28.9283), 
        sprite = 100, 
        color = 3, 
        scale = 1.2, 
        display = 4,
        shortRange = true,
        pulsing = true 
    }
}
```


## 🧑‍💻 Commands
/repair ` Manually start a repair process if enabled in the configuration.`
/wash ` Manually start a vehicle wash process at a wash station.` *ADMIN COMMAND!*
/dirt ` sets the vehicle to max dirt level`                       *ADMIN COMMAND!*
/deletepeds ` Admin command to remove all spawned mechanic peds.` *ADMIN COMMAND!* ((for debug))



## 🚧 Known Issues & Limitations
>>Pulsating blips may not always function as expected depending on FiveM limitations.
>>Configuring multiple mechanics/wash stations with similar coordinates may cause overlap issues. (can be set to false.)




## 🔗 SUPPORT
>>For any issues, suggestions, or contributions, join our Discord Community. We look forward to hearing your feedback and improving the script together! (discord.gg/v9f9Cbp4cG)
