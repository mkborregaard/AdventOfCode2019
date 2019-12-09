includet("OpCodes.jl")
using .OpCodes

data = readline("data/Dec9_data.txt")
getoutput(compute!(IntComputer(data), 1))

# question 2
getoutput(compute!(IntComputer(data), 2))




# test cases
ic = IntComputer("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
getoutput(compute!(ic))

ic = IntComputer("1102,34915192,34915192,7,4,7,99,0")
getoutput(compute!(ic))
