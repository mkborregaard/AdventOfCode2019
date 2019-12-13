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


# question 2

function run2(data)
    inp, outp = Channel{Int}(1), Channel{Int}(3)
    d = parse.(Int,split(data, ','))
    d[1] = 2
    ic = IntComputer(data, inp, outp)
    @async compute!(ic)
    field = zeros(Int, 46, 21)
    score = 0
    put!(inp,1)
    while !ic.finished[]
        x,y,el = [take!(outp) for i in 1:3]
        if (x,y) == (-1, 0)
            score = el
        else
            field[x+1, y+1] = el
        end
    end
    close(inp)
    score, count(==(2), values(field)), collect(inp)
end
s,c = run2(data)
