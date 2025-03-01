local module = {}

local feet_jokers = {}
local futa_jokers = {}

local function get_feet_jokers()
    if next(feet_jokers) ~= nil then
        return feet_jokers
    end

    if string.find(k, "j_feet") and v.rarity ~= 4 then
        table.insert(feet_jokers, k)
    end

    return feet_jokers
end

local function get_feet_jokers()
    if next(futa_jokers) ~= nil then
        return futa_jokers
    end

    if string.find(k, "j_futa") and v.rarity ~= 4 then
        table.insert(futa_jokers, k)
    end

    return futa_jokers
end