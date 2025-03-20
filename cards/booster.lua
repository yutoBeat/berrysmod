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


futajokers = {}
local function getrand_futajoker(alt)
    local existing_jokers = {}
    for _, joker in ipairs(G.jokers.cards) do
        existing_jokers[joker.config.center.key] = true
    end
    if futajokers[1] == nil then
        for k, v in pairs(G.P_CENTERS) do  
            if (string.find(k, "j_futa") or string.find(k, "j_fuet")) and v.rarity ~= 4 then
                table.insert(futajokers, k)
            end
        end
    end
    local available_jokers = {}
    for _, joker_key in ipairs(futajokers) do
        if not existing_jokers[joker_key] then
            table.insert(available_jokers, joker_key)
        end
    end
    if next(find_joker('Showman')) then
        if alt ~= nil then
            if #futajokers > 0 and next(existing_jokers) ~= nil then
                -- print("non alt choosen")
                local selectedKey = pseudorandom_element(footjokers,pseudoseed('footjoker'))
                return selectedKey
            end
        else 
            if #futajokers > 0 then 
                -- print("alt choosen")
                local selectedKey = pseudorandom_element(footjokers,pseudoseed('footjoker'.. tostring(alt)))
                return selectedKey
            end
        end
    else
        -- print(available_jokers)
        if alt ~= nil then
            if #available_jokers > 0 and next(existing_jokers) ~= nil then
                -- print("non alt choosen")
                local selectedKey = pseudorandom_element(available_jokers,pseudoseed('footjoker'))
                return selectedKey
            end
        else 
            if #available_jokers > 0 then 
                -- print("alt choosen")
                local selectedKey = pseudorandom_element(available_jokers,pseudoseed('footjoker'.. tostring(alt)))
                return selectedKey
            end
        end
    end
end
-- local function getrand_footjoker()
--     local footjokers = {}
--     for k, v in pairs(G.P_CENTERS) do  
--         if (string.find(k, "j_feet") or string.find(k, "j_fuet")) and v.rarity ~= 4 then
--             table.insert(footjokers, k)
--         end
--     end

--     if #footjokers > 0 then
--         local randomIndex = math.random(1, #footjokers)
--         local selectedKey = footjokers[randomIndex]
--         return selectedKey
--     end
-- end
local footjokers = {}
local function getrand_footjoker(alt)
    local existing_jokers = {}
    for _, joker in ipairs(G.jokers.cards) do
        existing_jokers[joker.config.center.key] = true
    end
    if footjokers[1] == nil then 
        for k, v in pairs(G.P_CENTERS) do  
            if (string.find(k, "j_feet") or string.find(k, "j_fuet")) and v.rarity ~= 4 then
                table.insert(footjokers, k)
            end
        end
    end
    local available_jokers = {}
    for _, joker_key in ipairs(footjokers) do
        if not existing_jokers[joker_key] then
            table.insert(available_jokers, joker_key)
        end
    end
    if next(find_joker('Showman')) then
        -- print("showman found")
        if alt ~= nil then
            if #footjokers > 0 and next(existing_jokers) ~= nil then
                local selectedKey = pseudorandom_element(footjokers,pseudoseed('footjoker'))
                return selectedKey
            end
        else 
            if #footjokers > 0 and next(existing_jokers) ~= nil then 
                local selectedKey = pseudorandom_element(footjokers,pseudoseed('footjoker'.. tostring(alt)))
                return selectedKey
            end
        end
    else
        if #available_jokers > 0 and existing_jokers ~= nil then
            if alt ~= nil then
                local selectedKey = pseudorandom_element(available_jokers,pseudoseed('footjoker'))
                return selectedKey
            else
                local selectedKey = pseudorandom_element(available_jokers,pseudoseed('footjoker'.. tostring(alt)))
                return selectedKey
            end
        else
            print("ERROR NO JOKER FOUND")
        end
    end
end

SMODS.Booster {
    key = 'booster_Futa', 
    atlas = 'booster',
    pos = {x=0, y=0},
    weight = 2, 
    cost = 4, 
    config = {extra = 2, choose = 1, c_jokers = {}},
    loc_txt = {
        name = 'Futa Pack',
        text = {
            "A Bag of {C:attention}Girl-dicks{}", 
            "Choose up to {C:attention}1{} of {C:attention}2{} Futa Themed Jokers"
        }, 
        group_name = "Choose a Futa",
    },
    ease_background_colour = function(self)
        colour = G.C.RED
    end,
    -- create_card = function(self, card, i)
    --     local new_card = SMODS.create_card{
    --         set = 'Joker',
    --         key = getrand_futajoker()
    --     }
    --     return new_card
    -- end
    create_card = function(self, card, i)
        local keys = getrand_futajoker(nil)
        local j = 1
        local attempt = 0
        local max = 30
        table.insert(self.config.c_jokers, keys)
        if i ~= 1 then -- nil check
            -- look if that joker has already been choosen
            while j <= #self.config.c_jokers-1 do
                if self.config.c_jokers[i] == self.config.c_jokers[j] and self.config.c_jokers[j] ~= nil then
                    repeat
                        keys = getrand_futajoker(j)
                        attempt = attempt + 1
                        table.remove( self.config.c_jokers, i )
                        table.insert( self.config.c_jokers, keys )
                    until(self.config.c_jokers[i] ~= self.config.c_jokers[j] or attempt == max)
                end
                j=j+1
            end
        end
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = keys
        }
        if i == self.config.extra then
            self.config.c_jokers = {}
        end
        return new_card
    end
}

SMODS.Booster {
    key = 'booster_Foot', 
    atlas = 'booster',
    pos = {x=1, y=0},
    weight = 2, 
    cost = 4, 
    config = {extra = 3, choose = 1, c_jokers = {}},
    loc_txt = {
        name = 'The Sole Collection',
        text = {
            "A step in the right direction.", 
            "Choose up to {C:attention}1{} of {C:attention}3{} Foot Themed Jokers"
        }, 
        group_name = "Choose a Foot",
    }, 
    create_card = function(self, card, i)
        local keys = getrand_footjoker(nil)
        local j = 1
        local attempt = 0
        local max = 30
        table.insert(self.config.c_jokers, keys)
        if i ~= 1 then -- nil check
            -- look if that joker has already been choosen
            while j <= #self.config.c_jokers-1 do
                if self.config.c_jokers[i] == self.config.c_jokers[j] and self.config.c_jokers[j] ~= nil then
                    repeat
                        keys = getrand_footjoker(j)
                        attempt = attempt + 1
                        table.remove( self.config.c_jokers, i )
                        table.insert( self.config.c_jokers, keys )
                    until(self.config.c_jokers[i] ~= self.config.c_jokers[j] or attempt == max)
                end
                j=j+1
            end
        end
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = keys
        }
        if i == self.config.extra then
            self.config.c_jokers = {}
        end
        return new_card
    end
}

SMODS.Booster {
    key = 'booster_Futa_Large', 
    atlas = 'booster',
    pos = {x = 2, y = 0},
    weight = 1, 
    cost = 8, 
    config = {extra = 4, choose = 2, c_jokers = {}},
    loc_txt = {
        name = 'Futa Mega Pack',
        text = {
            "A larger bag of {C:attention}Girl-dicks{}", 
            "Choose up to {C:attention}2{} of {C:attention}4{} Futa Themed Jokers"
        }, 
        group_name = "Choose a Futa",
    }, 
    create_card = function(self, card, i)
        local keys = getrand_futajoker(nil)
        local j = 1
        local attempt = 0
        local max = 30
        table.insert(self.config.c_jokers, keys)
        if i ~= 1 then -- nil check
            -- look if that joker has already been choosen
            while j <= #self.config.c_jokers-1 do
                if self.config.c_jokers[i] == self.config.c_jokers[j] and self.config.c_jokers[j] ~= nil then
                    repeat
                        keys = getrand_futajoker(j)
                        attempt = attempt + 1
                        table.remove( self.config.c_jokers, i )
                        table.insert( self.config.c_jokers, keys )
                    until(self.config.c_jokers[i] ~= self.config.c_jokers[j] or attempt == max)
                end
                j=j+1
            end
        end
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = keys
        }
        if i == self.config.extra then
            self.config.c_jokers = {}
        end
        return new_card
    end
}

SMODS.Booster {
    key = 'booster_Foot_Large', 
    atlas = 'booster',
    pos = {x = 3, y = 0},
    weight = 1, 
    cost = 9, 
    config = {extra = 5, choose = 2, c_jokers = {}},
    loc_txt = {
        name = 'The Sole Mega Collection',
        text = {
            "A larger step in the right direction.", 
            "Choose up to {C:attention}2{} of {C:attention}5{} Foot Themed Jokers"
        }, 
        group_name = "Choose a Foot",
    }, 
    create_card = function(self, card, i)
        local keys = getrand_footjoker(nil)
        local j = 1
        local attempt = 0
        local max = 30
        table.insert(self.config.c_jokers, keys)
        if i ~= 1 then -- nil check
            -- look if that joker has already been choosen
            while j <= #self.config.c_jokers-1 do
                if self.config.c_jokers[i] == self.config.c_jokers[j] and self.config.c_jokers[j] ~= nil then
                    repeat
                        keys = getrand_footjoker(j)
                        attempt = attempt + 1
                        table.remove( self.config.c_jokers, i )
                        table.insert( self.config.c_jokers, keys )
                    until(self.config.c_jokers[i] ~= self.config.c_jokers[j] or attempt == max)
                end
                j=j+1
            end
        end
        local new_card = SMODS.create_card{
            set = 'Joker',
            key = keys
        }
        if i == self.config.extra then
            self.config.c_jokers = {}
        end
        return new_card
    end

}
