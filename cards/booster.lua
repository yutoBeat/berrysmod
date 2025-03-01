SMODS.Atlas {
    key = 'booster',
    path = 'booster.png',
    px = 71,
    py = 95
}

local jokers = {
    'j_feet_mirko_ice',
    'j_feet_pearl',
    'Marina_Meat',
    'Pearls_meal',
    'j_feet_ghost',
    'Doki',
    'j_feet_dandandan',
    'j_fuet_splatoon',
    'j_feet_pantyhose',
    'j_feet_Tripple',
    'j_feet_Cum',
    'j_feet_Steamly',
    'j_feet_Roboco',
    'j_futa__IrYs',
    'dokianal',
    'j_futa_chart',
    'j_futa_splatdance',
    'j_feet_Lana',
    'j_feet_Peko',
    'j_feet_Twins',
    'j_feet_selen',
    'j_feet_marie',
    'j_feet_pantyhosefeet',
    'j_feet_dp',
    'j_feet_Fromuppper',
    'j_futa_tori',
    'j_feet_towa',
    'j_feet_botan',
    'j_feet_footlick',
    'j_feet_frog smell',
    'j_futa_gardivoir'
}

local function getrand_futajoker()
    local futajokers = {}
    for _, jokerkey in ipairs(jokers) do
        if string.match(jokerkey, "^j_futa") or string.match(jokerkey, "^j_fuet") then
            table.insert(futajokers, jokerkey)
        end
    end
    if #futajokers > 0 then
        local randomIndex = math.random(1, #futajokers)  -- Fixed inconsistent capitalization
        local jokerkey = futajokers[randomIndex]
        return "j_bery_" .. jokerkey  
    end
end

local function getrand_footjoker()
local footjoker = {}
    for _, jokerkey in ipairs(jokers) do
        if string.match(jokerkey, "^j_feet") or string.match(jokerkey, "^j_fuet") then
            table.insert(footjoker, jokerkey)
        end
    end
    if #footjoker > 0 then
        local randomIndex = math.random(1, #footjoker)  -- Fixed inconsistent capitalization
        local jokerkey = footjoker[randomIndex]
        return "j_bery_" .. jokerkey  
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
