

SMODS.Atlas {
    key = 'Deck_back',
    path = 'Deck_back.png',
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'berry_futa',
    loc_txt = {
        name = 'Futa',
        text = {'{C:purple}"Futa Domination"{}',
            "Start with a Deck",
            "with every {C:attention}Face card{}",
            "replaced with {C:attention}Queens{}",}
    },
    atlas = 'Deck_back',
    pos = {x=1, y=0},
    config = {only_one_rank = 'Queen',
        unlocked = true,
        discovered = true
    }, 
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    for _, card in ipairs(G.playing_cards) do
                        if card:get_id() == 11 or card:get_id() == 13  then
                            assert(SMODS.change_base(card, nil, self.config.only_one_rank))
                        end
                    end
                end
                return true
            end
            -- function = SMODS.change_base(card, suit, rank)
            --     for _, card in ipairs(G.playing_cards) do
            --         if card:get_id() == 11 then

                    
            --     end
            --     return {card, nil, only_one_rank}
            -- end
        }))
    end
}

SMODS.Back {
    key = 'berry_foot',
    loc_txt = {
        name = 'Sole-d',
        text = {'{C:purple}"No Hands only Feet"',
                "{C:red}+#1#{} discards",
                "{C:blue}#2#{} hands"
            }
    },
    atlas = 'Deck_back',
    pos = {x=0, y=0},
    config = {hands = -2, discards = 5,
        unlocked = true,
        discovered = true
    },
    loc_vars = function(self)
        return { vars = { self.config.discards, self.config.hands }}
    end
}