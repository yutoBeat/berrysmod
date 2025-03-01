-- Sample table with 10 values (strings)
local values = {"apple", "banana", "apple", "orange", "banana", "apple", "grape", "orange", "banana", "apple"}

-- Table to store counts of each value
local counts = {}

-- Loop through the `values` table and count occurrences
for _, value in ipairs(values) do
    if counts[value] then
        counts[value] = counts[value] + 1
    else
        counts[value] = 1
    end
end

-- Print the counts
for value, count in pairs(counts) do
    print(value .. ": " .. count)
end