using StaticArrays, Combinatorics

getv(data) = match(r"<x=(-*\d+), y=(-*\d+), z=(-*\d+)>",data).captures

function run1(data, nsteps)
    pos = [MVector{3}(parse.(Int, getv(x))) for x in data]
    vel = [MVector{3}(0,0,0) for x in 1:length(pos)]

    for step in 1:nsteps
    #    println("\nAfter $(step-1) steps:")
    #    [println("pos=<x=$(pos[x][1]), y=$(pos[x][2]), z=$(pos[x][3])>, vel=<x= $(vel[x][1]), y= $(vel[x][2]), z= $(vel[x][3])>") for x in eachindex(pos)]

        for comb in combinations(eachindex(pos), 2)
            for axis in 1:3
                v,l = pos[comb[1]][axis], pos[comb[2]][axis]
                rel = v == l ? (0, 0) : v > l ? (-1, 1) : (1, -1)
                for i in 1:2
                    vel[comb[i]][axis] += rel[i]
                end
            end
        end

        for i in eachindex(pos)
            pos[i] .+= vel[i]
        end
    end

    sum([sum(abs.(pos[i])) .* sum(abs.(vel[i])) for i in eachindex(pos)])
end

data = readlines("data/Dec12_data.txt")
run1(data, 1000)


function run2(data, nsteps)
    pos = [MVector{3}(parse.(Int, getv(x))) for x in data]
    vel = [MVector{3}(0,0,0) for x in 1:length(pos)]
    poss = Vector{typeof(pos)}()
    vels = Vector{typeof(vel)}()

    for step in 1:nsteps
        for comb in combinations(eachindex(pos), 2)
            for axis in 1:3
                v,l = pos[comb[1]][axis], pos[comb[2]][axis]
                rel = v == l ? (0, 0) : v > l ? (-1, 1) : (1, -1)
                for i in 1:2
                    vel[comb[i]][axis] += rel[i]
                end
            end
        end

        for i in eachindex(pos)
            pos[i] .+= vel[i]
        end
        push!(poss, deepcopy(pos))
        push!(vels, deepcopy(vel))
    end

    poss, vels #sum([sum(abs.(pos[i])) .* sum(abs.(vel[i])) for i in eachindex(pos)])
end

function findlag(v)
    f = 1
    while !isnothing(f)
        f = findnext(==(v[1]), v, f+1)
        v[1:f] == v[f .+ (1:f) .- 1] && return f-1
    end
end

function findlags(poss)
    ret = Int[]
    for planet in 1:length(poss[1])
        for axis in 1:length(poss[1][1])
            p = [poss[step][planet][axis] for step in eachindex(poss)]
            push!(ret, findlag(p))
        end
    end
    ret
end

poss, vels = run2(data, 1000000)
alls = lcm([findlags(poss); findlags(vels)]...)


# test cases

test1 = split("""
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>""",'\n')
