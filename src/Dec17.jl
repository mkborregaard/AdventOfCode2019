include("OpCodes.jl")
using .OpCodes
using OffsetArrays

ic = IntComputer(readline("data/Dec17_data.txt"))
asc = getoutput(compute!(ic))
field = string(Char.(asc)...)

spfield = split(field, '\n')[1:end-2]
bf = OffsetArray([spfield[i][j] != '.' for i in 1:length(spfield),
    j in 1:length(spfield[1])], (-1, -1))

isintersection(bf, i, j) = bf[i,j] && bf[i-1,j] && bf[i+1,j] && bf[i, j-1] && bf[i, j+1]

ints = [x for x in Iterators.product(1:45, 1:47) if isintersection(bf, x...)]
sum(prod,ints) # answer to problem 1


# problem 2
corner = Tuple(findfirst([spfield[i][j] == '^' for i in 1:length(spfield), j in 1:length(spfield[1])])) .- (1,1)

function hasscaffold(bf, (i, j))
    (i < 0 || i > size(bf, 1)-1) && return false
    (j < 0 || j > size(bf, 2)-1) && return false
    bf[i,j]
end

function followpath(bf, corner)
    pos = corner
    right =  [0  1;
             -1  0]
    left = -right
    dir = [-1, 0]
    path = []
    stepcounter = 0
    while true
        @show pos
        if hasscaffold(bf, pos .+ dir)
            pos = pos .+ dir
            stepcounter += 1
        else
            push!(path, stepcounter)
            stepcounter = 0
            if hasscaffold(bf, pos .+ left * dir)
                push!(path, 'L')
                dir = left * dir
            elseif hasscaffold(bf, pos .+ right * dir)
                push!(path, 'R')
                dir = right * dir
            else
                return path
            end
        end
    end
end

findrepeats(v) =



p = followpath(bf, corner)[2:end]










str = "A,A,B,C,B,C,B,C\n"
[Int(Char(x[1])) for x in str[1:2:end]]
