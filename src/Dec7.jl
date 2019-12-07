include("OpCodes5.jl")
using .OpCodes5
ps(x) = parse.(Int, split(x, ','))

data = ps(readline("data/Dec5_data.txt"))
