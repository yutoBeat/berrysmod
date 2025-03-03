SMODS.Atlas {
    key = 'booster',
    path = 'booster.png',
    px = 71,
    py = 95
}

-- SMODS.Sound{
--     key = "music_sniper",
--     path = "music_sniper.ogg",
--     select_music_track = function() 
--         return G.STAGE == G.STATES.SMODS_BOOSTER_OPENED and G.STATE and SMODS.OPENED_BOOSTER.label:find("booster_Futa")
--     end
-- }


local futajokers = {}
local function getrand_futajoker()
    for k, v in pairs(G.P_CENTERS) do   -- Use correct variable name `jokerkey`
        if (string.find(k, "j_futa") or string.find(k, "j_fuet")) and v.rarity ~= 4 then
            table.insert(futajokers, k)
        end
    end
    if #futajokers > 0 then
        local randomIndex = math.random(1, #futajokers)
        local selectedKey = futajokers[randomIndex]
        return selectedKey
    end
end

local footjokers = {}
local function getrand_footjoker()
    for k, v in pairs(G.P_CENTERS) do   -- Use correct variable name `jokerkey`
        if (string.find(k, "j_feet") or string.find(k, "j_fuet")) and v.rarity ~= 4 then
            table.insert(footjokers, k)
        end
    end
    if #footjokers > 0 then
        local randomIndex = math.random(1, #footjokers)
        local selectedKey = footjokers[randomIndex]
        table.remove(footjokers, randomIndex)
        return selectedKey
    end
end

SMODS.Booster {
    key = 'booster_Futa', 
    atlas = 'booster',
    pos = {x=0, y=0},
    weight = 10, 
    cost = 4, 
    config = {extra = 2, choose = 1},
    loc_txt = {
        name = 'Futa Pack',
        text = {
            "A Bag of {C:attention}Girl-dicks{}", 
            "Choose up to 1 of 2 Futa Themed Jokers"
        }, 
        group_name = "Choose a Futa",
    }, 
    create_card = function(self, card, i)
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = getrand_futajoker()
        }
        return new_card
    end
}

SMODS.Booster {
    key = 'booster_Foot', 
    atlas = 'booster',
    pos = {x=1, y=0},
    weight = 10, 
    cost = 4, 
    config = {extra = 3, choose = 1},
    loc_txt = {
        name = 'The Sole Collection',
        text = {
            "A step in the right direction.", 
            "Choose up to {C:attention}1{} of {C:attention}3{} Foot Themed Jokers"
        }, 
        group_name = "Choose a Foot",
    }, 
    create_card = function(self, card, i)
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = getrand_footjoker()
        }
        return new_card
    end
}

SMODS.Booster {
    key = 'booster_Futa_Large', 
    atlas = 'booster',
    pos = {x = 2, y = 0},
    weight = 2, 
    cost = 6, 
    config = {extra = 4, choose = 2},
    loc_txt = {
        name = 'Futa Mega Pack',
        text = {
            "A larger bag of {C:attention}Girl-dicks{}", 
            "Choose up to {C:attention}2{} of {C:attention}4{} Futa Themed Jokers"
        }, 
        group_name = "Choose a Futa",
    }, 
    create_card = function(self, card, i)
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = getrand_futajoker()
        }
        return new_card
    end
}

SMODS.Booster {
    key = 'booster_Foot_Large', 
    atlas = 'booster',
    pos = {x = 3, y = 0},
    weight = 2, 
    cost = 6, 
    config = {extra = 5, choose = 2},
    loc_txt = {
        name = 'The Sole Mega Collection',
        text = {
            "A larger step in the right direction.", 
            "Choose up to {C:attention}2{} of {C:attention}5{} Foot Themed Jokers"
        }, 
        group_name = "Choose a Foot",
    }, 
    create_card = function(self, card, i)
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = getrand_footjoker()
        }
        return new_card
    end

}
