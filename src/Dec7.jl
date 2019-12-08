includet("OpCodes.jl")
using .OpCodes

function testsettings(settings, data, input)
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
findmax(map(x->testsettings(x,data, 0), permutations(0:4)))

# Question 2
function circular(data, settings, input)
    channels = [Channel{Int}(32) for i in 1:5]
    ics = [IntComputer(data, channels[i], channels[i == 5 ? 1 : i + 1]) for i in 1:5]
    addinput!.(ics, settings)
    addinput!(ics[1], input)
    for i in 1:5
        @async compute!(ics[i])
    end
    @show [fetch(ics[i].output) for i in 1:5]
    getoutput(ics[end])
end

settings = 9:-1:5
data = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
circular(data, settings, 0)

# Test cases
test1 = ps("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
ics = [IntComputer(test1) for i in 1:5]
settings = [4,3,2,1,0]
testsettings(settings, ics, 0)

test2 = ps("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
ics = [IntComputer(test2) for i in 1:5]
settings = 0:4
testsettings(settings, ics, 0)
