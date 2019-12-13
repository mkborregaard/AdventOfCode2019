### Question 1

# I make this global variable `const` to ensure code stability
const codes = Dict('U'=>(1,0), 'D'=>(-1,0), 'R'=>(0,1), 'L'=>(0,-1))

function parsecode(code)
    op = code[1]
    dist = parse(Int, code[2:end])
    codes[op], dist   # captures the global variable `codes`
end

function evolve(line)
    ret = Tuple{Int, Int}[]
    pos = (0, 0)
    for code in line
        dir, dist = parsecode(code)
        for i in 1:dist
            pos = pos .+ dir
            push!(ret, pos)
        end
    end
    ret
end

manhattan(x) = sum(abs.(x))

function runlines(l1, l2)
    crosses = intersect(evolve(l1), evolve(l2))
    findmin(manhattan.(crosses))[1]
end

getlines(x::Vector) = split.(x, Ref(','))
# test case


using Test
test1 = """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
"""
l1, l2 = getlines(split(test1, '\n'))
@test runlines(l1, l2) == 159

test2 = """
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
"""
l1, l2 = getlines(split(test2, '\n'))
@test runlines(l1, l2) == 135

# Final result
l1, l2 = getlines(readlines("data/Dec3_data.txt"))
runlines(l1, l2)

### Question 2
function runlines2(l1, l2)
    line1, line2 = evolve(l1), evolve(l2)
    crosses = intersect(line1, line2)
    dist = [findfirst(==(x), line1) + findfirst(==(x), line2) for x in crosses]
    findmin(dist)[1]
end

runlines2(l1, l2)
