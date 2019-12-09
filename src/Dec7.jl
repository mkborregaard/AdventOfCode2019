includet("OpCodes.jl")
using .OpCodes

function testsettings(data, settings, input)
    ics = [IntComputer(data) for i in 1:5]
    addinput!.(ics, settings)
    for i in eachindex(settings)
        compute!(ics[i], input)
        input = getoutput(ics[i])[1]
    end
    input
end

# do it
using Combinatorics
data = readline("data/Dec7_data.txt")
findmax(map(x->testsettings(data, x, 0), permutations(0:4)))

# Question 2
function circular(data, settings, input)
    channels = [Channel{Int}(Inf) for i in 1:5]
    ics = [IntComputer(data, channels[i], channels[i == 5 ? 1 : i + 1]) for i in 1:5]
    addinput!.(ics, settings)
    addinput!(ics[1], input)
    @sync for i in 1:5
        @async compute!(ics[i])
    end
    getoutput(ics[end])
end

findmax(map(x->circular(data, x, 0), permutations(5:9)))





# Test cases

# for 1
test1 = ps("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
settings = [4,3,2,1,0]
testsettings(test1, settings, 0)

test2 = ps("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
settings = 0:4
testsettings(test2, settings, 0)

# for 2
settings = 9:-1:5
data = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
circular(data, settings, 0)[1]

settings = [9,7,8,5,6]
data = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
circular(data, settings, 0)[1]
