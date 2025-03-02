-- loads files
BERY = SMODS.current_mod

assert(SMODS.load_file("./cards/jokerz.lua"))()
assert(SMODS.load_file("./cards/hands.lua"))()
assert(SMODS.load_file("./cards/cosume.lua"))()
assert(SMODS.load_file("./cards/decks.lua"))()
assert(SMODS.load_file("./cards/booster.lua"))()
