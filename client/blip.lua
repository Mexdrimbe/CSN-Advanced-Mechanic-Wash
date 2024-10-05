function createBlips()
    for _, blipConfig in pairs(config.blips) do
        local blip = AddBlipForCoord(blipConfig.coords.x, blipConfig.coords.y, blipConfig.coords.z)

        SetBlipSprite(blip, blipConfig.sprite)
        SetBlipDisplay(blip, blipConfig.display)
        SetBlipScale(blip, blipConfig.scale)
        SetBlipColour(blip, blipConfig.color)
        SetBlipAsShortRange(blip, blipConfig.shortRange)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipConfig.name)
        EndTextCommandSetBlipName(blip)

        if blipConfig.pulsing then
            Citizen.CreateThread(function()
                local alpha = 255 
                local increasing = false 

                while true do
                    Citizen.Wait(50) 

                    if increasing then
                        alpha = alpha + 15
                        if alpha >= 255 then
                            alpha = 255
                            increasing = false
                        end
                    else
                        alpha = alpha - 15
                        if alpha <= 100 then
                            alpha = 100
                            increasing = true
                        end
                    end

                    SetBlipAlpha(blip, alpha)
                end
            end)
        end
    end
end

Citizen.CreateThread(function()
    createBlips()
end)