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


-- local joker_keys = {
--     "j_feet_mirko_ice",
--     "j_feet_pearl",
--     "Marina_Meat",
--     "Pearls_meal",
--     "j_feet_ghost",
--     "Doki",
--     "j_feet_dandandan",
--     "j_fuet_splatoon",
--     "j_feet_pantyhose",
--     "j_feet_Tripple",
--     "j_feet_Cum",
--     "j_feet_Steamly",
--     "j_feet_Roboco",
--     "j_futa__IrYs",
--     "dokianal",
--     "j_futa_chart",
--     "j_futa_splatdance",
--     "j_feet_Lana",
--     "j_feet_Peko",
--     "j_feet_Twins",
--     "j_feet_selen",
--     "j_feet_marie",
--     "j_feet_pantyhosefeet",
--     "j_feet_dp",
--     "j_feet_Fromuppper",
--     "j_futa_tori",
--     "j_feet_towa",
--     "j_futa_splat_orgy",
--     "j_feet_footlick",
--     "j_feet_frog smell",
--     "j_futa_gardivoir",
--     "j_foot_collection"
-- }


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


SMODS.Joker {
	key = 'j_feet_mirko_ice',
	loc_txt = {
		name = "Mirko's cooling",
		text = {
			"Start with {C:mult}+100 Mult{}",
            "and {C:chips}+0{} Chips, each hand",
            "{C:mult}-#2# mult{} and {C:chips}+#4# Chips{}",
            "{C:inactive}(Currently {C:mult}+#1#{} and {C:chips}+#3#)"
		}
	},
	config = { extra = { mult = 100, mult_gain = 4, chip = 0, chip_gain = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chip, card.ability.extra.chip_gain } }
	end,
	rarity = 1,
	atlas = 'feetandfuta',
	pos = { x = 3, y = 2 },
	cost = 2,
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
		name = 'Pearly toes',
		text = {
			
			"Earn {C:money}$5{}, At the",
            "end of round after",
            "three round gain {C:money}+$#3#",
            "{C:inactive}(Currently round #2# of 3){}", 
            "{C:inactive}(current earning {C:money}$#1#{})"
		}
	},
	
	config = { extra = { money = 5, counter = 0, money_gain = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.counter,  card.ability.extra.money_gain  } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 3 },
	
	cost = 4,

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
	key = 'Marina_Meat',
	loc_txt = {
		name = 'Marina Meat',
		text = {
			"Each Scored {C:attention}Ace{} of Spades",
			"gives {C:mult}+#1#{} Mult when scored"
			
		}
	},
	config = { extra = {mult = 20 } },
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
	
	key = 'Pearls_meal',
	
	loc_txt = {
		name = "Pearj_meal",
		text = {
			
			"Each Scored {C:attention}Ace{} of Spades",
            " gives {C:chips}+#1#{} Chips"
		}
	},
	
	config = { extra = { chips = 20 } },
	
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
					local card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('perkeo2')), nil)
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
			
			"Every Scoring King ",
            "gives {X:mult,C:white}X#1#{} mult"
		}
	},
	
	config = { extra = { Xmult = 3,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 1 },
	
	cost = 4,
	
	calculate = function(self, card, context)
		local king
		
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 13 then
				return {
					Xmult_mod = card.ability.extra.Xmult,
					message = "X3",
					card = other_card
				}
				-- If all conditions are met, return the result
				
			else 
				king = false
			end
			if king and context.joker_main and next(context.poker_hands['Straight']) and not context.blueprint then
				return {
					Xmult_mod = card.ability.extra.Xmult,
					message = "X5",
					card = card
				}
			end
		end
	end
	
	
}   

SMODS.Joker {
	
	key = 'j_feet_dandandan',
	
	loc_txt = {
		name = "Arch Support",
		text = {
			"{C:mult}+#1#{} {C:mult}Mult{} if scored",
            " cards are 10 or below"
		}
	},
	
	config = { extra = { mult_mod = 5 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_mod } }
	end,
	
	rarity = 3,
	
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
		name = 'show off',
		text = {
			
			"Each Jack gives ",
			"{X:mult,C:white}X#1#{} Mult when Scored"
		}
	},
	
	config = { extra = { Xmult = 1.5 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult} }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 3 },
	
	cost = 7,
    slug = "j_feet",
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
			
			"{C:mult}+#1# {} Mult"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 2 },
	
	cost = 2,

	slug = "j_feet",

    soul_pos = { x = 0, y = 2 },
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Tripple',
	
	loc_txt = {
		name = 'Triple stench',
		text = {
			
			"if play hand is a Three of a kind flush X2 mult"
		}
	},
	
	config = { extra = { Xmult = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 0 },
	
	cost = 2,
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
			
			"{C:mult}+#1# {} Mult"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 0 },
	
	cost = 2,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Steamly',
	
	loc_txt = {
		name = 'Motherly Nylon Soles',
		text = {
			
			"if a full house is play X1.5"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 2 },
	
	cost = 2,
    slug = "j_feet",

	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Roboco',
	
	loc_txt = {
		name = 'Metal Grippers',
		text = {
			
			"Playing exactly 4 cards gives +25 mult"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 3 },
	
	cost = 2,
    slug = "j_feet",

	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa__IrYs',
	
	loc_txt = {
		name = 'Futa love',
		text = {
			
			"If played hand contains 2 or more queens gain +30 Chips"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 0 },
	
	cost = 2,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'dokianal',
	
	loc_txt = {
		name = 'Aftermath',
		text = {
			
			"{C:mult}+#1# {} Mult"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 0 },
	
	cost = 2,
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa_chart',
	
	loc_txt = {
		name = 'Its a contest',
		text = {
			
			"Every Futa Joker gives +X1.5"
		}
	},
	
	config = { extra = { Xmult = 1.5 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 4 },
	
	cost = 2,

    soul_pos = { x = 1, y = 4 },
    slug = "j_futa",
	
	calculate = function(self, card, context)
		-- if context.joker_main then
		-- 	if other_jokers == "runner" then
		-- 		return {
		-- 			Xmult = card.ability.extra.Xmult,
		-- 			message = "X1.5",
		-- 			colour = G.C.Red
		-- 		}
		-- 	end
		-- end
	end
}

SMODS.Joker {
	
	key = 'j_futa_splatdance',
	
	loc_txt = {
        name = 'Night Out',
        text = {
            "When your hand contains both Spades and Hearts,",
            "gain +40 Chips and +2 Mult."
        }
    },
	
	config = { extra = { chip_bonus = 40, mult_bonus = 2} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_bonus, card.ability.extra.chip_bonus  } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 4 },
	
	cost = 3,

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
                return {
                    chips = card.ability.extra.chip_bonus,
                    mult = card.ability.extra.mult_bonus,
                    message = "Duet! Spades and Hearts present, bonus applied."
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
			
			"every {C:Blue}Club{} card gives {C:chips}+#2#{} Chips and {C:mult}+#1#{} Mult"
		}
	},
	
	config = { extra = { mult = 15, chips = 10 } },
	
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
			
			"every Heart gives",
			 "{C:chips}+#2#{} chips and {C:mult}+#1#{} mult"
		}
	},
	
	config = { extra = { mult = 15, chips = 10 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 5 },
	
	cost = 2,

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
			
			" If the hand is a 2 Pair Flush give {X:mult,C:white}X#1#{}"
		}
	},
	
	config = { extra = { Xmult = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 5 },
	
	cost = 2,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['bery_Twoplush']) and not context.blueprint then
			return{
				Xmult_mod = card.ability.extra.Xmult,
				message = localize { type = 'variable', key = 'a_Xmult', vars = { card.ability.extra.Xmult } }
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
			"{C:inactive}(currently {X:mult,C:white}X#1#{}){}"
		}
	},
	
	config = { extra = { Xmult = 1, Xmult_loss = 0.5, Xmult_gain = 0.25 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_loss, card.ability.extra.Xmult_gain } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 5 },
	
	cost = 6,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_loss
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
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
				message = "+X0.25",
				colour = G.C.Red
			}
		end

	end
}

SMODS.Joker {
	
	key = 'j_feet_marie',
	
	loc_txt = {
		name = 'Surporting stirups',
		text = {
			
			"{C:mult}+#1# {} Mult"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 5 },
	
	cost = 2,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_pantyhosefeet',
	
	loc_txt = {
		name = 'A sole worker',
		text = {
			
			"{C:mult}+#1# {} Mult"
		}
	},
	
	config = { extra = { mult = 100 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 6 },
	
	cost = 2,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.joker_main then
			
			return {
				mult_mod = card.ability.extra.mult,
				
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
				
			}
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_dp',
	
	loc_txt = {
		name = 'Double Trouble',
		text = {
			
			"Playing a Two-pair ",
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
	
	cost = 3,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		local pair = false
		if context.joker_main then
			if context.poker_hands['Two Pair'] then
				return {
					Xmult_mod = card.ability.extra.Xmult,
					message = "X2"
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
			"{C:attention}+#2#{} hand size per discard",
            "{C:attention}-#2#{} hand size per hand played",
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
	
	cost = 2,
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
		name = "A mother-load",
		text = {
			
			"Gain {C:money}$50{} at the end of the round",
            "self destructs after 3 turns",
            "{C:inactive}(Rounds Left {C:attention}#2#{}{C:inactive}/3){}"
		}
	},
	
	config = { extra = { money = 50, counter = 0, max_count = 3, Xmult = 0.5 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.counter, card.ability.extra.max_count, card.ability.extra.Xmult } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 6 },
	
	cost = 2,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then    
			if card.ability.extra.counter >= card.ability.extra.max_count - 1 then
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
		local bonus = card.ability.extra.money
		if bonus > 0 then 
			return bonus 
		end
	end
	
}

SMODS.Joker {
	
	key = 'j_feet_towa',
	
	loc_txt = {
		name = 'devils Lattice',
		text = {
			
			"If hand is a {C:Attention}Flush{} ", 
			"gain {C:mult}+#1#{} but {C:chips}-#2#{} chips"
		}
	},
	
	config = { extra = { mult = 50, chips_loss = 50 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips_loss } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 6 },
	
	cost = 2,
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
	
	key = 'j_futa_splat_orgy  ',
	
	loc_txt = {
		name = 'A Grandfest',
		text = {
			
			"If +50 chips for every futa joker"
		}
	},
	
	config = { extra = { chips = 5, chips_add = 145 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips_add} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 7 },
	
	cost = 5,7,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.other_joker then
			if string.find(context.other_joker.config.center.key, "j_futa") then
				return {
					chip_mod = card.ability.extra.chips_add,
					card = other_joker,
					message = "+50"
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
			"but if more than one lose {X:mult,C:white}-X#2#{}"
		}
	},
	
	config = { extra = { Xmult = 3, Xmult_loss = 0.25 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_loss } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 7 },
	
	cost = 6,
    slug = "j_feet",
	
	calculate = function(self, card, context)
		
		if context.final_scoring_step and next(context.poker_hands['High Card']) and not context.blueprint then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.Xmult } }
				
			}
		elseif context.final_scoring_step then
			if not next(context.poker_hands['High Card']) then
				card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_loss
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_frog smell',
	
	loc_txt = {
		name = 'adiction',
		text = {
			
			"If Hand is a {C:attention}pair{},",
			"{C:mult}+100{} mult and {C:chips}+50{} chips",
            "But is hand is {C:attention}not{} a {C:attention}Pair{}",
			"{C:mult}-100{} mult and {C:chips}-50{} chips"
		}
	},
	
	config = { extra = { mult = 100, chip = 50, mult_loss = -100, chips_loss = -50  } },
	
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
					message = "+50",
					colour = G.C.Chips
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
			
			"for each scored diamond card gain {C:mult}+#2#{} Mult",
            "{C:inactive}(Current Mult: {C:mult}#1#{}){}"
		}
	},
	
	config = { extra = { mult = 2, mult_gain = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 7 },
	
	cost = 2,
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
            "Every foot joker gives 1.5 muilt"
		}
	},
	
	config = { extra = { mult = 2, mult_gain = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 7 },
	
	cost = 2,
    slug = "j_foot",
	
	calculate = function(self, card, context)

	end
}
--------- voucher -----------


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
        unlocked = true, discovered = true
    },
    cost = 10,
	redeem = function(self, card)
        if G.jokers then 
            G.jokers.config.card_limit = G.jokers.config.card_limit + 2
        end
    end
}

