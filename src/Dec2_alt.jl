include("OpCodes2.jl")
using .OpCodes2

data = parse.(Int, split(readline("Dec2_data.txt"), ','))
data[2:3] .= (12, 2)
res = compute(data)[1]

# Question 2

function fun2(input)
    for i in 0:99, j in 0:99
        p = copy(input)
        p[2:3] .= (i, j)
        p = compute(p)
        p[1] == 19690720 && return(100i + j)
    end
    error("no input gave the right result")
end
fun2(data)
