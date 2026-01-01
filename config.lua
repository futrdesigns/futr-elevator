Config = {}

-- Interaction distance for elevator triggers
Config.InteractionDistance = 2.0

-- Teleportation settings
Config.FreezeTime = 2000        -- Time player is frozen before teleport (ms)
Config.TeleportDelay = 2500     -- Delay before teleport happens (ms)
Config.TransitionTime = 500     -- Transition effect time (ms)

-- UI Settings
Config.UseHelpText = true       -- Show help text when near elevator
Config.HelpTextKey = "~INPUT_CONTEXT~" -- Key to display in help text

-- Sound settings (optional)
Config.PlaySounds = true
Config.DoorCloseSound = "CLOSED"
Config.DoorOpenSound = "OPENED"
Config.TransitionSound = "Hack_Success"

-- Buildings configuration
Config.Buildings = {
    {
        name = "Luxury Penthouse",
        icon = "", -- Leave empty for default SVG icon, use emoji like "??", or image path like "logo.png"
        floors = {
            {
                name = "Penthouse Suite",
                coords = vector4(-288.1916, -722.6127, 125.4734, 251.4712),
                description = "Top Floor - Private Residence"
            },
            {
                name = "Ground Floor",
                coords = vector4(-304.9019, -720.9813, 28.0287, 164.4193),
                description = "Main Entrance"
            },
        },
    },
    
    -- Example: Office Building with emoji icon
    -- {
    --     name = "Office Tower",
    --     icon = "???",
    --     floors = {
    --         {
    --             name = "Rooftop",
    --             coords = vector4(-75.0, -818.0, 326.0, 0.0),
    --             description = "Helipad Access"
    --         },
    --         {
    --             name = "Floor 10",
    --             coords = vector4(-75.0, -818.0, 243.0, 0.0),
    --             description = "Executive Offices"
    --         },
    --         {
    --             name = "Floor 5",
    --             coords = vector4(-75.0, -818.0, 223.0, 0.0),
    --             description = "Conference Rooms"
    --         },
    --         {
    --             name = "Lobby",
    --             coords = vector4(-75.0, -818.0, 41.0, 0.0),
    --             description = "Main Entrance"
    --         },
    --         {
    --             name = "Parking",
    --             coords = vector4(-75.0, -818.0, 36.0, 0.0),
    --             description = "Underground Parking"
    --         },
    --     },
    -- },
    
    -- Example: Hospital with custom logo
    -- {
    --     name = "Pillbox Medical",
    --     icon = "hospital-logo.png", -- Place your logo.png in the html folder
    --     floors = {
    --         {
    --             name = "Roof",
    --             coords = vector4(338.5, -583.5, 74.16, 245.0),
    --             description = "Emergency Helipad"
    --         },
    --         {
    --             name = "ICU Floor",
    --             coords = vector4(327.0, -603.0, 43.28, 245.0),
    --             description = "Intensive Care Unit"
    --         },
    --         {
    --             name = "Main Floor",
    --             coords = vector4(332.0, -595.0, 28.79, 245.0),
    --             description = "Reception & ER"
    --         },
    --         {
    --             name = "Morgue",
    --             coords = vector4(275.0, -1361.0, 24.53, 140.0),
    --             description = "Lower Level"
    --         },
    --     },
    -- },
    
    -- Example: Apartment Complex
    -- {
    --     name = "Alta Apartments",
    --     icon = "???",
    --     floors = {
    --         {
    --             name = "Penthouse",
    --             coords = vector4(-279.0, -957.0, 86.0, 160.0),
    --             description = "Luxury Penthouse"
    --         },
    --         {
    --             name = "Floor 3",
    --             coords = vector4(-279.0, -957.0, 71.0, 160.0),
    --             description = "Residential Units"
    --         },
    --         {
    --             name = "Floor 2",
    --             coords = vector4(-279.0, -957.0, 66.0, 160.0),
    --             description = "Residential Units"
    --         },
    --         {
    --             name = "Lobby",
    --             coords = vector4(-279.0, -957.0, 31.0, 160.0),
    --             description = "Main Entrance"
    --         },
    --         {
    --             name = "Garage",
    --             coords = vector4(-279.0, -957.0, 26.0, 160.0),
    --             description = "Resident Parking"
    --         },
    --     },
    -- },
}