Config = {}
Config.Locale = GetConvar('esx:locale', 'en') -- Change this to your preferred language in server.cfg
Config.Dialogue = 'rep-talkNPC' -- you need rep-talkNPC its just if you renamed the folder or something.

-- Config settings
Config.SpawnInVehicle = false -- If true, the player will spawn inside the vehicle
Config.Notification = 'ox' -- 'ox' or 'esx'

Config.Blip = {
    Enable = true, -- Enable blips on the map
    Text = 'Garage', -- Blip text
    ImpoundText = 'Impound', -- Impound blip text (Dont mind if you use the impound)
    Sprite = 357, -- Blip sprite
    Scale = 0.7, -- Blip scale
    Colour = 11, -- Blip colour
    Display = 4, -- Blip display
}

--Impound settings
Config.Impound = true -- Enable build in impound
Config.ImpoundPrice = 5000 -- Price to get vehicle out of impound

-- Garages (Add more garages by copying the example below)
    -- ['Name'] = { -- Name of the garage
    --     Impound = true, -- Is it an impound? (true/false) or just remove the line
    --     Ped = 's_m_y_valet_01', -- Ped model
    --     Pedname = 'Poul', -- Ped name
    --     Pedcoords = {214.55288696289,-807.06463623047,30.840578079224,337.96301269531}, -- Ped coords
    --     Parking = { -- Parking spots for the garage (Has to be in a vector4)
    --         vector4(219.17825317383,-808.95306396484,30.691654205322,252.08013916016),
    --         vector4(220.37074279785,-806.54797363281,30.696380615234,257.26837158203),
    --         vector4(222.27728271484,-804.31536865234,30.67280960083,245.9109954834),
    --         vector4(222.71495056152,-801.68536376953,30.668800354004,246.83868408203),
    --     },
    -- },

Config.Garages = {
    -- Public garage
    ['Midtby Garage'] = {
        Ped = 's_m_y_valet_01',
        Pedname = 'Poul',
        Pedcoords = {214.55288696289,-807.06463623047,30.840578079224,337.96301269531}, 
        Parking = { 
            vector4(219.17825317383,-808.95306396484,30.691654205322,252.08013916016),
            vector4(220.37074279785,-806.54797363281,30.696380615234,257.26837158203),
            vector4(222.27728271484,-804.31536865234,30.67280960083,245.9109954834),
            vector4(222.71495056152,-801.68536376953,30.668800354004,246.83868408203),
        },
    },
    ['Spawn Garage'] = { 
        Ped = 's_m_y_valet_01',
        Pedname = 'Steve',
        Pedcoords = {-293.37481689453,-986.86901855469,31.081817626953,67.50700378418},
        Parking = {
            vector4(-297.58557128906,-990.41253662109,31.081817626953,341.78045654297),
            vector4(-301.28366088867,-989.20220947266,31.081817626953,340.5188293457),
        },
    },
    ['Davis Impound'] = {
        Impound = true,
        Ped = 's_m_y_valet_01',
        Pedname = 'Impound Ian',
        Pedcoords = {409.02, -1622.86, 29.29, 230.63},
        Parking = {
            vector4(417.28, -1627.51, 29.29, 143.57),
            vector4(419.65, -1629.48, 29.29, 139.94),
        },
    },
}

-- Example of a job garage
    -- ['Name'] = { -- Name of the garage
    --     Ped = 's_m_y_valet_01', -- Ped model
    --     Pedname = 'Jacob', -- Ped name
    --     Pedcoords = {459.31, -1007.96, 28.26, 92.22}, -- Ped coords
    --     Parking = { -- Parking spots for the garage (Has to be in a vector4)
    --         vector4(446.12, -1025.31, 28.64, 359.70),
    --         vector4(442.31, -1025.70, 28.72, 3.13),
    --     },
    --     Job = 'police', -- Job name (Only this job can use this garage)
    --     Vehicles = { -- Vehicles that can be spawned in this garage
    --         {model = 'police', label = 'Police'},
    --         {model = 'police2', label = 'Police 2'},
    --         {model = 'police3', label = 'Police 3'},
    --         {model = 'police4', label = 'Police 4'},
    --         {model = 'policeb', label = 'Police Bike'},
    --     },
    -- },

Config.JobGarages = { 
    -- Job garages
    ['MRPD Politi Garage'] = {
        Ped = 's_m_y_valet_01',
        Pedname = 'Jacob', 
        Pedcoords = {459.31, -1007.96, 28.26, 92.22},
        Parking = { 
            vector4(446.12, -1025.31, 28.64, 359.70),
            vector4(442.31, -1025.70, 28.72, 3.13),
        },
        Job = 'police',
        Vehicles = {
            {model = 'police', label = 'Police'},
            {model = 'police2', label = 'Police 2'},
            {model = 'police3', label = 'Police 3'},
            {model = 'police4', label = 'Police 4'},
            {model = 'policeb', label = 'Police Bike'},
        },
    },
}