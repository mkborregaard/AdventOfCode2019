data = [parse(Int,x) for x in readline("data/Dec8_data.txt")]

# Question 1
r = reshape(data, (25,6,:))
l = findmin(vec(mapslices(x->count(==(0),x),r, dims = 1:2)))[2]
count(==(1), r[:,:,l]) * count(==(2), r[:,:,l])

# Question 2
merg(a1, a2) = a1 == 2 ? a2 : a1
res = foldl((x,y) -> merg.(x,y), eachslice(r, dims = 3))
using Plots
heatmap(res', aspect_ratio = 1, yflip = true)
