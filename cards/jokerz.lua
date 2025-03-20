local data, err = SMODS.load_file('util.lua', "BERRY")
local ok, util = pcall(data)

SMODS.Atlas {
	key = "feetandfuta",
	path = "feetandfuta.png",
	px = 71,
	py = 95
}
SMODS.Atlas {
	key = "vouch",
	path = "vocher.png",
	px = 71,
	py = 95
}

local function is_face(card)
    local id = card:get_id()
    return id == 11 or id == 12 or id == 13
end


local function is_futa(card)
	if card == nil then 
		return false
	else
		if string.match(card, "j_futa") then
			return true
		else
			return false
		end
	end
end


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

local function get_futa_jokers()
    if next(futa_jokers) ~= nil then
        return futa_jokers
    end

    if string.find(k, "j_futa") and v.rarity ~= 4 then
        table.insert(futa_jokers, k)
    end

    return futa_jokers
end



	-- local function getrand_footjoker()
	-- 	for k, v in pairs(G.P_CENTERS) do   -- Use correct variable name `jokerkey`
	-- 		if (string.find(k, "j_feet") or string.find(k, "j_fuet")) and v.rarity ~= 4 then
	-- 			table.insert(footjokers, k)
	-- 		end
	-- 	end
	-- 	if #footjokers > 0 then
	-- 		local randomIndex = math.random(1, #footjokers)
	-- 		local selectedKey = footjokers[randomIndex]
	-- 		table.remove(footjokers, randomIndex)
	-- 		return selectedKey
	-- 	end
	-- end

SMODS.Joker {
	key = 'j_feet_mirko_ice',
	loc_txt = {
		name = "Mirko's Cooling",
		text = {
			"Start with {C:mult}+100 Mult{} and {C:chips}+0{} Chips,",
            "Each Hand {C:mult}-#2# mult{} and {C:chips}+#4# Chips{}",
            "{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} and{} {C:chips}+#3#{C:inactive}){}"
		}
	},
	config = { extra = { mult = 100, mult_gain = 10, chip = 0, chip_gain = 10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chip, card.ability.extra.chip_gain } }
	end,
	rarity = 2,
	atlas = 'feetandfuta',
	pos = { x = 3, y = 2 },
	cost = 3,
    slug = "j_feet",
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
                chip_mod = card.ability.extra.chip,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip } }
			}
		end

        if context.before and not context.blueprint then
            if card.ability.extra.mult ~= 0 then

                card.ability.extra.chip = card.ability.extra.chip + card.ability.extra.chip_gain
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_gain
                if card.ability.extra.mult < 0 then
                    card.ability.extra.mult = 0
                end
                return {
                    message = 'Cooled!',
                    colour = G.C.RED,
                    card = card
                }
            else
                return {
                    card = card
                }
            end 
        end
	end
}


SMODS.Joker {
	
	key = 'j_feet_pearl',
	
	loc_txt = {
		name = 'Pearly Toes',
		text = {
			
			"Earn {C:money}$#1#{}, At the",
            "End of Round, After",
            "Three Hands Gain {C:money}+$#3#",
            "{C:inactive}(Currently Hand #2# of 3){}"
		}
	},
	
	config = { extra = { money = 2, counter = 0, money_gain = 1 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.counter,  card.ability.extra.money_gain  } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 3 },
	
	cost = 5,

    soul_pos = { x = 0, y = 3 },
    slug = "j_feet",
	
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then return bonus end
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if card.ability.extra.counter == 3 then
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain
                card.ability.extra.counter = 0
                return {
                    card.ability.extra.counter,
                    card.ability.extra.money,
                    message = ("Upgraded"),
                    colour = G.C.RED
                }       
            else
                card.ability.extra.counter = card.ability.extra.counter + 1
                return {
                    card.ability.extra.counter,
                    message = ("+1 round"),
                    colour = G.C.ORANGE
                }
            end
        end
    end   
}


SMODS.Joker {
	key = 'j_futa_Marina_Meat',
	loc_txt = {
		name = 'Marina Meat',
		text = {
			"Each Scored {C:attention}Ace{} of {C:spades}Spades",
			"gives {C:mult}+#1#{} Mult when scored"
			
		}
	},
	config = { extra = {mult = 25 } },
	rarity = 1,
	atlas = 'feetandfuta',
	pos = { x = 2, y = 2 },
	cost = 4,
	slug = "j_futa",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult} }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == 14 and context.other_card:is_suit('Spades') then
                -- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa_Pearls_meal',
	
	loc_txt = {
		name = "Pearls_meal",
		text = {
			
			"Each Scored {C:attention}Ace{} of {C:spades}Spades",
            " gives {C:chips}+#1#{} Chips"
		}
	},
	
	config = { extra = { chips = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 4 },
	soul_pos = {x = 4, y= 3},
	cost = 2,

    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == 14 and context.other_card:is_suit('Spades') then
                -- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					chips = card.ability.extra.chips,
					card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_ghost',
	
	loc_txt = {
		name = 'Ghost Haunting',
		text = {
			
			"After Every Shop,",
			"Create a {C:dark_edition}Negative{} Copy",
			"of a Random Joker"
		}
	},
	
	config = { extra = {} },
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
	end,
	
	rarity = 4,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 1 },
	
	cost = 20,

    soul_pos = { x = 3, y = 1 },
    slug = "j_feet",
	calculate = function(self, card, context)
		if context.ending_shop then
			G.E_MANAGER:add_event(Event({
				func = function()
					-- pseudorandom_element is a vanilla function that chooses a single random value from a table of values, which in this case, is your consumables.
					-- pseudoseed('perkeo2') could be replaced with any text string at all - It's simply a way to make sure that it's affected by the game seed, because if you use math.random(), a base Lua function, then it'll generate things truly randomly, and can't be reproduced with the same Balatro seed. LocalThunk likes to have the joker names in the pseudoseed string, so you'll often find people do the same.
					local card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('ghost')), nil)
					if card ~= self then
						-- Vanilla function, it's (edition, immediate, silent), so this is ({edition = 'e_negative'}, immediate = true, silent = nil)
						card:set_edition('e_negative', true)
						card:add_to_deck()
						-- card:emplace puts a card in a cardarea, this one is G.consumeables, but G.jokers works, and custom card areas could also work.
						-- I think playing cards use "create_playing_card()" and are separate.
						G.jokers:emplace(card)
						return true
					end
				end
			}))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = localize('k_duplicated_ex') })
		end
	end
}


SMODS.Joker {
    key = 'Doki',
    loc_txt = {
        name = 'Cock shock',
        text = {
            "Give {C:mult}+#1#{} mult",
            "A {C:PURPLE}Special{} Joker is Made, If the Card is",
			"in your hand for more than 3 rounds",
            "{C:inactive}(Rounds: {}{C:attention}#2#{}{C:inactive}/{}{C:attention}3{}{C:inactive}){}"
        }
    },
    config = { extra = { mult = 3, count = 0 } },
    loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.mult, card.ability.extra.count} }
    end,
    rarity = 2,
    atlas = 'feetandfuta',
    pos = { x = 0, y = 1 },
    cost = 4,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
		if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
			card.ability.extra.count = card.ability.extra.count + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					if card.ability.extra.count == 3 then 
						G.jokers:remove_card(card)
						card:remove()
						card = nil
						local new_card = SMODS.create_card({
							set = 'Joker',
							key = "j_bery_j_fuet_dokianal",
							no_edition = true
						})
						if new_card then
							G.jokers:emplace(new_card)
							new_card:juice_up(0.4, 0.4)
						end
					end
					return true
				end
			}))
			return {
				card.ability.extra.count,
				message = ("+1 round"),
				colour = G.C.ORANGE
			}
		else
			return {}
		end
    end
}
  

SMODS.Joker {
	
	key = 'j_feet_dandandan',
	
	loc_txt = {
		name = "Arch Support",
		text = {
			"Cards with a value {C:attention}10 {}or {C:attention}below{}",
            "give {C:mult}+#1#{} {C:mult}Mult{} when scored"
		}
	},
	
	config = { extra = { mult_mod = 7 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_mod } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 1 },
	
	cost = 5,

    soul_pos = { x = 1, y = 1 },
    slug = "j_feet_stirups",
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() <= 10 then
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					mult = card.ability.extra.mult_mod,
					card = context.other_card
				}
			end
		end
	end
}

-- SMODS.Joker {
--     key = 'black_blood',
    
--     loc_txt = {
--         name = 'Black Blood',
--         text = {
--             "If you would {C:attention}bust{},",
--             " play the hand again with {C:mult}+#1#{}",
--             " Mult, but {C:chips}-#2#{} Chips."
--         }
--     },

--     config = { extra = { mult = 50, chip_loss = 100 } },

--     loc_vars = function(self, info_queue, card)
--         return { vars = { card.ability.extra.mult, card.ability.extra.chip_loss } }
--     end,

--     rarity = 3,

--     atlas = 'feetandfuta',

--     pos = { x = 2, y = 0 },

--     cost = 5,

--     loc_vars = function(self, info_queue, card)
--         return { 
--             vars = { 
--                 card.ability.extra.mult,  -- Multiplier value
--                 card.ability.extra.chip_loss  -- Chip loss value
--             }
--         }
--     end,

--     -- Function to activate the Joker ability
--     calculate = function(self, card, context)
--         if context.bust then
--             print("check if works")
            
--         end
--     end
-- }



SMODS.Joker {
	
	key = 'j_fuet_splatoon',
	
	loc_txt = {
		name = 'Show Off',
		text = {
			
			"Each Jack gives ",
			"{X:mult,C:white}X#1#{} Mult when Scored"
		}
	},
	
	config = { extra = { Xmult = 1.5 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 3 },
	
	cost = 7,
    slug = "j_feet", --unused
    alt_slug = "j_futa",
	
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 11 then
				return {
					Xmult_mod = card.ability.extra.Xmult,
					message = "X1.5",
					card = context.other_card
				}
			end
		end
	end


}

SMODS.Joker {
	
	key = 'j_feet_pantyhose',
	
	loc_txt = {
		name = 'Working legs',
		text = {
			
			"{C:red}+#1#{} discards",
			"each round,",
			"{C:red}#2#{} hand size"
		}
	},
	
	config = { extra = {  discard_size = 2, hand_size = -1 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discard_size, card.ability.extra.hand_size } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 2 },
	
	cost = 2,

	slug = "j_feet",

    soul_pos = { x = 0, y = 2 },
			
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard_size
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard_size
		G.hand:change_size(-card.ability.extra.hand_size)
	end
}

SMODS.Joker {
	
	key = 'j_feet_Tripple',
	
	loc_txt = {
		name = 'Triple Stench',
		text = {
			"if Played hand is a",
			"{C:attention}Three of a Kind Flush{}",
			"{X:mult,C:white}X2{} Mult"
		}
	},
	
	config = { extra = { Xmult = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 0 },
	
	cost = 6,
    slug = "j_feet",


	
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['bery_Threeflush']) and not context.blueprint then
			return {
				message = "X2",
				Xmult_mod = card.ability.extra.Xmult, 
				card = card
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Cum',
	
	loc_txt = {
		name = 'Money shot',
		text = {
			
			"If Played Hand",
			"Contains a {C:attention}Pair{} {C:money}+$6{} Dollars"
		}
	},
	
	config = { extra = { money = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 0 },
	
	cost = 4,
    slug = "j_feet",
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Pair']) and not context.blueprint then
			ease_dollars(6)
			return {
				message = "+6",
				colour = G.C.yellow
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Steamly',
	
	loc_txt = {
		name = 'Motherly Nylon Soles',
		text = {
			"If a {C:attention}Full House{}",
			" is played {X:mult,C:white}X#1#{} Mult"
		}
	},
	
	config = { extra = { mult = 1.5 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 2 },
	
	cost = 5,
    slug = "j_feet",

	
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands['Full House']) and not context.blueprint then
			return {
				message = "X1.5",
				Xmult_mod = card.ability.extra.mult, 
				card = card
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Roboco',
	
	loc_txt = {
		name = 'Metal Grippers',
		text = {
			
			"If hand has exactly 4 cards",
			"every scored cards gains,",
			"{X:mult,C:white}+#2#{} Mult and is {C:attention}CRUSHED{}",
			"{C:inactive}(Currently: +#1#){}"
		}
	},
	
	config = { extra = { mult = 0, mult_gain = 4  } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 3 },
	
	cost = 8,
    slug = "j_feet",

	
	calculate = function(self, card, context)
		
		if context.cardarea == G.play and #G.play.cards == 4 and not context.repetition then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				card = other_card,
				message = "Crushed!",
				colour = G.C.RED
			}
		end
		if context.joker_main then 
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa__IrYs',
	
	loc_txt = {
		name = 'Futa love',
		text = {
			
			"If played hand contains {C:attention}2{}",
			"or more {C:attention}Queens{}, {X:chips,C:white}X#1#{} Chips"
		}
	},
	
	config = { extra = { XChips = 2, queen_count = 0 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.XChips, card.ability.extra.queen_count} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 0 },
	
	cost = 4,
    slug = "j_futa",
	

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and context.other_card:get_id() == 12 then
			card.ability.extra.queen_count = card.ability.extra.queen_count + 1 
			print(card.ability.extra.queen_count)
		end
		if context.joker_main and card.ability.extra.queen_count >= 2 then
			return {
				xchips = card.ability.extra.XChips
			}
		end
		if context.end_of_round then
			card.ability.extra.queen_count = 0
		end	
	end
}

SMODS.Joker {
	
	key = 'j_fuet_dokianal',
	
	loc_txt = {
		name = 'Aftermath',
		text = {
			
			"Gives {X:mult,C:white}X7{} mult"
		}
	},
	
	config = { extra = { Xmult = 7 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	
	rarity = 4,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 0 },
	
	cost = 10,
	
	in_pool = function(self) -- make sure it can't spawn or be summoned
		return false 
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult
			}
		end
	end
}

-- SMODS.Joker {
	
-- 	key = 'j_futa_chart',
	
-- 	loc_txt = {
-- 		name = 'Its a contest',
-- 		text = {
			
-- 			"Every Futa Joker gives +X1.5"
-- 		}
-- 	},
	
-- 	config = { extra = { Xmult = 1.5 } },
	
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { card.ability.extra.Xmult } }
-- 	end,
	
-- 	rarity = 1,
	
-- 	atlas = 'feetandfuta',
	
-- 	pos = { x = 2, y = 4 },
	
-- 	cost = 2,

--     soul_pos = { x = 1, y = 4 },
--     slug = "j_futa",
	
-- 	calculate = function(self, card, context)
-- 		if context.other_joker then
-- 			for _, key in context.other_joker do
-- 				if is_futa(context.other_joker[key].key) then
-- 					return {
-- 						Xmult = card.ability.extra.Xmult
-- 					}
-- 				end
-- 			end
-- 		end
-- 	end
-- }
------------------------------------------------------------pAGE TWO--------------------------------------------------------------------------------------------
SMODS.Joker {
	
	key = 'j_futa_splatdance',
	
	loc_txt = {
        name = 'Night Out',
        text = {
            "IF your played hand",
			"contains {C:attention}BOTH{} {C:spades}Spades{} and {C:hearts}Hearts{},",
            "every scored card gains {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult."
        }
    },
	
	config = { extra = { chip_bonus = 30, mult_bonus = 4} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_bonus, card.ability.extra.chip_bonus  } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 4 },
	
	cost = 4,

    slug = "j_futa",
	
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local has_spades = false
            local has_hearts = false
            for _, other_card in ipairs(G.play.cards) do
                if other_card:is_suit('Spades') then
                    has_spades = true
                end
                if other_card:is_suit('Hearts') then
                    has_hearts = true
                end
            end
            if has_spades and has_hearts then
				has_spades = false
            	has_hearts = false
                return {
                    chips = card.ability.extra.chip_bonus,
                    mult = card.ability.extra.mult_bonus
                }
            end
        end
    end
}

SMODS.Joker {
	
	key = 'j_feet_Lana',
	
	loc_txt = {
		name = 'Mother stench',
		text = {
			
			"Every played {C:chips}Club{} card", "gives {C:chips}+#2#{} Chips and {C:mult}+#1#{} Mult"
		}
	},
	
	config = { extra = { mult = 5, chips = 30 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 4 },
	
	cost = 2,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit('Clubs') then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end

	end
}

SMODS.Joker {
	
	key = 'j_feet_Peko',
	
	loc_txt = {
		name = 'Pekomama',
		text = {
			
			"Every played {C:hearts}Heart{} card",
			"gives {C:chips}+#2#{} Chips and {C:mult}+#1#{} Mult"
		}
	},
	
	config = { extra = { mult = 5, chips = 30 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 5 },
	
	cost = 5,

    soul_pos = { x = 0, y = 5 },
    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit('Hearts') then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Twins',
	
	loc_txt = {
		name = 'Two pairs of soles',
		text = {
			
			" If the hand is a {C:attention}Two Pair{} gain {X:chips,C:white}X#1#{}"
		}
	},
	
	config = { extra = { Xchips = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xchips } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 5 },
	
	cost = 5,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		-- next(context.poker_hands['bery_Twoplush'])
		if context.before and next(context.poker_hands['Two pair']) and not context.blueprint then
			return{
				Xchips = card.ability.extra.Xchips,
			}
		end
			
	end
}
SMODS.Joker {
	
	key = 'j_feet_selen',
	
	loc_txt = {
		name = 'Freshly Opened',
		text = {
			
			"Every {C:attention}Booster pack{} Opened gives {X:mult,C:white}+X#3#{}", 
			"But every hand {X:mult,C:white}-X#2#{}", 
			"{C:inactive}(currently {X:mult,C:white}X#1#{}{C:inactive}){}"
		}
	},
	
	config = { extra = { Xmult = 1, Xmult_loss = 0.5, Xmult_gain = 0.3 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_loss, card.ability.extra.Xmult_gain } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 5 },
	
	cost = 8,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult,
			}
		elseif context.after then
			card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_loss
			return {
				message = "-X0.5"
			}
		end
		if context.open_booster then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = "+X0.3",
				colour = G.C.Red
			}
		end

	end
}

SMODS.Joker {
	
	key = 'j_futa_mirko',
	
	loc_txt = {
		name = 'Mirkos GIANT CO-',
		text = {
			"Every played {C:spades}Spade{} card",
			"gives {C:chips}+#2#{} Chips and {C:mult}+#1#{} Mult"
		}
	},
	
	config = { extra = { mult = 5, chips = 30 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 5 },
	
	cost = 5,

    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit('Spades') then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
	end
}

-- SMODS.Joker {
	
-- 	key = 'j_feet_pantyhosefeet',
	
-- 	loc_txt = {
-- 		name = 'A sole worker',
-- 		text = {
			
-- 			"{C:mult}+#1# {} Mult"
-- 		}
-- 	},
	
-- 	config = { extra = { mult = 100 } },
	
-- 	loc_vars = function(self, info_queue, card)
-- 		return { vars = { card.ability.extra.mult } }
-- 	end,
	
-- 	rarity = 1,
	
-- 	atlas = 'feetandfuta',
	
-- 	pos = { x = 0, y = 6 },
	
-- 	cost = 2,

--     slug = "j_feet",
	
-- 	calculate = function(self, card, context)
		
-- 		if context.joker_main then
			
-- 			return {
-- 				mult_mod = card.ability.extra.mult,
				
-- 				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
-- 			}
-- 		end
-- 	end
-- }

SMODS.Joker {
	
	key = 'j_feet_dp',
	
	loc_txt = {
		name = 'Double Trouble',
		text = {
			
			"Playing a {C:attention}Two-pair{} ",
			"Gives {X:mult,C:white}X#1#{} Mult"
		}
	},
	
	config = { extra = { Xmult = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 6 },
	
	cost = 5,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		local pair = false
		if context.joker_main then
			if context.poker_hands['Two Pair'] then
				return {
					Xmult_mod = card.ability.extra.Xmult,
					message = "X2",
					colour = G.C.Red
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Fromuppper',
	
	loc_txt = {
		name = 'Looking up',
		text = {
			"{C:attention}+#2#{} hand size per {C:mult}Discard{}",
            "{C:attention}-#2#{} hand size per {C:chips}Hand{} played",
            "Resets every round",
            "{C:inactive}(Currently {C:attention}+#1#{C:inactive} hand size)"
		}
	},
	
	config = { extra = { current_h_size = 0, h_mod = 1} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.current_h_size, card.ability.extra.h_mod }}
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 6 },
	
	cost = 3,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		-- Decrease hand size
		if context.joker_main then
			if card.ability.extra.current_h_size > 0 then
				card.ability.extra.current_h_size = card.ability.extra.current_h_size - card.ability.extra.h_mod
				G.hand:change_size(-card.ability.extra.h_mod)
				-- Decrease message
				return {
					message = "Hand Size Down"
				}
			end
		end
		-- Increase hand size
		if context.pre_discard then
			card.ability.extra.current_h_size = card.ability.extra.current_h_size +  card.ability.extra.h_mod
			G.hand:change_size(card.ability.extra.h_mod)
			-- Increase message
			return {
				message = "Hand Size up"
			}
		end
		if context.end_of_round and not context.individual and not context.repetition then
			if card.ability.extra.current_h_size ~= 0 then
				G.hand:change_size(-card.ability.extra.current_h_size)
				card.ability.extra.current_h_size = 0
				-- Reset message
				return {
					message = "Reset"
				}
			end
		end

	end
}

SMODS.Joker {
	
	key = 'j_futa_tori',
	
	loc_txt = {
		name = "A Mothers load",
		text = {
			
			"{C:green}#4# in #5#{} chance of gaining {C:money}$#1#{} at the end of the round",
            "self destructs after 3 turns",
            "{C:inactive}(Rounds Left {C:attention}#2#{}{C:inactive}/3){}"
		}
	},
	
	config = { extra = { money = 25, counter = 0, max_count = 3, Xmult = 0.5, odds = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.counter, card.ability.extra.max_count, card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds  } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 6 },
	
	cost = 5,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then    
			if card.ability.extra.counter >= card.ability.extra.max_count then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end
						}))
						return true
					end
				}))
				return {
					message = "Empty!", 
					colour = G.C.GREY
				}
			else
				card.ability.extra.counter = card.ability.extra.counter + 1
				return {
					counter = card.ability.extra.counter,
					message = "+1 round",
					colour = G.C.ORANGE,
				}
			end
		end
		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult,
			}
		end
	end,
	calc_dollar_bonus = function(self, card)
		if pseudorandom('Futasumta') < G.GAME.probabilities.normal / card.ability.extra.odds then
			local bonus = card.ability.extra.money
			if bonus > 0 then 
				return bonus 
			end
		end
	end
	
}

SMODS.Joker {
	
	key = 'j_feet_towa',
	
	loc_txt = {
		name = 'devils Lattice',
		text = {
			
			"If hand is a {C:Attention}Flush{} ", 
			"gain {C:mult}+#1#{} but {C:chips}#2#{} chips"
		}
	},
	
	config = { extra = { mult = 40, chips_loss = -40 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips_loss } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 6 },
	
	cost = 5,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.before and next(context.poker_hands['Flush']) and not context.blueprint then
			return {
				mult = card.ability.extra.mult, 
				chips = card.ability.extra.chips_loss,
				card = card
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa_splat_orgy',
	
	loc_txt = {
		name = 'A Grandfest',
		text = {
			
			"If {C:chips}+50{} chips for every {C:attention}Futa{} joker"
		}
	},
	
	config = { extra = { chips = 5, chips_add = 50 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips_add} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 7 },
	
	cost = 5,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.other_joker then
			if string.find(context.other_joker.config.center.key, "j_futa") then
				return {
					chip_mod = card.ability.extra.chips_add,
					card = other_joker,
					message = "+50",
					colour = G.C.chips
				}
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_feet_footlick',
	
	loc_txt = {
		name = 'Self love',
		text = {
			
			"if scored hand is only",
            "{C:attention}One{} card {X:mult,C:white}X#1#{} mult", 
			"But if more than One {X:mult,C:white}X#2#{}"
		}
	},
	
	config = { extra = { Xmult = 3, Xmult_loss = 0.25, count = 0, } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_loss } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 7 },
	
	cost = 6,
    slug = "j_feet",
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			card.ability.extra.count = card.ability.extra.count + 1
		end
		if context.joker_main and not context.repetition then 
		 	if card.ability.extra.count == 1 then
				card.ability.extra.count = 0  
				return {
					xmult = card.ability.extra.Xmult,
				}
			else
				card.ability.extra.count = 0 
				return {
					xmult = card.ability.extra.Xmult_loss,
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_frog smell',
	
	loc_txt = {
		name = 'Addiction',
		text = {
			
			"If Hand is a {C:attention}Pair{},",
			"{C:mult}+#1#{} Mult and {C:chips}+#2#{} chips",
            "But if Hand {C:red}doesn't{} contain a {C:attention}Pair{}",
			"{C:mult}#3#{} Mult and {C:chips}#4#{} Chips"
		}
	},
	
	config = { extra = { mult = 25, chip = 50, mult_loss = -50, chips_loss = -25  } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chip, card.ability.extra.mult_loss, card.ability.extra.chips_loss } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 7 },
	
	cost = 2,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.joker_main then 
			if next(context.poker_hands["Pair"]) then
				return {
					mult = card.ability.extra.mult,
					chip = card.ability.extra.chip,
				}
			end
			if not next(context.poker_hands["Pair"]) then
				return {
					mult = card.ability.extra.mult_loss,
					chip = card.ability.extra.chips_loss,
				}
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_gardivoir',
	
	loc_txt = {
		name = 'Alpha cock',
		text = {
			
			"For each Scored {C:diamonds}Diamond{} Card gain {C:mult}+#2#{} Mult",
            "{C:inactive}(Current Mult: {}{C:mult}#1#{}{C:inactive}){}"
		}
	},
	
	config = { extra = { mult = 2, mult_gain = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 7 },
	
	cost = 4,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit('Diamonds') then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
		
	end
}
SMODS.Joker {
	
	key = 'j_foot_collection',
	
	loc_txt = {
		name = 'Surrounded',
		text = {
            "Every {C:attention}Foot{} Joker gives {X:mult,C:white}X1.5{} Mult"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 7 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
------- get back to this one -----------
SMODS.Joker {
	
	key = 'j_foot_boot',
	
	loc_txt = {
		name = 'Trapped?',
		text = {
            "If the lowest {C:attention}Played{} card is a {C:attention}2, 3, {}or {C:attention}4{},",
			"it gets an additional {C:mult}+#1#{} mult",
			" for every {C:attention}Face{} card in the {C:attention}hand{}",
		}
	},
	
	config = { extra = { mult = 5, faceCardAmount = 0 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 8 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		-- if context.individual and context.cardarea == G.hand and not context.repetition then
		-- 	if context.other_card:get_id() == 11 or context.other_card:get_id() == 12 or context.other_card:get_id() == 13 then
		-- 		card.ability.extra.faceCardAmount = card.ability.extra.faceCardAmount + 1
		-- 	end
		-- end
		-- if context.individual and context.cardarea == G.play and not context.repetition then
		-- 	if context.other_card:get_id() == 4 or context.other_card:get_id() == 3 or context.other_card:get_id() == 2 then
		-- 		local final_mult = card.ability.extra.mult * card.ability.extra.faceCardAmount
		-- 		if final_mult ~= 0 then
		-- 			return {
		-- 				mult = final_mult,
		-- 				card = context.other_card
		-- 			}
		-- 			card.ability.extra.faceCardAmount = 0
		-- 		else
		-- 			print("error")
		-- 		end
		-- 	end
		-- end
	end
}

SMODS.Joker {
	
	key = 'j_foot_smuthered',
	
	loc_txt = {
		name = 'A mouthfull',
		text = {
            "Every played {C:attention}Flush{} gain {C:mult}+#2#{} mult",
			"{C:inactive}(currently {C:mult}+#1#{C:inactive})"
		}
	},
	
	config = { extra = { mult = 5, mult_gain = 5} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,card.ability.extra.mult_gain} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 8 },
	
	cost = 5,
    slug = "j_foot",
	soul_pos = {x=1,y=8},
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
		if context.before and next(context.poker_hands['Flush']) and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
		end
		
	end
}
SMODS.Joker {
	
	key = 'j_foot_MIlfcircle',
	
	loc_txt = {
		name = 'Worship Circle',
		text = {
            "If Played {C:attention}hand{} is a {C:attention}Two Pair{} then ",
			"every played{C:attention} EVEN{} card gives {C:mult}+#1#{} mult",
			
		}
	},
	
	config = { extra = { mult = 10,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 8 },
	
	cost = 5,
    slug = "j_foot",
	tp = false,
	
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Two Pair']) and not context.blueprint then
			card.tp = true
		end
		if context.individual and context.cardarea == G.play and not context.repetition and not context.blueprint then
			if card.tp then 
				if context.other_card:get_id() % 2 == 0 then
					return {
						mult = card.ability.extra.mult,
						card = other_card
					}
				end
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_foot_mirrored',
	
	loc_txt = {
		name = 'Sole reflection',
		text = {
            "If Played {C:attention}hand{} contains a",
			"{C:attention}Pair{} with exactly the same", 
			"{C:attention}suit{} and {C:attention}rank{} then {X:mult,C:white}X3{} mult"
		}
	},
	
	config = { extra = { xmult = 3,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 8 },
	
	cost = 7,
    slug = "j_foot",
	vaild_hand = false,

	calculate = function(self, card, context)
		local cards123 = {}
		if context.cardarea == G.play and not context.blueprint then
			for k, v in ipairs(G.play.cards) do
				table.insert(cards123, {v:get_id(), v.base.suit})
			end
			local seen = {}
			for _, v in ipairs(cards123) do
				local key = v[1] .. "_" .. v[2] 
				
				if seen[key] == nil then
					seen[key] = true
					
				else
					card.vaild_hand = true
					break
				end
			end
		end
		if context.joker_main and not context.repetition and card.vaild_hand then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_foot_under',
	
	loc_txt = {
		name = 'Hidden Enjoyment',
		text = {
            "Each hand played gain {X:mult,C:white}+X#2#{} mult,", 
			"But if a {C:attention}Full house{} or {C:attention}Flush{} is",
			"played {C:mult}Lose all mult gained",
			"{C:inactive}(currently: {X:mult,C:white}X#1#{C:inactive})"
		}
	},
	
	config = { extra = { xmult = 1, xmult_gain = 0.2} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain,} }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 9 },
	
	cost = 8,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.after then 
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
			return {
				message = "upgrade"
			}
		end
		if context.before and (next(context.poker_hands['Flush']) or next(context.poker_hands['Full House'])) and not context.blueprint and not context.repetition then
			card.ability.extra.xmult = 1
			return {
				message = "reset",
			}
		end
		if context.joker_main and not context.repetition then
			return {
				xmult = card.ability.extra.Xmult
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa_facial',
	
	loc_txt = {
		name = 'Facial',
		text = {
            "Every Hand there is a 1/2 chance",
			"for a random played card to gain", 
			"a foil Enhancement"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 9 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_dickspread',
	
	loc_txt = {
		name = 'Spread',
		text = {
            "Every {C:attention}Foot{} Joker gives {X:mult,C:white}X1.5{} Mult"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 9 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa__taker',
	
	loc_txt = {
		name = 'Taker POV',
		text = {
            "Every {C:attention}Foot{} Joker gives {X:mult,C:white}X1.5{} Mult"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 9 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_Coffee',
	
	loc_txt = {
		name = 'Mommy!, Sorry. Mommy! Sorr-',
		text = {
            "Replay all {C:attention}Queen{} cards"
		}
	},
	
	config = { extra = {repetitions = 1} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 9 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 12 then
				return {
					message = 'Sorry!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		end
	end
}
SMODS.Joker {

	key = 'j_futa_isekai_blow',
	
	loc_txt = {
		name = 'Deep',
		text = {
            "Every {C:mult}discard{} gains {X:mult,C:white}X#2#{} mult, But",
			"every {C:mult}discarded{} card {C:attention}-1 Hand size{}",
			"{C:mult}resets{} every {C:attention}hand{}",
			"{C:inactive}(currently: {X:mult,C:white}X#1#{C:inactive})"
		}
	},
	
	config = { extra = { xmult = 1, current_loss= 0, xmult_gain = 2} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain} }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 10 },
	
	cost = 8,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.pre_discard then 
			card.ability.extra.current_loss = card.ability.extra.current_loss + #G.hand.highlighted
			G.hand:change_size(-#G.hand.highlighted)
			card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.xmult_gain*#G.hand.highlighted)
			return {
				message = "Upgraded"
			}
		end
		if context.after and not context.repetition then
			if card.ability.extra.current_loss ~= 0 then 
				G.hand:change_size(card.ability.extra.current_loss)
			end
			card.ability.extra.current_loss = 0
			card.ability.extra.xmult = 1
			return {
				message = "Reset"
			}
		end
		if context.joker_main and not context.repetition then
			return {
				xmult = card.ability.extra.xmult
			} 
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_demon',
	
	loc_txt = {
		name = 'Demonic Judgement',
		text = {
            "Every {C:attention}Foot{} Joker gives {X:mult,C:white}X1.5{} Mult"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 10 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_holoen',
	
	loc_txt = {
		name = 'House party',
		text = {
			"If Played hand contains a {C:attention}Full House{}",
			"and has 4 different suits and",
			"{C:attention}Two{} or more {C:attention}Queens{} then {X:mult,C:white}X5{}"
		}
	},
	
	config = { extra = { xmult = 5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 10 },
	
	cost = 5,
    slug = "j_foot",
	vaild_hand = false,
	
	calculate = function(self, card, context)
		local cards123 = {}
		if context.cardarea == G.play and not context.blueprint and not context.repetition then
			for k, v in ipairs(G.play.cards) do
				table.insert(cards123, {v:get_id(),v.base.suit})
			end
			local seen = {}
			local queenscount = 0
			for _, v in ipairs(cards123) do
				local key = v[2] 
				
				if seen[key] == nil then
					seen[key] = true
				end
				if v[1] == 12 then
					queenscount = queenscount + 1
				end
			end
			local count = 0
			for _ in pairs(seen) do 
				count = count + 1 
			end
			if count==4 and queenscount >= 2 and next(context.poker_hands['Full House']) then
				card.vaild_hand = true
			else 
				card.vaild_hand = false
			end
		end

		if context.joker_main and card.vaild_hand then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_sana_earth',
	
	loc_txt = {
		name = 'Limiter off',
		text = {
            "If played hand is a {C:attention}Full House{}",
			"then gain {X:mult,C:white}X#2#{}",
			"{C:inactive}(Current mult: {X:mult,C:white}X#1#{}{C:inactive}){}"
		}
	},
	
	config = { extra = { xmult = 1, xmultgain = 0.2} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,card.ability.extra.xmultgain} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 10 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Full House']) and not context.repetition and not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultgain
		end
		if context.joker_main and not context.repetition then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_fuet_tsunade',
	
	loc_txt = {
		name = "Shinobi's Tool Belt",
		text = {
            "Every {C:attention}Foot{} Joker gives {X:mult,C:white}X1.5{} Mult"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 10 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
SMODS.Joker {
	
	key = 'j_foot_wet',
	
	loc_txt = {
		name = 'Soaked',
		text = {
            "Every {C:attention}Foot{} Joker gives {X:mult,C:white}X1.5{} Mult"
		}
	},
	
	config = { extra = { xmult = 1.5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0,y = 11 },
	
	cost = 5,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if context.other_joker and string.find(context.other_joker.config.center.key, "j_feet") and context.other_joker ~= self then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}
--------- VOUCHER -----------
SMODS.Voucher {
	key = "Toe",
	loc_txt = {
		name = "Toes",
		text = {"Nice to look at...", "{C:inactive}does nothing..{}"},
	},
	atlas = 'vouch',
    pos = {x= 1, y = 0},
	config = {unlocked = true, discovered = true},
	cost = 10,
	redeem = function(self, card)
	end
}

SMODS.Voucher {
    key = "Sole",
    loc_txt = {
        name = "Soles",
        text = {"A Card for Each Foot!",
			"{C:attention}+2{} Joker slots"}
    },
    atlas = 'vouch',
    pos = {x= 0, y = 0},
    config = {
        unlocked = false, discovered = true
    },
    cost = 15,
	requires = {"v_bery_Toe"},
	redeem = function(self, card)
        if G.jokers then 
            G.jokers.config.card_limit = G.jokers.config.card_limit + 2
        end
    end
}

