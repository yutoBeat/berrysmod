SMODS.Atlas {
    key = 'booster',
    path = 'booster.png',
    px = 71,
    py = 95
}

SMODS.Sound{
    key = "music_sniper",
    path = "music_sniper.ogg",
    select_music_track = function() 
        return G.STAGE == G.STATES.SMODS_BOOSTER_OPENED and G.STATE and SMODS.OPENED_BOOSTER.label:find("booster_Futa")
    end
}

local jokerkey = {
    "j_feet_mirko_ice",
    "j_feet_pearl",
    "Marina_Meat",
    "Pearls_meal",
    "j_feet_ghost",
    "Doki",
    "j_feet_dandandan",
    "j_fuet_splatoon",
    "j_feet_pantyhose",
    "j_feet_Tripple",
    "j_feet_Cum",
    "j_feet_Steamly",
    "j_feet_Roboco",
    "j_futa__IrYs",
    "dokianal",
    "j_futa_chart",
    "j_futa_splatdance",
    "j_feet_Lana",
    "j_feet_Peko",
    "j_feet_Twins",
    "j_feet_selen",
    "j_feet_marie",
    "j_feet_pantyhosefeet",
    "j_feet_dp",
    "j_feet_Fromuppper",
    "j_futa_tori",
    "j_feet_towa",
    "j_futa_splat_orgy",
    "j_feet_footlick",
    "j_feet_frog smell",
    "j_futa_gardivoir",
    "j_foot_collection"
}

local function getrand_futajoker()
    local futajokers = {}
    for _, key in ipairs(jokerkey) do  -- Use correct variable name `jokerkey`
        if string.match(key, "^j_futa") or string.match(key, "^j_fuet") then
            table.insert(futajokers, key)
        end
    end
    if #futajokers > 0 then
        local randomIndex = math.random(1, #futajokers)
        local selectedKey = futajokers[randomIndex]
        return "j_bery_" .. selectedKey
    end
end

local function getrand_footjoker()
    local footjokers = {}
    for _, key in ipairs(jokerkey) do  -- Use correct variable name `jokerkey`
        if string.match(key, "^j_feet") or string.match(key, "^j_fuet") then
            table.insert(footjokers, key)
        end
    end
    if #footjokers > 0 then
        local randomIndex = math.random(1, #footjokers)
        local selectedKey = footjokers[randomIndex]
        return "j_bery_" .. selectedKey
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
    weight = 10, 
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
    weight = 10, 
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
