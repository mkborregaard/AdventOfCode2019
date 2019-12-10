
data = split(
"""
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
""", "\n")

data = split(
"""
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
""", "\n")

function maketuples(data)
    a = Vector{Tuple{Int, Int}}()
    for (i, line) in enumerate(data)
        for j in findall(==("#"), split(line, ""))
            push!(a, (i,j))
        end
    end
    a
end

function countseen(a::Vector, i)
    seen = Set{Tuple{Float64, Float64}}()
    for asts in a
        asts == i && continue
        dir = asts .- i
        dirp = dir[1] == 0 ? dir ./ abs(dir[2]) : dir ./ abs(dir[1])
        push!(seen, dirp)
    end
    length(seen)
end

data = readlines("data/Dec10_data.txt")
a = maketuples(data)
t = countseen(a, a[1])
findmax(map(i->countseen(a, i), a))

using DataStructures
function seenDict(a::Vector, i)
    seen = MultiDict{Tuple{Float64, Float64}, Tuple{Int, Int}}()
    for asts in a
        asts == i && continue
        dir = asts .- i
        dirp = dir[1] == 0 ? dir ./ abs(dir[2]) : dir ./ abs(dir[1])
        insert!(seen, dirp, dir)
    end
    seen
end

function shootstars(myast, a)
    ret = Tuple{Int, Int}[]
    sd = seenDict(a, myast)
    for (k,v) in sd
        sort!(v, by = x->sum((x .- myast).^2), rev = true)
    end
    sortedkeys = sort(collect(keys(sd)), by = x->atan(x[2], x[1]), rev = true)
    counter = 0
    for key in sortedkeys
        if !isempty(sd[key])
            p = pop!(sd[key])
            push!(ret, p .+ myast)
            (counter += 1) == 200 && return p .+ myast .- (1,1)
        end
    end
end
res = shootstars(a[353], a)
res[2]*100 + res[1]
