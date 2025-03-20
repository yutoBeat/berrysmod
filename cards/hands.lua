SMODS.PokerHand {
    key = 'Twoplush',
    chips = 35,
    mult = 3,
    l_chips = 15,
    l_mult = 2,
    example = {
        {'H_A', true},
        {'H_A', true},
        {'S_8', false},
        {'H_2', true},
        {'H_2', true},
    },
    loc_txt = {
        ['en-us'] = {
            name = "Two Pair Flush",
            description = {
                'A Two Pair consisting',
                'only of one suit'
            }
        }
    },
    evaluate = function(parts, hand)
    end
-- --     evaluate = function(parts, hand)
-- --         local vaild_cards, suitsvalues, counts = {}, {}, {}
-- --         local flush_suit, max_count, vaild = "", 0, false
-- --         local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
    
-- --         if next(parts._2) then
-- --             for i = 1, #hand do
-- --                 vaild_cards[i] = hand[i]
-- --                 table.insert(suitsvalues, vaild_cards[i].base.suit)
-- --             end
    
-- --             for _, suit in ipairs(suitsvalues) do
-- --                 counts[suit] = (counts[suit] or 0) + 1
-- --             end
    
-- --             for suit, count in pairs(counts) do
-- --                 if count > max_count then
-- --                     max_count = count
-- --                     flush_suit = suit
-- --                 end
-- --             end
-- --             for i = #vaild_cards, 1, -1 do
-- --                 if vaild_cards[i].base.suit ~= flush_suit then
-- --                     table.remove(vaild_cards, i)
-- --                 end
-- --             end
    
-- --             if counts[flush_suit] == 4 then
-- --                 vaild = true
-- --             end
-- --         end
-- --         if vaild then return{vaild_cards} end
-- --     end
--     evaluate = function(parts, hand)
--         local vaild_cards = {}
--         local suited = {}
--         local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
--         local counts = {}
--         local rcounts = {}
--         local flush_suit = ""
--         local max_count = 0
--         local vaild = false
--         local suitsvalues = {}
--         local rankvalues = {}

--         if not next(parts._2) then
--             vaild_cards = {}
--         end
--         --- grab if all cards if a pair is present
--         if next(parts._2) then
--             for i=1, #hand do 
--                 vaild_cards[i] = hand[i]
--                 table.insert(suitsvalues, vaild_cards[i].base.suit)
--                 -- table.insert(rankvalues, vaild_cards[i]:get_id())
--                 -- print(suitsvalues)
--             end
--             --counts rank and suit apperances
--             for _, suits in ipairs(suitsvalues) do
--                 if counts[suits] then
--                     counts[suits] = counts[suits] + 1
--                 else
--                     counts[suits] = 1
--                 end
--             end
--             -- find most common suit
--             for suit, count in pairs(counts) do
--                 if count > max_count then
--                     max_count = count
--                     flush_suit = suit
--                 end
--             end
--             --------------------------------------------
--             for i=1, #vaild_cards do
--                 if hand[i].base.suit == flush_suit then 
--                     table.insert(rankvalues, vaild_cards[i]:get_id())
--                 end
--             end
--             --------------------------------------------
--             for _, rank in ipairs(rankvalues) do
--                 if rcounts[rank] then
--                     rcounts[rank] = rcounts[rank] + 1
--                 else
--                     rcounts[rank] = 1
--                 end
--             end
--             -- remove non flush suit cards
--             for i=1, #vaild_cards do 
--                 if hand[i].base.suit ~= flush_suit then
--                     table.remove(vaild_cards, i )
--                 end
--             end
--             -- check if hand is vaild
--             if counts[flush_suit] == 4 and #rcounts >= 2 then
--                 vaild = true
--             end
--         end
--         if vaild then return{vaild_cards} end
--     end
}

SMODS.PokerHand {
    key = 'Threeflush',
    chips = 45,
    mult = 5,
    l_chips = 22,
    l_mult = 3,
    example = {
        {'H_A', true},
        {'H_A', true},
        {'H_A', true},
        {'C_2', false},
        {'S_8', false},
    },
    loc_txt = {
        ['en-us'] = {
            name = '3 Of a Kind Flush',
            description = {
                'A Three of a Kind consisting',
                ' only of one suit'
            }
        }
    },
    evaluate = function(parts, hand)
        local vaild_cards = {}
        local suited = {}
        local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
        local counts = {}
        local rcounts = {}
        local flush_suit = ""
        local mostrank = ""
        local max_count = 0
        local max_rcount = 0
        local vaild = false
        local suitsvalues = {}
        local rankvalues = {}

        if not next(parts._3) then
            vaild_cards = {}
        end
        --- grab if all pairs and print it(plus some extras) 
        if next(parts._3) then
            for i=1, #hand do 
                vaild_cards[i] = hand[i]
                table.insert(suitsvalues, vaild_cards[i].base.suit)
                -- table.insert(rankvalues, vaild_cards[i]:get_id())
                -- print(suitsvalues)
            end
            --counts rank and suit apperances
            for _, suits in ipairs(suitsvalues) do
                if counts[suits] then
                    counts[suits] = counts[suits] + 1
                else
                    counts[suits] = 1
                end
            end
            -- find most common suit
            for suit, count in pairs(counts) do
                if count > max_count then
                    max_count = count
                    flush_suit = suit
                end
            end
            --------------------------------------------
            for i=1, #vaild_cards do
                if hand[i].base.suit == flush_suit then 
                    table.insert(rankvalues, vaild_cards[i]:get_id())
                end
            end
            --------------------------------------------
            for _, rank in ipairs(rankvalues) do
                if rcounts[rank] then
                    rcounts[rank] = rcounts[rank] + 1
                else
                    rcounts[rank] = 1
                end
            end
            for rank, rcount in pairs(rcounts) do
                if rcount > max_rcount then
                    max_rcount = rcount
                    mostrank = rank
                end
            end
            -- print(flush_suit)
            for i=1, #vaild_cards do 
                if hand[i].base.suit ~= flush_suit or hand[i]:get_id() ~= mostrank then
                    table.remove(vaild_cards, i )
                end
            end
            if counts[flush_suit] == 3 and rcounts[mostrank] == 3 then
                vaild = true
            end
        end
        if vaild then return{vaild_cards} end
    end
}