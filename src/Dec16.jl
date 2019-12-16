getdata(data) = parse.(Int, split(data, ""))
dats = getdata(readline("data/Dec16_data.txt"))

l = length(dats)
for i in eachindex(dats)
pat = repeat([0,1,0,-1], inner = i, outer = 1 + l ÷ 4i)[2:l+1]
res = getindex.(digits.(dats .* pat), Ref(1))
dats .* pat
