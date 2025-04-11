local data, err = SMODS.load_file('util.lua', "BERRY")
local ok, util = pcall(data)

function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

local function forced_message(message, card, color, delay, juice)
    if delay == true then
        delay = 0.7 * 1.25
    elseif delay == nil then
        delay = 0
    end

    G.E_MANAGER:add_event(Event({trigger = 'before', delay = delay, func = function()

        if juice then juice_card(juice) end

        card_eval_status_text(
            card,
            'extra',
            nil, nil, nil,
            {message = message, colour = color, instant = true}
        )
        return true
    end}))
end

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
SMODS.Sound({key = 'slam', path = 'slam.ogg'})

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

-------------- FRIST PAGE ----------------------
SMODS.Joker {
	key = 'j_feet_mirko_ice',
	loc_txt = {
		name = "Mirko's Cooling",
		text = {
			"Start with {C:mult}+100 Mult{} and {C:chips}+0{} Chips",
            "Each Hand {C:mult}-#2# mult{} and {C:chips}+#4#{} Chips",
            "{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} and{} {C:chips}+#3#{C:inactive}){}"
		},
		boxes = {2, 1}
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
		if not card.debuff then
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
		},
		boxes = {3,1}
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
		if not card.debuff then
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
		if not card.debuff then
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
	end
}

SMODS.Joker {
	
	key = 'j_futa_Pearls_meal',
	
	loc_txt = {
		name = "Pearls meal",
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
		if not card.debuff then
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
		if not card.debuff then
			if context.ending_shop and not context.blueprint and not context.repetition and not context.Brainstorm then
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
	end
}


SMODS.Joker {
    key = 'Doki',
    loc_txt = {
        name = 'Cock shock',
        text = {
            "Give {C:mult}+#1#{} mult",
            "A {C:purple}Special{} Joker is Made if the {C:attention}Card{} is",
			"in your hand for more than 3 rounds",
            "{C:inactive}(Rounds: {}{C:attention}#2#{}{C:inactive}/{}{C:attention}3{}{C:inactive}){}"
        },
		boxes = {3,1}
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
        if not card.debuff and context.joker_main then
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
		if not card.debuff then
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
	end
}

SMODS.Joker {
	
	key = 'j_fuet_splatoon',
	
	loc_txt = {
		name = 'Show Off',
		text = {
			
			"Each {C:attention}Jack{} gives ",
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
		if not card.debuff then
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
	end


}

SMODS.Joker {
	
	key = 'j_feet_pantyhose',
	
	loc_txt = {
		name = 'Working legs',
		text = {
			
			"{C:attention}+#1#{} {C:mult}discards{} each",
			"round, {C:attention}#2#{} {C:attention}hand size{}"
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
			"Score {X:mult,C:white}X2{} Mult"
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
		if not card.debuff then
			if context.before and next(context.poker_hands['bery_Threeflush']) and not context.blueprint then
				return {
					message = "X2",
					Xmult_mod = card.ability.extra.Xmult, 
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Cum',
	
	loc_txt = {
		name = 'Money shot',
		text = {
			
			"If Played Hand",
			"Contains a {C:attention}Pair{} {C:money}+$2{}"
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
		if not card.debuff then
			if context.before then 
				if next(context.poker_hands['Pair']) and not context.blueprint and not context.repetition then
					ease_dollars(2)
					return {
						message = "+6",
						colour = G.C.YELLOW
					}
				end
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Steamly',
	
	loc_txt = {
		name = 'Motherly Nylon Soles',
		text = {
			"If a {C:attention}Flush Five{}",
			"is played {X:mult,C:white}X#1#{} Mult"
		}
	},
	
	config = { extra = { mult = 3 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 2 },
	
	cost = 5,
    slug = "j_feet",

	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.joker_main and next(context.poker_hands['Flush Five']) and not context.blueprint then
				return {
					xmult = card.ability.extra.mult, 
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Roboco',
	
	loc_txt = {
		name = 'Metal Grippers',
		text = {
			
			"If hand has exactly {C:attention}4 cards{}",
			"every {C:attention}scored{} cards is {C:attention}CRUSHED{}",
			"Gain {C:mult,}+#2#{} mult",
			"{C:inactive}(Currently: +#1#){}"
		},
		boxes = {3,1}
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
		if not card.debuff then
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
	end
}

SMODS.Joker {
	
	key = 'j_futa__IrYs',
	
	loc_txt = {
		name = 'Futa Love',
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
		if not card.debuff then
			if context.cardarea == G.play and context.individual and context.other_card:get_id() == 12 then
				card.ability.extra.queen_count = card.ability.extra.queen_count + 1 
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
		if not card.debuff then
			if context.joker_main then
				return {
					Xmult = card.ability.extra.Xmult
				}
			end
		end
	end
}
------------------------------------------------------------pAGE TWO--------------------------------------------------------------------------------------------
SMODS.Joker {
	
	key = 'j_futa_splatdance',
	
	loc_txt = {
        name = 'Night Out',
        text = {
            "IF your played hand contains",
			"{C:attention}BOTH{} {C:spades}Spades{} and {C:hearts}Hearts{}, every",
            "scored card gains {C:mult}+#1#{} mult and {C:chips}+#2#{} chips."
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
		if not card.debuff then
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
    end
}

SMODS.Joker {
	
	key = 'j_feet_Lana',
	
	loc_txt = {
		name = 'Mother Stench',
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
		if not card.debuff then
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
		if not card.debuff then
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
	end
}

SMODS.Joker {
	
	key = 'j_feet_Twins',
	
	loc_txt = {
		name = 'Twins',
		text = {
			
			" If the hand is a",
			"{C:attention}Two Pair{} gain {X:chips,C:white}X#1#{}"
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
		if not card.debuff then
		-- next(context.poker_hands['bery_Twoplush'])
			if context.joker_main and next(context.poker_hands['Two Pair']) and not context.blueprint then
				return{
					xchips = card.ability.extra.Xchips,
				}
			end
		end
			
	end
}
SMODS.Joker {
	
	key = 'j_feet_selen',
	
	loc_txt = {
		name = 'Freshly Opened',
		text = {
			
			"Every {C:attention}Booster pack{} Opened", 
			"gives {X:mult,C:white}+X#3#{}, But every {C:attention}hand {X:mult,C:white}-X#2#{}", 
			"{C:inactive}(currently {X:mult,C:white}X#1#{}{C:inactive}){}"
		},
		boxes = {2,1}
	},
	
	config = { extra = { Xmult = 1, Xmult_loss = 0.4, Xmult_gain = 0.3 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_loss, card.ability.extra.Xmult_gain } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 5 },
	
	cost = 8,

    slug = "j_feet",
	
	calculate = function(self, card, context)
		if not card.debuff then
		
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
		if not card.debuff then
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
	end
}

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
		if not card.debuff then
			local pair = false
			if context.joker_main then
				if next(context.poker_hands['Two Pair']) and not next(context.poker_hands['Full House']) and not next(context.poker_hands['Three of a Kind']) then
					return {
						Xmult = card.ability.extra.Xmult,
						message = "X2",
						colour = G.C.Red
					}
				end
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_Fromuppper',
	
	loc_txt = {
		name = 'Looking Up',
		text = {
			"{C:attention}+#2#{} hand size per {C:mult}Discard{}",
            "{C:attention}-#2#{} hand size per {C:chips}Hand{} played",
            "Resets every round",
            "{C:inactive}(Currently {C:attention}+#1#{C:inactive} hand size)"
		},
		boxes = {2,1,1}
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
		if not card.debuff then
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
		name = "A Mothers Load",
		text = {
			
			"{C:green}#5# in #6#{} chance of gaining ",
            "{C:money}$#1#{} at the end of the round",
			"Self destructs after 3 round",
            "{C:inactive}(Rounds Left {C:attention}#2#{}{C:inactive}/3){}"
		},
		boxes = {2,1}
	},
	
	config = { extra = { money = 25, counter = 0, max_count = 3, Xmult = 0.5, odds = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.counter, card.ability.extra.max_count, card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
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
		name = 'Devils Lattice',
		text = {
			
			"If hand is a {C:attention}Flush{} ", 
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
		if not card.debuff then
			if context.joker_main and next(context.poker_hands['Flush']) and not context.blueprint then
				return {
					mult = card.ability.extra.mult, 
					chips = card.ability.extra.chips_loss,
				}
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_futa_splat_orgy',
	
	loc_txt = {
		name = 'A Grandfest',
		text = {
			
			"{C:chips}+#1#{} chips for",
			" every {C:attention}Futa{} joker"
		}
	},
	
	config = { extra = { chips_add = 75 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_add} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 7 },
	
	cost = 5,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.before and not context.blueprint and not context.repetition and context.other_joker then
				if string.find(context.other_joker.config.center.key, "j_futa") then
					return {
						chip = card.ability.extra.chips_add,
						card = other_joker,
					}
				end
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_feet_footlick',
	
	loc_txt = {
		name = 'Self Love',
		text = {
			
			"if scored hand is only",
            "{C:attention}One{} card {X:mult,C:white}X#1#{} mult", 
			"otherwise score {X:mult,C:white}X#2#{}"
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
	onecard = true,
	calculate = function(self, card, context)
		if context.cardarea == G.play and not context.blueprint and not context.repetition then
			if #context.scoring_hand == 1 then 
				self.onecard = true
			else 
				self.onecard = false
			end			
		end
		if context.joker_main and not context.repetition and not context.repetition_only and not card.debuff then
			if self.onecard == true then
				self.onecard = false
				return {
					xmult = card.ability.extra.Xmult,
				}
			elseif self.onecard == false then
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
			
			"If Hand does contain a {C:attention}Pair{}",
			"Score {C:mult}+#1#{} Mult and {C:chips}+#2#{} chips",
			"Otherwise {C:mult}#3#{} Mult and {C:chips}#4#{} Chips"
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
		if not card.debuff then
			if context.joker_main then 
				if next(context.poker_hands["Pair"]) then
					return {
						mult = card.ability.extra.mult,
						chips = card.ability.extra.chip,
					}
				end
				if not next(context.poker_hands["Pair"]) then
					return {
						mult = card.ability.extra.mult_loss,
						chips = card.ability.extra.chips_loss,
					}
				end
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_gardivoir',
	
	loc_txt = {
		name = 'Alpha Cock',
		text = {
		
			"For each Scored {C:diamonds}Diamond{}",
			"Card gain {C:mult}+#2#{} Mult",
            "{C:inactive}(Current Mult: {}{C:mult}#1#{}{C:inactive}){}"
		},
		boxes = {2, 1}
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
		if not card.debuff then
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
		
	end
}
SMODS.Joker {
	
	key = 'j_feet_collection',
	
	loc_txt = {
		name = 'Surrounded',
		text = {
            "Every {C:attention}Foot{} Joker",
			"gives {X:mult,C:white}X1.5{} Mult"
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
		if not card.debuff then
			if context.other_joker and context.other_joker ~= card then 
				if (string.find(context.other_joker.config.center.key, "j_feet") or string.find(context.other_joker.config.center.key, "j_fuet")) then
					print("")
					G.E_MANAGER:add_event(Event({
						func = function()
							context.other_joker:juice_up(0.5, 0.5)
							return true
						end
					})) 
					return {
						xmult = card.ability.extra.xmult,
					}
				end
			end
		end
	end
}
------------------------------------------------------------------- PAGE THREE -----------------------------------------------------------
SMODS.Joker {
	
	key = 'j_feet_boot',
	
	loc_txt = {
		name = 'Trapped?',
		text = {
            "If a {C:attention}Played{} card is",
			"{C:attention}2, 3, {}or {C:attention}4{}, score {C:mult}+#1#{}",
			"mult for every {C:attention}Face{} card in the {C:attention}hand{}",
		}
	},
	
	config = { extra = { mult = 9,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 8 },
	
	cost = 5,
    slug = "j_foot",
	faceCardAmount = 0,
	vaild_hand = false,
	
	calculate = function(self, card, context)
		if not card.debuff then
			local cards123 = {}
			if context.individual and context.cardarea == G.hand and not context.repetition then
				if context.other_card:is_face() then
					self.faceCardAmount = self.faceCardAmount + 1
				end
			end
			if context.individual and context.cardarea == G.play and not context.repetition then
				if context.other_card:get_id() == 4 or context.other_card:get_id() == 3 or context.other_card:get_id() == 2 then
					self.vaild_hand = true
				end
			end
			if context.joker_main and not context.repetition then 
				if self.faceCardAmount >= 0 and self.vaild_hand then
					return {
						mult = card.ability.extra.mult * self.faceCardAmount
					}
				end
			end
			if context.final_scoring_step then 
				self.faceCardAmount = 0
			end
		end
	end
}

SMODS.Joker {
	
	key = 'j_feet_smuthered',
	
	loc_txt = {
		name = 'A Mouthfull',
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
		if not card.debuff then
			if context.joker_main then
				return {
					mult = card.ability.extra.mult
				}
			end
			if context.before and next(context.poker_hands['Flush']) and not context.blueprint then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			end
		end
			
	end
}
SMODS.Joker {
	
	key = 'j_feet_medusa_m',
	
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
    slug = "j_feet",
	tp = false,
	
	calculate = function(self, card, context)
		if not card.debuff then
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
	end
}
SMODS.Joker {
	
	key = 'j_feet_mirrored',
	
	loc_txt = {
		name = 'Sole Reflection',
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
		if not card.debuff then
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
	end
}
SMODS.Joker {
	
	key = 'j_feet_under',
	
	loc_txt = {
		name = 'Hidden Enjoyment',
		text = {
            "Each hand played gain {X:mult,C:white}+X#2#{} mult,", 
			"But if a {C:attention}Full house{} or {C:attention}Flush{} is",
			"played {C:mult}Lose all mult gained",
			"{C:inactive}(currently: {X:mult,C:white}X#1#{C:inactive})"
		},
		boxes = {3, 1}
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
		if not card.debuff then
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
	end
}

SMODS.Joker {
	
	key = 'j_futa_facial',
	
	loc_txt = {
		name = 'Facial',
		text = {
            "{C:green}#2# in #3#{} chance for a random",
			"Played card to gain a {C:attention}Foil{}", 
		}
	},
	
	config = { extra = { mult = 15, odds = 2 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 9 },
	
	cost = 7,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.post_joker and not context.repetition and not context.blueprint then
				if pseudorandom('Facial') < G.GAME.probabilities.normal / card.ability.extra.odds then
					local foilcard = pseudorandom_element(G.play.cards, pseudoseed('Facialcard'))
					foilcard.set_edition(foilcard, 'e_foil')
				end
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_dickspread',
	
	loc_txt = {
		name = 'Spread',
		text = {
            "For every {C:attention}Different{} card in",
			"hand, score {C:mult}+#1#{} mult for",
			"each card"
		}
	},
	
	config = { extra = { mult = 10,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 9 },
	
	cost = 5,
    slug = "j_futa",
	count = 0,
	
	calculate = function(self, card, context)
		if not card.debuff then
			local cards123 = {}
			if context.cardarea == G.play and not context.blueprint and not context.repetition then
				for k, v in ipairs(G.play.cards) do
					table.insert(cards123, {v:get_id()})
				end
				local seen = {}
				local queenscount = 0
				for _, v in ipairs(cards123) do
					local key = v[1]
					
					if seen[key] == nil then
						seen[key] = true
					end
				end
				local count = 0
				for _ in pairs(seen) do 
					count = count + 1 
				end
				self.count = count
			end
			if context.joker_main then 
				if count ~= 0 then
					return {
						mult = card.ability.extra.mult*self.count
					}
				end
			end
		end
	end
}
SMODS.Joker {
	
	key = 'j_futa_ladder',
	
	loc_txt = {
		name = 'Futas Ladder',
		text = {
            "If Played hand is a",
			"{C:attention}Straight{} score {C:chips}+#1#{} chips"
		}
	},
	
	config = { extra = { chips = 100,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips,} }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0,y = 11 },
	
	cost = 5,
    slug = "j_futa",
	
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands['Straight']) then
			return {
				chips = card.ability.extra.chips
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
		if not card.debuff then
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
	end
}
SMODS.Joker {

	key = 'j_futa_isekai_blow',
	
	loc_txt = {
		name = 'Deep',
		text = {
            "Every {C:mult}discard{} gains {X:mult,C:white}X#2#{} mult, But",
			"Does {C:mult}NOT{} draw after {C:mult}discard{}",
			"{C:mult}resets{} every {C:attention}hand{}",
			"{C:inactive}(currently: {X:mult,C:white}X#1#{C:inactive})"
		},
		boxes = {3, 1}
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
		if not card.debuff then
			if context.pre_discard then
				if G.hand.size ~= 1 then 
					card.ability.extra.current_loss = card.ability.extra.current_loss + #G.hand.highlighted
					G.hand:change_size(-#G.hand.highlighted)
					card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.xmult_gain*#G.hand.highlighted)
					return {
						message = "Upgraded"
					}
				end
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
	end
}

SMODS.Joker {
	
	key = 'j_futa_demon',
	
	loc_txt = {
		name = 'Demonic Judgement',
		text = {
            "{X:mult,C:white}X#1#{} mult but {C:green}#2# in #3#{} chance",
			"of destoring all other jokers"
		}
	},
	
	config = { extra = { xmult = 6.66, odds = 10} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 10 },
	
	cost = 5,
    slug = "j_foot",
	safe = true,
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.before and not context.repetition and not context.blueprint then
				if pseudorandom('demon') < G.GAME.probabilities.normal / card.ability.extra.odds then
					self.safe = false
				else
					self.safe = true
				end
			end
			if context.other_joker and context.other_joker ~= card and not self.safe then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						context.other_joker.T.r = -0.2
						context.other_joker:juice_up(0.3, 0.4)
						context.other_joker.states.drag.is = true
						context.other_joker.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.4,
							blockable = false,
							func = function()
								G.jokers:remove_card(context.other_joker)
								context.other_joker:remove()
								context.other_joker = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = "bye",
				}
			elseif context.joker_main and not context.repetition then 
				if self.safe then 
					return {
						xmult = card.ability.extra.xmult
					}
				end
			end
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
		if not card.debuff then
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
		},
		boxes = {2, 1}
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
		if not card.debuff then
			if context.before and next(context.poker_hands['Full House']) and not context.repetition and not context.blueprint then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultgain
			end
			if context.joker_main and not context.repetition then
				return {
					xmult = card.ability.extra.xmult
				}
			end
		end
	end
}
SMODS.Joker { --j_fuet_tsunade
	
	key = 'j_fuet_tsunade',
	
	loc_txt = {
		name = "Shinobi's Pleasure",
		text = {
            "If Played Hand contains a {C:attention}Queen{}",
			"and a {C:attention}Straight{} then score {X:chips,C:white}X3{} chips",
		}
	},
	
	config = { extra = { xchips = 3,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 10 },
	
	cost = 5,
    slug = "j_fuet",
	vaildhand = false,
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.cardarea == G.play and not context.blueprint and not context.repetition then
				local cards123 = {}
				local queenfound = false
				for k, v in ipairs(G.play.cards) do
					if v:get_id() == 12 then
						queenfound = true
					end
				end
				if queenfound and next(context.poker_hands['Straight']) then 
					self.vaildhand = true
				else 
					self.vaildhand = false
				end
			end
			if context.joker_main and not context.repetition and self.vaildhand then
				return {
					xchips = card.ability.extra.xchips
				}
			end
		end
	end
}
SMODS.Joker { --j_feet_wet 
	
	key = 'j_feet_wet',
	
	loc_txt = {
		name = 'Soaked',
		text = {
            "For Every {C:attention}Foil{} card in",
			"the deck score {C:mult}+#1#{}"
		}
	},
	
	config = { extra = { mult = 5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 3, y = 9 },
	
	cost = 3,
    slug = "j_foot",
	foil_count = 0,
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.cardarea == G.play then
				local count = 0
				local deck = {}
				if self.foil_count == 0 then
					for k,v in ipairs(G.deck.cards) do
						if v.edition ~= nil and v.edition.foil then
							count = count + 1
						end
					end
					self.foil_count = count
				end
			end
			if context.joker_main and not context.repetition then 
				if self.foil_count ~= nil then 
					if self.foil_count >= 0 then 
						local final_mult = card.ability.extra.mult * self.foil_count
						return {
							mult = final_mult
						}
					end
				end
			end
		end
	end
}
SMODS.Joker { --j_feet_sole_press
	
	key = 'j_feet_sole_press',
	
	loc_txt = {
		name = 'Sole Press',
		text = {
            "After a hand is played a",
			"{C:green}random{} card in {C:attention}hand{} {C:mult}loses{}",
			"a {C:attention}rank{} and permanently",
			"gains {C:mult}+2{} mult"
		}
	},
	
	config = { extra = {} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 11 },
	soul_pos = {x= 2, y= 11},
	cost = 3,
    slug = "j_foot",
	foil_count = 0,
	
	calculate = function(self, card, context)
		if not context.repetition and context.joker_main then
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
				local chosen = pseudorandom_element(G.hand.cards)
				local choosen_id = chosen:get_id()
				if choosen_id > 2 and chosen ~= nil then
					local suit_prefix = string.sub(chosen.base.suit, 1, 1)..'_'
					local rank_suffix = chosen.base.id == 14 and 2 or math.max(chosen.base.id-1, 2)
					if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
					elseif rank_suffix == 10 then rank_suffix = 'T'
					elseif rank_suffix == 11 then rank_suffix = 'J'
					elseif rank_suffix == 12 then rank_suffix = 'Q'
					elseif rank_suffix == 13 then rank_suffix = 'K'
					elseif rank_suffix == 14 then rank_suffix = 'A'
					end
					chosen:set_base(G.P_CARDS[suit_prefix..rank_suffix])
					play_sound("tarot1")
					forced_message("Crushed!", chosen, G.C.RED)
					chosen:juice_up(0.3, 0.4)
					chosen.ability.perma_mult = (chosen.ability.perma_mult or 0) + 2
				end
			return true end }))
		end
	end
}
SMODS.Joker { --j_feet_caked
	
	key = 'j_feet_caked',
	
	loc_txt = {
		name = 'Caked',
		text = {
            "Gain {C:mult}+#1#{} mult for every",
			"{C:diamonds}Diamonds{} and {C:hearts}Heart{} suit in {C:attention}hand"
		}
	},
	
	config = { extra = { mult = 5,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 11 },
	
	cost = 3,
    slug = "j_foot",
	val = 0,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand then
			if context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds')  then
				self.val = self.val + 1
			end
		end
		if context.joker_main and not context.repetition then 
			return { mult = card.ability.extra.mult*self.val }
		end
		if context.final_scoring_step then 
			self.val = 0
		end
	end
}
SMODS.Joker { --j_feet_pink
	
	key = 'j_feet_pink',
	
	loc_txt = {
		name = 'Soft Pinks',
		text = {
            "If a {C:hearts}Heart{} {C:attention}Flush{}",
			"is played then {C:white,X:mult}X#1#{}"
		}
	},
	
	config = { extra = { xmult = 3,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult,} }
	end,
	
	rarity = 1,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 12 },
	
	cost = 6,
    slug = "j_foot",
	count = 0,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint and not context.repetition then
			if context.other_card:is_suit("Hearts") then 
				self.count = self.count + 1
			end
		end

		if context.joker_main and not context.repetition then 
			if next(context.poker_hands["Flush"]) and self.count == 5 then
				return {
					xmult = card.ability.extra.xmult
				}
			end
		end
		if context.final_scoring_step then 
			self.count = 0
		end
	end
}
SMODS.Joker { --j_feet_demon_soles
	
	key = 'j_feet_demon_soles',
	
	loc_txt = {
		name = 'Demonic Soles',
		text = {
            "If played hand contains a {C:attention}Pair{}, those",
			"cards {C:attention}permanently{} gain {C:mult}+10{} mult but has",
			"a {C:green}#2#/#3#{} chance of {C:red}Destroying{} all played cards"
		}
	},
	
	config = { extra = { mult = 5, odds = 66, fail_chance = 1, fail_max = 3 } },
	
	loc_vars = function(self, info_queue, card)
		return { vars = {  card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 12 },
	
	cost = 6,
    slug = "j_foot",
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.poker_hands and context.joker_main and not context.repetition then
				if next(context.poker_hands["Pair"]) then
					for _, card_in_play in ipairs(G.play.cards) do
						card_in_play.ability.perma_mult = card_in_play.ability.perma_mult or 0
						card_in_play.ability.perma_mult = card_in_play.ability.perma_mult + card.ability.extra.mult
						forced_message("Upgraded", card_in_play, G.C.RED,0.5)
					end
					if pseudorandom('demon') < G.GAME.probabilities.normal / card.ability.extra.odds then
						for _, c in ipairs(context.scoring_hand) do
							G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,
								func = function()
									c:start_dissolve()
									c = nil
									return true
								end
							}))
						end
					end
				end
			end
		end
	end
}
SMODS.Joker { --j_feet_Worn
	
	key = 'j_feet_Worn',
	
	loc_txt = {
		name = 'Well Worn',
		text = {
            "Gives {C:mult}+#1#{} mult for the {C:attention}total{} amount",
			"of times all scored cards have been {C:attention}played"
		}
	},
	
	config = { extra = { mult = 2, times = 0} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 2, y = 12 },
	
	cost = 3,
    slug = "j_foot",
	foil_count = 0,
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.cardarea == G.play and context.individual and not context.repetition then
				if context.other_card.base.times_played ~= 0 then
					card.ability.extra.times = card.ability.extra.times + context.other_card.base.times_played
				end
			end
			if context.joker_main and card.ability.extra.times ~= 0 then
				return {
					mult = card.ability.extra.times * card.ability.extra.mult
				}
			end
			if context.final_scoring_step then
				card.ability.extra.times = 0
			end

		end
	end
}
SMODS.Joker { --j_futa_sneakpeek

	key = 'j_futa_sneakpeek',

	loc_txt = {
		name = 'Sneak Peek',
		text = {
			"{C:attention}Once{} per round, if your played hand",
			"contains no {C:attention}face{} cards, gain {C:chips}+#2#{} Chips",
			"{C:inactive}(currently {C:chips}+#1#{C:inactive})"
		}
	},

	config = { extra = { used = false, chips = 0, chip_gain = 15 } },

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,

	rarity = 2, -- Uncommon

	atlas = 'feetandfuta',

	pos = { x = 3, y = 12 },

	cost = 6,

	calculate = function(self, card, context)
		if context.joker_main and not context.repetition and not context.blueprint then
			if not self.config.extra.used then
				local has_face = false
				for _, c in ipairs(context.full_hand) do
					if c:is_face() then
						has_face = true
						break
					end
				end
				if not has_face then
					self.config.extra.used = true
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
					return {
						chips = card.ability.extra.chips
					}
				end
			else 
				if card.ability.extra.chips ~= 0 then 
					return {
						chips = card.ability.extra.chips
					}
				end
			end
		end
		if context.end_of_round then 
			self.config.extra.used = false
		end
	end,
}
SMODS.Joker { --j_feet_track_star
	
	key = 'j_feet_track_star',
	
	loc_txt = {
		name = 'Track Star',
		text = {
            "Gain {C:mult}+#1#{} Mult per {C:attention}unique{}",
            "card rank in your hand"
		}
	},
	
	config = {extra = { mult = 4}},
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 4, y = 12 },
	
	cost = 5,
	
	calculate = function(self, card, context)
		if context.joker_main and not context.repetition then
			local ranks = {}
			for _, c in ipairs(context.full_hand) do
				ranks[c:get_id()] = true
			end
			local count = 0
			for _ in pairs(ranks) do count = count + 1 end
			return { mult = count*card.ability.extra.mult }
		end
	end
}
SMODS.Joker { --j_feet_cheer
	
	key = 'j_feet_cheer',
	
	loc_txt = {
		name = 'Cheerleader',
		text = {
            "If number cards in played hand ",
			"is more than one the {C:attention}left{} most",
			"and {C:attention}right{} most are replayed"
		}
	},
	
	config = { extra = { mult = 5, repetitions = 1} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,card.ability.extra.repetitions } }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 13 },
	
	cost = 4,
    slug = "j_foot",
	foil_count = 0,
	
	calculate = function(self, card, context)
		if not self.debuff then
			if context.cardarea == G.play and context.repetition and not context.repetition_only then
				if #G.play.cards >= 2 then  
					print("number of cards: "..tostring(#G.play.cards))
					if context.other_card == G.play.cards[#G.play.cards] or context.other_card == G.play.cards[1] then
						return {
							message = 'Again!',
							repetitions = card.ability.extra.repetitions,
							card = context.other_card
						}
					end
				end
			end
		end
	end
}
SMODS.Joker { --j_feet_flowjob
	
	key = 'j_feet_flowjob',
	
	loc_txt = {
		name = 'Flowjob',
		text = {
            "If {C:attention}scored{} hand contains a",
			"{C:attention}Pair{} of either {C:attention}Jacks{} or {C:attention}kings{}",
			"score {C:mult}+#1#{} mult"
		}
	},
	
	config = { extra = { mult = 20,} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult,} }
	end,
	
	rarity = 2,
	
	atlas = 'feetandfuta',
	
	pos = { x = 1, y = 13 },
	
	cost = 3,
    slug = "j_foot",
	foil_count = 0,
	
	calculate = function(self, card, context)
		if not card.debuff then
			if context.joker_main then 
				if next(context.poker_hands["Pair"]) then
					local val = false
					for v,k in ipairs(context.poker_hands["Pair"]) do
						if k:get_id() == 13 or k:get_id() == 11 then 
							val = true
						else
							val = false
						end
					end
					if val then 
						return {
							mult = card.ability.extra.mult,
						}
					end
				else
					val = false
				end
			end
		end
	end
}
SMODS.Joker { --j_futa_thump
	
	key = 'j_futa_thump',
	
	loc_txt = {
		name = 'Thumper',
		text = {
            "Every {C:attention}round{} the cock is either {C:attention}lifted{} or {C:attention}slammed{}",
			"when it is {C:attention}slammed{} gain {X:mult,C:white}+#1#X{} mult",
			"Will only score if the cock is slammed",
			"{C:inactive}(current: {X:mult,C:white}X#3#{C:inactive}){}"
		},
		boxes = {3,1}
	},
	
	config = { extra = { Xmult = 0.6, CxMult = 1} },
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, self.cockon, card.ability.extra.CxMult}}
	end,
	
	rarity = 3,
	
	atlas = 'feetandfuta',
	
	pos = { x = 0, y = 14 },
	
	cost = 6,
    slug = "futa",
	foil_count = 0,
	cockon = false,
	update = function(self, card)
        if self.discovered or card.bypass_discovery_center then
			local timer = (G.TIMERS.REAL * G.ANIMATION_FPS * 0.2)
			local frame_amount = 4
			local frame = 1
			if self.cockon == true and card.children.center.sprite_pos.x ~= 3 then
				local wrapped_value = (math.floor(timer) - 1) % frame_amount
				card.children.center:set_sprite_pos({x = wrapped_value, y = card.children.center.sprite_pos.y})
				frame = frame + 1 
			elseif self.cockon == false then
				frame = 1
				card.children.center:set_sprite_pos({x = 0, y = card.children.center.sprite_pos.y})
			end
        end
    end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.individual and not context.repetition then 
			self.cockon = not self.cockon
			if self.cockon then
				card.ability.extra.CxMult = card.ability.extra.CxMult + card.ability.extra.Xmult
				G.E_MANAGER:add_event(Event({
					func = function()
						forced_message("Slam!", card, G.C.RED, nil, nil)
						play_sound('bery_slam',1, 1.9)
						card:juice_up(0.3, 0.4)
						return true
					end
				}))
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(0.3, 0.4)
						play_sound('tarot1')
						return true
					end
				}))
				return{
					message = "up"
				}
			end
		end
		if context.joker_main then
			if self.cockon then
				return {
					xmult = card.ability.extra.CxMult
				}
			end
		end
	end
}






--------------------------------------------------------------------- VOUCHER -----------------------------------------------------------------
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

