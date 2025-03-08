
SMODS.Atlas {
    key = 'planet',
    path = 'Planets.png',
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = 'tarot_sheet', 
    path = 'Tarot.png',
    px = 71, 
    py = 95
}

SMODS.Consumable {
    set = 'Planet',
    key = 'Stopalo',
    config = {hand_type = 'bery_Twoplush'},
    pos = {x = 1, y = 0},
    atlas = 'planet',
    generate_ui = 1,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_planet_x'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end, -- Enables UI generation for the card
    loc_txt = {
        ['en-us'] = {
            name = 'Stopalo',
            description = 'A unique and mysterious planet, with strange flora and fauna. A place of beauty and danger.',
        },
    }
}

SMODS.Consumable {
    set = 'Planet',
    key = 'Archon',
    config = {hand_type = 'bery_Threeflush'},
    pos = {x = 0, y = 0},
    atlas = 'planet',
    generate_ui = 1,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end, -- Enables UI generation for the card
    loc_txt = {
        ['en-us'] = {
            name = 'Archon',
            description = 'A unique and mysterious planet, with strange flora and fauna. A place of beauty and danger.',
        },
    }
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
    'j_futa_mirko',
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
        if string.match(jokerkey, "j_futa")then --  or string.match(jokerkey, "^j_fuet")
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
        if string.match(jokerkey, "j_feet") then --  or string.match(jokerkey, "^j_fuet")
            table.insert(footjoker, jokerkey)
        end
    end
    if #footjoker > 0 then
        local randomIndex = math.random(1, #footjoker)  -- Fixed inconsistent capitalization
        local jokerkey = footjoker[randomIndex]
        return "j_bery_" .. jokerkey  
    end
end


SMODS.Consumable {
    set = 'Tarot',
    key = "FOot",
    loc_txt = {
        ['en-us'] = {
            name = "The Sole’s Revelation",
            text = {
                "Create a random {C:attention}Foot Joker{}",
                "{C:inactive}(Must have room){}"
            }
        }
    },
    ability_name = "FOot maker",
    cost = 7,
    cost_mult = 1,
    discovered = true,
    unlocked = true,
    generate_ui = 1,
    atlas = 'tarot_sheet',
    pos = {x=0, y=0},
     

    can_use = function()        
        if G.jokers.config.card_limit > #G.jokers.cards then
            return {
                true
            }
        else return{false } end
    end,

    use = function(card, area, copier)
        if G.jokers.config.card_limit > #G.jokers.cards then
            local key_joker = getrand_footjoker()
            SMODS.add_card{
                set = 'Joker',
                key = key_joker
            }
        end
    end
}

SMODS.Consumable {
    set = 'Tarot',
    key = "FUta",
    loc_txt = {
        ['en-us'] = {
            name = "The Potent Empress",
            text = {
                "Create a random {C:attention}Futa Joker{}",
                "{C:inactive}(Must have room){}"
            }
        }
    },
    ability_name = "Futa maker",
    cost = 7,
    cost_mult = 1,
    discovered = true,
    unlocked = true,
    generate_ui = 1,
    atlas = 'tarot_sheet',
    pos = {x=1, y=0},

    can_use = function()
        return {
            G.jokers.config.card_limit > #G.jokers.cards
        }

    end,

    use = function(card, area, copier)
        if G.jokers.config.card_limit > #G.jokers.cards then
            local key_joker = getrand_futajoker()
            SMODS.add_card{
                set = 'Joker',
                key = key_joker
            }
        end
    end
}




