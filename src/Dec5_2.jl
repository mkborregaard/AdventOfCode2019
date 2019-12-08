include("OpCodes.jl")
using .OpCodes

#Question 1
data = readline("data/Dec5_data.txt")
ic = IntComputer(data)
compute!(ic, 1)
ic.output

# Question 2
ic = IntComputer(data)
compute!(ic, 5)
