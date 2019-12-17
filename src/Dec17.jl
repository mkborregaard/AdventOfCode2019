include("OpCodes.jl")
using .OpCodes
using OffsetArrays

ic = IntComputer(readline("data/Dec17_data.txt"))
asc = getoutput(compute!(ic))
field = string(Char.(asc)...)

spfield = split(field, '\n')[1:end-2]
bf = OffsetArray([spfield[i][j] == '#' for i in 1:length(spfield),
    j in 1:length(spfield[1])], (-1, -1))

isintersection(bf, i, j) = bf[i,j] && bf[i-1,j] && bf[i+1,j] && bf[i, j-1] && bf[i, j+1]

ints = [x for x in  Iterators.product(1:45, 1:47) if isintersection(bf, x...)]
sum(prod,ints)


str = "A,A,B,C,B,C,B,C\n"
[Int(Char(x[1])) for x in str[1:2:end]]
