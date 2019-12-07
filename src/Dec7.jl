include("OpCodes.jl")
using .OpCodes
ps(x) = parse.(Int, split(x, ','))

function testsettings(settings, ics, input)
    for i in eachindex(settings)
        compute!(ics[i], [settings[i], input])
        input = ics[i].output[1]
    end
    ics[end].output
end

test1 = ps("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
ics = [IntComputer(test1) for i in 1:5]
settings = [4,3,2,1,0]
testsettings(settings, ics, 0)


data = ps(readline("data/Dec7_data.txt"))
abcde = [IntComputer(data) for i in 1:5]
