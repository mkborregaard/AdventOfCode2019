include("OpCodes5.jl")
using .OpCodes5
ps(x) = parse.(Int, split(x, ','))

data = ps(readline("data/Dec5_data.txt"))
res = compute(data, 1)
res.output


compute(ps("3,9,8,9,10,9,4,9,99,-1,8"))
