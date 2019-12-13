include("OpCodes.jl")
using .OpCodes

function run1(data)
    inp, outp = Channel{Int}(1), Channel{Int}(3)
    ic = IntComputer(data, inp, outp)
    @async compute!(ic)
    dc = Dict{Tuple{Int,Int}, Int}()
    while !ic.finished[]
        x,y,el = [take!(outp) for i in 1:3]
        dc[(x,y)] = el
    end
    dc
end

data = readline("data/Dec13_data.txt")
r1 = run1(data)
count(==(2), values(r1))

# and a map
field = fill(NaN, 21, 46)
[field[(reverse(k).+1)...] = v for (k,v) in r1]
using Plots
heatmap(field)
