include("OpCodes.jl")
using .OpCodes

function run1(data)
    function move!(ic, nsteps, pos, origin)
        pos ∈ positions && return
        push!(positions, pos)
        dirs = setdiff(1:4, origin)
        for dir in dirs
            put!(inp, dir)
            res = take!(outp)
            field[(pos .+ directions[dir])] = res
            if res > 0
                res == 2 && (shortest_path_length = nsteps + 1)
                orig = back[dir]
                move!(ic, nsteps + 1, pos .+ directions[dir], orig)
                put!(inp, orig)
                throwaway = take!(outp)
            end
        end
    end
    inp, outp = Channel{Int}(1), Channel{Int}(1)
    ic = IntComputer(data, inp, outp)
    nsteps = 0
    positions = Set{Tuple{Int, Int}}()
    directions = ((1,0), (-1,0), (0,-1), (0,1))
    back = (2, 1, 4, 3)
    shortest_path_length = 99999
    field = Dict((0,0)=>1)
    @async compute!(ic)
    move!(ic, 0, (0,0), 5)
    shortest_path_length, field
end
result1, field = run1(readline("data/Dec15_data.txt"))

function run2(field)
    neighbors(pos) = (pos .+ a for a in ((1,0), (-1,0), (0,1), (0,-1)))
    current = Set([k for (k,v) in field if v == 2])
    space = Set([k for (k,v) in field if v > 0])
    pop!(space, first(current))
    counter = 0
    while true
        counter += 1
        next = Set([v for v in Iterators.flatten(neighbors.(current)) if v ∈ space])
        @show counter, length(space), length(next), next
        [pop!(space, n) for n in next]
        length(space) == 0 && return counter
        current = next
    end
end
run2(field)
