-- FUTR Elevator System - Client Script
local isNearElevator = false
local currentBuilding = nil
local currentFloor = nil
local isUIOpen = false
local isTeleporting = false

-- Optimized distance checking thread
CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearestElevator, nearestDist, nearestBuilding, nearestFloor = nil, nil, nil, nil

        -- Find nearest elevator
        for _, building in ipairs(Config.Buildings) do
            if building.floors then
                for _, floor in ipairs(building.floors) do
                    local dist = #(playerCoords - vector3(floor.coords.x, floor.coords.y, floor.coords.z))
                    
                    if not nearestDist or dist < nearestDist then
                        nearestDist = dist
                        nearestElevator = floor
                        nearestBuilding = building
                        nearestFloor = floor
                    end
                end
            end
        end

        -- Update state based on distance
        if nearestDist and nearestDist < Config.InteractionDistance then
            if not isNearElevator then
                isNearElevator = true
                currentBuilding = nearestBuilding
                currentFloor = nearestFloor
                sleep = 0 -- Check more frequently when near
            end
        else
            if isNearElevator then
                isNearElevator = false
                currentBuilding = nil
                currentFloor = nil
            end
        end

        Wait(sleep)
    end
end)

-- Input handling thread
CreateThread(function()
    while true do
        local sleep = 500

        if isNearElevator and not isUIOpen and not isTeleporting then
            sleep = 0
            
            if Config.UseHelpText then
                DisplayHelpText("Press " .. Config.HelpTextKey .. " to use the elevator")
            end
            
            if IsControlJustReleased(0, 38) then -- E key
                OpenElevatorUI(currentBuilding, currentFloor)
            end
        end

        Wait(sleep)
    end
end)

-- Open elevator UI
function OpenElevatorUI(building, currentFloor)
    if isUIOpen or isTeleporting then return end
    
    isUIOpen = true
    
    local sendData = {
        action = "open",
        building = {
            name = building.name,
            icon = building.icon or "",
            floors = building.floors
        },
        currentFloor = currentFloor.name
    }
    
    SendNUIMessage(sendData)
    SetNuiFocus(true, true)
end

-- Close elevator UI
function CloseElevatorUI()
    if not isUIOpen then return end
    
    isUIOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        action = "close"
    })
end

-- NUI Callback: Close UI
RegisterNUICallback('close', function(data, cb)
    CloseElevatorUI()
    cb('OK')
end)

-- NUI Callback: Set NUI focus
RegisterNUICallback('setNuiFocus', function(data, cb)
    SetNuiFocus(data.focus or false, data.cursor or false)
    cb('OK')
end)

-- NUI Callback: Floor selected
RegisterNUICallback('floorSelected', function(data, cb)
    cb('OK')
    
    if isTeleporting then return end
    
    local coords = data.coords
    if not coords then return end
    
    isTeleporting = true
    local ped = PlayerPedId()
    
    -- Close UI immediately
    CloseElevatorUI()
    
    -- Freeze player
    FreezeEntityPosition(ped, true)
    
    -- Play door closing sound
    if Config.PlaySounds then
        PlaySoundFrontend(-1, Config.DoorCloseSound, "MP_PROPERTIES_ELEVATOR_DOORS", 1)
    end
    
    -- Wait for door close animation
    Wait(Config.FreezeTime)
    
    -- Screen fade out
    DoScreenFadeOut(500)
    Wait(500)
    
    -- Teleport player
    SetEntityCoords(ped, coords.x, coords.y, coords.z - 1.0, false, false, false, true)
    SetEntityHeading(ped, coords.w)
    
    -- Wait for teleport delay
    Wait(Config.TeleportDelay)
    
    -- Play transition sound
    if Config.PlaySounds then
        PlaySoundFrontend(-1, Config.TransitionSound, "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
    end
    
    Wait(Config.TransitionTime)
    
    -- Screen fade in
    DoScreenFadeIn(500)
    Wait(500)
    
    -- Play door opening sound
    if Config.PlaySounds then
        PlaySoundFrontend(-1, Config.DoorOpenSound, "MP_PROPERTIES_ELEVATOR_DOORS", 1)
    end
    
    -- Unfreeze player
    FreezeEntityPosition(ped, false)
    isTeleporting = false
end)

-- Helper function to display help text
function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    if isUIOpen then
        CloseElevatorUI()
    end
    
    if isTeleporting then
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        DoScreenFadeIn(500)
    end
end)