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
    #[sum(abs.(pos[i])) for i in 1:3]
end

data = readlines("data/Dec12_data.txt")
run1(data, 1000)




# test cases

test1 = split("""
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>""",'\n')
