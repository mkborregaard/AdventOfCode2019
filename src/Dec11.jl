include("Opcodes.jl")
using .OpCodes
using StaticArrays

function run1(data, startwhite = false)
    right =  @SMatrix [0  1;
                     -1  0]
    left = @SMatrix [0 -1;
                      1  0]
    dir =   @SVector [-1, 0]
    pos =   @SVector [0, 0]
    field = Dict{typeof(pos), Int}()
    inp = Channel{Int}(1)
    outp = Channel{Int}(1)
    ic = IntComputer(data, inp, outp)
    @async compute!(ic)
    startwhite && (field[pos] = 1)
    while !ic.finished[]
        put!(inp, get(field, pos, 0))
        field[pos] = take!(outp)
        dir = take!(outp) == 1 ? right * dir : left * dir
        pos = pos + dir
    end
    field
end

# question 1
f = run1(readline("data/Dec11_data.txt"))
length(keys(f))

# question 2 (plus an added arg to the function)
f = run1(readline("data/Dec11_data.txt"), true)

b = fill(NaN, 100, 100)
for (k,v) in f
    b[(k .+ 50)...] = v
end
heatmap(b, ylim = (40,60), xlim = (40, 100), yflip = true)
